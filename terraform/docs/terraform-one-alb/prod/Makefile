help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

fmt: ## 再起的にfmt
	terraform fmt --recursive

apply1: ## apply1
	cd network && terraform init -migrate-state && terraform apply -auto-approve
	cd rds/db1 && terraform init -migrate-state && terraform apply -auto-approve
	cd apps/common/ecs_cluster && terraform init -migrate-state && terraform apply -auto-approve
	cd apps/common/alb && terraform init -migrate-state && terraform apply -auto-approve

apply2: ## apply2
	cd apps/admin-api && terraform init -migrate-state && terraform apply -auto-approve
	cd apps/user-api && terraform init -migrate-state && terraform apply -auto-approve
	cd apps/admin-front && terraform init -migrate-state && terraform apply -auto-approve
	cd apps/user-front && terraform init -migrate-state && terraform apply -auto-approve
	cd codepipeline && terraform init -migrate-state && terraform apply -auto-approve
# cd ssm_parameter && terraform init -migrate-state && terraform apply -auto-approve
	cd banstion && terraform init -migrate-state && terraform apply -auto-approve

destroy: ## all destroy
	cd apps/admin-api && terraform destroy -auto-approve
	cd apps/user-api && terraform destroy -auto-approve
	cd apps/admin-front && terraform destroy -auto-approve
	cd apps/user-front && terraform destroy -auto-approve
# cd ssm_parameter && terraform destroy -auto-approve
	cd codepipeline && terraform destroy -auto-approve
	cd apps/common/alb && terraform destroy -auto-approve
	cd apps/common/ecs_cluster && terraform destroy -auto-approve
	cd rds/db1 && terraform destroy -auto-approve
	cd banstion && terraform destroy -auto-approve
	cd network && terraform destroy -auto-approve

cp-env: ## envのコピー
# variables.tfのコピー
	cp variables.tf network/variables.tf
	cp variables.tf rds/db1/variables.tf
	cp variables.tf apps/common/ecs_cluster/variables.tf
	cp variables.tf apps/common/alb/variables.tf
	cp variables.tf apps/admin-api/variables.tf
	cp variables.tf apps/admin-front/variables.tf
	cp variables.tf apps/user-api/variables.tf
	cp variables.tf apps/user-front/variables.tf
	cp variables.tf codepipeline/variables.tf
	cp variables.tf ssm_parameter/variables.tf
	cp variables.tf banstion/variables.tf
# terraform.tfvarsのコピー
	cp terraform.tfvars network/terraform.tfvars
	cp terraform.tfvars rds/db1/terraform.tfvars
	cp terraform.tfvars apps/common/ecs_cluster/terraform.tfvars
	cp terraform.tfvars apps/common/alb/terraform.tfvars
	cp terraform.tfvars apps/admin-api/terraform.tfvars
	cp terraform.tfvars apps/admin-front/terraform.tfvars
	cp terraform.tfvars apps/user-api/terraform.tfvars
	cp terraform.tfvars apps/user-front/terraform.tfvars
	cp terraform.tfvars codepipeline/terraform.tfvars
	cp terraform.tfvars ssm_parameter/terraform.tfvars
	cp terraform.tfvars banstion/terraform.tfvars

all-cler: ## all cler
# .terraformの削除
	rm -rf network/.terraform
	rm -rf rds/db1/.terraform
	rm -rf apps/common/ecs_cluster/.terraform
	rm -rf apps/common/alb/.terraform
	rm -rf apps/admin-api/.terraform
	rm -rf apps/admin-front/.terraform
	rm -rf apps/user-api/.terraform
	rm -rf apps/user-front/.terraform
	rm -rf codepipeline/.terraform
	rm -rf ssm_parameter/.terraform
	rm -rf banstion/.terraform
# .terraform.lock.hclの削除
	rm -rf network/.terraform.lock.hcl
	rm -rf rds/db1/.terraform.lock.hcl
	rm -rf apps/common/ecs_cluster/.terraform.lock.hcl
	rm -rf apps/common/alb/.terraform.lock.hcl
	rm -rf apps/admin-api/.terraform.lock.hcl
	rm -rf apps/admin-front/.terraform.lock.hcl
	rm -rf apps/user-api/.terraform.lock.hcl
	rm -rf apps/user-front/.terraform.lock.hcl
	rm -rf codepipeline/.terraform.lock.hcl
	rm -rf ssm_parameter/.terraform.lock.hcl
	rm -rf banstion/.terraform.lock.hcl
