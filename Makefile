tf-init:
	./build-lambdas.sh && terraform init

tf-plan:
	terraform plan

tf-apply:
	terraform apply

tf-destroy:
	terraform destroy
