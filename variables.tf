variable "vpc_subnet" {
  type = string
}

variable "subnets" {
  type = map(object({
    map_public_ip_on_launch = bool
    availability_zone       = number
  }))
}

variable "instance" {
  type = map(object({
    associate_public_ip = bool
    instance_type       = string
    key_name            = optional(string)
  }))
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