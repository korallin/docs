#!/bin/bash

arq=$1

DATA=`date +'%Y;%m;%d' -r $arq`
TAMANHO=`du -b $arq | cut -f 1`
ARQ=`basename $arq`
echo "${DATA};${ARQ};${TAMANHO}"