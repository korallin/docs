# Logical Volume Manager - LVM
O LVM é útil para gerir os discos de forma inteligente através de volumes. Conheça essa tecnologia usada em muitas distribuições
O LVM é um gerenciador de discos do Kernel do Linux. Ele permite que discos sejam trocados sem interrupção do serviço (hotswap), alterar o tamanho dos volumes, criar backup de imagens dos volumes, criar um volume único a partir de vários discos (similar ao RAID 0) ou criar volumes espelhados em mais de um disco (similar ao RAID 1).
O LVM possibilita ampliar o sistema de arquivos que tradicionalmente é visto como um conjunto de discos físicos e partições. Seu objetivo é permitir uma flexibilidade grande para o administrador no gerenciamento dos discos.

## Volumes Físicos
É um disco ou algum hardware que se comporte como um disco (como um storage que use RAID);

### Listando informações dos Volumes Físicos
> pvs -a

### Criando Volume Físico
> pvcreate /dev/sdb1

### Rescan de discos
#### Discos que foram expandidos
> echo 1 > /sys/block/<SDXX>/device/rescan

#### Rescan de novos Discos
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


### Volume Group
É uma abstração do LVM que congrega volumes lógicos e volumes físicos em uma mesma unidade administrativa;

#### Criando Volume Group
> vgcreate VG01 /dev/sdb1

#### Adicionando Discos ao Volume Group
> vgextend VG01 /dev/sdc1

#### Verificando discos que compõe um determinado VG
```shell
[root@m4tr1x ~]# lvs --segments -o+devices
  LV   VG     Attr       #Str Type   SSize    Devices
  LV01 VG01   -wi-a-----    1 linear 1020.00m /dev/sdc(0)
  LV01 VG01   -wi-a-----    1 linear 1020.00m /dev/sdd(0)
  root centos -wi-ao----    1 linear   <6.20g /dev/sda2(205)
  swap centos -wi-ao----    1 linear  820.00m /dev/sda2(0)

[root@m4tr1x ~]# lvs VG01 --segments -o+devices
  LV   VG   Attr       #Str Type   SSize    Devices
  LV01 VG01 -wi-a-----    1 linear 1020.00m /dev/sdc(0)
  LV01 VG01 -wi-a-----    1 linear 1020.00m /dev/sdd(0)
```

#### Removendo disco do Volume Group
Verificando utilização dos discos antes de mover os dados entre os discos do VG
```shell
[root@m4tr1x ~]# pvs -o+pv_used
  PV         VG     Fmt  Attr PSize    PFree    Used
  /dev/sda2  centos lvm2 a--    <7.00g       0    <7.00g
  /dev/sdb   VG01   lvm2 a--  1020.00m       0  1020.00m
  /dev/sdc   VG01   lvm2 a--  1020.00m 1016.00m    4.00m
  /dev/sdd   VG01   lvm2 a--  1020.00m 1020.00m       0
```

Caso tenha espaço disponível para movimentar o espaço em uso do disco que será removido, basta mover o conteúdo do disco a ser removido entre os demais discos:
```shell
[root@m4tr1x ~]# pvmove /dev/sdb
  /dev/sdb: Moved: 0.78%
  /dev/sdb: Moved: 100.00%

[root@m4tr1x ~]# pvs -o+pv_used
  PV         VG     Fmt  Attr PSize    PFree    Used
  /dev/sda2  centos lvm2 a--    <7.00g       0    <7.00g
  /dev/sdb   VG01   lvm2 a--  1020.00m 1020.00m       0
  /dev/sdc   VG01   lvm2 a--  1020.00m 1016.00m    4.00m
  /dev/sdd   VG01   lvm2 a--  1020.00m       0  1020.00m
```

