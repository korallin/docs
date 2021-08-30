# Mostrando informações de uma partiçao
tune2fs -l /dev/sda1

# Verificando blocos reservados
tune2fs -l /dev/sda1 | grep -i reserved

# Ajustando quantidade de blocos reservados
tune2fs -m0 /dev/sda1
Setting reserved blocks percentage to 0% (0 blocks)

# Habilitando ACL
tune2fs -o +acl /dev/sda1