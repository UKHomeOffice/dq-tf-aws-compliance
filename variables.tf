variable "ENV_ACCT_ID" {
}

variable "ENV_ACCT_KEY" {
}

variable "namespace" {
  default = "test"
}

variable "config_name" {
  "dq-aws-config"
}

# variable "account_id" {
#   type = map(string)
#   default = {
#     "test" = "797728447925"
#     # "notprod" = "483846886818"
#     # "prod"    = "337779336338"
#   }
# }
