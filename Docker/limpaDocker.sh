#!/bin/bash
echo
date

# Gerando estatistica de uso de Filesystem antes de executar limpeza
docker system df
echo
# Removendo todos os containers que nao estao em execucao
echo "Removendo containers com status=exited"
/usr/bin/docker rm $(/usr/bin/docker ps -q --filter "status=exited")
echo
# Removendo os volumes e imagens associados aos conteiners excluidos que nao estao mais em uso
echo "Limpando arquivos temporarios"
/usr/bin/docker volume prune --force
echo

# Verificando se a data de execucao eh o primeiro dia do mes
DATA=`date +%d`
if [ $DATA -eq '01' ]; then
  # Limpando as imagens que nao sao mais utilizadas (mensalmente)
  docker image prune
fi

# Gerando estatistica de uso de Filesystem depois de executar limpeza
docker system df

echo "----------------------------------------------------------------"
