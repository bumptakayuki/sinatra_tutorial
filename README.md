# sinatra_tutorial

## 初期化
```
$ bundle install
```

## SQL

```
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
