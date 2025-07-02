# DesafioCompass1
Este é o primeiro projeto desenvolvido como parte do programa de estágio AWS DevSecOps 2025 da Compass.Uol.

## 📜 Sobre o Projeto
O objetivo principal deste projeto é a criação de uma infraestrutura de nuvem na AWS para hospedar esta página web. A infraestrutura foi configurada com uma estrutura de rede segura e uma máquina virtual (EC2) para servir o conteúdo.

Além da hospedagem, foi implementado um script de monitoramento que verifica continuamente a disponibilidade da página. Caso o site fique indisponível, o script envia automaticamente uma notificação para um canal do Discord através de um webhook, informando o status HTTP.

## 🚀 Tecnologias e Serviços Utilizados
O projeto foi construído utilizando os seguintes serviços e tecnologias:

### AWS:

- VPC (Virtual Private Cloud): Criação de uma rede virtual isolada para garantir um ambiente seguro e controlado.

- Subnets: Segmentação da VPC para organizar os recursos e controlar o fluxo de tráfego.

- EC2 (Elastic Compute Cloud): Provisionamento de um servidor virtual para hospedar a aplicação web.

- Security Group: Configuração de regras de firewall para controlar o tráfego de entrada e saída da instância EC2.

- CloudWatch: Monitoramento do uso de CPU da EC2.

- SNS: Notificação ao proprietário do uso de CPU em excesso.

- User_data: Automação das configurações iniciais da EC2

### Outros:

- Discord Weebhook: Envio de notificação ao usuário da indisponibilidade do serviço via Discord.

- Nginx: Servidor Web.

## 🎯 Funcionalidades Principais

- Hospedagem de Página Web: A página de apresentação do projeto está sendo servida por um servidor Nginx na instância EC2.

- Monitoramento Ativo: Um script verifica o status da aplicação e notifica em caso de falhas.

- Notificações em Tempo Real: Alertas são enviados para um canal do Discord, permitindo uma resposta rápida a incidentes.

## 💻 Provisionamento da Infraestrutura

### Pelo painel:

1. Abra o portal da AWS e faça o login, ou cadastre-se caso não tenha uma conta.

2. Para iniciar vamos começar provisionando uma infraestrutura de rede. Na barra de busca superior, digite VPC e selecione o serviço VPC.

3. Certifique-se de estar na região da AWS desejada (por exemplo, us-east-1, sa-east-1) no canto superior direito do console.

4. Crie a Virtual Private Cloud (VPC)

5. No painel de navegação esquerdo, clique em Suas VPCs.

6. Clique no botão Criar VPC.

7. Em Recursos a serem criados, selecione VPC e mais. Isso utilizará o assistente que facilita a criação dos recursos associados.

Configurações da VPC (Virtual Private Cloud):

    . Nome da tag - opcional: Dê um nome para sua VPC (ex: minha_vpc). Isso ajuda na identificação dos recursos.

    . Bloco CIDR IPv4: Defina o intervalo de IPs para sua VPC. Um bom começo é 10.0.0.0/16.

Configurações de sub-rede (Subnet):

    . Número de zonas de disponibilidade (AZs): Selecione 2. Isso garantirá alta disponibilidade.

    . Número de sub-redes públicas: Selecione 2.

    . Número de sub-redes privadas: Selecione 2.

    . Blocos CIDR de sub-rede: O assistente irá sugerir uma divisão dos blocos CIDR. Você pode customizar se necessário (ex: 10.0.1.0/24, 10.0.2.0/24 para as públicas e 10.0.3.0/24, 10.0.4.0/24 para as privadas).

Internet Gateways (IGW):

    . Internet Gateway: Mantenha a opção Criar um internet gateway selecionada. O assistente irá criá-lo e associá-lo à VPC.

    . Deixe as outras opções com os valores padrão e clique em Criar VPC.

    . O assistente levará alguns instantes para criar e configurar todos os componentes. Ao final, você pode clicar em Visualizar VPC para ver os recursos criados.

Opcional (NAT Gatways): Não é necessário para o funcionamento dessa aplicação, mas caso em um projeto futuro necessite de acesso a rede com a subnet privada é necessário utilizar.

