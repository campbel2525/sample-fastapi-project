## 環境構築

### 手順

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
make env

## 初期のプロジェクトの環境構築について

### 新規で作成する手順

参考 udemy  
お名前.com でドメイン(campbel.jp)をとったと想定します

1  
acm や route53 の設定をします

```
cd terraform/common/route53
terraform init -migrate-state && terraform apply -auto-approve
```

2  
お名前.com に dns の設定  
aws のマネコンを開き、route53 のリソースにアクセスし、作成されたホストゾーンを開く  
作成された タイプが「NS」 の「値/トラフィックのルーティング先」の値を値をお名前.com のネームサーバーに設定を行う(最後の「.」は外す)

3  
acm の CNAME をお名前.com に設定  
手順 2 の画面と同じ
acm を開く(東京、バージニアリージョンのどっちでも ok)  
お名前.com の「DNS 設定/転送設定」のリンク -> DNS レコード設定を利用する  
その CNAME をお名前.com の DNS レコードに追加する(最後の「.」は外す)

設定項目  
「お名前.com のホスト名」には「aws のレコード名」  
「お名前.com の VALUE」には「aws の値/トラフィックのルーティング先」  
「お名前.com の TYPE」は CNAME

ネームサーバーの変更確認コマンド  
nslookup -type=ns campbel.jp

ここまで行ったら、一旦コンソールを修了して ok  
時間が経つと  
保留中の検証 -> 成功  
ステータスが変わる(はず)

4  
route53 の ホストゾーン ID と東京リージョンの acm の arn とバージニアの acm の arn は aws のマネコンから参照し  
terraform/prod/terraform.tfvars  
に書き込む

5  
cd terraform/prod  
make env  
(後に aws コマンド化)

6  
make apply  
ssm にプロジェクトの.env を登録する  
codepipeline の Source の編集で github の認証情報の「保留中の接続を更新」を完了させる

### aws-cli コマンド

aws-cli  
ec2 一覧

```
aws --profile campbel2525 ec2 describe-instances
```

rds 一覧

```
aws --profile campbel2525 rds describe-db-instances
```

例 踏み台サーバー - shell

```
aws --profile campbel2525 ssm start-session --target i-0b33f6c640b533e89 --document-name SSM-SessionManagerRunShell
```

例 踏み台サーバー - ポートホワード

```
aws --profile campbel2525 ssm start-session --target i-0058f9967879b5cfe --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"host":["myai-prod-mysql-standalone.ctecenutz9b2.ap-northeast-1.rds.amazonaws.com"],"portNumber":["3306"],"localPortNumber":["13306"]}'
```

コンテナにログイン

```
aws ecs execute-command --profile campbel2525 --region ap-northeast-1 --cluster myai-prod-ecs-cluster --task 5ff182b68905403f99f76b133287dd52 --container myai-prod-user-api-app --interactive --command "/bin/bash"
```

パラメーターストア取得

```
aws --profile campbel2525 ssm get-parameter --name "/ecs/myai/prod/migration1/.env" --with-decryption --query 'Parameter.Value' --output text
```

## メモ

ecr は ecs と完全に独立しているため、tf ファイルを分けてもいいが、今回は一緒にまとめて作っている  
別ファイルに切り出してもいいかも

github の ghp の設定方法  
ghp での設定  
https://rfs.jp/server/git/github/personal_access_tokens.html  
codepipeline との連携で必要な権限  
GitHub Personal Access Token (ghp)を CodePipeline で使用するためには、以下のスコープの権限が一般的に必要です。  
repo: プライベートリポジトリを含むすべてのリポジトリへの読み取り/書き込みアクセスを有効にします。  
admin:repo_hook: リポジトリフック（webhooks）の読み取り、書き込み、および削除を有効にします。

今後  
backend "s3"  
の部分を env かできたらいいな。  
->現状は仕様としてできないらしい

### todo

iam の権限の絞り込み  
role の権限の絞り込み  
s3 の tf 化  
github 連携をもっといい感じにできる？

### vpc エンドポイントについて

前にいた現場では、vpc エンドポイントは ecr.dkr, ecr.api, s3 の 3 つのみでした  
他にも logs, secretsmanager, ssm, ssmmessages の vpc エンドポイントもあるようです  
よく要検討すること  
参考 url  
https://dev.classmethod.jp/articles/vpc-endpoints-for-ecs-2022/  
https://qiita.com/ldr/items/7c8bc08baca1945fdb50

### やりたいこと

「コンテナランタイム ID 名」は「タスク id-265927825」のようにしたい。 265927825 はおそらくランダムな数字
