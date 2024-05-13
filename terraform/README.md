# 概要

環境は

- stg
- prod

を想定しています。リソースはひとまとまりになるようにフェルだを設計しています
全環境で共通の処理、書く環境で設定する項目があります。
route53 は全環境で共通の処理です。(stg も prod も同じドメインを使用してサブドメインで作成することを想定しているためです。)

# 環境構築

## 環境変数の設定の手順

環境変数は格環境ごとに作成します。リソースに限らず同じ環境変数を使用します。
`make cp-cnv`で格リソースにコピーが可能です
下記はその手順になります

1
terraform/common/route53/terraform.tfvars.example
を参考に
terraform/common/route53/terraform.tfvars
を適切に作成する

2
terraform/prod/terraform.tfvars.example
を参考に
terraform/prod/terraform.tfvars
を適切に作成する

3
cd terraform/prod

4
make cp-env

## DNS の設定

参考 udemy
お名前.com でドメイン(example.com)を取得したと想定します

stg は

- stg-example.com
  prod は
- example.com

のようなドメインを想定しているため、このドメインの設定は stg と prod で共通で 1 回行うことになります

下記は手順です

1 acm や route53 の設定(ネームサーバー)

terraform/common/route53/terraform.tfvars.example
を参考に
terraform/common/route53/terraform.tfvars
を作成する
その後に下記のコマンドを実行する

```
cd terraform/common/route53
terraform init -migrate-state && terraform apply -auto-approve
```

2 お名前.com の dns の設定
aws のマネコンを開き、route53 のリソースにアクセスし、作成されたホストゾーンを開く
作成された タイプが「NS」 の「値/トラフィックのルーティング先」の値を値をお名前.com のネームサーバーに設定を行う(最後の「.」は外す)

3 acm の CNAME をお名前.com に設定
手順 2 の画面と同じ
acm を開く(東京、バージニアリージョンのどっちでも ok)
お名前.com の「DNS 設定/転送設定」のリンク -> DNS レコード設定を利用する
その CNAME をお名前.com の DNS レコードに追加する(最後の「.」は外す)

設定項目
「お名前.com のホスト名」には「aws のレコード名」
「お名前.com の VALUE」には「aws の値/トラフィックのルーティング先」
「お名前.com の TYPE」は CNAME

ネームサーバーの変更確認コマンド
nslookup -type=ns example.com

ここまで行ったら、一旦コンソールを修了して ok
時間が経つと
保留中の検証 -> 成功
ステータスが変わる(はず)

## prod 環境を作る手順のサンプル

「DNS の設定」が終わった後にこちらの手順を実行します
1
route53 の ホストゾーン ID と東京リージョンの acm の arn とバージニアの acm の arn は aws のマネコンから参照し
terraform/prod/terraform.tfvars
に書き込む

2

```
cd terraform/prod
make cp-env
```

3

```
make apply
```

4
rds のパスワードを書き換える
ssm にプロジェクトの.env を登録する
(github との連携を手動で行う)
codepipeline の Source の編集で github の認証情報の「保留中の接続を更新」を完了させる。一旦画面を開いて閉じてから再度開く必要がある

5
githubprod ブランチに push すると cicd が走ってデプロイされます

# その他

## github の ghp の設定方法

ghp の設定
https://rfs.jp/server/git/github/personal_access_tokens.html

キーの設定場所
profile settings > Developer Settings > Personal access tokens > tokens (classic)

codepipeline との連携で必要な権限
GitHub Personal Access Token (ghp)を CodePipeline で使用するためには、以下のスコープの権限が一般的に必要です。

repo: プライベートリポジトリを含むすべてのリポジトリへの読み取り/書き込みアクセスを有効にします。
admin:repo_hook: リポジトリフック（webhooks）の読み取り、書き込み、および削除を有効にします。

## 今後の課題

1.  下記の内容を要調査する

- iam の権限の絞り込み
- role の権限の絞り込み
- github 連携をもっといい感じにできる？

2. vpc エンドポイントの再考察
   現状設定している vpc エンドポイントは ecr.dkr, ecr.api, s3 の 3 つのみです。 他にも logs, secretsmanager, ssm, ssmmessages の vpc エンドポイントもあるようです
   よく要検討すること
   参考 url
   https://dev.classmethod.jp/articles/vpc-endpoints-for-ecs-2022/
   https://qiita.com/ldr/items/7c8bc08baca1945fdb50

3. 現状は prod しかないが stg 環境も作る。マルチ環境は terraform どう作るか考える
   参考 url
   https://qiita.com/poly_soft/items/c71bb763035b2047d2db
