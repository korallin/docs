# O que é MinIO?
Minio é um servidor de armazenamento de objetos compatível com o protocolo S3, compatível com AWS, escrito em Go.
Ele pode ser usado para armazenar qualquer objeto como fotos, vídeos, arquivos de registro, backups, etc.
Você pode utilizar como se fosse seu próprio servidor de object storage como o S3 da AWS e outros object storages.

## Instalando MinIO
- Baixar o binário em https://min.io/download
- Copiar o binário para uma pasta no host

## Administrando MinIO

### Utilitário MC
Com o utilitário *MC* é possível administrar o MinIO em modo console.

#### Alias
Criação de um *Alias* para conexção com o utilitário *mc*
> ./mc alias set <alias_minio> <url_minio> <AccessKey> <SecretKey>

Exemplo de utilização:
> ./mc alias set pjehmlminio http://172.16.3.51:9000/ miniopje 67e8d5353f115facce8a1a2a683d9bda

Listando os alias já criados:
> ./mc alias ls

#### Informações sobre uma instâncias de MinIO ####
```bash
./mc admin info pjehmlminio
●  srvpjehmlminio1:9000
   Uptime: 17 minutes
   Version: 2021-05-26T00:22:46Z
   Network: 2/2 OK
   Drives: 4/4 OK

●  srvpjehmlminio2:9000
   Uptime: 17 minutes
   Version: 2021-05-26T00:22:46Z
   Network: 1/2 OK
   Drives: 4/4 OK

44 MiB Used, 1 Bucket, 1 Object
8 drives online, 0 drives offline
```
#### Criando um Bucket
> ./mc mb pjehmlminio/teste

#### Removendo um Bucket
> ./mc rb pjehmlminio/teste --force

#### Removendo pasta/objetos recursivamente em um Bucket
> ./mc rm -r --force local/bucket.teste/202101

#### Estatísticas
> ./mc stat pjehmlminio

#### Estatísticas de um determinado objeto
```bash
tr301005@nuope08-trf1 /opt/minio$ ./mc stat pjehmlminio/br.jus.pje.5.09/202101/01/teste
Name      : teste
Date      : 2021-05-28 14:05:48 -03
Size      : 1 B
ETag      : ff44570aca8241914870afbc310cdb85
Type      : file
Metadata  :
  Content-Type: application/pdf
```

## Criando usuário com acesso apenas em um determinado Bucket

### Criando Usuarios
> mc admin user add pjehmlminio usuario1 senha123
> mc admin user add pjehmlminio usuario2 senha456
> mc admin user add pjehmlminio usuario3 senha789

### Criando Grupo
> mc admin group add pjehmlminio grupoPje usuario1 usuario2

### Adicionando Usuarios no Grupo
> mc admin group add pjehmlminio grupoPje usuario3

### Verificando Usuarios que fazem parte de um Grupo
```bash
tr301005@nuope08-trf1 /opt/minio$ mc admin group info pjehmlminio grupoPje
Group: grupoPje
Status: enabled
Policy:
Members: usuario1,usuario2,usuario3
```

### Criando Policy para acesso Leitura e Escrita em um Bucket
```bash
cat > pjeBucket.json << EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action": "s3:ListAllMyBuckets",
         "Resource":"arn:aws:s3:::*"
      },
      {
         "Effect":"Allow",
         "Action":["s3:ListBucket","s3:GetBucketLocation"],
         "Resource":"arn:aws:s3:::br.jus.pje.5.09"
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject"
         ],
         "Resource":"arn:aws:s3:::br.jus.pje.5.09/*"
      }
   ]
}
EOF

./mc admin policy add pjehmlminio PjeReadWrite pjeBucket.json
./mc admin policy set pjehmlminio PjeReadWrite group=SESOL
```

Acessando o Bucket http://pjehmlminio.trf1.jus.br:9000/minio/br.jus.pje.5.09/



