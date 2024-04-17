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

# pipのアップデート
RUN pip install --upgrade pip

# pipenvのインストール
RUN pip install --upgrade setuptools pipenv

# プロジェクトのファイルをコピー
COPY ./apps/admin-api/ /project/
COPY ./apps/common/api/database/ /project/common/database/
COPY ./apps/common/api/migrations/ /project/migrations/

# ライブラリのインストール
RUN pipenv install

# entrypoint.shの実行
COPY ./apps/admin-api/docker/fargate/python/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 777 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# local開発環境の値と異なることに注意
CMD ["gunicorn", "api.main:app", "--workers", "3", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000", "--timeout", "120"]
