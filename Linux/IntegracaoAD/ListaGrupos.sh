#!/bin/bash

# Listando todos os grupos de um determinado usuário em estações linux integradas com AD
id | sed 's/.*grupos=//g ; s/,/\n/g ; s/(/\ -\ /g ; s/)//g' | sort -k 2

# Saída do comando é algo parecido com a listagem abaixo:
    tr301005@nuope08-trf1 ~$ id|sed 's/.*grupos=//g ; s/,/\n/g ; s/(/\ -\ /g ; s/)//g' | sort -k 2
    84661922 - all_securitygroups
    84661580 - ditec-servidores
    84646758 - ditec-sesof-seção de software corporativo
    84600513 - domain users
    84669431 - grp_acesso_apl1_trf1
    84612253 - grp_acesso_apl1x_trf1
    84673170 - grp_acesso_apl_ti1_trf1
    84672773 - grp_deploy_admin_nuope
    84680055 - grp_dipla_geral
    84680560 - grp_dipla_trf1_ajpc
    84680599 - grp_dipla_trf1_geral
    84680607 - grp_dipla_trf1_pap
    84680608 - grp_dipla_trf1_terceirizados
    84680966 - grp_email_sesof
    84681470 - grp_email_sesol
    84680493 - grp_git_lab_admins
    84679063 - grp_grafana_admins
    84668918 - grp_internet_7_ti_trf1
    84678219 - grp_linux_admins
    84681899 - grp_linux_kibpje
    84674388 - grp_midia_w_publico
    84681158 - grp_nexus_admins
    84671270 - grp_oraserv_geral - write
    84677556 - grp_pss2g_read
    84672896 - grp_rmidia_geral
    84672892 - grp_rmidia_infra
    84672889 - grp_rmidia_map
    84675786 - grp_rmidia_sj
    84681309 - grp_rundeck_admins
    84674222 - grp_secin_certificados
    84680864 - grp_secin_coint_compartilhada_read
    84680865 - grp_secin_coint_compartilhada_write
    84680437 - grp_secin_coint_diope_compartilhada_write
    84680863 - grp_secin_coint_diope_geral
    84680440 - grp_secin_coint_diope_sesol_write
    84680862 - grp_secin_coint_ditec_geral
    84680395 - grp_secin_coint_ditec_seeco_read
    84680867 - grp_secin_coint_gabinete_read
    84680847 - grp_secin_coint_geral
    84669391 - grp_secin_comite_ti
    84677614 - _grp_secin_geral
    84680488 - grp_secin_geral
    84682193 - grp_secin_nugti_publico_read
    84675050 - grp_secin_nuope
    84680856 - grp_secin_publico_read
    84644595 - grp_secin - write
    84678545 - grp_virtualizacao_so_trf1
    84678278 - grp_wiki_admins
    84611311 - internetfull
    84655384 - introscope-admin
    84654248 - rsa-blade
    84654247 - rsa-sec
    84601400 - secin
    84608785 - secin - lista
    84664194 - trf1 - all_users - bo
    84611111 - trf1 - servidores
    987 - vboxusers