8. Com a Infraestrutura de rede pronta, vamos provisionar nosso servidor virtual. Navegue até o serviço EC2: Na barra de busca superior do console da AWS, digite EC2 e selecione o serviço. Você será levado ao painel do EC2.

9. Inicie a criação da instância: No painel do EC2, localize e clique no botão laranja Executar instância (Launch instance).

10. Dê um nome e escolha a imagem da aplicação (AMI):

    . Nome: Dê um nome para o seu servidor, por exemplo, minha_vm.

    . Imagens de aplicações e SO (AMI): Escolha a imagem do sistema operacional. Uma opção comum e funcional para o User_Data e essa aplicação é o Ubuntu. Selecione sua AMI ou a versão mais recente disponível.

11. Escolha o Tipo de Instância:

    . Esta configuração define o poder de hardware (CPU, memória) do seu servidor.

    . Para manter-se no nível gratuito e para esta aplicação, selecione o tipo t2.micro, que suporta essa aplicação tranquilamente.

12. Crie um Par de Chaves para Acesso (Key Pair):

    . Este passo é crucial para que você possa se conectar ao servidor de forma segura via SSH.

    . Clique em Criar novo par de chaves.

    . Nome do par de chaves: Dê um nome, como minha_key.

    . Tipo de par de chaves: Mantenha RSA.

    . Formato do arquivo de chave privada: Selecione .pem se quiser fazer o acesso via Openssh ou .ppk 
    se quiser fazer via Putty.

13. Clique em Criar par de chaves. Seu navegador fará o download do arquivo (Minha_key). Guarde este arquivo em um local seguro e nao compartilhe com ninguem! Além disso, você não poderá baixar novamente.

14. Configure as Definições de Rede:

    . Esta é a etapa onde conectamos o servidor à rede que criamos anteriormente.

    . No painel "Definições de Rede", clique em Editar.

    . VPC: Selecione a VPC que você criou no passo 4 (ex: minha_vpc).

    . Sub-rede: É fundamental escolher uma sub-rede pública. Selecione uma das sub-redes públicas criadas pelo assistente (os nomes geralmente terminam com public1 ou public2).

    . Atribuir IP público automaticamente: Verifique se esta opção está Habilitada.

15. Firewall (grupos de segurança): 

    . Selecione Criar um grupo de segurança.

    . Nome do grupo de segurança: Dê um nome descritivo, como acesso_web_ssh_meu_securuty_group.

    . Descrição: Algo como Libera portas HTTP e SSH.

    . Regras de entrada: Vamos adicionar regras:

    . Regra 1 (SSH): Tipo SSH, Protocolo TCP, Intervalo de portas 22. Para maior segurança, selecione Meu IP. 

    . Regra 2 (HTTP): Tipo HTTP, Protocolo TCP, Intervalo de portas 80.Selecione Qualquer lugar (Anywhere), que corresponde a 0.0.0.0/0. Isso permitirá que qualquer pessoa na internet acesse sua aplicação web.

16. Configure o Armazenamento:

    . O padrão de 8 GiB no volume raiz é suficiente para esta aplicação. Mantenha os valores padrão.

- Opcional: Utilizar o User_Data para automatizar primeiras configurações.

    . Selecione detalhes avançados (Advanced details). Por padrão, ela pode estar recolhida. Clique nela para expandir.

    . Dentro do painel "Detalhes avançados" que se abriu, role um pouco para baixo até encontrar o campo de texto chamado Dados do usuário (User data).

    . Nesta caixa de texto você ira colar um script desse repositório. Que se encontra em /terraform/userdata.sh

17. Pronto, sua infraestrutura está provisionada utilizando o painel da AWS.

### Pelo Terraform

1. Clone esse repositório (git clone (URL))

