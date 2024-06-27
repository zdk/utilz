resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
	public_key = "<ssh public key>"
}
