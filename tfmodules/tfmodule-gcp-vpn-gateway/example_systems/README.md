## Local setup

1. Install terraform using `brew install terraform`.
2. We usually check in `terraform.tfvars.sample` which can be used to
   create `terraform.tfvars`.
3. Run `terraform init` to sync with backend and import terraform modules.
4. Run `terraform plan` to verify infrastructure state.
