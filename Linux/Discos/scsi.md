# Identificando dispositvo SCSI dos discos virtuais VMDK

[root@srvbdrep-trf1 ~]# ls -d /sys/block/sd*/device/scsi_device/*
/sys/block/sda/device/scsi_device/0:0:0:0  /sys/block/sdb/device/scsi_device/0:0:1:0  /sys/block/sdc/device/scsi_device/0:0:2:0  /sys/block/sdd/device/scsi_device/0:0:3:0

[root@srvbdrep-trf1 ~]# ls -d /sys/block/sd*/device/scsi_device/* |awk -F '[/]' '{print $4,"- SCSI",$7}'
sda - SCSI 0:0:0:0
sdb - SCSI 0:0:1:0
sdc - SCSI 0:0:2:0
sdd - SCSI 0:0:3:0

A saída deve ser interpretada da seguinte ordem a:b:c:d:
    a = Hostadapter ID.
    b = SCSI channel = número da controller SCSI.
    c = Device ID = número do device SCSI.
    d = LUN.