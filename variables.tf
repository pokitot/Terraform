# variables.tf

variable "newrelic_account_id" {
  description = "New Relic account ID"
  type        = string
}

variable "newrelic_api_key" {
  description = "New Relic API key"
  type        = string
}
variable "email_recipients" {
  description = "List of email addresses to receive notifications"
  type        = string
}