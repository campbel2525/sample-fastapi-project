FROM python:3.10

# apt-getのアップデート
RUN apt-get update

# 必要なものをインストール
RUN apt-get -y install \
    locales \
    vim \
    less

# 日本語設定
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

# デフォルトのディレクトリを設定
# イメージにディレクトリがないので作成される
WORKDIR /project

# project配下に.venvを作成する
ENV PIPENV_VENV_IN_PROJECT=1

# log出力をリアルタイムにする
ENV PYTHONUNBUFFERED=1

# キャッシュを作成しない
ENV PYTHONDONTWRITEBYTECODE=1

# パスを通す
ENV PYTHONPATH "/project"

# デバッグ用
# EXPOSE 9000

# pipのアップデート
RUN pip install --upgrade pip

# pipenvのインストール
RUN pip install --upgrade setuptools pipenv

# プロジェクトのファイルをコピー
# COPY ./ /project/

# ライブラリのインストール
# RUN pipenv install --dev
