# Envia mensajes entre dispositivos a traves de la red
Es un programa el cual servirá para enviar mensajes entre dispositivos
En este programa utilizaremos los comandos neths, sc, PING y MSG para las opciones

### Cosas que hacer
- Desactivar el firewall de este equipo (netsh advfirewall set allprofiles state off).
- Activar el servicio mensajero de este equipo (sc config MessagingService start=demand).
- El usuario debera introducir el numero de IP del equipo con el que se desea comunicarse.
- La red se obtendra automaticamente a partir de la IP local.
- Los mensajes a la IP se enviaran con el comando MSG.
- Cuando el usuario quiera salir del programa el servicio mensajero se desactivara y el firewall se volvera a activar.
