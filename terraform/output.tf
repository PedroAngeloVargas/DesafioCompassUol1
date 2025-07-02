
#Mostra o Ip da vm no terminal para acesso rápido
output "ip_vm" {
value = aws_instance.vm.public_ip
}