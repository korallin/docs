#!/usr/bin/env bash

# titulo: testando_cores_do_bash.sh
# autor: claytu_dinamiti_1000
# Data: 2020

clear
echo
echo -e "\e[1;36m \n# —> Testando as cores do Bash no Linux! Fundo verde <-\n\e[0m"
sleep 2
echo -e "\e[1;42m*** Fundo VERDE BOLD! ***\n\e[0m"
sleep 2
echo -e "\e[34mTexto azul\n\e[0m"
sleep 3
echo -e "\e[34m Texto azul\n \e[0m"
sleep 2
echo -e "\e[34m*** Texto azul ***\n\e[0m"
sleep 3
echo -e "\e[36mTexto cyan\n\e[0m"
sleep 2
echo -e "\e[36m Texto cyan\n \e[0m"
sleep 3
echo -e "\e[36m*** Texto cyan ***\n\e[0m"
sleep 2
echo -e "\e[1mTexto BOLD\n\e[0m"
sleep 3
echo -e "\e[1;36mTexto BOLD CYAN\n\e[0m"
sleep 2
echo -e "\e[4mTexto sublinhado\n\e[0m"
sleep 3
echo -e "\e[4;32mTexto sublinhado VERDE\n\e[0m"
sleep 2
echo -e "\e[1;4;32mTexto sublinhado VERDE BOLD\n\e[0m"
sleep 3
echo -e "\e[5mTexto piscando\n\e[0m"
sleep 2
echo -e "\e[1;4;5mTexto piscando sublinhado BOLD\n\e[0m"
sleep 3
echo -e "\e[1;4;31;5mTexto piscando sublinhado BOLD vermelho\n\e[0m"
sleep 2
echo -e "\e[5m*** Texto piscando ***\n\e[0m"
sleep 3
echo -e "\e[1;31;5m*** Fatal Error! ***\n\e[0m"
sleep 2
echo -e "\e[1;36;5m*** Brincadeirinha! Just kidding! Kkk… ***\n\e[0m"
sleep 3
echo -e "\e[7m*** Video caracteres reverso ***\n\e[0m"
sleep 2
echo -e "\e[7m*** Linux Life! ***\n\e[0m"
sleep 2
echo -e "\e[1;36;5m\n*** FEITO! SAINDO EM 5 SEGUNDOS! ***\n\e[0m"
sleep 5
clear
exit 0
