include docker/.env
pf := $(COMPOSE_FILE)
pn := $(PROJECT_NAME)

help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

cp-env: ## envのコピー
	cp apps/admin-api/.env.example apps/admin-api/.env
	cp apps/user-api/.env.example apps/user-api/.env
	cp apps/admin-front/.env.example apps/admin-front/.env
	cp apps/user-front/.env.example apps/user-front/.env

init: ## 開発環境構築(ビルド)
# 開発環境の削除
	make destroy
# キャッシュ、ログ、ライブラリの削除
	make c
# ビルド
	docker compose -f $(pf) -p $(pn) build --no-cache
	docker compose -f $(pf) -p $(pn) down --volumes
	docker compose -f $(pf) -p $(pn) up -d
	./docker/wait-for-db.sh
	docker compose -f $(pf) -p $(pn) exec -T db mysql -psecret < docker/setup.dev.sql
# ライブラリのインストール
	make install
# DBリセット
	make reset

up: ## 開発環境up
	docker compose -f $(pf) -p $(pn) up -d

down: ## 開発環境down
	docker compose -f $(pf) -p $(pn) down

destroy: ## 開発環境削除
	make down
	docker network ls -qf name=$(pn) | xargs docker network rm
	docker container ls -a -qf name=$(pn) | xargs docker container rm
	docker volume ls -qf name=$(pn) | xargs docker volume rm

reset: ## DBのリセット
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run python app/console/commands/drop_all_tables.py
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run alembic upgrade head
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run python app/console/commands/seeds.py

