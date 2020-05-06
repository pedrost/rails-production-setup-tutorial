#README

## Instalação

### Passo 1 - Instalando ruby

Para rodar a aplicação é preciso ter o **ruby 2.5.1** em sua máquina  
Guia completo pode ser encontrado aqui [RVM Page](https://rvm.io/) 

### Passo 2 - Instando dependencias

Com o ruby instalado rode `gem install bundler` para baixar o  
instalador de pacotes ruby, e depois `bundle install` para instalar  
todas as dependencias de **Gemfile**  

## Configuração

### Passo 1 - Configurando o Banco / Criando server

Primeiro precisamos configurar o banco, seja local (ambiente de desenvolvimento) ou um suposto banco de produção.  

Para ambos os casos, precisamos de uma máquina que tenha um banco instalado  
No meu caso, vou instalar o **mysql** como banco em uma máquina **remota** na **amazon**  

Tenho um script automatizado pra fazer isso, entao eu so rodo esse comando no servidor que roda um **Ubuntu 18.04** como SO  
```sudo curl https://raw.githubusercontent.com/pedrost/fast-mysql-setup/master/setup.sh | sudo bash```

Esse script cria um usuario chamado **web_service** e dá permissões do banco á ele, ele também troca a senha do usuário **root** para **secret123**

Após o banco estar configurado no meu servidor, preciso abrir as portas de conexões  
Vou abrir uma porta **80 HTTP** para o phpmyadmin e outra porta **TCP 3306** para o mysql

Também vou mudar as configuraçoes do mysql para aceitar conexões remotas e não apenas do localhost  
No arquivo **/etc/mysql/mysql.conf.d/mysqld.cnf** troque o valor de **bind-address** para **0.0.0.0**
Desse modo: `bind-address = 0.0.0.0`

Depois de ter configurado o banco, e aberto as portas para melhor gerenciamento  

Vamos ao segundo passo  

### Passo 2 - Configurando /config/database.yml

Nesse arquivo ficam as configurações do banco de dados, é preciso altera-las conforme estiverem  
os seus respectivos bancos (teste, desenvolvimento e produção)  

Muita atenção para o atributo **adapter** e **encoding**  
Esses atributos são essenciais dependendo do banco que você queira  
que a aplicação se conecte. No meu caso **adaper: mysql2** e **encoding: utf8mb4**  
também é preciso configurar **user** e **password** que foram criados em seu banco  

No meu caso, vou preencher **mysql_username: web_service** e **mysql_password: secret123** nas **credentials** como variaveis  
de producao, rodando o comando `EDITOR=nano bin/rails credentials:edit`  
Também vou preencher **hostname** com o **IP** do servidor remoto que eu configurei  
Que no caso é **3.134.253.125**, junto com o local do **socket** do **mysql**  
Que no caso é **socket: '/var/run/mysqld/mysqld.sock'**  

```
production:
production:
 <<: *default
 database: web_service_production
 pool: 5
 timeout: 5000
 username: <%= Rails.application.credentials.dig(:production, :mysql_username) %>
 password: <%= Rails.application.credentials.dig(:production, :mysql_password) %>
 host: '3.134.253.125'
 socket: '/var/run/mysqld/mysqld.sock'
```

### Passo 3 - Criando o banco de produção e migrando o banco

Com o database.yml configurado e banco configurado é possivel  
criar o banco em produção **web_service_production** rodando  
```rake db:create RAILS_ENV=production```

Depois, migrar o banco em produção  
```rake db:migrate RAILS_ENV=production```

Agora podemos iniciar nossa aplicação em produção rodando   
```RAILS_ENV=production rails s```

### Passo 3 - Instalando e configurando nginx

Para instalar o nginx rode  
```sudo apt-get install nginx```

Depois configure o arquivo default
```sudo nano /etc/nginx/sites-available/default```

Vou configurar dessa maneira para que meu localhost aponte para o socket do puma  

```
upstream app {
    # É preciso alterar para o caminho de onde voce baixou esse repositorio
    server unix:/var/www/web_service/shared/sockets/puma.sock fail_timeout=0;
}

server {
    listen 80;
    server_name localhost;

    root /home/deploy/appname/public;

    try_files $uri/index.html $uri @app;

    location @app {
        proxy_pass http://app;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}
```

Depois restarte o nginx  
```sudo service nginx reload```

### Passo 4 - Startando puma

O puma já está configurado para produção em /config/puma.rb  
Você pode encontrar mais informações sobre o puma aqui [PUMA Page](https://rvm.io/) 
Você pode iniciar o puma rodando
```puma```

A aplicação deve estar rodando em  
```http://localhost```

## Testes

Para rodar os testes automatizados basta rodar ```rspec```  

## Rotas

**Verb**&nbsp;&nbsp;&nbsp;**URI&nbsp;Pattern**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Controller#Action**  
GET&nbsp;&nbsp;&nbsp;&nbsp;/poll(.:format)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;polls#index   
POST&nbsp;&nbsp;/poll(.:format)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;polls#create   
GET&nbsp;&nbsp;&nbsp;&nbsp;/poll/:id(.:format)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;polls#show   
GET&nbsp;&nbsp;&nbsp;&nbsp;/poll/:id/stats(.:format)&nbsp;&nbsp;polls#stats  
POST&nbsp;&nbsp;/poll/:id/vote(.:format)&nbsp;&nbsp;&nbsp;polls#vote  