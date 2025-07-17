
#Par de chaves. Devem ser gerados com ssh-keygen
resource "aws_key_pair" "chave" {
  key_name   = "Chave deploy"
  public_key = file("./SUA_CHAVE.pub") ## Utilize o ssh-keygen para gerar um par de chaves, coloque aqui a chave publica
}

#Vm EC2 com ami Ubuntu e tags referentes ao Programa de Bolsas 2025 Compass.Uol
resource "aws_instance" "vm" {
  associate_public_ip_address = true
  ami                     = "AMI" ##Coloque a ami do sistema operacional que deseja utilizar
  instance_type           = "t2.micro"
  key_name                = aws_key_pair.chave.key_name
  subnet_id               = aws_subnet.minha_subnet_publica1.id
  vpc_security_group_ids  = [aws_security_group.grupo_seguranca.id]

  #User_data para automatizar a config do ambiente
  user_data = file("./userdata.sh")
  
  tags = {
    Name = "ProjetoCompass"
  }
}
