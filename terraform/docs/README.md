# ecr と.env の関係

この作り方では ecr には.env は push されないです  
cmd.sh は

```
コンテナが起動する際に動的に環境変数をファイルに書き込むことが可能となります。つまり、Dockerイメージ自体は環境変数の内容を含んでいませんが、コンテナが実行されるときにその環境変数の値が書き込まれます。
```

という使われ方をするため、直接.env を指定しているわけではないからです

まとめるとコンテナが実行されるタイミングで、cmd.sh が実行され、container_definitions に指定されている APP_ENV_VALUES がセットされます

そのため、ecr にある image を使用する際には、.env の値を指定する必要があります

# ecs のポートと内部で動くポートの関係

networkMode=awsvpc  
という制約があるため、ecs のポートと内部で動くポートは合わせる必要がある

```
│ Error: creating ECS Task Definition (ps-prod-admin-front-ecs-task-definition): ClientException: When networkMode=awsvpc, the host ports and container ports in port mappings must match.
│
│ with aws_ecs_task_definition.ecs_app,
│ on ecs.tf line 3, in resource "aws_ecs_task_definition" "ecs_app":
│ 3: resource "aws_ecs_task_definition" "ecs_app" {
│

```

# front のビルドを行う場所

front のビルドを行う場所は codebuild で行うようにしました。  
理由としては、next.js のビルドは結構なスペックが必要で ecs でビルドを行う場合は下記のスペックが必要でした。

```
cpu = "512"
memory = "2048"
```

そのため public な.env は buildspec に含める必要があります(ビルド時に.env を含める必要がるためです)

# 色々考察したこと

1.  front は amplify を使用しようと考えたのですが、標準の使い方では amplify のビルド・デプロイを完全に制御できなさそうでした。amplify では「ビルド・デプロイ」は一貫して行われるようです  
    なるべくビルド・デプロイのタイミングは合わせたいため、ecs を使用することにしました。

github action は

- blue/green デプロイの設定がクソめんどくさい
- 記述量がやけに多い
  との理由から使用をやめて codepipline を使用することにしました。

2.  alb はアプリごとに 1 個にするか、共通で 1 個にするかでかなり悩みました。

それぞれのメリット、デメリットは下記の通りです。
コードの綺麗さをとるか、お金をとるか。。
お金を取りました！！笑

alb をアプリごとに 1 個ずつにする場合
メリット

- 設定が簡単
- 高い

共通で 1 個にする場合
メリット

- 構成が単純
- 安い

デメリット

- alb のリスナールールの priority はプロジェクト全体で被らないようにする必要がある
- セキュリティグループの設定が多くなる

3.  このコードでは、本番と stg で ecr をわかれるようにしていますが、上記の理由から、分けないで、いいかもしれません。  
    というのも、ブランチ運用が、main->stg->prod のように、完全位守られていれば、stg で作成した image を使用できるためです  
    ただこのやり方だと、main->prod へマージした際にそうするかわからないです。 致命的なバグが出た場合は、main->prod のマージを行うことが出てくるかもしれません。

# 費用についてのメモ

1 ドル = 150 円として換算

alb

- https://aws.amazon.com/jp/elasticloadbalancing/pricing/
- 32.76 USD/月 = 4914 円

ecs

nat gateway  
https://aws.amazon.com/jp/vpc/pricing/  
NAT ゲートウェイの時間単位料金: NAT ゲートウェイは時間単位で請求されます。このリージョンの場合、1 時間あたりの料金は 0.045 USD です。  
NAT ゲートウェイのデータ処理料金: 1 GB のデータが NAT ゲートウェイを経由すると、データ処理では、0.045 USD が課金されることになります。

固定費分 nat 4860 円/月  
通信量

# よく使う aws コマンド

ec2 一覧

```
aws ec2 describe-instances \
--profile xxxxx
```

rds 一覧

```
aws rds describe-db-instances \
--profile xxxxx
```

実行中の ec2 の id 一覧

```
aws ec2 describe-instances \
--profile xxxxx \
--filters "Name=instance-state-name,Values=running" \
--query 'Reservations[*].Instances[*].InstanceId' \
--output text
```

例 踏み台サーバー - shell

```
aws ssm start-session \
--profile xxxxx \
--target i-12345678910 \
--document-name SSM-SessionManagerRunShell
```

例 踏み台サーバー - ポートフォワード

```
aws ssm start-session \
--profile xxxxx \
--target i-12345678910 \
--document-name AWS-StartPortForwardingSessionToRemoteHost \
--parameters '{"host":["<rds の endpoint>"],"portNumber":["3306"],"localPortNumber":["13306"]}'
```

コンテナにログイン

```
aws ecs execute-command \
--profile xxxxx \
--region ap-northeast-1 \
--cluster ps-prod-ecs-cluster \
--task 22d032a7aa0a48c8abf2b419ca5fa79c \
--container ps-prod-admin-api-app \
--interactive \
--command "/bin/bash"
```

パラメーターストア取得

```
aws ssm get-parameter \
--profile xxxxx \
--name "/ecs/myai/prod/migration1/.env" \
--with-decryption \
--query 'Parameter.Value' \
--output text
```
