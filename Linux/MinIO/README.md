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

#### Listando buckets e ojbetos em formato de árvore
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