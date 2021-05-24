# Logical Volume Manager - LVM #
O LVM é útil para gerir os discos de forma inteligente através de volumes. Conheça essa tecnologia usada em muitas distribuições
O LVM é um gerenciador de discos do Kernel do Linux. Ele permite que discos sejam trocados sem interrupção do serviço (hotswap), alterar o tamanho dos volumes, criar backup de imagens dos volumes, criar um volume único a partir de vários discos (similar ao RAID 0) ou criar volumes espelhados em mais de um disco (similar ao RAID 1).
O LVM possibilita ampliar o sistema de arquivos que tradicionalmente é visto como um conjunto de discos físicos e partições. Seu objetivo é permitir uma flexibilidade grande para o administrador no gerenciamento dos discos.

## Volumes Físicos ##
É um disco ou algum hardware que se comporte como um disco (como um storage que use RAID);

### Listando informações dos Volumes Físicos ###
> pvs -a

### Criando Volume Físico ###
> pvcreate /dev/sdb1

### Rescan de discos ###
#### Discos que foram expandidos ####
> echo 1 > /sys/block/<SDXX>/device/rescan

#### Rescan de novos Discos ####
1) Forma de Rescan
```
    #  grep mpt /sys/class/scsi_host/host?/proc_name
    /sys/class/scsi_host/host2/proc_name:mptspi
    # echo "- - -" > /sys/class/scsi_host/host2/scan
```

2) Forma de Rescan
```
    for i in $(ls /sys/class/scsi_host/); do 
      echo "- - -" > /sys/class/scsi_host/${i}/scan; 
    done
```

3) Forma de Rescan
```
    # ls /sys/class/scsi_device/
    # echo 1 > /sys/class/scsi_device/0\:0\:0\:0/device/rescan
```


### Volume Group ###
É uma abstração do LVM que congrega volumes lógicos e volumes físicos em uma mesma unidade administrativa;

#### Criando Volume Group ####
> vgcreate VG01 /dev/sdb1

#### Adicionando Discos ao Volume Group #### 
> vgextend VG01 /dev/sdc1

#### Removendo disco do Volume Group ####
Verificando utilização dos discos antes de mover os dados entre os discos do VG
> pvs -o+pv_used

Caso tenha espaço disponível para movimentar o espaço em uso do disco que será removido, basta mover o conteúdo do disco a ser removido entre os demais discos:
> pvmove /dev/sdb1

Após mover o conteúdo do disco para os demais discos do VG, basta retirar o disco do VG:
> vgreduce VG01 /dev/sdb1

### Volume Lógico ###
É o equivalente a uma partição em um sistema não-LVM.

#### Criando Volume Lógico ####
> lvcreate --name LV01 --size 50m VG01

#### Formatando LVM ####
> mkfs -t xfs /dev/VG01/LV01

#### Extendendo Volume Lógico #### 
```
    lvextend -r -L +10GB /dev/VG01/LV01
    lvextend -R -l +100%FREE /dev/VG01/LV01
    xfs_growfs /dev/mapper/VG01-LV01
```

## LVM distribuido (Striped) ##
Fonte: https://web.mit.edu/rhel-doc/5/RHEL-5-manual/Cluster_Logical_Volume_Manager/striped_volumes.html

### Convertendo LVM de Linear (default) para Striped ###
```
    [root@localhost ~] vgcreate vg1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
    [root@localhost ~] lvcreate -n lv1 -l 200 vg1 /dev/sdb:0-199
    [root@localhost ~] lvconvert -y --type raid1 --mirrors 1 vg1/lv1
    [root@localhost ~] lvconvert -y --type raid5_n vg1/lv1
    [root@localhost ~] lvconvert -y --stripes 2 vg1/lv1
    [root@localhost ~] lvconvert -y --type striped vg1/lv1
    [root@localhost ~] lvs -o +devices
```