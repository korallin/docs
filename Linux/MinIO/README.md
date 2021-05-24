# O que é MinIO? #
Minio é um servidor de armazenamento de objetos compatível com o protocolo S3, compatível com AWS, escrito em Go.
Ele pode ser usado para armazenar qualquer objeto como fotos, vídeos, arquivos de registro, backups, etc.
Você pode utilizar como se fosse seu próprio servidor de object storage como o S3 da AWS e outros object storages.

## Instalando MinIO ##
- Baixar o binário em https://min.io/download
- Copiar o binário para uma pasta no host

## Administrando MinIO ##
### Utilitário MC ###
Com o utilitário *MC* é possível administrar o MinIO em modo console.

#### Alias ####
Criação de um *Alias* para conexção com o utilitário *mc*
> ./mc alias set <alias_minio> <url_minio> <AccessKey> <SecretKey>

Exemplo de utilização:
> ./mc alias set myminio http://172.16.3.51:9000/ miniopje 67e8d5353f115facce8a1a2a683d9bda

Listando os alias já criados:
> ./mb alias ls

#### Informações sobre uma instâncias de MinIO ####
> ./mc admin info myminio

#### Estatísticas ####
> ./mc stat minio

## Referências ##
https://fabiosilva.com.br/2020/07/08/minio/


