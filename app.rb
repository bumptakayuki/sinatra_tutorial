require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'mysql2'
require 'mysql2-cs-bind'

enable :sessions

# Mysqlドライバの設定
client = Mysql2::Client.new(
    host: 'localhost',
    port: 3306,
    username: 'root',
    password: '',
    database: 'insta',
    reconnect: true,
)

# Viewディレクトリの設定
configure do
  set :views, 'app/views'
end

# トップページ
get '/' do
  @posts = client.xquery("SELECT * FROM posts")

  # デバッグ例
  # @posts = client.query('SELECT * FROM posts').each do |entry|
  #   raise entry['id'].inspect
  # end

  erb :index
end

# 投稿詳細
get '/show/:id' do
  @post = client.xquery('SELECT * FROM posts WHERE id = ?', params[:id]).first
  erb :show
end

# 新規作成(GET)
get '/create' do
  erb :create
end

# 新規作成(POST)
post '/create' do

  # 画像情報を取得
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  # 画像をディレクトリに配置
  File.open("./public/img/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end

  # 投稿を新規作成
  query = 'INSERT INTO posts (title, description, image_path,created_at,updated_at) VALUES (?,?,?,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP())'
  client.xquery(query, params[:title], params[:description], "/img/#{@filename}")

  flash[:notice] = "登録しました！"

  # トップページにリダイレクト
  redirect to('/')
end

# 削除
delete '/destroy/:id' do
  query = 'DELETE FROM posts WHERE id = ?'
  client.xquery(query, params[:id])

  redirect to('/')
end

# 編集(GET)
get '/edit/:id' do
  # @post = Post.find(params[:id])
  @post = client.xquery('SELECT * FROM posts WHERE id = ?', params[:id]).first

  erb :edit
end

# 編集(put)
put '/edit/:id' do

  # 画像情報を取得
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  # 画像をディレクトリに配置
  File.open("./public/img/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end

  query = 'UPDATE posts SET title=?, description=?, image_path=?, updated_at=CURRENT_TIMESTAMP() WHERE id = ?'
  client.xquery(query, params[:title], params[:description], "/img/#{@filename}", params[:id])

  redirect to('/')
end
