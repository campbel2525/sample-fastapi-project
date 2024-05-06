# 使用するNode.jsのバージョンを指定
FROM public.ecr.aws/docker/library/node:18-bullseye

# アップデート
RUN apt-get update && apt-get upgrade -y

# アプリケーションのディレクトリを設定
WORKDIR /project

# 環境変数
ENV NODE_ENV=development

# npmを最新バージョンにアップグレード
RUN npm install -g npm@latest
