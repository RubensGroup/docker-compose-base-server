
#Instalar Actualizaciones de sistema
#sudo apt-get update -y 

#instalar dependencias de Ansible
#sudo apt-get install  -y software-properties-common
#sudo apt-add-repository ppa:ansible/ansible
#sudo apt-get update -y
#sudo apt-get install ansible -y

#Instalar docker en el equipo vagrant
#sudo apt-get install docker.io
sudo apt-get update -y
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt-get update -y

#Agregar el usuario Vagrant al grupo Docker para poder descargar los contenedores
sudo usermod -a -G docker $USER

#Creación de carpetas para la distribución de los DockerFile