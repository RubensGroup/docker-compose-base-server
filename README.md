# vagrant-dockers
Levantamiento de máquina Vagrant con RAM específica, contiene una shell que prepara instalaciones de utilidades básicas y configura 4 Docker's dedicados para Ruby Rails, PHP, Server NGINX, Servidor para desarrollo de AngularJS + Angular+ NodeJS.

##Características Vagrant
*Referencia a carpeta compartida de sistema host Windows.
*Asignación de Ram

##Docker
Docker usa LXC Contenedores Linux, que se ejecutan por conmandos o a sus vez por una archivo de configuración Dockerfile, el cual permite generar un contendor Linux de una manera más fácil para el usuario final, al usar directamente LXC es un poco mas complejo.

'''cmd
#Instalación de Docker
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
'''

#Docker recomienda crear un usuario del grupo docker, si  no se quiere realizar las acciones con el usuarios ROOT
'''
	#Agregar el usuario que necesites al grupo docker
	sudo usermod -aG docker your-user

#	WARNING: Adding a user to the "docker" group will grant the ability to run
#         containers which can be used to obtain root privileges on the
#         docker host.
#         Refer to https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
#         for more information.
'''

##Dockerfile
Es un archivo de configuraciones que permite ejecutar comando de manera secuencial, en la que se puede anotar varia sentencias para prepara la descarga y configuración de una imagen que postreriormente puede ser un cointendor DOCKER.


##Para la instalación de los contendores, es necesario ejecutar el docker de cada uno de los servicios ques se requiere iniciar.
'''cmd
sudo docker build -t mysql_custom_3306 /vagrant/mysql/.
sudo docker build -t apache2_php_custom_80 /vagrant/apache2-php/.
'''

#Para revisar las imagenes instaladas en mi entorno y tomar el ID
'''cmd
docker images -a
'''

#Remover Imágenes/Contenedore
'''cmd
docker rm [nombre docker]
docker rmi [nombre imagen]
'''

#crear un contendor a partir un ID de imagen
'''cmd
# -d  correr demonio en background
# -P publicar todos los puertos
# -name nombre del contenedor
# -v montar un directorio
# --link [Si se esta dentro de un Vagrant, recorda que la base ocupable es /home/vagrant]

docker run -d -P --name [Nombre Contenedor] [IMAGE ID]
docker run -d -P --name mysql 9998dd892646
docker run --name memcached_ins -d -p 45001:11211 memcached_img

docker run -d -P  -v [Directorio del Proyecto]:[Directorio Destino Contenido WEB /var/www/...] --name [Nombre Nuevo Contenedor]  --link [Nombre Contenedor al ques e quiere Linkear(Hacer Referencia)] [IMAGE ID]
docker run -d -P  -v /Users/rogerreyes/WebApp/DrupalPHP:/var/www/html --name web e5ce6d448205 --link mysql:mysql
'''

Para acceder a la consola de un contenedor:

'''cmd
docker run -it [nombre/id de imagen] -bash
'''

Un contenedor nace a partir de una imagen, sin embargo despues se puede customizar para que el contenedor se comporte de acuerdo a nuestra necesidad, por lo que puede ser configurado y guardarse como una imagen, para ser base de un nuevo contendor.

'''cmd
docker commit -m "What did you do to the image" -a "Author Name" container-id repository/new_image_name
###ejm:
docker commit -m "added node.js" -a "Sunday Ogwu-Chinuwa" d9b100f2f636 finid/ubuntu-nodejs
'''

Publicar el contenido de la imagen a Docker Hub
'''cmd
docker login -u docker-registry-username
docker push docker-registry-username/docker-image-name
'''
Comandos mas usado para Docker
'''cmd
docker  start    [CONTAINER ID] #Iniciar un contenedor
docker  restart  [CONTAINER ID] #Reiniciar un contenedor
docker  stop     [CONTAINER ID] #Detener un contenedor
docker  port     [CONTAINER ID] #puerto público el cual está NAT-eado 
docker  save -o [nombre_Archivo] [IMAGE ID] #Guardar un tar.gz de una imagen Docker.
'''
https://github.com/kstaken/dockerfile-examples