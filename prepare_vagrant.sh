
#Instalar Actualizaciones de ssitema
sudo apt-get update -y 

#instalar dependencias de Ansible
sudo apt-get install  -y software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update -y
sudo apt-get install ansible -y

#Extra Packages para la instalación de docker
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo apt-get update -y