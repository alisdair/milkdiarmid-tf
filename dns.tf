variable "dnsimple_account" {
  type = "string"
}

variable "dnsimple_token" {
  type = "string"
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
