variable "instance" {
  type = map(object({
    associate_public_ip = bool
    instance_type       = string
    key_name            = optional(string)
  }))
}
variable "public_subnet_id" {
  type = string
}
variable "private_subnet_id" {
  type = string
}

variable "bastion_sg" {
  type = map(object({
    name        = string
    port        = number
    description = string
  }))
}
variable "webserver_sg" {
  type = map(object({
    name        = string
    port        = number
    description = string
  }))
}

variable "vpc_id" {
  type = string
}