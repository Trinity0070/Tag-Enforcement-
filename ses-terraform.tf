resource "aws_ses_email_identity" "email_identity" {
  count = length(var.email_addresses)
  email = var.email_addresses[count.index]
}



