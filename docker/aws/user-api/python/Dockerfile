FROM public.ecr.aws/docker/library/python:3.10-bullseye

# アップデート
RUN apt-get update && apt-get upgrade -y

# 必要なものをインストール
# RUN apt-get -y install locales

# 日本語設定
# RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

# デフォルトのディレクトリを設定
# イメージにディレクトリがないので作成される
WORKDIR /project

# project配下に.venvを作成する
ENV PIPENV_VENV_IN_PROJECT=1

# log出力をリアルタイムにする
ENV PYTHONUNBUFFERED=1

# キャッシュを作成しない
# ENV PYTHONDONTWRITEBYTECODE=1

# パスを通す
ENV PYTHONPATH "/project"

# pipのアップデート
RUN pip install --upgrade pip

# pipenvのインストール
RUN pip install --upgrade setuptools pipenv

# プロジェクトのファイルをコピー
COPY ./apps/user-api/ /project/
COPY ./apps/core/api/database/ /project/core/database/
COPY ./apps/core/api/migrations/ /project/migrations/

# ライブラリのインストール
RUN pipenv install

# サーバーの起動
COPY ./docker/aws/user-api/python/cmd.sh /usr/local/bin/cmd.sh
RUN chmod 777 /usr/local/bin/cmd.sh
CMD ["/usr/local/bin/cmd.sh"]
