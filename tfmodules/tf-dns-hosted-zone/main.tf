module "hosted_zone" {
	source    = "../modules/tfmodule-aws-route53-hosted-zone"
	domain    = "<domain>"
}
