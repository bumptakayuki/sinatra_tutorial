require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'mysql2'
require 'mysql2-cs-bind'
require 'pry'

enable :sessions

set :public_folder, File.dirname(__FILE__) + '/public'

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

def check_user
  if session[:user_id].nil?
    redirect '/login'
  end
end

def set_user(client)
  return nil if session[:user_id].nil?
  @user = client.xquery("SELECT * From users WHERE id = ?", session[:user_id]).to_a.first
end

# トップページ
get '/' do

  set_user(client)
  check_user
  @posts = client.xquery("SELECT * FROM posts")

  # デバッグ例
  # @posts = client.query('SELECT * FROM posts').each do |entry|
  #   raise entry['id'].inspect
  # end

  erb :index
end

# 投稿詳細
get '/show/:id' do
  check_user
  set_user(client)
  @post = client.xquery('SELECT * FROM posts WHERE id = ?', params[:id]).first
  erb :show
end

# 新規作成(GET)
get '/create' do
  set_user(client)
  erb :create
end

# 新規作成(POST)
post '/create' do

  set_user(client)
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

  set_user(client)
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

def login?
  !session[:user_id].nil?
end

get '/signup' do
  redirect '/' if login?

  erb :signup
end

post '/signup' do
  redirect '/' if login?

  name = params[:name]
  email = params[:email]
  password = params[:password]

  client.xquery('INSERT INTO users (name, email, password) VALUES (?,?,?)', name, email, password)
  session[:user_id] = client.last_id

  redirect '/'
end

get '/login' do
  redirect '/' if login?

  erb :login
end

post '/login' do
  email = params[:email]
  password = params[:password]

  user = client.xquery("SELECT * FROM users where email = ? and password = ?",email, password).to_a.first
  if user
    session[:user_id] = user['id']
    # binding.pry

    redirect '/'
  else
    erb :login
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

# routing Example
# 通常
# get '/' do
#   "hello world again"
# end
#
# # 通常
# get '/hello/:name' do
#   "hello #{params[:name]}"
# end

# 単一パラメータ (params[]省略)
# get '/hello/:name' do |name|
#   "hello #{name}"
# end

# 複数パラメータ (params[]省略)
# get '/hello/:fname/:lname' do |f, l|
#   "hello #{f} #{l}"
# end

# 複数パラメータ (オプショナル有り)
# get '/hello/:fname/?:lname?' do |f, l|
#   "hello #{f} #{l}"
# end

# ワイルドカード
# get '/hello/*/*' do |f, l|
#   "hello #{f} #{l}"
# end

# ワイルドカード
# get '/hello/*/*' do
#   "hello #{params[:splat][0]} #{params[:splat][1]}"
# end

# 正規表現
# get %r{/users/([0-9]*)} do
#   "user id = #{params[:captures][0]}"
# end