Após mover o conteúdo do disco para os demais discos do VG, basta retirar o disco do VG:
```shell
[root@m4tr1x ~]# vgs -o+devices
  VG     #PV #LV #SN Attr   VSize  VFree    Devices
  VG01     2   1   0 wz--n-  1.99g 1016.00m /dev/sdb(0)
  VG01     2   1   0 wz--n-  1.99g 1016.00m /dev/sdd(0)
  VG01     2   1   0 wz--n-  1.99g 1016.00m /dev/sdc(0)
  centos   1   2   0 wz--n- <7.00g       0  /dev/sda2(0)
  centos   1   2   0 wz--n- <7.00g       0  /dev/sda2(205)

[root@m4tr1x ~]# vgreduce VG01 /dev/sdb
  Removed "/dev/sdb" from volume group "VG01"

[root@m4tr1x ~]# vgs -o+devices
  VG     #PV #LV #SN Attr   VSize  VFree    Devices
  VG01     2   1   0 wz--n-  1.99g 1016.00m /dev/sdd(0)
  VG01     2   1   0 wz--n-  1.99g 1016.00m /dev/sdc(0)
  centos   1   2   0 wz--n- <7.00g       0  /dev/sda2(0)
  centos   1   2   0 wz--n- <7.00g       0  /dev/sda2(205)

```

### Volume Lógico
É o equivalente a uma partição em um sistema não-LVM.

#### Criando Volume Lógico
> lvcreate --name LV01 --size 50m VG01
ou
> lvcreate --name LV01 -l+100%FREE VG01

#### Formatando LVM
> mkfs -t xfs /dev/VG01/LV01

#### Extendendo Volume Lógico
```shell
    lvextend -r -L +10GB /dev/VG01/LV01
    lvextend -R -l +100%FREE /dev/VG01/LV01
    xfs_growfs /dev/mapper/VG01-LV01
```

#### Reduzindo Volume Lógico
  Step 0. Lab Preparation:
  – Create a primary lvm partition using fdisk with 2 Gib size:
  ```shell
  # fdisk /dev/sdb
  # partprobe
  ```

  – Create a physical volume:
  ```shell
  # pvcreate /dev/sdb1 # create a physical volume
  ```

  – Create a volume group with an extent size of 16M:
  ```shell
  # vgcreate -s 16M vg00 /dev/sdb1 
  ```
  – Create logical volume with size of 800M (50 extents)
  ```shell
  # lvcreate -L 800M -n lv00 vg00 
  ```
  – Convert the logical volume to xfs file system
  ```shell
  # mkfs.xfs /dev/vg00/lv00
  ```
  – Mount the partition to a directory
  ```shell
  # mkdir /test 
  # mount /dev/vg00/pv00 /test
  ```
  – Create some file in the directory
  ```shell
  # dd if=/dev/zero of=/test/file01 bs=1024k count=10
  # dd if=/dev/zero of=/test/file02 bs=1024k count=10
  # dd if=/dev/zero of=/test/file03 bs=1024k count=10
  ```
  
  – Install the xfsdump package
  ```shell
  # yum install xfsdump -y
  ```
  
  Step 1. Backup The Data
  ```shell
  # xfsdump -f /tmp/test.dump /test
  ```
  
  Step 2. Unmount The Partition
  ```shell
  # umount /test
  ```

  Step 3. Reduce The Partition Size
  ```shell
  # lvreduce -L 400M /dev/vg00/lv00
  ```

  Step 4. Format The Partition With XFS Filesystem
  ```shell
  # mkfs.xfs -f /dev/vg00/lv00
  ```

  Step 5. Remount the Parition
  ```shell
  # mount /dev/vg00/lv00 /test
  ```
  
  Step 6. Restore The Data
  ```shell
  # xfsrestore -f /tmp/test.dump /test
  ```

  – check the content of partition
  ```shell
  # ls -l /test
  ```