2. Baixe o Terraform, siga os passos da página oficial (https://developer.hashicorp.com/terraform/install)

3. Acesse o diretório do Terraform (Exemplo: /IA_Cloud/terraform/)

4. É necessário gerar um par de chaves para acesso remoto. Abra o terminal no diretorio especificado acima, e digite:

    . ssh-keygen (Ao ser questionado pela primeira vez, insira o nome do par)

- Observação: Isso irá gerar um par de chaves unico .pem e .pub. Caso prefira utilizar o Putty para o acesso, é
necessário a conversão da chave, então digite:

    . puttygen minha_key.pem -o minha_key.ppk

5. Em /IA-Cloud/terraform/ec2.tf procure por "public_key = file("./SUA_CHAVE_SSH")"

6. Substitua pela nome de sua chave publica (Exemplo: minha_key.pub)

7. Para inicializar o state e baixar as configurações do provider, abra o terminal e digite:

    . terraform init 

8. Copie e cole suas credencias da AWS no terminal. Com a seguinte sintaxe de acordo com seu SO:

    . Linux | Mac

    . export AWS_ACCESS_KEY_ID="SUA_CHAVE_ACESSO"

    . export AWS_SECRET_ACCESS_KEY="SUA_CHAVE_SECRETA_ACESSO"

    . export AWS_SESSION_TOKEN="TOKEN_DE_SESSAO_SE_APLICAVEL"
    
    . Windows (CMD)

    . set AWS_ACCESS_KEY_ID="SUA_CHAVE_ACESSO"

    . set AWS_SECRET_ACCESS_KEY="SUA_CHAVE_SECRETA_ACESSO"

    . set AWS_SESSION_TOKEN="TOKEN_DE_SESSAO_SE_APLICAVEL"

9. Para fazer um plano de backup e visualizar todos os recursos criados, no terminal digite:

    . terraform plan -out plan.out

10. Ao visualizar os recursos e estiver de acordo, para executar, no terminal digite:

    . terraform apply plan.out

11. Pronto, sua infraestrutura está provisionada utilizando o Terraform.

- Importante: Para destruir TODOS os recursos, caso queira, no terminal digite:

    . terraform destroy (Ao ser questionado, digite "yes" para concordar)

## 💻 Acessando a Máquina e iniciando as configurações internas.

1. Para acessar a instância, navegue ao diretório /IA_Cloud/terraform/, no terminal digite:

    . ssh -i minha_key.pem ubuntu@IP_INSTÂNCIA (Para consultar o ip, no painel da EC2 selecione sua máquina, 
    e vai estar la como public_ip: / Utilize "plink" e "minha_key.ppk", ao invés de "ssh" e "minha_key.pem",
    se preferir usar o Putty)

- Observação: Caso tenha utilizado User_Data, pode pular do passo 2 ao 8

2. Obtenha Privilégios de Administrador (usuário root)

    . sudo su (Acessar com usuário root)

3. Atualizar o Sistema

    . apt-get update -y 
    
    . apt-get upgrade -y

4. Instalar o Servidor Web Nginx para hospedar nossa página

    . apt-get install -y nginx (apt-get install para instalar pacotes)

5. Configurar o Diretório Web. Aqui você prepara o diretório onde os arquivos da página ficarão.

    . chown ubuntu:ubuntu /var/www/html (Adicionar usuário ubuntu para esse diretório)

6. Criar um Arquivo de Log. Esses comandos são para criar um arquivo de log vazio que vai ser usado
pelo script de monitoramento.

    . cd /var/log (Acessar diretorio com cd)

    . touch meu_script.log (Criar arquivo com touch)

7. Retornar ao Diretório Raiz. Este comando simplesmente retorna você ao diretório principal (raiz) 
do sistema de arquivos.

    . cd / (Diretório raiz do Linux)

8. Iniciar e Habilitar o Nginx. Os comandos finais garantem que seu servidor web esteja em execução e que ele inicie automaticamente com o sistema.

    . systemctl start nginx (Iniciar o nginx)

    . systemctl enable nginx (Habilitar para sempre ligar junto da máquina)

9. Vamos configurar o Nginx para iniciar automaticamente caso o mesmo pare de funcionar. Então vamos Criar um arquivo 
override.conf para substituir o original.

    . mkdir -p /etc/systemd/system/nginx.service.d (Mkdir para criar diretório)

    . sudo nano /etc/systemd/system/nginx.service.d/override.conf 
    
11. Dentro do editor de texto, digite:

        [Service]
        Restart=always
        RestartUSec=5s

12. Pressione Ctrl + O pra salvar e Ctrl + X pra sair do editor.

13. Aplique as mudanças, reinicie o Nginx:

    . sudo systemctl daemon-reload

    . sudo systemctl restart nginx

14. Vamos ver se systemd entendeu as novas regras. Esse comando mostra todas as configurações do serviço Nginx 
e filtra (grep) apenas as linhas que contêm a palavra "restart", permitindo que você veja se Restart=always 
("Always" para sempre reinicar quando desligar) foi carregado corretamente.

    . sudo systemctl show nginx | grep -i restart

15. Teste o funcionamento. O comando pkill é usado para "matar" (finalizar) processos. Ao rodar este comando, você força o encerramento de todos os processos do Nginx, simulando uma falha.

    . sudo pkill -f nginx (pkill pra motar processos | Flag -f pra forçar a execução)

- Observação: Não adianta utilizar "systemctl stop nginx" para ver esse reinicio, pois dessa forma o sistema entende que
o usuário desligou por conta própria e o restart não é feito. 

## 💻 Upload dos arquivos e carregamento da página

1. Navegue até o caminho de sua chave privada /DesafioCompassUol1/terraform/minha_key.pem

2. Modifique suas permissões por segurança, para que a chave não tenha permissões públicas, com o comando chmod

    . chmod 400 minha_key.pem

3. Prepare sua Chave e Terminal. Com seu terminal local, vamos utilizar o comando sftp para conectar a máquina 
local a instãncia e assim fazer o upload. Seguindo a sintaxe de exemplo:

    . sftp -i minha_key.pem ubuntu@IP_INSTÂNCIA

4. Faça o upload dos respectivos arquivos com o terminal sftp em aberto, seguindo o exemplo:

    . put ~/DesafioCompassUol1/index.html /var/www/html (O primeiro caminho diz respeito ao da máquina local e 
     segundo ao da máquina virtual | comando "put" do sftp é utilizado para fazer o envio)

    . put ~/DesafioCompassUol1/script.sh /var/www/html (Envio dos arquivos no diretório var/www/html é essencial para
     funcionamento do Nginx)

    . put -r ~/DesafioCompassUol1/images /var/www/html (Flag -r para enviar arquivos recursivamente, as imagens nesse caso)

5. Pronto. Ao acessar o IP da instância no seu navegador, ele usa a porta 80 http por padrão. O Nginx, que está escutando nessa porta, recebe a requisição, encontra o arquivo index.html (que já é configurado como padrão para ser exibido) e o serve para o navegador. Por fim, o navegador interpreta o código HTML e exibe a página. O site está no ar!

## 💻 Colocando o Script pra funcionar

1. Acesse o script.sh com editor de texto:

    . nano /var/www/html/script.sh

2. Mude as variaveis, SITE_URL="URL" e DISCORD_WEBHOOK_URL="SEU_WEBHOOK" para se adequar ao seu caso.

    . SITE_URL="URL" (Utilize a URL da página)

    . DISCORD_WEBHOOK_URL="SEU_WEBHOOK (Gerar link webhook no discord. Criar Servidor > Configurações do Servidor >
    Integrações > Webhooks > Novo webhook)

