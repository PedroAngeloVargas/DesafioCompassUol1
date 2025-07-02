# DesafioCompass1
Este é o primeiro projeto desenvolvido como parte do programa de estágio AWS DevSecOps 2025 da Compass.Uol.

## 🔎 Sobre o Projeto
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

## ☁️ Provisionamento da Infraestrutura

### Pelo painel:

1. Abra o portal da AWS e faça o login, ou cadastre-se caso não tenha uma conta.

2. Para iniciar vamos começar provisionando uma infraestrutura de rede. Na barra de busca superior, digite VPC e selecione o serviço VPC.

3. Certifique-se de estar na região da AWS desejada (por exemplo, us-east-1, sa-east-1) no canto superior direito do console.

4. Crie a Virtual Private Cloud (VPC)

5. No painel de navegação esquerdo, clique em Suas VPCs.

6. Clique no botão Criar VPC.

7. Em Recursos a serem criados, selecione VPC e mais. Isso utilizará o assistente que facilita a criação dos recursos associados.

Configurações da VPC (Virtual Private Cloud):

    ```
    . Nome da tag - opcional: Dê um nome para sua VPC (ex: minha_vpc). Isso ajuda na identificação dos recursos.

    . Bloco CIDR IPv4: Defina o intervalo de IPs para sua VPC. Um bom começo é 10.0.0.0/16.
    ```

Configurações de sub-rede (Subnet):

    ```
    . Número de zonas de disponibilidade (AZs): Selecione 2. Isso garantirá alta disponibilidade.

    . Número de sub-redes públicas: Selecione 2.

    . Número de sub-redes privadas: Selecione 2.

    . Blocos CIDR de sub-rede: O assistente irá sugerir uma divisão dos blocos CIDR. Você pode customizar se necessário (ex: 10.0.1.0/24, 10.0.2.0/24 para as públicas e 10.0.3.0/24, 10.0.4.0/24 para as privadas).
    ```

Internet Gateways (IGW):

    ```
    . Internet Gateway: Mantenha a opção Criar um internet gateway selecionada. O assistente irá criá-lo e associá-lo à VPC.

    . Deixe as outras opções com os valores padrão e clique em Criar VPC.

    . O assistente levará alguns instantes para criar e configurar todos os componentes. Ao final, você pode clicar em Visualizar VPC para ver os recursos criados.
    ```

- Opcional (NAT Gatways): Não é necessário para o funcionamento dessa aplicação, mas caso em um projeto futuro necessite de acesso a rede com a subnet privada é necessário utilizar.

8. Com a Infraestrutura de rede pronta, vamos provisionar nosso servidor virtual. Navegue até o serviço EC2: Na barra de busca superior do console da AWS, digite EC2 e selecione o serviço. Você será levado ao painel do EC2.

9. Inicie a criação da instância: No painel do EC2, localize e clique no botão laranja Executar instância (Launch instance).

10. Dê um nome e escolha a imagem da aplicação (AMI):

    ```
    . Nome: Dê um nome para o seu servidor, por exemplo, minha_vm.

    . Imagens de aplicações e SO (AMI): Escolha a imagem do sistema operacional. Uma opção comum e funcional para o User_Data e essa aplicação é o Ubuntu. Selecione sua AMI ou a versão mais recente disponível.
    ```

11. Escolha o Tipo de Instância:

    ```
    . Esta configuração define o poder de hardware (CPU, memória) do seu servidor.

    . Para manter-se no nível gratuito e para esta aplicação, selecione o tipo t2.micro, que suporta essa aplicação tranquilamente.

    ```

12. Crie um Par de Chaves para Acesso (Key Pair):

    ```
    . Este passo é crucial para que você possa se conectar ao servidor de forma segura via SSH.

    . Clique em Criar novo par de chaves.

    . Nome do par de chaves: Dê um nome, como minha_key.

    . Tipo de par de chaves: Mantenha RSA.

    . Formato do arquivo de chave privada: Selecione .pem se quiser fazer o acesso via Openssh ou .ppk 
    se quiser fazer via Putty.
    ```

