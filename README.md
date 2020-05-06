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

No meu caso, vou preencher **user: web_service** e **password: secret123** como o meu script  
automatizado criou lá em cima quando configurei o banco no servidor.  
Também vou preencher **hostname** com o **IP** do servidor remoto que eu configurei  
Que no caso é **3.134.253.125**, junto com o local do **socket** do **mysql**  
Que no caso é **socket: '/var/run/mysqld/mysqld.sock'**  

```
production:
 <<: *default
 database: web_service_production
 pool: 5
 timeout: 5000
 username: root
 password: secret123
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

## Testes

Para rodar os testes automatizados basta rodar ```rspec```  

## Rotas

**Verb**&nbsp;&nbsp;&nbsp;**URI&nbsp;Pattern**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Controller#Action**&nbsp;&nbsp;
GET&nbsp;&nbsp;&nbsp;&nbsp;/poll(.:format)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;polls#index&nbsp;&nbsp;
POST&nbsp;&nbsp;&nbsp;/poll(.:format)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;polls#create&nbsp;&nbsp;
GET&nbsp;&nbsp;&nbsp;&nbsp;/poll/:id(.:format)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;polls#show&nbsp;&nbsp;
GET&nbsp;&nbsp;&nbsp;&nbsp;/poll/:id/stats(.:format)&nbsp;&nbsp;polls#stats&nbsp;&nbsp;
POST&nbsp;&nbsp;&nbsp;/poll/:id/vote(.:format)&nbsp;&nbsp;&nbsp;polls#vote&nbsp;&nbsp;