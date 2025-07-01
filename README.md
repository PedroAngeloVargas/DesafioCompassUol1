### DesafioCompass1
Este é o primeiro projeto desenvolvido como parte do programa de estágio AWS DevSecOps 2025 da Compass.Uol.

## Sumário

- [Sobre](#Sobre-o-Projeto)
- [Tecnologias](#Tecnologias-e-Serviços-Utilizados)
- [Funcionalidades](#Funcionalidades-Principais)
- [Execução](#Execução-da-Aplicação)
- [Lógica](#Lógica-nos-Bastidores)

## 📜 Sobre o Projeto
O objetivo principal deste projeto é a criação de uma infraestrutura de nuvem na AWS para hospedar esta página web. A infraestrutura foi configurada com uma estrutura de rede segura e uma máquina virtual (EC2) para servir o conteúdo.

Além da hospedagem, foi implementado um script de monitoramento que verifica continuamente a disponibilidade da página. Caso o site fique indisponível, o script envia automaticamente uma notificação para um canal do Discord através de um webhook, informando o status HTTP.

## 🚀 Tecnologias e Serviços Utilizados
O projeto foi construído utilizando os seguintes serviços e tecnologias:

# AWS:

- VPC (Virtual Private Cloud): Criação de uma rede virtual isolada para garantir um ambiente seguro e controlado.

- Subnets: Segmentação da VPC para organizar os recursos e controlar o fluxo de tráfego.

- EC2 (Elastic Compute Cloud): Provisionamento de um servidor virtual para hospedar a aplicação web.

- Security Group: Configuração de regras de firewall para controlar o tráfego de entrada e saída da instância EC2.

- CloudWatch: Monitoramento do uso de CPU da EC2.

- SNS: Notificação ao proprietário do uso de CPU em excesso.

- User_data: Automação das configurações iniciais da EC2

# Outros:

- Discord Weebhook: Envio de notificação ao usuário da indisponibilidade do serviço via Discord.

- Nginx: Servidor Web.

## 🎯 Funcionalidades Principais

- Hospedagem de Página Web: A página de apresentação do projeto está sendo servida por um servidor Nginx na instância EC2.

- Monitoramento Ativo: Um script verifica o status da aplicação e notifica em caso de falhas.

- Notificações em Tempo Real: Alertas são enviados para um canal do Discord, permitindo uma resposta rápida a incidentes.

## 💻 Execução da Aplicação

1. Abra o portal da AWS.

2. 