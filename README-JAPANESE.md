# 注意

開発途中なので色々コードは変わります

# 概要

サーバーは fastapi、フロントは svelte の spa でユーザー管理アプリを作ってみました  
ユーザー管理はどんなプロジェクトでも使用すると思うので何なにかプロジェクトを作る際にはこのリポジトリを参考にしてみてください
サンプルのため最低限の機能になります  
fastapi や svelte の方は勉強中です

認証は jwt 認証を用いています  
fastapi 側のフォルダ構成は今考え中で一旦 laravel のフォルダ構成を参考にして作りました

# 開発環境について

管理側、ユーザー側を作ってあります。

- 管理側の api: admin-api
- ユーザー側の api: user-api
- 管理側のフロント: admin-front
- ユーザー側のフロント: user-front

と対応しています。

## 開発環境 url

admin-api
http://localhost:8000/docks  
user-api
http://localhost:8001/docks  
admin-front
http://localhost:3000/  
user-front
http://localhost:3001/

## 共通

開発環境: docker  
想定エディタ: vscode or cursor  
認証方法: jtw

## fastapi 側の環境の詳細

言語: python3.10.0  
フレームワーク: fasapi  
デバッグ: debugpy  
ライブラリ管理: pipenv  
orm: sqlalchemy  
mysql: 8.0  
フォーマッターなど: flake8, mypy, black, isort  
jwt: pyJw

## svelte 側の環境の詳細

フレームワーク: svelte  
デザインフレームワーク: sveltestrap  
言語: typescript

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
下記のコマンドにて admin-api サーバーを立ち上げて、ブラウザで  
http://localhost:8000/docks  
にアクセスして swagger が表示されれば OK

```
make admin-api-run
```

手順 4  
下記のコマンドにて admin-front サーバーを立ち上げて、ブラウザで  
http://localhost:3000/  
にアクセスして画面が表示されれば OK

```
make admin-front-run
```

手順 5  
下記のコマンドにて user-api サーバーを立ち上げて、ブラウザで  
http://localhost:8001/docks  
にアクセスして swagger が表示されれば OK

```
make user-api-run
```

手順 6  
下記のコマンドにて user-front サーバーを立ち上げて、ブラウザで  
http://localhost:3001/  
にアクセスして画面が表示されれば OK

```
make user-front-run
```

# その他

## push 時のルール

コンテナが立ち上がっている状態で下記のコマンドを実行してから push すること  
フォーマッタの実行、静的解析チェックが走ります。

```
make check
```

## api 側のライブラリのインストール方法

user-api を例に説明します  
docker を利用しているので モジュールをインストールする場合はコンテナの中に入ってインストールする必要があります  
またモジュールの管理に pipenv を使用しているため特別な方法でインストールを実行する必要があります  
以下にその方法を説明します

例  
numpy をインストールする方法

手順 1  
下記のコマンドでコンテナの中に入ります

```
make user-api-shell
```

手順 2  
下記のコマンドで numpy をインストールします

```
pipenv install numpy
```

## front 側のライブラリのインストール方法

user-front を例に説明します  
docker を利用しているので モジュールをインストールする場合はコンテナの中に入ってインストールする必要があります  
またモジュールの管理に pipenv を使用しているため特別な方法でインストールを実行する必要があります  
以下にその方法を説明します

例  
xxx をインストールする方法

手順 1  
下記のコマンドでコンテナの中に入ります

```
make user-front-shell
```

手順 2  
下記のコマンドで xxx をインストールします

```
npm install xxx
```

## vscode で debugpy によるデバッグの方法

vscode で debugpy によるデバッグ方法を説明します  
参考: https://atmarkit.itmedia.co.jp/ait/articles/2107/16/news029.html

`python/src/sample.py` をデバッグする方法

手順 1  
vscode のプラグインの XXX をインストールします

手順 2  
`python/src/sample.py` のデバッグのコメントアウトを外します

手順 3  
「python の実行方法」を参考に実行し `python/src/sample.py` を実行します

手順４  
コンソールを確認すると

```
waiting ...
```

と表示されていることを確認

手順 5  
自分がデバッグを開始したい箇所にブレークポイントをセットします

手順 6  
F5 のキーを押します  
デバッグが開始されます。

## python コードのフォーマット、静的解析について

python にはプログラミングコードの品質を保つため、お勧めされているコードフォーマットや静的解析があります。  
下記のコマンドを実行することで python 配下の python コードが自動で整形がされ、また静的解析が行われます。

```
make check
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

# サンプル URL

fastapi  
https://fastapi.tiangolo.com/ja/

svelte  
https://kit.svelte.jp/

svelte 参考  
https://zenn.dev/wnr/articles/50cnoe5xvzmw

sveltestrap  
https://sveltestrap.js.org/?path=/docs/sveltestrap-overview--docs  
https://github.com/bestguy/sveltestrap

bootstrap  
https://getbootstrap.jp/docs/5.0/components/card/#navigation

# 課題

1. 認証を sha512 などに変更する
2. 認可を入れる？
3. モノレポの弊害

- 各プロジェクトで import 文に名前空間のエラーが出る
  python の方はライブラリの参照元に飛べない。node の方(php も)は飛べるので何か方法はあるはず
  解決方法としてコンテナにアタッチして vscode を開いて対応している
  workspace というのを使用してそれぞれのフォルダ内に./vscode/settings.json を置けばうまくいくことは確認できたが複数開かれるので微妙かもしれない
  いったんは workspace は使用せずに対応しようと思う
  workspace を使用するには下記のファイルのコメントアウトを外して、メニューの「ファイル > ファイルでワークスペースを開く」で project.code-workspace を選択する
  - apps/admin-api/.vscode
  - apps/user-api/.vscode
  - project.code-workspace

4. front 側にリフレッシュトークンの仕組みを入れる
5. admin-api-と user-api の認証のロジックを共通化する

## 関数名

それぞれの関数名は下記でよろしくお願いします  
なんでもいいのですが djangorest framework を参考にしました  
https://www.django-rest-framework.org/api-guide/viewsets/

- 一覧: index
- 詳細取得: retrieve
- 作成: create
- 更新: update
- 削除: destroy

tyu