migration-reset: ## マイグレーションのリセット
# 開発中のコマンドになる
# 運用が始まったら使用しないこと
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run python app/console/commands/drop_all_tables.py
	rm -rf apps/common/api/migrations/versions/*
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run alembic revision --autogenerate -m 'comment'
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run alembic upgrade head
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run python app/console/commands/seeds.py

migrate: ## マイグレート
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run alembic revision --autogenerate -m 'comment'
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run alembic upgrade head

install: ## インストール
# ライブラリの削除
	make lib-c
# ライブラリのインストール
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv install --dev
	docker compose -f $(pf) -p $(pn) exec -it user-api pipenv install --dev
	docker compose -f $(pf) -p $(pn) exec -it admin-front npm install --save-dev
	docker compose -f $(pf) -p $(pn) exec -it user-front npm install --save-dev

admin-api-shell: ## shellに入る
	docker compose -f $(pf) -p $(pn) exec -it admin-api bash

user-api-shell: ## shellに入る
	docker compose -f $(pf) -p $(pn) exec -it user-api bash

admin-front-shell: ## shellに入る
	docker compose -f $(pf) -p $(pn) exec -it admin-front bash

user-front-shell: ## shellに入る
	docker compose -f $(pf) -p $(pn) exec -it user-front bash

db-shell: ## shellに入る
	docker compose -f $(pf) -p $(pn) exec -it db bash

check: ## コードフォーマット
# admin-api
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run isort .
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run black .
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run flake8 .
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run mypy .
# user-api
	docker compose -f $(pf) -p $(pn) exec -it user-api pipenv run isort .
	docker compose -f $(pf) -p $(pn) exec -it user-api pipenv run black .
	docker compose -f $(pf) -p $(pn) exec -it user-api pipenv run flake8 .
	docker compose -f $(pf) -p $(pn) exec -it user-api pipenv run mypy .
# admin-front
	docker compose -f $(pf) -p $(pn) exec -it admin-front npx prettier .  --write
	docker compose -f $(pf) -p $(pn) exec -it admin-front npx eslint . --fix
# docker compose -f $(pf) -p $(pn) exec -it admin-front npm run check
# user-front
	docker compose -f $(pf) -p $(pn) exec -it user-front npx prettier . --write
	docker compose -f $(pf) -p $(pn) exec -it user-front npx eslint . --fix
# docker compose -f $(pf) -p $(pn) exec -it user-front npm run check

# テスト
# mak test

admin-api-run: ## サーバー起動
	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run uvicorn main:app --host 0.0.0.0 --reload --port 8000

user-api-run: ## サーバー起動
	docker compose -f $(pf) -p $(pn) exec -it user-api pipenv run uvicorn main:app --host 0.0.0.0 --reload --port 8000

admin-front-run: ## サーバー起動
	docker compose -f $(pf) -p $(pn) exec -it admin-front npm run dev

# admin-front-run-preview: ## サーバー起動
# 	docker compose -f $(pf) -p $(pn) exec -it admin-front npm run preview

admin-front-build-run: ## サーバー起動
	docker compose -f $(pf) -p $(pn) exec -it admin-front npm run build
	docker compose -f $(pf) -p $(pn) exec -it admin-front sh -c "HOST=0.0.0.0 PORT=3000 node build"

user-front-run: ## サーバー起動
	docker compose -f $(pf) -p $(pn) exec -it user-front npm run dev

# user-front-run-preview: ## サーバー起動
# 	docker compose -f $(pf) -p $(pn) exec -it user-front npm run preview

user-front-build-run: ## サーバー起動
	docker compose -f $(pf) -p $(pn) exec -it user-front npm run build
	docker compose -f $(pf) -p $(pn) exec -it user-front sh -c "HOST=0.0.0.0 PORT=3000 node build"

# test: ## テスト
# 	make admin-api-test
# 	make user-api-test
# 	make admin-front-test
# 	make user-front-test

# admin-api-test: ## テスト
# 	docker compose -f $(pf) -p $(pn) exec -it admin-api pipenv run pytest

# user-api-test: ## テスト
# 	docker compose -f $(pf) -p $(pn) exec -it user-api pipenv run pytest

# admin-front-test: ## テスト
# 	docker compose -f $(pf) -p $(pn) exec -it admin-front

# user-front-test: ## テスト
# 	docker compose -f $(pf) -p $(pn) exec -it user-front

c: ## キャッシュ、ログ、ライブラリの削除
# キャッシュの削除
	rm -rf apps/admin-api/.mypy_cache
	rm -rf apps/user-api/.mypy_cache
	rm -rf apps/admin-front/.next
	rm -rf apps/admin-front/next-env.d.ts
	rm -rf apps/user-front/.next
	rm -rf apps/user-front/next-env.d.ts
# ログの削除
	rm -rf apps/admin-api/log/fastapi.log
	rm -rf apps/admin-api/logs/sqlalchemy.log
	rm -rf apps/user-api/log/fastapi.log
	rm -rf apps/user-api/logs/sqlalchemy.log
# ライブラリの削除
	make lib-c

lib-c: ## ライブラリの削除
	rm -rf apps/admin-api/.venv
	rm -rf apps/user-api/.venv
	rm -rf apps/admin-front/node_modules
	rm -rf apps/user-front/node_modules

push: ## push
# make format
	git switch main
	git pull origin main
	git add .
	git commit -m "Commit at $$(date +'%Y-%m-%d %H:%M:%S')"
	git push origin main
	git push origin main:prod

# reset-commit: ## mainブランチのコミット履歴を1つにする
# 	git checkout --orphan new-branch-name
# 	git add .
# 	git branch -D main
# 	git branch -m main
# 	git commit -m "Initial commit"
# 	git push origin -f main

github-init:
# ビルド
	docker compose -f $(pf) -p $(pn) build --no-cache
	docker compose -f $(pf) -p $(pn) down --volumes
	docker compose -f $(pf) -p $(pn) up -d
	./docker/wait-for-db.sh
	docker compose -f $(pf) -p $(pn) exec -T db mysql -psecret < docker/setup.dev.sql
# ライブラリのインストール
	make install
# DBリセット
	make reset

github-check:
# admin-api
	docker compose -f $(pf) -p $(pn) exec -it admin-api bash -c "pipenv run isort . --check-only"
	docker compose -f $(pf) -p $(pn) exec -it admin-api bash -c "pipenv run black . --check"
	docker compose -f $(pf) -p $(pn) exec -it admin-api bash -c "pipenv run flake8 ."
	docker compose -f $(pf) -p $(pn) exec -it admin-api bash -c "pipenv run mypy ."
# user-api
	docker compose -f $(pf) -p $(pn) exec -it user-api bash -c "pipenv run isort . --check-only"
	docker compose -f $(pf) -p $(pn) exec -it user-api bash -c "pipenv run black . --check"
	docker compose -f $(pf) -p $(pn) exec -it user-api bash -c "pipenv run flake8 ."
	docker compose -f $(pf) -p $(pn) exec -it user-api bash -c "pipenv run mypy ."
# admin-front
	docker compose -f $(pf) -p $(pn) exec -it admin-front bash -c "npx prettier . --check"
	docker compose -f $(pf) -p $(pn) exec -it admin-front bash -c "npx eslint ."
# docker compose -f $(pf) -p $(pn) exec -it admin-front bash -c "npm run check"
# user-front
	docker compose -f $(pf) -p $(pn) exec -it user-front bash -c "npx prettier . --check"
	docker compose -f $(pf) -p $(pn) exec -it user-front bash -c "npx eslint ."
# docker compose -f $(pf) -p $(pn) exec -it user-front bash -c "npm run check"

#
