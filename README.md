## Entorno para creación de ambiente de desarrollo
Esta configuración básica de Docker Compose, es para crear una batería de servidores de Bases de Datos Mysql, Redis, Mongo.

### Bases de Datos
####  Mysql, Redis, Mongo.
Para levantar la batearía de servidores del docker-compose:
```
#construir las imagenes de los motores de BD
docker-compose build
#levantar todos los servidores como `demon`

docker-compose up -d
```
#####  Mysql
Levantar solamente el servidor Mysql.
```
#Si se quiere levatar el servicio cómo `deamond`, se agregar -d al final
docker-compose up mysqldb -d
```
##### Mongo.
Levantar solamente el servidorMongo.
```
#Si se quiere levatar el servicio cómo `deamond`, se agregar -d al final
docker-compose up mongodb
```
#####  Redis.
Levantar solamente el servidor Redis.
```
#Si se quiere levatar el servicio cómo `deamond`, se agregar -d al final
docker-compose up redis
```

**Nota:** Todos los servidores para poder verse desde un docker, deben pertenecer a la misma RED `base-server-network`. Para cual es necesario específicar el parametro `--network base-server-network `
``` 
docker run -it --rm \
--network ${PWD##*/}_base-server-network \
...
```

###### Utilidades docker-compose
Docker crea redes para poder separar las instancias y que no se puedan comunicar entre ellas solamente con configuraciaón previa.
```sh
docker network prune
docker network ls
docker network inspect ${PWD##*/}_base-server-network
```
**Troubleshootin**
Otros Comandos útiles de docker-compose
```
#docker-compose run [service name] bash
docker-compose run mongodb bash

#docker-compose --verbose up [service name]
docker-compose --verbose up mongodb
docker-compose logs -f --tail 1000 app
```

Son muy usados tambien los comandos docker, por lo que se recomienda hacer un alias.
```
dockerclean='docker rm `docker ps -aq -f status=exited`'
dockerpurgeimages='docker rmi $(docker images -q)'
dockerstopclean='docker stop $(docker ps -a -q) | docker rm $(docker ps -a -q)'
```
Revisar configuraciones de Docker, para setear usuario, email, etc.
```
git config --list
#ejemplo para setear a nivel de todos el SO
git config [--global] user.name "Nombre Apellido"
#configuración de correo, solamente para este repositorio
git config user.email "reocomboysgm@gmail.com"
```

###### Referencias:
- [Network en Docker](https://docs.docker.com/network/network-tutorial-standalone/)
- [Network Docker Compose](https://docker-k8s-lab.readthedocs.io/en/latest/docker/docker-compose.html)