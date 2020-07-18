#!/bin/bash
export SSHPASS=trf1tmp

date >> /home/tr301005/unb/transferencia-00.log
sshpass -e rsync -e "ssh -p 8080 -o PreferredAuthentications=password" -Pazv /mnt/unb/00  limited@164.41.91.132:/home/limited/ >> /home/tr301005/unb/transferencia-00.log 2>&1