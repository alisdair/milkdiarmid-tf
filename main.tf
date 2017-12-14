variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "dnsimple_account" {
  type = "string"
}

variable "dnsimple_token" {
  type = "string"
}

variable "web_count" {
  default = 1
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count         = "${var.web_count}"
  ami           = "ami-2757f631"
  instance_type = "t2.micro"

  tags {
    "Name" = "web ${count.index+1}/${var.web_count}"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_ip}"]
}

provider "dnsimple" {
  account = "${var.dnsimple_account}"
  token = "${var.dnsimple_token}"
}

resource "dnsimple_record" "milkdiarmid" {
  domain = "milkdiarmid.com"
  type = "A"
  name = "www"
  ttl = 60
  value = "${element(aws_instance.web.*.public_ip, count.index)}"
}