## LVM distribuido (Striped)
### Criando VG com 3 discos
Preferencialmente utilizar discos de tamanhos iguais;
```shell
[root@m4tr1x ~]# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0    8G  0 disk
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0    7G  0 part
  ├─centos-root 253:0    0  6.2G  0 lvm  /
  └─centos-swap 253:1    0  820M  0 lvm  [SWAP]
sdb               8:16   0    1G  0 disk
└─sdb1            8:17   0 1023M  0 part
sdc               8:32   0    1G  0 disk
└─sdc1            8:33   0 1023M  0 part
sdd               8:48   0    1G  0 disk
└─sdd1            8:49   0 1023M  0 part
sr0              11:0    1 1024M  0 rom

[root@m4tr1x ~]# pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1
  Physical volume "/dev/sdb1" successfully created.
  Physical volume "/dev/sdc1" successfully created.
  Physical volume "/dev/sdd1" successfully created.

[root@m4tr1x ~]# vgcreate VG01 /dev/sdb1 /dev/sdc1 /dev/sdd1
  Volume group "VG01" successfully created
```

### Criando LV com blocos de 128kb
```shell
[root@m4tr1x ~]# lvcreate -L300M -i3 -I 128k -n lv_stripe VG01
  Logical volume "lv_stripe" created.

[root@m4tr1x ~]# lvs --segments -o+stripe_size,devices
  LV        VG     Attr       #Str Type    SSize   Stripe  Devices
  lv_stripe VG01   -wi-a-----    3 striped 300.00m 128.00k /dev/sdb1(0),/dev/sdc1(0),/dev/sdd1(0)
  root      centos -wi-ao----    1 linear   <6.20g      0  /dev/sda2(205)
  swap      centos -wi-ao----    1 linear  820.00m      0  /dev/sda2(0)
```

- Legenda:
  - -L: Tamanho em GIGA/MEGA
  - -i: Quantidade de discos
  - -I: Tamanho da coluna
  - -n: Nome do LVOL

Se por acaso for criado um LV com tamanho diferente dos multiplos da quantidade de discos, o LVM faz um ajuste para que o tamanho fique distribuidos de forma euilibrada em todos os discos que compõe o VG. Como por exemplo abaixo:
```shell
[root@m4tr1x ~]# lvcreate -L50M -i3 -I 128k -n lv_stripe1 VG01
  Rounding up size to full physical extent 52.00 MiB
  Rounding size 52.00 MiB (13 extents) up to stripe boundary size 60.00 MiB(15 extents).
  Logical volume "lv_stripe1" created.
```

### Extendendo LV Striped
- Adicionar sempre discos de mesmo tamanho
- Adicionar sempre a mesma qtde de discos queo VG foi criado

```shell
[root@m4tr1x ~]# lvextend -L+300M /dev/VG01/lv_stripe
  Using stripesize of last segment 128.00 KiB
  Size of logical volume VG01/lv_stripe changed from 300.00 MiB (75 extents) to 600.00 MiB (150 extents).
  Logical volume VG01/lv_stripe successfully resized.

[root@m4tr1x ~]# lvs --segments -o+stripe_size,devices
  LV        VG     Attr       #Str Type    SSize   Stripe  Devices
  lv_stripe VG01   -wi-a-----    3 striped 600.00m 128.00k /dev/sdb1(0),/dev/sdc1(0),/dev/sdd1(0)
  root      centos -wi-ao----    1 linear   <6.20g      0  /dev/sda2(205)
  swap      centos -wi-ao----    1 linear  820.00m      0  /dev/sda2(0)
```

Fonte: https://web.mit.edu/rhel-doc/5/RHEL-5-manual/Cluster_Logical_Volume_Manager/striped_volumes.html

### Convertendo LVM de Linear (default) para Striped
**Procedimento ainda não foi testado!**
```shell
    [root@localhost ~] vgcreate vg1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
    [root@localhost ~] lvcreate -n lv1 -l 200 vg1 /dev/sdb:0-199
    [root@localhost ~] lvconvert -y --type raid1 --mirrors 1 vg1/lv1
    [root@localhost ~] lvconvert -y --type raid5_n vg1/lv1
    [root@localhost ~] lvconvert -y --stripes 2 vg1/lv1
    [root@localhost ~] lvconvert -y --type striped vg1/lv1
    [root@localhost ~] lvs -o +devices
```