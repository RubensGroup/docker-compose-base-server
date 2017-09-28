##MEMCACHED
Motor de almacenamiento de datos distribuido OPEN SOURCE, su principal uso es almacenar infomación en RAM, para acelerar el proceso de recupaeración de información.

Función principal, almacenar información del tipo Clave -> Valor de hasta 1MB que se puede distribuir a travez de varios servidores virtuales.

docker build -t memcached_img /vagrant/memcached/.
docker run --name memcached_ins -d -p 45001:11211 memcached_img
docker run -name memcached_ins -m 256m -d -p 45001:11211 memcached_img
