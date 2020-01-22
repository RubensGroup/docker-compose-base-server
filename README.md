## Entorno para creación de ambiente de desarrollo
Esta configuración básica de Docker Compose, para crear una batería de servidores de Bases de Datos Mysql, Redis, Mongo.

**Nota:** Asegurarse que los archivos .sh que están en /config, tienen permisos de ejecución `chmod 755`.

### Bases de Datos
####  Mysql, Redis, Mongo.
Es necesario levantar la batearía de servidores de docker-compose:
```
#construir las imagenes de los motores de BD
docker-compose build
docker-compose up -d
```

### Creación de imagen base para desarrollo con Ruby
Es necesario crear la imagen base, desde la que se levantaran las imagenes docker en local:
```sh
cd ruby

#se debe elegir la version de Ruby con la que se trabajará
docker build . -t image-base-railsapp-ruby:2.5
docker build . -t image-base-railsapp-ruby:2.6

#Para revisar que la imagen se creó bien
docker run -it --rm --name docker-instance-RANDOM image-base-railsapp-ruby:2.5 bash
docker run -it --rm --name docker-instance-RANDOM image-base-railsapp-ruby:2.6 bash
```

### Creación de imagen base para desarrollo para una aplicación nueva.
Subiremos la imagenes a Docker Hub para depués poder solo utilizarlas de manera pública.
```sh
#Docker image to a new project
docker build . -t tundervirld/ruby-2.6.4:new-app-rails-5.2 -f Dockerfile
docker push tundervirld/ruby-2.6.4:new-app-rails-5.2

#Ejecutar una instancia docker para crear la aplicación
#Se deberá crear la carpeta en la cual se quiere crear la apliación.
docker run -it --rm \
-v $(pwd):/myrailsapp \
tundervirld/ruby-2.6.4:new-app-rails-5.2 \
rails new . \
--database mysql \
--webpack
```

### Creación de imagen base para desarrollo de una aplicación existente.
Subiremos la imagenes a Docker Hub para depués poder solo utilizarlas de manera pública.
```sh
#Docker image to a new project
docker build . -t tundervirld/ruby-2.6.4:existing-app-rails-5.2
docker push tundervirld/ruby-2.6.4:existing-app-rails-5.2

#Ejecutar una instancia docker para levantar una aplicación existente
#Levantar de manera simple la aplicación
docker run -it --rm \
-e APP_PORT=3000 \
-e APP_SERVER_HOST=0.0.0.0 \
-p 3666:3000 \
-v $(pwd):/myrailsapp \
--name docker-instance-${PWD##*/} \
tundervirld/ruby-2.6.4:existing-app-rails-5.2

#Levantar de manera simple la aplicación con la configuración completa, revisar sección Rails WebApp

docker run -it --rm \
-p 4001:3000 \
--network docker-compose-base-dev_backennetwork \
--env-file .env.docker \
-v $(pwd):/myrailsapp \
--name docker-instance-${PWD##*/} \
tundervirld/ruby-2.6.4:existing-app-rails-5.2

#Entrar en la instancia Docker por ssh
docker exec -ti docker-instance-${PWD##*/} bash
```

### Rails WebApp
#### Configuraciones y PreRequitos
Para un proyecto nuevo o existente, es necesario tener en cuenta algunas configuraciones de variables de entorno que puede usar la aplicación. 

##### 1.- Crear Carpeta de proyecto
Se debe crear el Directorio para la aplciación.
```sh
#Se debe crear el directorio en que se quiere guardar la aplicación, para poder hacer referencia como un volumen en la instancia docker mas adelante.
mkdir [Carpeta Nombre Proyecto]
```
##### 2.- Archivo de Variables
Dentro del directorio de la aplicación, se debe crear el archivo para las variables de entorno de la aplicación *.env.docker*
```sh
RAILS_ENV=development
APP_ROOT=$(pwd)
APP_PORT=3000
APP_SERVER_HOST=0.0.0.0
ADMIN_NAME=[Nombre administrador]
ADMIN_EMAIL=[Nombre administrador]
ADMIN_PASSWORD=[Nombre administrador]
EMAIL_PROVIDER_USERNAME=[Nombre administrador]
EMAIL_PROVIDER_PASSWORD=[Nombre administrador]
DOMAIN_NAME=[Nombre administrador]
MYSQLDB_USER=root
MYSQLDB_PASSWORD=password
MYSQLDB_HOST=mysqldb-server
MYSQLDB_DATABASE_NAME=[Nombre BD] #De preferencia el nombre del directorio, lo puedes extraer con ** echo "${PWD##*/}" **
REDISDB_URL=redis://cache
REDISDB_PORT=6379
```