#### Espaço utilizado
##### Espaço total sumarizado de um Bucket
```bash
tr301005@nuope08-trf1 /opt/minio$ ./mc du pjehmlminio/br.jus.pje.5.09/
365B    br.jus.pje.5.09
```

##### Espaço total de um Bucket com detalhe de uso de cada sub-pasta
```bash
tr301005@nuope08-trf1 /opt/minio$ mc du -d 2 pjehmlminio/br.jus.pje.5.09/
31B     br.jus.pje.5.09/202101
28B     br.jus.pje.5.09/202102
31B     br.jus.pje.5.09/202103
30B     br.jus.pje.5.09/202104
31B     br.jus.pje.5.09/202105
30B     br.jus.pje.5.09/202106
31B     br.jus.pje.5.09/202107
31B     br.jus.pje.5.09/202108
30B     br.jus.pje.5.09/202109
31B     br.jus.pje.5.09/202110
30B     br.jus.pje.5.09/202111
31B     br.jus.pje.5.09/202112
365B    br.jus.pje.5.09
```

#### Listando buckets e diretórios em formato de árvore
```bash
tr301005@nuope08-trf1 /opt/minio$ ./mc tree -d 1 pjehmlminio
pjehmlminio
└─ br.jus.pje.5.09
   ├─ 202101
   ├─ 202102
   ├─ 202103
   ├─ 202104
   ├─ 202105
   ├─ 202106
   ├─ 202107
   ├─ 202108
   ├─ 202109
   ├─ 202110
   ├─ 202111
   └─ 202112
```

#### Listando objetos em formato de árvore
```bash
tr301005@nuope08-trf1 /opt/minio$ mc tree -f pjehmlminio/br.jus.pje.5.09/202106/01
pjehmlminio/br.jus.pje.5.09/202106/01
├─ 10d79981a7c7706bb40a7327e83b8138291d3ad4
├─ 14ff87e31f97f2c550168c2f690f50707239400f
├─ 3a22e54d8c3a084b1d443c00b49ef9ce4a6a4640
├─ 3e7cc735dfc55953020840d517529b7a3e7ae619
├─ 7f2435cc3ea98b8b4b6a41158c7b3beb89f0d647
├─ 8088cc4d26f8df1289e4ce710cce75da6a5b9130
├─ ab3e57d694126bda9fc6eb2d6fac605b73cf413e
├─ bff7887e48aca41669f4fcae0a32ac508ca614ae
├─ bff9b7e5b608bdca71c7ce717993b174b9c5009a
├─ c70d2f294dd317e2a0b183a05d1832a23c652de1
├─ e0992050dd8285f51a0dd0aac15256b227aab4db
├─ eb2ab0ba7c7244bdfd067eb4217a3d0459606403
├─ f9942cc314a9828979f25e52aed788d5fb5eea26
└─ teste
```

#### Enviando arquivo para um determinado bucket
> ./mc cp arquivo.json pjehmlminio/teste
> ./mc cp --attr key1=value1;key2=value2 arquivo.json pjehmlminio/teste

#### Listando arquivos criados no dia
> ./mc ls --rewind 0d pjehmlminio/teste

#### Mostrando conteúdo de um arquivo
```bash
./mc cat pjehmlminio/teste/admin.json
{
        "Version": "2012-10-17",
        "Statement": [{
                        "Action": [
                                "admin:*"
                        ],
                        "Effect": "Allow",
                        "Sid": ""
                },
                {
                        "Action": [
                "s3:*"
                        ],
                        "Effect": "Allow",
                        "Resource": [
                                "arn:aws:s3:::*"
                        ],
                        "Sid": ""
                }
        ]
}
```

## Links de Download e Upload

#### Criando link para Download de um determinado Objeto
```bash
tr301005@nuope08-trf1 /opt/minio$ mc share download pjehmlminio/br.jus.pje.5.09/202106/01/3e7cc735dfc55953020840d517529b7a3e7ae619
URL: http://pjehmlminio.trf1.jus.br:9000/br.jus.pje.5.09/202106/01/3e7cc735dfc55953020840d517529b7a3e7ae619
Expire: 7 days 0 hours 0 minutes 0 seconds
Share: http://pjehmlminio.trf1.jus.br:9000/br.jus.pje.5.09/202106/01/3e7cc735dfc55953020840d517529b7a3e7ae619?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=miniopje%2F20210601%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210601T192444Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=c25607de2c4cc43f629af2b55441a4c1f93e12bb005f4a062fd430a1a8dc0c8c
```

