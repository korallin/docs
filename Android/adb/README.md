Listando dispositivos

D:\Zenfone\adb\platform-tools>adb devices
List of devices attached
H2AZB6039775XS4 device

Conectando em um Dispositivo
D:\Zenfone\adb\platform-tools>adb shell
ASUS_Z012D:/ $

Listando packages
ASUS_Z012D:/ $ pm list packages | grep br.com
package:br.com.estrategiaaudio
package:br.com.cetelem.mobilebank
package:br.com.intermedium
package:br.com.nrtech.expertelectronics.expert
package:br.com.oktoplus
package:br.com.bb.android
package:br.com.estrategiaeducacional.concursos
package:br.com.bb.oewallet
package:br.com.iq
package:br.com.brainweb.ifood
package:br.com.pilovieira.tk303g
package:br.com.edeploy.gol.checkin.activities
package:br.com.santander.way
package:br.com.mesotec.detrandf

Removendo package
pm uninstall -k -user 0 br.com.intermedium

Fonte: https://olhardigital.com.br/2018/08/10/dicas-e-tutoriais/como-remover-os-apps-de-fabrica-do-seu-android-sem-root/