
terraform {
  backend "s3" {
    bucket = "a.khalilau-terraform"
    key    = "statefiles/terraform.tfstate"
    region = "eu-central-1"
  }
}