#### Criando link para Upload de arquivo
```bash
tr301005@nuope08-trf1 /opt/minio$ mc share upload pjehmlminio/br.jus.pje.5.09/202106
URL: http://pjehmlminio.trf1.jus.br:9000/br.jus.pje.5.09/202106
Expire: 7 days 0 hours 0 minutes 0 seconds
Share: curl http://pjehmlminio.trf1.jus.br:9000/br.jus.pje.5.09/ -F bucket=br.jus.pje.5.09 -F policy=eyJleHBpcmF0aW9uIjoiMjAyMS0wNi0wOFQxOToyNjowNC43OTdaIiwiY29uZGl0aW9ucyI6W1siZXEiLCIkYnVja2V0IiwiYnIuanVzLnBqZS41LjA5Il0sWyJlcSIsIiRrZXkiLCIyMDIxMDYiXSxbImVxIiwiJHgtYW16LWRhdGUiLCIyMDIxMDYwMVQxOTI2MDRaIl0sWyJlcSIsIiR4LWFtei1hbGdvcml0aG0iLCJBV1M0LUhNQUMtU0hBMjU2Il0sWyJlcSIsIiR4LWFtei1jcmVkZW50aWFsIiwibWluaW9wamUvMjAyMTA2MDEvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJdXX0= -F x-amz-algorithm=AWS4-HMAC-SHA256 -F x-amz-credential=miniopje/20210601/us-east-1/s3/aws4_request -F x-amz-date=20210601T192604Z -F x-amz-signature=3dbed673b3788e0b9e7bfa1f5ca1466466eae924cdfa3af26d2054df292c4e3c -F key=202106 -F file=@<FILE>
```

#### Listando links ativos para Download
```bash
tr301005@nuope08-trf1 /opt/minio$ mc share list download pjehmlminio
URL: http://pjehmlminio.trf1.jus.br:9000/br.jus.pje.5.09/202106/01/3e7cc735dfc55953020840d517529b7a3e7ae619
Expire: 6 days 23 hours 57 minutes 23 seconds
Share: http://pjehmlminio.trf1.jus.br:9000/br.jus.pje.5.09/202106/01/3e7cc735dfc55953020840d517529b7a3e7ae619?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=miniopje%2F20210601%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210601T192444Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=c25607de2c4cc43f629af2b55441a4c1f93e12bb005f4a062fd430a1a8dc0c8c

URL: http://pjehmlminio.trf1.jus.br:9000/br.jus.pje.5.09/202106/01/d3105fc84e8acc468785f1f75645ce39cb2d5bf7
Expire: 6 days 23 hours 53 minutes 4 seconds
Share: http://pjehmlminio.trf1.jus.br:9000/br.jus.pje.5.09/202106/01/d3105fc84e8acc468785f1f75645ce39cb2d5bf7?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=miniopje%2F20210601%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210601T192025Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=bf28c96f1a2f5f97813d3232c9f1e5c0c1952a5d99ef0512da4a0d6308f85314
```

