variable "instance_name_pub" {
  description = "brinks public ec2"
  type        = string
  default     = "brinks-pub"
}

variable "instance_name_pri" {
  description = "brinks private ec2"
  type        = string
  default     = "brinks-pri"
}

variable "ami_ubuntu"{
  description = "Ubuntu AMI"
  type        = string
  default     = "ami-0b6c6ebed2801a5cb"
}

variable "instance_type" {
  description = "brinks EC2 instance's type"
  type        = string
  default     = "t3.micro"
}

variable "lista_ips_publicos" {
    description = "Lista de ips publicos permitidos para SSH"
    type = list(string)
}