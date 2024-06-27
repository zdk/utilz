apply: plan addkey
	terraform apply -auto-approve plan

.PHONY: plan
plan:
	terraform plan --out plan

destroy:
	terraform destroy

addkey:
	ssh-add ~/.ssh/<domain>/aws/demo/deployer