#### Listando links ativos para Upload
```bash
tr301005@nuope08-trf1 /opt/minio$ mc share list upload pjehmlminio
URL: http://pjehmlminio.trf1.jus.br:9000/br.jus.pje.5.09/202106
Expire: 6 days 23 hours 58 minutes 25 seconds
Share: curl http://pjehmlminio.trf1.jus.br:9000/br.jus.pje.5.09/ -F bucket=br.jus.pje.5.09 -F policy=eyJleHBpcmF0aW9uIjoiMjAyMS0wNi0wOFQxOToyNjowNC43OTdaIiwiY29uZGl0aW9ucyI6W1siZXEiLCIkYnVja2V0IiwiYnIuanVzLnBqZS41LjA5Il0sWyJlcSIsIiRrZXkiLCIyMDIxMDYiXSxbImVxIiwiJHgtYW16LWRhdGUiLCIyMDIxMDYwMVQxOTI2MDRaIl0sWyJlcSIsIiR4LWFtei1hbGdvcml0aG0iLCJBV1M0LUhNQUMtU0hBMjU2Il0sWyJlcSIsIiR4LWFtei1jcmVkZW50aWFsIiwibWluaW9wamUvMjAyMTA2MDEvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJdXX0= -F x-amz-algorithm=AWS4-HMAC-SHA256 -F x-amz-credential=miniopje/20210601/us-east-1/s3/aws4_request -F x-amz-date=20210601T192604Z -F x-amz-signature=3dbed673b3788e0b9e7bfa1f5ca1466466eae924cdfa3af26d2054df292c4e3c -F key=202106 -F file=@<FILE>
```

# Mirror
## Efetuando um mirror de um determinado bucket
Bucket local que vai receber o bucket remoto
```bash
tr301005@nuope08-trf1 /opt/minio$ mc admin info local
●  localhost:9000
   Uptime: 16 minutes
   Version: 2021-05-26T00:22:46Z
   Network: 1/1 OK

1 B Used, 1 Bucket, 1 Object
```

Bucket remoto em modo Cluster distribuído que vai ser replicado
```bash
tr301005@nuope08-trf1 /opt/minio$ mc admin info pjehmlminio
●  srvpjehmlminio2:9000
   Uptime: 3 hours
   Version: 2021-05-26T00:22:46Z
   Network: 2/2 OK
   Drives: 4/4 OK

●  srvpjehmlminio1:9000
   Uptime: 3 hours
   Version: 2021-05-26T00:22:46Z
   Network: 2/2 OK
   Drives: 4/4 OK

365 B Used, 1 Bucket, 365 Objects
8 drives online, 0 drives offline
```

Criando o Bucket local que vai ser sincronizado com o Bucket remoto
```bash
tr301005@nuope08-trf1 /opt/minio$ mc mb local/espelho
Bucket created successfully `local/espelho`.
```

Sincronizando o Bucket remoto com o Bucket local
```bash
tr301005@nuope08-trf1 /opt/minio$ mc mirror --remove pjehmlminio/br.jus.pje.5.09 local/espelho
....jus.pje.5.09/202112/30/teste:  365 B / 365 B ┃#################################┃ 303 B/s 1
```

# Configurando MinIO Console
## Baixando binário
> wget https://github.com/minio/console/releases/latest/download/console-linux-amd64

## Configurando serviço

### Criando usuário para Console
```bash
mc admin user add myminio/
Enter Access Key: console
Enter Secret Key: xxxxxxxx
```

### Criando Policy a ser utilizada na Console
```bash
cat > admin.json << EOF
{
	"Version": "2012-10-17",
	"Statement": [{
			"Action": [
				"admin:*"
			],
			"Effect": "Allow",
			"Sid": ""
		},
		{
			"Action": [
                "s3:*"
			],
			"Effect": "Allow",
			"Resource": [
				"arn:aws:s3:::*"
			],
			"Sid": ""
		}
	]
}
EOF

./mc admin policy add pjehmlminio consoleAdmin admin.json
./mc admin policy set pjehmlminio consoleAdmin user=console
```

### Iniciando serviço MinIO Console
```bash
# Salt to encrypt JWT payload
export CONSOLE_PBKDF_PASSPHRASE=SECRET

# Required to encrypt JWT payload
export CONSOLE_PBKDF_SALT=SECRET

# MinIO Endpoint
export CONSOLE_MINIO_SERVER=http://localhost:9000

./console-linux-amd64 server --port 8080
```

# Referências
https://fabiosilva.com.br/2020/07/08/minio/
https://docs.min.io/docs/minio-client-complete-guide.html
https://github.com/minio/console