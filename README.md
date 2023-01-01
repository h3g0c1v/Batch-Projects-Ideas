---- Author: h3g0c1v ----
# Ideas de Proyectos en BATCH
Este repositorio contiene una serie de ideas practicar programación en BATCH (.bat) con sus resoluciones realizadas.

## Ejercicio 1:
Es un programa el cual servirá para gestionar los usuarios y los grupos locales del equipo.
En este programa utilizaremos los comandos net user y net localgroup para las opciones.


### Cosas que hacer: 
- El nombre del script debe de ser algo parecido a gestion_usuarios_grupos_windows.bat
- Debes avisarle al usuario que debe correr el programa como administrador
- Una opción para la gestión de usuarios
- Una opción para la gestión de grupos
- Una opción para salir del programa

### Dentro de las opciones de gestión de usuarios:
- Visualizar todos los usuarios
- Visualizar informacion de un usuario
- Crear un usuario
- Borrar un usuario
- Borrar usuarios a partir de un fichero
- Activar/Desactivar un usuario
- Configurar cuando expira una password de un usuario
- Indicar si un usuario puede cambiar su password o no
- Asignar una password random a un usuario
- Establecer los dias que un usuario puede iniciar sesion
- Agregar un comentario a un usuario
- Filtrar por alguna cadena en la informacion de un usuario
- Volver al menu principal
- Salir del programa

### Dentro de las opciones de gestión de grupos:
- Visualizar todos los grupos locales
- Visualizar informacion de un grupo local
- Crear un grupo local
- Crear grupos locales a partir de un fichero
- Borrar un grupo local
- Borrar grupos locales a partir de un fichero
- Agregar un usuario a un grupo local
- Eliminar un usuario a un grupo local
- Agregar un comentario a un grupo local
- Filtrar por alguna cadena en la informacion de un grupo local
- Volver al menu principal
- Salir del programa

## Ejercicio 2:
Es un programa el cual servirá para ver la conectividad de los equipos.
En este programa utilizaremos el comando PING para las opciones.

### Cosas que hacer: 
- El nombre del script debe de ser algo parecido a ip_check.bat
- Una opción para ver la configuracion de red del equipo (ipconfig /all)
- Una opción para comprobar la red
- Una opción para salir del programa

### Dentro de las opciones de comprobar la red:
- Comprobar la conectividad con una IP (PING)
- Comprobar un PC del aula,la IP de la red se sacará automaticamente y el usuario introducirá el número de la IP
  - La IP de la red se sacará automaticamente
  - El usuario introducirá el número de la IP a comprobar
- Comprobar todo el aula
  - La IP de la red se sacará automaticamente
  - El usuario introducirá el número de la primera y la ultima IP a escanear
- Una opcion para volver al menu principal

## Ejercicio 3:
Es un programa el cual servirá para filtrar información de la red.
En este programa utilizaremos los comandos ipconfig /all y getmac para las opciones.

### Cosas que hacer: 
- Mostrar interfaces de red
- Mostrar tarjetas de red
- Mostrar nombre de este equipo
- Mostrar IPv4 o IPv6
- Mostrar direcciones MAC
- Mostrar servidores DHCP
- Salir del programa

## Ejercicio 4:
Es un programa el cual servirá para gestionar el firewall entre otras.
En este programa utilizaremos el comando netsh para las opciones.

### Cosas que hacer: 
- Una opción para comandos de netsh
- Otra opción para visualizar cuales son los comandos que se ejecutan en las opciones de comandos netsh

### Dentro de las opciones de comandos netsh
- Visualizar todas las reglas del firewall de Windows
- Visualizar todas las reglas del firewall del perfil actual
- Comprobar el estado de las interfaces de red
- Comprobar todas las conexiones inalambricaas disponibles
- Comprobar la fuerza de todas las conexiones inalambricas
- Desconectar dispositivo inalambrico
- Conectarse a un dispositivo inalambrico
- Mostrar todas las interfaces inalambricas
- Mostrar los controladores de interfaces inalambricas
- Comprobar la configuracion de proxy actual
- Comprobar el estado de los parametros globales TCP/UDP
- Abrir/Bloquear un puerto de entrada/salida
- Agregar DNS
- Permitir/Bloquear solicitudes eco ICMP (Habilitar solicitudes ping)
- Habilitar/Deshabilitar Firewall en todos los perfiles
- Restablecer la configuracion predeterminada del Firewall
- Empezar/Terminar captura de paquetes
- Visualizar panel de ayuda de netsh
- Salir

### Dentrode las opciones de visualizar cuales son los comandos que se ejecutan en las opciones de comandos netsh
- Visualizar todas las reglas del firewall de Windows
- Visualizar todas las reglas del firewall del perfil actual
- Comprobar el estado de las interfaces de red
- Comprobar todas las conexiones inalambricaas disponibles
- Comprobar la fuerza de todas las conexiones inalambricas
- Desconectar dispositivo inalambrico
- Conectarse a un dispositivo inalambrico
- Mostrar todas las interfaces inalambricas
- Mostrar los controladores de interfaces inalambricas
- Comprobar la configuracion de proxy actual
- Comprobar el estado de los parametros globales TCP/UDP
- Abrir/Bloquear un puerto de entrada/salida
- Agregar DNS
- Permitir/Bloquear solicitudes eco ICMP (Habilitar solicitudes ping)
- Habilitar/Deshabilitar Firewall en todos los perfiles
- Restablecer la configuracion predeterminada del Firewall
- Empezar/Terminar captura de paquetes
- Visualizar panel de ayuda de netsh
- Salir

## Ejercicio 5:
Es un programa el cual servirá para enviar mensajes entre dispositivos.
En este programa utilizaremos los comandos neths, sc, PING y MSG para las opciones.

### Cosas que hacer
- Desactivar el firewall de este equipo (netsh advfirewall set allprofiles state off).
- Activar el servicio mensajero de este equipo (sc config MessagingService start=demand).
- El usuario debera introducir el numero de IP del equipo con el que se desea comunicarse.
- La red se obtendra automaticamente a partir de la IP local.
- Los mensajes a la IP se enviaran con el comando MSG.
- Cuando el usuario quiera salir del programa el servicio mensajero se desactivara y el firewall se volvera a activar.

## Ejercicio 6:
Es un programa el cual servirá para obtener la contraseña de las conexiones inalambricas a las que te has conectado con anterioridad.
En este programa utilizaremos los comandos netsh para las opciones.

### Cosas que hacer
- El usuario deberá introducir el nombre de alguna de las redes disponibles que tenga
- Le mostrarás la contraseña del dispositivo inalámbrico
- Le preguntaras que si quiere visualizar otra contraseña de otro dispositivo inalámbrico.
  - Si introduce que si quiere, volverá a la pregunta para introducir el nombre de la red
  - Si introduce que no quiere, terminará el programa
