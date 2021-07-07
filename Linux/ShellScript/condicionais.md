# Condicionais em Shell Script

## Comparando Inteiros
```bash
#!/bin/bash
v1=1
v2=2

# V1 igual V2
if [ $v1 -eq $v2 ]; then
   echo "V1 == V2"

# V1 não é igual V2
elif [ $v1 -ne $v2 ]; then
   echo "V1 == V2"

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

```bash
#!/bin/bash
v1=1
v2=2
v3=3

if [ $v1 -lt $v2 -a $v3 -gt $v2 ]; then
   echo "(V1 < V2) AND (V3 > V2)"
fi

if [ $v1 -lt $v2 -o $v3 -gt $v2 ]; then
   echo "(V1 < V2) OR (V3 > V2)"
fi
```