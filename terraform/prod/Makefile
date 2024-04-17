help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

tf-fmt: ## 再起的にfmt
	terraform fmt --recursive

all-apply: ## all apply
	cd network && terraform init -migrate-state && terraform apply -auto-approve
	cd rds/project-sample && terraform init -migrate-state && terraform apply -auto-approve
	cd app/common/ecs_cluster && terraform init -migrate-state && terraform apply -auto-approve
	cd app/admin-api && terraform init -migrate-state && terraform apply -auto-approve

# ecrのimageの削除をマネコンから行う必要があります
all-destroy: ## all destroy
	cd app/common/ecs_cluster && terraform destroy -auto-approve
	cd rds/project-sample && terraform destroy -auto-approve
	cd network && terraform destroy -auto-approve
	cd app/admin-api && terraform destroy -auto-approve

init: ## init
	make cp-env
	make apply

cp-env: ## envのコピー
# variables.tfのコピー
	cp variables.tf network/variables.tf
	cp variables.tf rds/project-sample/variables.tf
	cp variables.tf app/common/ecs_cluster/variables.tf
	cp variables.tf app/admin-api/variables.tf
# terraform.tfvarsのコピー
	cp terraform.tfvars network/terraform.tfvars
	cp terraform.tfvars rds/project-sample/terraform.tfvars
	cp terraform.tfvars app/common/ecs_cluster/terraform.tfvars
	cp terraform.tfvars app/admin-api/terraform.tfvars
