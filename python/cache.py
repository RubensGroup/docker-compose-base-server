# Importar python-memcache y sys por argumentos
import memcache
import sys

# Establece la dirección de acceso para la instancia de Memcached
addr = 'localhost'

# Toma los numeros de argumentos
# Formato esperado: python cache.py [puerto memcached] [clave] [valor]
len_argv = len(sys.argv)

# Al menos el número puerto y una clave debe ser proporcionados
if len_argv < 3:
    sys.exit("No hay suficientes argumentos")

# El puerto y la clave son suministrados - ¡Vamos a conectarnos!
port  = sys.argv[1]
cache = memcache.Client(["{0}:{1}".format(addr, port)])

# Obtener la Clave
key   = str(sys.argv[2])

# Si también se proporciona un valor, ajustar para clave-valor
if len_argv == 4:

    value = str(sys.argv[3])
    cache.set(key, value)

    print "¡Valor para {0} establecido!".format(key)

# Si no se proporciona un valor, devuelve el valor de la clave:

    value = cache.get(key)

    print "¡Valor para {0} es {1}!".format(key, value)