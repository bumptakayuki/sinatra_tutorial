# sinatra_tutorial

<img width="1261" alt="2018-05-16 16 53 29" src="https://user-images.githubusercontent.com/12216342/40132412-ab6dc16a-5977-11e8-8df4-182dab5b3d8a.png">

## 初期化
```
$ bundle install
```

## SQL

```
CREATE TABLE users (
id INT( 5 ) NOT NULL AUTO_INCREMENT PRIMARY KEY ,
name VARCHAR( 25 ) NOT NULL ,
email VARCHAR( 35 ) NOT NULL ,
password VARCHAR( 60 ) NOT NULL ,
UNIQUE (email)
);

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title varchar(255),
  description varchar(255),
  image_path varchar(255),
  created_at date NOT NULL,
  updated_at date NOT NULL
);

INSERT INTO posts (title,description,image_path,created_at,updated_at) VALUES ('沖縄のペルー料理屋',   '沖縄のペルー料理屋に来ました！#okinawa #koza','/img/1.jpg',current_timestamp,current_timestamp);
INSERT INTO posts (title,description,image_path,created_at,updated_at) VALUES ('沖縄の中華料理屋',   '沖縄の中華料理屋に来ました！#okinawa #koza','/img/2.jpg',current_timestamp,current_timestamp);
INSERT INTO posts (title,description,image_path,created_at,updated_at) VALUES ('沖縄のフランス料理屋',   '沖縄のフランス料理屋に来ました！#okinawa #koza','/img/3.jpg',current_timestamp,current_timestamp);
```


# routing Example
# 通常

```ruby
get '/' do
  "hello world again"
end
```

# 通常

```ruby
get '/hello/:name' do
  "hello #{params[:name]}"
end
```

# 単一パラメータ (params[]省略)

```ruby
get '/hello/:name' do |name|
  "hello #{name}"
end
```

# 複数パラメータ (params[]省略)

```ruby
get '/hello/:fname/:lname' do |f, l|
  "hello #{f} #{l}"
end
```

# 複数パラメータ (オプショナル有り)

```ruby
get '/hello/:fname/?:lname?' do |f, l|
  "hello #{f} #{l}"
end
```

# ワイルドカード

```ruby
get '/hello/*/*' do |f, l|
  "hello #{f} #{l}"
end
```

# ワイルドカード

```ruby
get '/hello/*/*' do
  "hello #{params[:splat][0]} #{params[:splat][1]}"
end
```

# 正規表現

```ruby
get %r{/users/([0-9]*)} do
  "user id = #{params[:captures][0]}"
end
```
