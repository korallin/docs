# Criando um Mirror Yum #

## Usando rsync ##
```
#!/bin/bash
echo "Atualizando pacotes - EPEL 7"
rsync -avz --delete --exclude='repo*' --exclude='debug' rsync://mirrors.rit.edu/epel/7/x86_64/ /var/www/html/repos/epel/7/x86_64/

echo "Atualizando pacotes - CentOS7 BASE"
rsync -avz --delete --exclude='repo*' --exclude='debug' rsync://centos.ufes.br/centos/7/os/x86_64/ /var/www/html/repos/centos/7/os/x86_64/

echo "== Atualizando repositorios - EPEL 7"
createrepo --update /var/www/html/repos/epel/7/x86_64/

echo "== Atualizando repositorios - CentOS7 BASE"
createrepo --update /var/www/html/repos/centos/7/os/x86_64/ -g /var/www/html/repos/centos/7/os/x86_64/repodata/38b60f66d52704cffb8696750b2b6552438c1ace283bc2cf22408b0ba0e4cbfa-c7-x86_64-comps.xml
```

## Usando wget ##
```
wget --mirror --convert-links --no-parent https://download.docker.com/linux/centos/7/x86_64/ -P /var/www/html/repos/docker/
wget --no-parent https://download.docker.com/linux/centos/gpg -O /var/www/html/repos/docker/gpg
```

## Exemplo de um arquivo de Repositorio Yum ##
```
[base]
name=TRF1 Repo: CentOS-$releasever - Base
baseurl=http://srvrepocentos-trf1.trf1.gov.br/repos/centos/7/os/$basearch/
gpgcheck=0

[docker]
name=TRF1 Repo: Docker CE Stable CentOS-$releasever - $basearch
baseurl=http://srvrepocentos-trf1.trf1.gov.br/repos/docker/linux/centos/7/$basearch//stable
enabled=1
gpgcheck=1
gpgkey=http://srvrepocentos-trf1.trf1.gov.br/repos/docker/gpg
```