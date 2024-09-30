## [for english](https://github.com/campbel2525/sample-project/blob/main/README-ENGLISH.md)

# 注意

開発途中なので色々コードは変わります

# 技術スタック

- バックエンド側: python の fastapi
- フロントエンド側: next.js(app router)
- インフラ: AWS
- iac: terraform
- 開発環境: docker

# 概要

ユーザー画面でユーザーが会員登録を行い、管理画面で編集できるといった簡単なサンプルアプリを作ってみました。
この機能はどんなプロジェクトでも使用する機能だと思うので、なにかプロジェクトを作る際にはこのリポジトリを参考にしてみてください
フォーマッター、静的解析、デバッグなども取り入れています

fastapi のフォルダ構成は今考え中で一旦 laravel のフォルダ構成を参考にして作りました
fastapi や next.js は勉強中ですので、何か不備がありましたら申し訳ありません

# 開発環境

管理側、ユーザー側を作ってあります。下記の url に対応しています

- 管理側の api: admin-api
  - http://localhost:8000/docs
- ユーザー側の api: user-api
  - http://localhost:8001/docs
- 管理側のフロント: admin-front
  - http://localhost:3000/
- ユーザー側のフロント: user-front
  - http://localhost:3001/

## サンプルユーザー

管理側
admin1@example.com
test1234

ユーザー側
user1@example.com
test1234

## 環境構築方法

手順 1
pc に docker が入っていない方は docker のインストールをしてください
公式サイト: https://code.visualstudio.com/download

手順 2
下記のコマンドを実行して docker の開発環境を作成します

```
make cp-env
make init
```

手順 3
admin-api の立ち上げ方法

```
make admin-api-run
```

を実行してブラウザで
http://localhost:8000/docs
にアクセスする

手順 4
admin-front の立ち上げ方法

```
make admin-front-run
```

を実行してブラウザで
http://localhost:3000/
にアクセスする

手順 5
user-api の立ち上げ方法

```
make user-api-run
```

を実行してブラウザで
http://localhost:8001/
にアクセスする

手順 6
user-front の立ち上げ方法

```
make user-front-run
```

を実行してブラウザで
http://localhost:3001/
にアクセスする

# iac について

[参照](https://github.com/campbel2525/sample-project/blob/main/infrastructures/terraform/README.md)

# その他

## push 時のルール

コンテナが立ち上がっている状態で下記のコマンドを実行してから push するようにしてください
バックエンド側、フロントエンド側のフォーマッタの実行、静的解析チェックなどが実行されます

```
make check
```

## api 側のライブラリのインストール方法

admin-api を例に説明します
docker を利用しているので モジュールをインストールする場合はコンテナの中に入ってインストールする必要があります
またモジュールの管理に pipenv を使用しているため特別な方法でインストールを実行する必要があります
以下にその方法を説明します

例
numpy をインストールする方法

手順 1
下記のコマンドでコンテナの中に入ります

```
make admin-api-shell
```

手順 2
下記のコマンドで numpy をインストールします

```
pipenv install numpy
```

## front 側のライブラリのインストール方法

admin-front を例に説明します
docker を利用しているので モジュールをインストールする場合はコンテナの中に入ってインストールする必要があります
またモジュールの管理に pipenv を使用しているため特別な方法でインストールを実行する必要があります
以下にその方法を説明します

例
xxx をインストールする方法

手順 1
下記のコマンドでコンテナの中に入ります

```
make admin-front-shell
```

手順 2
下記のコマンドで xxx をインストールします

```
npm install xxx
```

## マイグレーションについて

`app/models`配下に定義してあるテーブルが管理されます
新しくモデルのファイルを追加した場合は`app/models/__init__.py`に追記をする必要があります
下記のコマンドを実行することでマイグレーションとマイグレートが実行できます

### マイグレーション作成

```
pipenv run alembic revision --autogenerate -m 'comment'
```

### マイグレート

```
pipenv run alembic upgrade head
```

もしくは

```
make migrate
```

# 運用

## ブランチ運用

想定しているブランチは下記の通りになります

- main ブランチ: 開発
- (stg ブランチ: ステージングブランチ)
- prod ブランチ: 本番ブランチ

## デプロイフロー

デプロイのフローの流れは下記の通りになっています

1. main ブランチ -> prod ブランチのプルリクを作る
2. github 上でテストが実行される
3. テストが正しく終わったことを確認して、prod ブランチにマージする。これがトリガーになって下記の cicd が実行される
4. フロント、バックエンドのそれぞれがビルドされる
5. マイグレーション用の admin-api をビルドして、マイグレーションを実行する(ここのビルドは無駄。1 個前のステップでビルドしたものを使えばいいと思うはできないものか)
6. 上記の 4 つのプロジェクトをそれぞれデプロイする
