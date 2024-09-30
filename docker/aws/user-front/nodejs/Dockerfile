# 使用するNode.jsのバージョンを指定
FROM public.ecr.aws/docker/library/node:18-bullseye

# アップデート
RUN apt-get update && apt-get upgrade -y

# アプリケーションのディレクトリを設定
WORKDIR /project

# 環境変数
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=8000

# npmを最新バージョンにアップグレード
RUN npm install -g npm@latest

# プロジェクトのファイルをコピー
COPY ./apps/user-front/ /project/

# ライブラリのインストール
RUN npm install

# # ビルド
RUN npm run build

# Dockerfile内でAWSのパラメーターストアから設定を動的に取得するには、ビルド時ではなく、コンテナの実行時に設定を取得する必要があります。
# Dockerのビルドプロセス（RUN コマンドを使用する部分）は静的であり、実行時の動的な操作（例えば、環境変数に基づいて異なる動作をする）はサポートしていません。
# そのため、ENTRYPOINT や CMD を使って実行時に設定を取得する方法を検討する必要があります。

# サーバーの起動
COPY ./docker/aws/user-front/nodejs/cmd.sh /usr/local/bin/cmd.sh
RUN chmod 777 /usr/local/bin/cmd.sh
CMD ["/usr/local/bin/cmd.sh"]