13. Clique em Criar par de chaves. Seu navegador fará o download do arquivo (Minha_key). Guarde este arquivo em um local seguro e nao compartilhe com ninguem! Além disso, você não poderá baixar novamente.

14. Configure as Definições de Rede:

    ```
    . Esta é a etapa onde conectamos o servidor à rede que criamos anteriormente.

    . No painel "Definições de Rede", clique em Editar.

    . VPC: Selecione a VPC que você criou no passo 4 (ex: minha_vpc).

    . Sub-rede: É fundamental escolher uma sub-rede pública. Selecione uma das sub-redes públicas criadas pelo assistente (os nomes geralmente terminam com public1 ou public2).

    . Atribuir IP público automaticamente: Verifique se esta opção está Habilitada.
    ```

15. Firewall (grupos de segurança): 

    ```
    . Selecione Criar um grupo de segurança.

    . Nome do grupo de segurança: Dê um nome descritivo, como acesso_web_ssh_meu_securuty_group.

    . Descrição: Libera portas HTTP e SSH.

    . Regras de entrada: Vamos adicionar regras:

    . Regra 1 (SSH): Tipo SSH, Protocolo TCP, Intervalo de portas 22. Para maior segurança, selecione Meu IP. 

    . Regra 2 (HTTP): Tipo HTTP, Protocolo TCP, Intervalo de portas 80.Selecione Qualquer lugar (Anywhere), que corresponde a 0.0.0.0/0. Isso permitirá que qualquer pessoa na internet acesse sua aplicação web.
    ```

16. Configure o Armazenamento:
   
    ```
    . O padrão de 8 GiB no volume raiz é suficiente para esta aplicação. Mantenha os valores padrão.
    ```

- Opcional: Utilizar o User_Data para automatizar primeiras configurações.

    ```
    . Selecione detalhes avançados (Advanced details). Por padrão, ela pode estar recolhida. Clique nela para expandir.

    . Dentro do painel "Detalhes avançados" que se abriu, role um pouco para baixo até encontrar o campo de texto chamado Dados do usuário (User data).

    . Nesta caixa de texto você ira colar um script desse repositório. Que se encontra em /terraform/userdata.sh
    ```

17. Pronto, sua infraestrutura está provisionada utilizando o painel da AWS.

### Pelo Terraform

1. Clone esse repositório (git clone (URL))