#### 2.1 Aplicación Rails Nueva, Si no existe
Para crear una aplicación Rails desde cero se puede hacer ejecutando la instancia Docker de la imagen creada anteriormente:
```sh
# Crear la aplicación rails
docker run -it --rm \
-v $(pwd):/myrailsapp \
image-base-railsapp-ruby:2.5 \
rails new . --force --no-deps --database=mysql

# Crear la aplicación rails con VueJS
docker run -it --rm \
-v $(pwd):/myrailsapp \
image-base-railsapp-ruby:2.5 \
rails new . --force --no-deps --database=mysql --webpack=vue
```

#### 3 Configuración de acceso a Base de datos
Reemplazar el contenido del archivo _database.yml_ por:
```yaml
default: &default
  ...
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV['MYSQLDB_USER'] %>
  password:  <%= ENV['MYSQLDB_PASSWORD'] %>
  host:  <%= ENV['MYSQLDB_HOST'] %>
  ...

development:
  <<: *default
  database:  <%= ENV['MYSQLDB_DATABASE_NAME'] %>_development
  ...

test:
  <<: *default
  database: <%= ENV['MYSQLDB_DATABASE_NAME'] %>_test
  ...

production:
  <<: *default
  database: <%= ENV['MYSQLDB_DATABASE_NAME'] %>_production
  username: <%= ENV['MYSQLDB_USER'] %>
  password: <%= ENV['MYSQLDB_PASSWORD'] %>
```

#### 4 Lenvatar una instancia Docker con mi aplicación
Despues del paso anterior, se creó un aplicación rails, este mismo procedimiento es para una aplicación pre-existente:
```sh
#Levantar la instancia Docker con mi App Rails
docker run -it --rm \
-p 3002:3000 \
--network docker-compose-base-dev_backennetwork \
--env-file .env.docker \
-v $(pwd):/myrailsapp \
--name docker-instance-${PWD##*/}-${RANDOM} image-base-railsapp-ruby:2.5

```

#### Configuración de Modelo de Datos
Si se desea crear la BD, crear las migraciones, se debe hacer:
```ruby
rake db:create
rake db:migrate
```


#### CRUD para Test
Con este comando se puede crear un CRUD para poder revisar la conectividad con la Base De Datos.
```sh
docker-compose run web rails generate scaffold HighScore game:string score:integer
docker-compose run web rake db:migrate
```


###### Redes Docker
Docker crea redes para poder separar las instancias y que no se pudan comunicar entre ellas a menos que se configure.
```sh
docker network prune
docker network ls
docker network inspect docker-compose-base-dev_backennetwork
```


Otros Comandos Compose útiles de docker-compose
```
docker-compose run test bundle exec "rails db:setup && xvfb-run rails spec"
docker-compose run  app bash
docker-compose logs -f --tail 1000 app
```

###### Referencias:
- [Network en Docker](https://docs.docker.com/network/network-tutorial-standalone/)
- [Network Docker Compose](https://docker-k8s-lab.readthedocs.io/en/latest/docker/docker-compose.html)
- [Dockerize App](https://nickjanetakis.com/blog/dockerize-a-rails-5-postgres-redis-sidekiq-action-cable-app-with-docker-compose)
- [Unifying Rails Environments](https://phraseapp.com/blog/posts/unifying-rails-environments-docker-compose/unifying-rails-environments-docker-compose/)