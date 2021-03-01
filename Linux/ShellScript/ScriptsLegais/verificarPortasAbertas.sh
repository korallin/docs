#!/bin/bash

REDE="192.168.0"
REDE_START=1
REDE_END=254
PORTAS=(22 80 443 5500)

for i in $(seq $RED_START $REDE_END); do
    IP="$REDE.$i"
    for PORTA in "${PORTAS[@]}"; do
        timeout 1 bash -c "(: </dev/tcp/$IP/$PORTA) &>/dev/null && echo '${IP}:${PORTA} ABERTO'"
    done
done