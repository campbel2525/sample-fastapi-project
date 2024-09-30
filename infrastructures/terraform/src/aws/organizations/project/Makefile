help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

fmt: ## 再起的にfmt
	terraform fmt --recursive

cp-variables:
# 配下のディレクトリにvariables.tfをコピー
	cp variables.tf acm/variables.tf
	cp variables.tf app/variables.tf
	cp variables.tf banstion/variables.tf
	cp variables.tf codepipeline/variables.tf
	cp variables.tf network/variables.tf
	cp variables.tf ssm_parameter/variables.tf
	cp variables.tf rds/db1/variables.tf

prod-init: ## init
	make cp-variables
# 配下のディレクトリにtprodm.tfvarsをコピー
	cp terraform.prod.tfvars acm/terraform.prod.tfvars
	cp terraform.prod.tfvars app/terraform.prod.tfvars
	cp terraform.prod.tfvars banstion/terraform.prod.tfvars
	cp terraform.prod.tfvars codepipeline/terraform.prod.tfvars
	cp terraform.prod.tfvars network/terraform.prod.tfvars
	cp terraform.prod.tfvars ssm_parameter/terraform.prod.tfvars
	cp terraform.prod.tfvars rds/db1/terraform.prod.tfvars
# init
	cd acm && terraform init -backend-config=../backend-config.prod.hcl -reconfigure
	cd app && terraform init -backend-config=../backend-config.prod.hcl -reconfigure
	cd banstion && terraform init -backend-config=../backend-config.prod.hcl -reconfigure
	cd codepipeline && terraform init -backend-config=../backend-config.prod.hcl -reconfigure
	cd network && terraform init -backend-config=../backend-config.prod.hcl -reconfigure
	cd ssm_parameter && terraform init -backend-config=../backend-config.prod.hcl -reconfigure
	cd rds/db1 && terraform init -backend-config=../../backend-config.prod.hcl -reconfigure
	cd ../aws-admin/route53-record/aws-prod && terraform init -backend-config=../../backend-config.hcl -reconfigure

prod-apply1: ## apply
	make prod-init
	cd acm && terraform apply -auto-approve -var-file="terraform.prod.tfvars"
	cd network && terraform apply -auto-approve -var-file="terraform.prod.tfvars"
	cd rds/db1 && terraform apply -auto-approve -var-file="terraform.prod.tfvars"
	cd ssm_parameter && terraform apply -auto-approve -var-file="terraform.prod.tfvars"
# cd banstiosn && terraform apply -auto-approve -var-file="terraform.prod.tfvars"

prod-apply2: ## apply
	make prod-init
	cd app && terraform apply -auto-approve -var-file="terraform.prod.tfvars"
	cd codepipeline && terraform apply -auto-approve -var-file="terraform.prod.tfvars"

prod-apply3: ## apply
	cd ../aws-admin/route53-record/aws-prod && terraform apply -auto-approve -var-file="terraform.prod.tfvars"

prod-destroy: ## all destroy
	cd ../aws-admin/route53-record/aws-prod && terraform destroy -auto-approve -var-file="terraform.prod.tfvars"
	cd codepipeline && terraform destroy -auto-approve -var-file="terraform.prod.tfvars"
	cd app && terraform destroy -auto-approve -var-file="terraform.prod.tfvars"
	cd banstion && terraform destroy -auto-approve -var-file="terraform.prod.tfvars"
	cd ssm_parameter && terraform destroy -auto-approve -var-file="terraform.prod.tfvars"
	cd rds/db1 && terraform destroy -auto-approve -var-file="terraform.prod.tfvars"
	cd network && terraform destroy -auto-approve -var-file="terraform.prod.tfvars"
	cd acm && terraform destroy -auto-approve -var-file="terraform.prod.tfvars"

reset:
	find . -type d -name ".terraform" -exec rm -rf {} +
	find . -type f -name ".terraform.lock.hcl" -exec rm -f {} +
