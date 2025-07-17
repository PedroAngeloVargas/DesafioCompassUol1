
/*Caso seja necessário o acesso das subnets privadas a internet, retire os sinais de comentarios dos blocos a seguir*/

#VPC
resource "aws_vpc" "minha_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc"
  }
}

#IPs Elasticos (Necessários para os NAT Gateways)
/*
resource "aws_eip" "ip1" {
  domain = "vpc"

  tags = {
    Name = "IP_Elastico1"
  }
}

resource "aws_eip" "ip2" {
  domain = "vpc"

  tags = {
    Name = "IP_Elastico2"
  }
}
*/

#Internet Gateway 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.minha_vpc.id

  tags = {
    Name = "Internet_Gateway"
  }

}

#NAT Gateways 
/*
resource "aws_nat_gateway" "meu_nat1" {
  allocation_id = aws_eip.ip1.id
  subnet_id     = aws_subnet.minha_subnet_publica1.id


  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "NAT1"
  }

}

resource "aws_nat_gateway" "meu_nat2" {
  allocation_id = aws_eip.ip2.id
  subnet_id     = aws_subnet.minha_subnet_publica2.id

  depends_on = [aws_internet_gateway.igw]


  tags = {
    Name = "NAT2"
  }
}
*/

#4 Subnets (2 Publicas / 2 Privadas)
resource "aws_subnet" "minha_subnet_publica1" {
  vpc_id     = aws_vpc.minha_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_publica1"
  }

}

resource "aws_subnet" "minha_subnet_publica2" {
  vpc_id     = aws_vpc.minha_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_publica2"
  }

}

resource "aws_subnet" "minha_subnet_privada1"{
  vpc_id     = aws_vpc.minha_vpc.id
  cidr_block = "10.0.100.0/24"
  availability_zone = "us-east-1a"


  tags = {
    Name = "subnet_privada1"
  }
}

resource "aws_subnet" "minha_subnet_privada2"{
  vpc_id     = aws_vpc.minha_vpc.id
  cidr_block = "10.0.200.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet_privada2"
  }

}

#Route Tables 

resource "aws_route_table" "tabela_rotas_publica" {
  vpc_id = aws_vpc.minha_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "Tabelo_Rotas_Publica"
  }
}
/*
resource "aws_route_table" "tabela_rotas_privada1" {
  vpc_id = aws_vpc.minha_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.meu_nat1.id
  }


  tags = {
    Name = "Tabelo_Rotas_Privada1"
  }
}

resource "aws_route_table" "tabela_rotas_privada2" {
  vpc_id = aws_vpc.minha_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.meu_nat2.id
  }

  tags = {
    Name = "Tabelo_Rotas_Privada2"
  }
}
*/

#Associações das Route Tables 

resource "aws_route_table_association" "publica_associacao1" {
  subnet_id      = aws_subnet.minha_subnet_publica1.id
  route_table_id = aws_route_table.tabela_rotas_publica.id
}

resource "aws_route_table_association" "publica_associacao2" {
  subnet_id      = aws_subnet.minha_subnet_publica2.id
  route_table_id = aws_route_table.tabela_rotas_publica.id
}
/*
resource "aws_route_table_association" "privada_associacao1" {
    subnet_id = aws_subnet.minha_subnet_privada1.id
    route_table_id = aws_route_table.tabela_rotas_privada1.id
}

resource "aws_route_table_association" "privada_associacao2" {
    subnet_id = aws_subnet.minha_subnet_privada2.id
    route_table_id = aws_route_table.tabela_rotas_privada2.id
}
*/


#Security Groups (Aberto a 80 e 22)
resource "aws_security_group" "grupo_seguranca" {
  name        = "acesso-servidores-web"
  description = "Liberada porta 80 para web e 22 para acesso SSH restrito"
  vpc_id      = aws_vpc.minha_vpc.id 

  ingress {
    description      = "HTTP para todos"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH apenas para meu IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["SEU_IP/32"] # Coloque seu IP com /32 para garantir acesso individual ao shell da VM
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" 
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Security_Group"
  }
}