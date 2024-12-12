variable "vpc_subnet" {
  type = string
}

variable "subnets" {
  type = map(object({
    map_public_ip_on_launch = bool
    availability_zone       = number
  }))
}

