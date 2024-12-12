vpc_subnet = "10.0.0.0/16"
subnets = {
  "public_subnet_1" = {
    map_public_ip_on_launch = true
    availability_zone       = 0
  }
  "public_subnet_2" = {
    map_public_ip_on_launch = true
    availability_zone       = 1
  }
  "private_subnet_1" = {
    map_public_ip_on_launch = false
    availability_zone       = 0
  }
  "private_subnet_2" = {
    map_public_ip_on_launch = false
    availability_zone       = 1
  }
}

instance = {
  "bastion_host" = {
    associate_public_ip = true
    instance_type       = "t2.micro"
    key_name            = "jenkins"
  }
  "web_server" = {
    associate_public_ip = false
    instance_type       = "t2.micro"
  }
}

bastion_sg = {
  bastion_sg = {
    description = "Allow tls traffic from port 22"
    name        = "bastion_sg"
    port        = 22
  }
}

webserver_sg = {
  webserver_sg = { description = "Allow tls traffic from port 22"
    name = "bastion_sg"
  port = 80 }
}