2. Baixe o Terraform, siga os passos da página oficial (https://developer.hashicorp.com/terraform/install)

3. Acesse o diretório do Terraform (Exemplo: /IA_Cloud/terraform/)

4. É necessário gerar um par de chaves para acesso remoto. Abra o terminal no diretorio especificado acima, e digite:
    
    ```
    . ssh-keygen (Ao ser questionado pela primeira vez, insira o nome do par)
    ```

- Observação: Isso irá gerar um par de chaves unico .pem e .pub. Caso prefira utilizar o Putty para o acesso, é
necessário a conversão da chave, então digite:

    ```
    . puttygen minha_key.pem -o minha_key.ppk
    ```

5. Em /DesafioCompassUol1/terraform/ec2.tf procure por "public_key = file("./SUA_CHAVE_SSH")"

6. Substitua pela nome de sua chave publica (Exemplo: minha_key.pub)

7. Para inicializar o state e baixar as configurações do provider, abra o terminal e digite:

    ```
    . terraform init 
    ```

8. Copie e cole suas credencias da AWS no terminal. Com a seguinte sintaxe de acordo com seu SO:

    ```
    . Linux | Mac

    . export AWS_ACCESS_KEY_ID="SUA_CHAVE_ACESSO"

    . export AWS_SECRET_ACCESS_KEY="SUA_CHAVE_SECRETA_ACESSO"

    . export AWS_SESSION_TOKEN="TOKEN_DE_SESSAO_SE_APLICAVEL"
    
    . Windows (CMD)

    . set AWS_ACCESS_KEY_ID="SUA_CHAVE_ACESSO"

    . set AWS_SECRET_ACCESS_KEY="SUA_CHAVE_SECRETA_ACESSO"

    . set AWS_SESSION_TOKEN="TOKEN_DE_SESSAO_SE_APLICAVEL"
    ```

9. Para fazer um plano de backup e visualizar todos os recursos criados, no terminal digite:
   
    ```
    . terraform plan -out plan.out
    ```

10. Ao visualizar os recursos e estiver de acordo, para executar, no terminal digite:

    ```
    . terraform apply plan.out
    ```

11. Pronto, sua infraestrutura está provisionada utilizando o Terraform.

- Importante: Para destruir TODOS os recursos, caso queira, no terminal digite:

    ```
    . terraform destroy (Ao ser questionado, digite "yes" para concordar)
    ```

- Opcional (NAT Gatways): Não é necessário para o funcionamento dessa aplicação, mas caso em um projeto futuro necessite dele, o mesmo ja está com suas configurações em comentário no diretório do Terraform. Também há o arquivo de monitoring.tf com uma solução de monitoramento de uso de CPU com Cloudwatch + SNS pra notificação.

## 🌐 Acessando a Máquina e iniciando as configurações internas.

1. Para acessar a instância, navegue ao diretório /DesafioCompassUol1/terraform/, no terminal digite:

    ```
    . ssh -i minha_key.pem ubuntu@IP_INSTÂNCIA (Para consultar o ip, no painel da EC2 selecione sua máquina, 
    e vai estar la como public_ip: / Utilize "plink" e "minha_key.ppk", ao invés de "ssh" e "minha_key.pem",
    se preferir usar o Putty)
    ```

- Observação: Caso tenha utilizado User_Data, pode pular do passo 2 ao 8

2. Obtenha Privilégios de Administrador (usuário root)
    
    ```
    . sudo su (Acessar com usuário root)
    ```

3. Atualizar o Sistema

    ```
    . apt-get update -y 
    
    . apt-get upgrade -y
    ```

4. Instalar o Servidor Web Nginx para hospedar nossa página

    ```
    . apt-get install -y nginx (apt-get install para instalar pacotes)
    ```

5. Configurar o Diretório Web. Aqui você prepara o diretório onde os arquivos da página ficarão.

    ```
    . chown ubuntu:ubuntu /var/www/html (Adicionar usuário ubuntu para esse diretório)
    ```

6. Criar um Arquivo de Log. Esses comandos são para criar um arquivo de log vazio que vai ser usado
pelo script de monitoramento.
   
    ```
    . cd /var/log (Acessar diretorio com cd)

    . touch meu_script.log (Criar arquivo com touch)
    ```

7. Retornar ao Diretório Raiz. Este comando simplesmente retorna você ao diretório principal (raiz) 
do sistema de arquivos.
    
    ```
    . cd / (Diretório raiz do Linux)
    ```

8. Iniciar e Habilitar o Nginx. Os comandos finais garantem que seu servidor web esteja em execução e que ele inicie automaticamente com o sistema.

    ```
    . systemctl start nginx (Iniciar o nginx)

    . systemctl enable nginx (Habilitar para sempre ligar junto da máquina)
    ```

9. Vamos configurar o Nginx para iniciar automaticamente caso o mesmo pare de funcionar. Então vamos Criar um arquivo 
override.conf para substituir o original.

    ```
    . mkdir -p /etc/systemd/system/nginx.service.d (Mkdir para criar diretório)

    . sudo nano /etc/systemd/system/nginx.service.d/override.conf 
    ```

11. Dentro do editor de texto, digite:
    
     ```
        [Service]
        Restart=always
        RestartUSec=5s
    ```

12. Pressione Ctrl + O pra salvar e Ctrl + X pra sair do editor.

13. Vamos apagar esconder um dado possivelmente sensivel. Então acesse o arquivo, e habilite a opção:

    ```
    . sudo nano /etc/nginx/nginx.conf
   
    . Habilite a opção "server_tokens off;", que se encontra comentada com "#", aoenas tire o caracter.
    
    . Ctrl + O pra salvar e Ctrl + X
    ```
- Observação: Isso é importante porque desabilita a informação da versão do Nginx, pois ao fazer uma requisição GET com curl ou     wget, retorna a versão do servidor, o problema é que caso exista um exploit para a versão determinada que vocẽ está utilizando do Nginx, um invasor pode prejudicar seu servidor.

14. Aplique as mudanças, reiniciando o Nginx:
    
    ```
    . sudo systemctl daemon-reload

    . sudo systemctl restart nginx
    ```

15. Vamos ver se systemd entendeu as novas regras. Esse comando mostra todas as configurações do serviço Nginx 
e filtra (grep) apenas as linhas que contêm a palavra "restart", permitindo que você veja se Restart=always 
("Always" para sempre reinicar quando desligar) foi carregado corretamente.

    ```
    . sudo systemctl show nginx | grep -i restart
    ```

16. Teste o funcionamento. O comando pkill é usado para "matar" (finalizar) processos. Ao rodar este comando, você força o encerramento de todos os processos do Nginx, simulando uma falha.

    ```
    . sudo pkill -f nginx (pkill pra motar processos | Flag -f pra forçar a execução)
    ```


- Observação: Não adianta utilizar "systemctl stop nginx" para ver esse reinicio, pois dessa forma o sistema entende que
o usuário desligou por conta própria e o restart não é feito. 

## 📤 Upload dos arquivos e carregamento da página

1. Navegue até o caminho de sua chave privada /DesafioCompassUol1/terraform/minha_key.pem

2. Modifique suas permissões por segurança, para que a chave não tenha permissões públicas, com o comando chmod
   
    ```
    . chmod 400 minha_key.pem
    ```

3. Prepare sua Chave e Terminal. Com seu terminal local, vamos utilizar o comando sftp para conectar a máquina 
local a instãncia e assim fazer o upload. Seguindo a sintaxe de exemplo:

    ```
    . sftp -i minha_key.pem ubuntu@IP_INSTÂNCIA
    ```

4. Faça o upload dos respectivos arquivos com o terminal sftp em aberto, seguindo o exemplo:

    ```
    . put ~/DesafioCompassUol1/index.html /var/www/html (O primeiro caminho diz respeito ao da máquina local e 
     segundo ao da máquina virtual | comando "put" do sftp é utilizado para fazer o envio)

    . put ~/DesafioCompassUol1/script.sh /var/www/html (Envio dos arquivos no diretório var/www/html é essencial para
     funcionamento do Nginx)

    . put -r ~/DesafioCompassUol1/images /var/www/html (Flag -r para enviar arquivos recursivamente, as imagens nesse caso)
    ```

5. Testar resposta do site com curl, a resposta deve ser algo próximo disso:

    ```
    . curl URL -I

    . HTTP/1.1 200 OK
    . Server: nginx
    . Date: Wed, 02 Jul 2025 15:12:39 GMT
    . Content-Type: text/html
    . Content-Length: 10671
    . Last-Modified: Tue, 27 May 2025 19:03:02 GMT
    . Connection: keep-alive
    . ETag: "68360c66-29af"
    . Accept-Ranges: bytes
    ```
- Observação: O http status code indica 200, ou seja, o site está funcionando normalmente

6. Pronto. Ao acessar o IP da instância no seu navegador, ele usa a porta 80 http por padrão. O Nginx, que está escutando nessa porta, recebe a requisição, encontra o arquivo index.html (que já é configurado como padrão para ser exibido) e o serve para o navegador. Por fim, o navegador interpreta o código HTML e exibe a página. O site está no ar!

## 🤖 Colocando o Script pra funcionar

1. Acesse o script.sh com editor de texto:

    ```
    . nano /var/www/html/script.sh
    ```

2. Mude as variaveis, SITE_URL="URL" e DISCORD_WEBHOOK_URL="SEU_WEBHOOK" para se adequar ao seu caso.

    ```
    . SITE_URL="URL" (Utilize a URL da página)

    . DISCORD_WEBHOOK_URL="SEU_WEBHOOK (Gerar link webhook no discord. Criar Servidor > Configurações do Servidor >
    Integrações > Webhooks > Novo webhook)
    ```

3. Saia do Editor

    ```
    . Ctrl + O 

    . Ctrl + X
    ```

4. Adicione permissão de execução para o script

    ```
    . chmod +x script.sh (Flag +x adicionar execução 'x')
    ```

5. Execute o script

    ```
    . ./script.sh
    ```

6. Faça a validação do monitoramento armazenado

    ```
    . tail /var/log/meu_script.log
    ```

7. Vamos agora automatizar a verificação com crontab -e. Primeiro execute o crontab, aparecerá um menu de opções,
escolha a numero 1

    ```
    . crontab -e
    ```

8. No final do arquivo, adicione a seguinte linha com o caminho do seu script.sh, para que assim a verificação seja feita
a cada 1 minuto

    ```
    . * * * * * /var/www/html/script.sh
    ```

9. Saia do Editor

    ```
    . Ctrl + O 

    . Ctrl + X
    ```

10. Agora vamos testar o monitoramento, para isso preciso pausar a execução do Nginx, dessa forma:

    ```
    . sudo systemctl stop nginx
    ```

11. Pronto. Em um minuto, irá aparecer uma mensagem de site fora do ar no seu discord. Para o site voltar, só 
executar:

    ```
    . sudo systemctl start nginx
    ```

## ⚙️ Explicando a Lógica do Script

    ```
    #!/bin/bash
    SITE_URL="URL"
    DISCORD_WEBHOOK_URL="SEU_WEBHOOK"
    SITE_NAME="Projeto Compass"
    LOG_FILE="/var/log/meu_script.log"

    STATUS_CODE=$(curl -L -s -o /dev/null -w "%{http_code}" "$SITE_URL")
    if [[ "$STATUS_CODE" -eq 200 ]]; then

        LOG_MESSAGE="$(date '+%Y-%m-%d %H:%M:%S') - SITE FUNCIONANDO UHULLL :) - Site: $SITE_NAME ($SITE_URL) - Status HTTP: $STATUS_CODE"
        echo "$LOG_MESSAGE" >> "$LOG_FILE"
    else

        LOG_MESSAGE="$(date '+%Y-%m-%d %H:%M:%S') - SITE NÃO TA FUNCIONANDO :( - Site: $SITE_NAME ($SITE_URL) - Status HTTP: $STATUS_CODE"
        echo "$LOG_MESSAGE" >> "$LOG_FILE"


        DISCORD_CONTENT="!O site **$SITE_NAME** ($SITE_URL) está fora do ar! Código HTTP: $STATUS_CODE"
        curl -X POST -H 'Content-Type: application/json' \
            -d "{
                \"username\": \"Monitor de Sites\",
                \"content\": \"$DISCORD_CONTENT\"
                }" "$DISCORD_WEBHOOK_URL"
    fi
    ```

- Exemplo de saida no Discord:

    ```
    . O site Projeto Compass (http://146.190.78.135/) está fora do ar! Código HTTP: 403
    ```

- A primeira linha "#!/bin/bash" é o componente que identifica que se trata de um arquivo shell, é essencial que o script contenha 
essa linha para o funcionamento correto.

- Os seguintes trechos:

    ```
    . SITE_URL="URL"
    . DISCORD_WEBHOOK_URL="SEU_WEBHOOK"
    . SITE_NAME="Projeto Compass"
    . LOG_FILE="/var/log/meu_script.log"
    ```
- Identificam as variaveis utilizadas pelo script, a primeira identifica a url do site, a segunda a url weebhook do servidor Discord, a terceira é apenas o nome do site para melhor identificar no Discord e a ultima representa o caminho do arquivo de armazenamento do log.

- A linha "STATUS_CODE=$(curl -L -s -o /dev/null -w "%{http_code}" "$SITE_URL")" pode ser dividida em partes para melhor explicação, o curl é uma ferramenta já utilizada acima para fazer requisições http, nesse caso GET, para buscar informações.A primeira flag "-L" indica pro curl buscar todos os redirecionamentos, até chegar no codigo 200, pois se ele não estivesse ali, pode ocorrer de ter um status de 300, o que nao é um erro, apenas um redirecionamento, isso elimina a chance de o script falhar. A flag "-s" é o modo silencioso, que mostra apenas o conteudo e não exibe mensagens de erro. A flag "-o /dev/null" elimina o conteudo do site, enquanto o "-s" faz a eliminação de mensagens de erro. E por fim, a flag "-w "%{http_code}"" mostra apenas o que o script realmente precisa, o status http para verificar a disponibilidade do site. Sendo 200 sucesso, 400 e 500 erro. Tudo isso vai armazenado na variavel "STATUS_CODE".

- O bloco IF:

    ```
    . if [[ "$STATUS_CODE" -eq 200 ]]; then

    . LOG_MESSAGE="$(date '+%Y-%m-%d %H:%M:%S') - SITE FUNCIONANDO UHULLL :) - Site: $SITE_NAME ($SITE_URL) - Status HTTP: . ..   
    . $STATUS_CODE"
    . echo "$LOG_MESSAGE" >> "$LOG_FILE"
    ```

- O nosso IF identifica se a variavel "STATUS_CODE" armazenou o codigo 200, que o codigo que identifica sucesso na comunicação. Também armazena no "LOG_MESSAGE" a data e o horário da validação, juntamente com uma mensagem, a url, e o codigo http. Como no caso do IF a resposta é positiva, a resposta é apenas armazenada no arquivo /var/log/meu_script.log.

- O bloco ELSE:

    ```
    . else

    . LOG_MESSAGE="$(date '+%Y-%m-%d %H:%M:%S') - SITE NÃO TA FUNCIONANDO :( - Site: $SITE_NAME ($SITE_URL) - Status HTTP: .   
    . $STATUS_CODE"
    . echo "$LOG_MESSAGE" >> "$LOG_FILE"


    . DISCORD_CONTENT="!O site **$SITE_NAME** ($SITE_URL) está fora do ar! Código HTTP: $STATUS_CODE"
    .   curl -X POST -H 'Content-Type: application/json' \
    .        -d "{
    .            \"username\": \"Monitor de Sites\",
    .            \"content\": \"$DISCORD_CONTENT\"
    .           }" "$DISCORD_WEBHOOK_URL"
    . fi
    ```

- A logica do primeiro bloco segue o mesmo principio do IF, mas nesse caso qualquer coisa diferente de 200 será visto como erro, e assim armazenado do /var/log/meu_script_log. No segundo bloco, a variavel "DISCORD_CONTENT" armazena a mensagem de erro, e depois é feito uma requisição usando curl, mas dessa vez do tipo "POST" para enviar dados, usando a flag "-X POST" para que assim seja feito, o "-H" passa o cabeçalho informando se tratar de um json, e o "-d" passa o conteudo json a ser inserido na variavel "$DISCORD_WEBHOOK_URL" que armazena a url webhook do discord.

## 🚨 Integração com CloudWatch e SNS

### No Painel: Primeiro o SNS

1.  Vamos criar o canal de comunicação para os alertas. Acesse o serviço SNS: Na barra de busca superior do console da AWS, digite SNS (Simple Notification Service) e acesse o serviço.

2. Crie um tópico: No painel esquerdo, clique em Tópicos e depois no botão laranja Criar tópico.

3. Configure o tópico:
    
    ```
    . Tipo: Selecione Padrão (Standard).
 
    . Nome: ALERTA-USO-DE-CPU-ESTA-ALEM-DO-PERMITIDO

    . Deixe as outras configurações como padrão e clique em Criar tópico no final da página.
    ```

4. Agora, faremos a inscrição por e-mail. Acesse a página do tópico: Após criar, você será redirecionado para a página de detalhes do seu tópico. Se não, clique nele na lista de tópicos.

5. Crie uma Assinatura: Na parte inferior da página, procure pela aba Inscrições e clique no botão Criar Assinatura.

6. Configure a inscrição:

    ```
    . ARN do tópico: Provavel que já esteja lá

    . Protocolo: Selecione E-mail.

    . Endpoint: Digite o seu endereço de e-mai.
    ```

7. Clique em Criar inscrição.

8. Confirme seu E-mail:

    ```
    . A AWS enviará um e-mail para o endereço que você forneceu com o assunto "AWS Notification - Subscription Confirmation".

    . Abra este e-mail e clique no link "Confirm subscription".

    . Até que você faça isso, a inscrição ficará com o status "Pendente" e você não receberá os alertas.
    ```

### No Painel: Agora o CloudWatch

1. Acesse o serviço CloudWatch: Na barra de busca, digite CloudWatch e acesse o serviço.

2. Vá para Alarmes: No painel esquerdo, em Alarmes, clique em Todos os alarmes.

3. Crie um alarme: Clique no botão laranja Criar alarme.

4. Selecione a Métrica:

    ```
    . Clique em Selecionar métrica.

    . Na lista de serviços, clique em EC2.

    . Selecione Métricas por instância.

    . Encontre sua VM na lista e marque a caixa de seleção na métrica CPUUtilization.

    . Clique em Selecionar métrica.
    ```

5. Especifique as condições da métrica:

    ```
    . Estatística: Selecione Média (Average).

    . Período: Selecione 5 minutos (corresponde a 300 segundos)

    . Em Condições:

        . Tipo de limite: Estático.

        . Sempre que CPUUtilization for...: Selecione Maior/Igual (GreaterThanOrEqualToThreshold).
        que...: Digite 10 (o limite de 10%).
    ```

6. Configure as opções adicionais:

    ```
    . Expanda Configuração adicional.

    . Pontos de dados para alarme: Preencha com 2 de 2. Isso significa que o alarme só vai disparar se o uso de CPU ficar acima de 10% por dois períodos consecutivos de 5 minutos (totalizando 10 minutos).

    . Tratamento de dados ausentes: Deixe como está.
    ```

7. Configure as Ações:

    ```
    . Na seção Ações, garanta que a opção Em alarme esteja selecionada.

    . Em Enviar uma notificação para..., selecione Selecionar um tópico do SNS existente.

    . No campo abaixo, escolha o tópico que você criou na Parte 1 (ALERTA-USO-DE-CPU...).
    ```

8. Adicione nome e descrição:

    ```
    . Nome do alarme: Controle de Uso de CPU

    . Descrição do alarme (opcional): Monitoramento de Uso de CPU
    ```

9. Clique em Criar Alarme

10. Pronto. Seu CloudWatch com SNS está configurado!

## ✨ Sobre o Programa de Estágio

- Este projeto faz parte do Compass.Uol Schoolarship Program, que em parceria com universidades, oferece bolsas de estudo e oportunidades de aprendizagem para estudantes de tecnologia com excelente desempenho acadêmico, com foco em soluções de ponta e potencial de contratação.

## 👨‍💻 Autor

- Pedro Angelo Vargas

- GitHub: @PedroAngeloVargas








