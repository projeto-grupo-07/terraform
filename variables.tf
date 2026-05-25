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

variable "ami_ubuntu" {
  description = "Ubuntu AMI"
  type        = string
  default     = "ami-0b6c6ebed2801a5cb"
}

variable "instance_type" {
  description = "brinks EC2 instance's type"
  type        = string
  default     = "t3.small"
}

variable "instance_key" {
  description = "brinks EC2 instance's key"
  type        = string
  default     = "vockey"
}

variable "porta_ssh" {
  description = "Porta para acesso ssh"
  type        = number
  default     = 22
}

variable "porta_http" {
  description = "Porta para acesso http"
  type        = number
  default     = 80
}

variable "porta_mysql" {
  description = "Porta para acesso mysql"
  type        = number
  default     = 3306
}

variable "ips_qualquer_lugar_v4" {
  description = "Lista de CIDR para qualquer lugar IPv4"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ips_qualquer_lugar_v6" {
  description = "Lista de CIDR para qualquer lugar IPv6"
  type        = list(string)
  default     = ["::/0"]

}

variable "lambda_raw_name" {
  default = "lambda-raw"
}

variable "user_suffix" {
  description = "Identificador único por usuário"
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key (evite hardcoding; prefira perfil de instância)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS secret key (evite hardcoding; prefira perfil de instância)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aws_session_token" {
  description = "AWS session token (se usar credenciais temporárias)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "gmail_user" {
  description = "Conta Gmail para envio de e-mails (app password)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "gmail_password" {
  description = "Senha do Gmail ou app password"
  type        = string
  sensitive   = true
  default     = ""
}
