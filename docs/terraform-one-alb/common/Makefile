tf-fmt:
	terraform fmt --recursive

apply:
	cd route53 && terraform init -migrate-state && terraform apply -auto-approve

destroy:
	cd route53 && terraform destroy -auto-approve