3. Saia do Editor

    . Ctrl + O 

    . Ctrl + X

4. Adicione permissão de execução para o script

    . chmod +x script.sh (Flag +x adicionar execução 'x')

5. Execute o script

    . ./script.sh

6. Faça a validação do monitoramento armazenado

    . tail /var/log/meu_script.log

7. Vamos agora automatizar a verificação com crontab -e. Primeiro execute o crontab, aparecerá um menu de opções,
escolha a numero 1

    . crontab -e

8. No final do arquivo, adicione a seguinte linha com o caminho do seu script.sh, para que assim a verificação seja feita
a cada 1 minuto

    . * * * * * /var/www/html/script.sh

9. Saia do Editor

    . Ctrl + O 

    . Ctrl + X

10. Agora vamos testar o monitoramento, para isso preciso pausar a execução do Nginx, dessa forma:

    . sudo systemctl stop nginx

11. Pronto. Em um minuto, irá aparecer uma mensagem de site fora do ar no seu discord. Para o site voltar, só 
executar:

    . sudo systemctl start nginx

## ✨ Sobre o Programa de Estágio
Este projeto faz parte do Compass.Uol Schoolarship Program, que em parceria com universidades, oferece bolsas de estudo e oportunidades de aprendizagem para estudantes de tecnologia com excelente desempenho acadêmico, com foco em soluções de ponta e potencial de contratação.

## 👨‍💻 Autor
Pedro Angelo Vargas

GitHub: @PedroAngeloVargas