# Condicionais em Shell Script

## Comparando Inteiros
| operador | Condição       |
|----------|----------------|
| -eq      | Igual          |
| -ne      | Não Igual      |
| -gt      | Maior que      |
| -ge      | Maior ou igual |
| -lt      | Menor que      |
| -le      | Menor ou igual |

```bash
#!/bin/bash
v1=1
v2=2

# V1 igual V2
if [ $v1 -eq $v2 ]; then
   echo "V1 == V2"

# V1 não é igual V2
elif [ $v1 -ne $v2 ]; then
   echo "V1 != V2"

# V1 maior que V2
elif [ $v1 -gt $v2 ]; then
   echo "V1 > V2"

# V1 maior ou igual que V2
elif [ $v1 -ge $v2 ]; then
   echo "V1 >= V2"

# V1 menor que V2
elif [ $v1 -lt $v2 ]; then
   echo "V1 < V2"

# V1 menor ou igual que V2
elif [ $v1 -le $v2 ]; then
   echo "V1 <= V2"

fi
```

## Multiplas comparações
| operador | Condição  |
|----------|-----------|
| -a       | AND lógico|
| -o       | OR  lógico|
| !        | Negação   |

```bash
#!/bin/bash
v1=1
v2=2
v3=3

# AND Logico
if [ $v1 -lt $v2 -a $v3 -gt $v2 ]; then
   echo "(V1 < V2) AND (V3 > V2)"
fi

# OR Logico
if [ $v1 -lt $v2 -o $v3 -gt $v2 ]; then
   echo "(V1 < V2) OR (V3 > V2)"
fi

# Negação
if [ ! $v1 -eq $v2 ]; then
   echo "V1 != V2"
fi
```

## Arquivos e Diretorios
| operador | Descrição                                         |
|----------|---------------------------------------------------|
| -d       | Verifica se é diretório                           |
| -f       | Verifica se é arquivo                             |
| -e       | Verifica se existe                                |
| -O       | Verifica se dono do arquivo é quem está executando|
| -s       | Verifica se arquivo não é vázio                   |
| -L       | Verifica se é link simbólico                      |
| -r       | Verifica se é usuário tem permissão leitura       |
| -w       | Verifica se é usuário tem permissão gravação      |
| -x       | Verifica se é usuário tem permissão execução      |
| -nt      | Verifica se é mais recente                        |
| -ot      | Verifica se é mais antigo                         |
| -nt      | Verifica se é igual                               |

https://acloudguru.com/blog/engineering/conditions-in-bash-scripting-if-statements
https://cleitonbueno.com/shell-script-estrutura-condicional/
https://www.shellscriptx.com/2016/12/estrutura-condicional-if-then-elif-else-fi.html