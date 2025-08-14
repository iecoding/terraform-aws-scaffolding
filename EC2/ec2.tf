provider "aws" {
  region = "us-east-1"
  profile = "<profile-name>"
}

# Genera un par de claves SSH
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Sube la clave pública a AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "mediform-terraform-key" # Nombre que tendrá tu clave en AWS
  public_key = tls_private_key.rsa.public_key_openssh
}

# Guarda la clave privada en un archivo .pem local
resource "local_file" "private_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "mediform-terraform-key.pem" # Nombre del archivo .pem en tu máquina local
  file_permission = "0400" # Permisos recomendados para la clave privada
}

# Crea una instancia EC2 con la clave generada
resource "aws_instance" "EC2" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t3.small" # Tipo de instancia para entornos de desarrollo
  key_name      = aws_key_pair.generated_key.key_name
  security_groups = [ aws_security_group.mediformSG.name ]

  tags = {
    Name = "terraform-mediform-development"
  }
}

# Asocia una dirección IP elástica a la instancia EC2
resource "aws_eip" "mediformEIP" {
    instance = aws_instance.EC2.id

    tags = {
        Name = "terraform-mediform-development-eip"
    }
}

# Crea un grupo de seguridad para la instancia EC2
resource "aws_security_group" "mediformSG" {
    name        = "terraform-mediform-development-sg"
    description = "Security group for Mediform development environment"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["104.28.198.101/32"]
        description = "Allow SSH access from specific IP (Infinitec office)"
    }

    ingress {
        from_port   = 10000
        to_port     = 10000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

} 

# Salida de información útil (opcional)
output "InsideModule" {
    value = aws_eip.mediformEIP.public_ip
}

output "instance_public_ip" {
  value = aws_instance.EC2.public_ip
}

output "key_pair_name" {
  value = aws_key_pair.generated_key.key_name
}