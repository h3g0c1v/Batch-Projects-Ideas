@echo off
REM Programa para aprender netsh en MSDOS
cls

:info_administrator
echo.
echo.
echo ******************************************************************
echo [*] Asegurate de estar corriendo el programa como Administrador
echo ******************************************************************
echo.
pause

:helpPanel
cls
echo.
echo
echo ***************************************************
echo              OPCIONES DISPONIBLES
echo ***************************************************
echo        [1] Opciones de los comandos netsh
echo        [2] Visualizar los comandos reales
echo.

set /p options_helpPanel=Introduce una opcion: 

if %options_helpPanel% == 1 (
    goto netsh_commands
) else if %options_helpPanel% == 2 (
    goto show_commands
) else (
    echo.
    echo [!] ERROR: Se esparaba una opcion del 1-2
    echo.
    pause
    goto helpPanel
)

:show_commands
cls
echo.
echo ************************************************************************
echo                        NETSH COMMANDS MSDOS
echo ************************************************************************
echo    [1] Visualizar todas las reglas del firewall de Windows
echo    [2] Visualizar todas las reglas del firewall del perfil actual
echo    [3] Comprobar el estado de las interfaces de red
echo    [4] Verificar todos los perfiles inalambricos
echo    [5] Comprobar todas las conexiones inalambricaas disponibles
echo    [6] Comprobar la fuerza de todas las conexiones inalambricas
echo    [7] Desconectar dispositivo inalambrico
echo    [8] Conectarse a un dispositivo inalambrico
echo    [9] Mostrar todas las interfaces inalambricas
echo    [10] Mostrar los controladores de interfaces inalambricas
echo    [11] Comprobar la configuracion de proxy actual
echo    [12] Comprobar el estado de los parametros globales TCP/UDP
echo    [13] Abrir/Bloquear un puerto de entrada/salida
echo    [14] Agregar DNS
echo    [15] Permitir/Bloquear solicitudes eco ICMP (Habilitar solicitudes ping)
echo    [16] Habilitar/Deshabilitar Firewall en todos los perfiles
echo    [17] Restablecer la configuracion predeterminada del Firewall
echo    [18] Empezar/Terminar captura de paquetes
echo    [19] Visualizar panel de ayuda de netsh
echo    [20] Salir
echo.

set /p option_show_commands=Introduce una opcion: 

if %option_show_commands% == 1 (
    goto command_show_all_rules
) else if %option_show_commands% == 2 (
    goto command_show_all_profile_rules
) else if %option_show_commands% == 3 (
    goto command_state_net_interfaces
) else if %option_show_commands% == 4 (
    goto command_wireless_profiles
) else if %option_show_commands% == 5 (
    goto command_wireless_conetions
) else if %option_show_commands% == 6 (
    goto command_wireless_strength
) else if %option_show_commands% == 7 (
    goto command_device_disconect
) else if %option_show_commands% == 8 (
    goto command_wifi_conect
) else if %option_show_commands% == 9 (
    goto command_show_wireless_interfaces
) else if %option_show_commands% == 10 (
    goto command_show_wireless_controlers
) else if %option_show_commands% == 11 (
    goto command_proxy_settings
) else if %option_show_commands% == 12 (
    goto command_params_state_tcp_or_udp
) else if %option_show_commands% == 13 (
    goto command_open_or_close_port
) else if %option_show_commands% == 14 (
    goto command_dns_add
) else if %option_show_commands% == 15 (
    goto command_allow_disallow_icmp_eco
) else if %option_show_commands% == 16 (
    goto command_allow_disallow_firewall
) else if %option_show_commands% == 17 (
    goto command_reset_settings_firewall
) else if %option_show_commands% == 18 (
    goto command_capture_packets
) else if %option_show_commands% == 19 (
    goto command_show_help_netsh
) else if %option_show_commands% == 20 (
    goto salir   
) else (
    echo.
    echo [!] ERROR: Se esperaba un numero del 1-20
    echo.
    pause
    goto helpPanel
)

REM ----------------------------------------------------------------
REM OPCIONES PARA VISUALIZAR LOS COMANDOS REALES QUE SE EJECUTARAN
:command_show_all_rules
echo.
echo netsh advfirewall firewall show rule name=all

goto quehacer

:command_show_all_profile_rules
echo.
echo netsh advfirewall show currentprofile

goto quehacer

:command_state_net_interfaces
echo.
echo netsh interface show nterface

goto quehacer

:command_wireless_profiles
echo.
echo netsh wlan show profile

goto quehacer

:command_wireless_conetions
echo.
echo netsh wlan show networks

goto quehacer

:command_wireless_strength
echo.
echo netsh wlan show networks mode=bssid

goto que hacer

:command_device_disconect
echo.
echo netsh "nombre_de_la_interfaz" disconnect

goto quehacer

:command_wifi_conect
echo.
echo netsh wlan connect name="nombre_del_dispositivo_inalambrico"

goto quehacer

:command_show_wireless_interfaces
echo.
echo netsh wlan show interfaces

goto quehacer

:command_show_wireless_controlers
echo.
echo netsh wlan show drivers

goto quehacer

:command_proxy_settings
echo.
echo netsh winhttp show proxy

goto quehacer

:command_params_state_tcp_or_udp
echo.
echo [+] TCP
echo netsh interface tcp show global

echo.
echo [+] UDP
echo netsh interface udp show global

goto quehacer

:command_open_or_close_port
echo.
echo [+] Abrir un puerto TCP de entrada
netsh advfirewall firewall add rule name="Nombre de la regla a agregar" protocol=TCP dir=in localport="Numero de puerto a abrir" action=allow

echo.
echo [+] Abrir un puerto TCP de salida
netsh advfirewall firewall add rule name="Nombre de la regla a agregar" protocol=TCP dir=out localport="Numero de puerto a abrir" action=allow

echo.
echo [+] Cerrar un puerto TCP de entrada
netsh advfirewall firewall add rule name="Nombre de la regla a agregar" protocol=TCP dir=in localport="Numero de puerto a abrir" action=block

echo.
echo [+] Cerrar un puerto TCP de salida
netsh advfirewall firewall add rule name="Nombre de la regla a agregar" protocol=TCP dir=out localport="Numero de puerto a abrir" action=block

goto quehacer

:command_dns_add
echo.
echo netsh interface ip add dns name="Nombre del DNS" addr=IP_del_DNS

goto quehacer

:command_allow_disallow_icmp_eco
echo.
echo [+] Habilitar eco ICMP request de entrada
netsh advfirewall firewall add rule name="Nombre de la regla a agregar" dir=in action=allow protocol=icmpv4

echo.
echo [+] Habilitar eco ICMP request de salida
netsh advfirewall firewall add rule name="Nombre de la regla a agregar" dir=out action=allow protocol=icmpv4

echo.
echo [+] Bloquear eco ICMP request de entrada
netsh advfirewall firewall add rule name="Nombre de la regla a agregar" dir=in action=block protocol=icmpv4

echo.
echo [+] Bloquear eco ICMP request de salida
netsh advfirewall firewall add rule name="Nombre de la regla a agregar" dir=out action=block protocol=icmpv4
goto quehacer

:command_allow_disallow_firewall
echo.
echo [+] Habilitar el firewall
echo netsh advfirewall set allprofiles state on

echo.
echo [+] Deshabilitar el firewall
echo netsh advfirewall set allprofiles state off

goto quehacer

:command_reset_settings_firewall
echo.
echo netsh advfirewall reset

goto quehacer

:command_capture_packets
echo.
echo [+] Empezar captura de paquetes
echo netsh trace start capture=yes tracefile=Ruta_del_fichero.etl persistent=yes maxsize=Tamaño_maximo

echo.
echo [+] Terminar captura de paquetes
echo netsh trace stop

goto quehacer

:command_show_help_netsh
echo.
echo netsh /?

goto quehacer

REM FINALIZA LAS OPCIONES PARA VISUALIZAR LOS COMANDOS REALES QUE SE EJECUTARAN
REM ----------------------------------------------------------------

:netsh_commands
cls
echo.
echo ************************************************************************
echo                        NETSH COMMANDS MSDOS
echo ************************************************************************
echo    [1] Visualizar todas las reglas del firewall de Windows
echo    [2] Visualizar todas las reglas del firewall del perfil actual
echo    [3] Comprobar el estado de las interfaces de red
echo    [4] Verificar todos los perfiles inalambricos
echo    [5] Comprobar todas las conexiones inalambricaas disponibles
echo    [6] Comprobar la fuerza de todas las conexiones inalambricas
echo    [7] Desconectar dispositivo inalambrico
echo    [8] Conectarse a un dispositivo inalambrico
echo    [9] Mostrar todas las interfaces inalambricas
echo    [10] Mostrar los controladores de interfaces inalambricas
echo    [11] Comprobar la configuracion de proxy actual
echo    [12] Comprobar el estado de los parametros globales TCP/UDP
echo    [13] Abrir/Bloquear un puerto de entrada/salida
echo    [14] Agregar DNS
echo    [15] Permitir/Bloquear solicitudes eco ICMP (Habilitar solicitudes ping)
echo    [16] Habilitar/Deshabilitar Firewall en todos los perfiles
echo    [17] Restablecer la configuracion predeterminada del Firewall
echo    [18] Empezar/Terminar captura de paquetes
echo    [19] Visualizar panel de ayuda de netsh
echo    [20] Salir
echo.

:options
set /p option=Introduce una opcion disponible: 

if %option% == 1 (
    goto show_all_rules
) else if %option% == 2 (
    goto show_all_profile_rules
) else if %option% == 3 (
    goto state_net_interfaces
) else if %option% == 4 (
    goto wireless_profiles
) else if %option% == 5 (
    goto wireless_conetions
) else if %option% == 6 (
    goto wireless_strength
) else if %option% == 7 (
    goto device_disconect
) else if %option% == 8 (
    goto wifi_conect
) else if %option% == 9 (
    goto show_wireless_interfaces
) else if %option% == 10 (
    goto show_wireless_controlers
) else if %option% == 11 (
    goto proxy_settings
) else if %option% == 12 (
    goto params_state_tcp_or_udp
) else if %option% == 13 (
    goto open_or_close_port
) else if %option% == 14 (
    goto dns_add
) else if %option% == 15 (
    goto allow_disallow_icmp_eco
) else if %option% == 16 (
    goto allow_disallow_firewall
) else if %option% == 17 (
    goto reset_settings_firewall
) else if %option% == 18 (
    goto capture_packets
) else if %option% == 19 (
    goto show_help_netsh
) else if %option% == 20 (
    goto salir   
) else (
    echo.
    echo [!] ERROR: Se esperaba un numero del 1-20
    echo.
    pause
    goto helpPanel
)

:show_all_rules
REM Opcion para visualizar todas las reglas del firewall de Windows
echo.
set /p rule_name=Introduce el nombre de la regla a visualizar (all para visualizar todas): 
echo.

netsh advfirewall firewall show rule name=%rule_name%
pause

goto quehacer


:show_all_profile_rules
REM Opcion para visualizar las reglas del firewall del perfil actual
netsh advfirewall show currentprofile
pause

goto quehacer

:state_net_interfaces
REM Opcion para visuzliar el estado de las interfaces de red
echo.
set /p interface_name=Introduce el nombre de la interfaz a ver su estado (all para visualizar todas): 
echo.

if %interface_name% == all (
    netsh interface show nterface
) else (
    netsh interface show interface name=%interface_name%
)

goto quehacer

:wireless_profiles
REM Opcion para visualizar todos los profiles inalambricos
echo.
set /p wireless_profile=Introduce el nombre del perfil a visualizar (all para visualizar todos): 
echo.

if %wireless_profile% == all (
    netsh wlan show profile
) else (
    netsh wlan show profile name=%wireless_profile% 
)

goto quehacer

:wireless_conetions
REM Opcion para visuzaliar todas las conexiones inalambricas disponibles
netsh wlan show networks

goto quehacer

:wireless_strength
REM Opcion para visualizar la fuerza de las conexiones inalambricas disponibles
netsh wlan show networks mode=bssid

goto quehacer

:device_disconect
REM Opcion para desconectarse de un dispositivo inalambrico actualmente conectado
echo.
set /p interface_name=Introduce el nombre de la interfaz que deseas Desconectar
echo.

netsh %interface_name% disconnect

goto quehacer

:wifi_conect
REM Opcion para conectarse a un dispositivo inalambrico
echo.
set /p wireless_device_name=Introduce el nombre del dispositivo inalambrico a conectarse: 
echo.

netsh wlan connect name="%wireless_device_name%"

goto quehacer

:show_wireless_interfaces
REM Opcion para visualizar todas las interfaces inalambricas
netsh wlan show interfaces

:show_wireless_controlers
REM Opcion para visualizar los controladores de interfaces inalambricas
netsh wlan show drivers

:proxy_settings
REM Opcion para visualizar la configuracion actual del proxy
netsh winhttp show proxy

:params_state_tcp_or_udp
REM Opcion para comprobar el estaado de los parametros globales TCP y/o UDP
echo.
set /p option_state=De que protocolo desas comprobar sus parametros [T = TCP / U = UDP / A = Ambos]
echo.

if %option_state% == T (
    goto params_state_tcp
) else if %option_state% == t (
    goto params_state_tcp
) else if %option_state% == U (
    goto params_state_udp
) else if %option_state% == u (
    goto params_state_udp
) else if %option_state% == A (
    goto state_tcp_and_udp
) else if %option_state% == a (
    goto state_tcp_and_udp
) else (
    echo.
    echo ERROR: Se esperaba T, U o A
    echo.
    pause
    goto quehacer
)

REM OPCIONES DE VISUALIZAR LOS PARAMETROS DE LOS PROTOCOLOS TCP Y/O UDP
:params_state_tcp
REM Opciones para visualizar los parametros TCP
netsh interface tcp show global

goto quehacer

:params_state_udp
REM Opciones para visualizar los parametros UDP
netsh interface udp show global


:state_tcp_and_udp
REM Opciones para visualizar los parametros TCP y UDP
echo.
echo [+] Visualizando opciones de los parametros TCP
echo.

netsh interface tcp show global

echo.
echo [+] Visualizando opciones de los parametros UDP
echo.

netsh interface udp show global

goto quehacer
REM FINALIZA LAS OPCIONES DE VISUALIZACION DE LOS PARAMETROS DE LOS PROTOCOLOS TCP Y/O UDP

:open_or_close_port
REM Opcion para abrir o cerrar un puerto
echo.
set /p open_or_close=Desea abrir o cerrar un puerto [A = Abrir / C = Cerrar]: 

if %open_or_close% == A (
    goto open_port
) else if %open_or_close% == a (
    goto open_port
) else if %open_or_close% == C (
    goto close_port
) else if %open_or_close% == c (
    goto close_port
) else (
    echo.
    echo ERROR: Se esperaba A o C
    echo.
    pause
    goto helpPanel
)

:open_port
echo.
set /p port_number=Introduce el numero del puerto a abrir: 
echo.
set /p in_or_out=Desea abrir un puerto de entrada o de salida? [I = Entrada / O = Salida]: 
echo.
set /p rule_name=Introduce el nombre de la regla que crearas para abrir el puerto corresponiente: 

if %in_or_out% == I (
    goto open_in_port
) else if %in_or_out% == i (
    goto open_in_port
) else if %in_or_out% == O (
    goto open_out_port
) else if %in_or_out% == o (
    goto open_out_port
) else (
    echo.
    echo ERROR: Se esperaba I u O
    echo.
    pause
)

REM -----------------------------------------------------------------------------------------------------------------
REM OPCIONES PARA ABRIR UN PUERTO DE ENTRADA
:open_in_port
echo.
set /p protocol=Introduce el protocolo del puerto %port_number% [T = TCP / U = UDP / A = All]: 
echo.

if %protocol% == T (
    goto open_in_tcp_port
) else if %protocol% == t (
    goto open_in_tcp_port
) else if %protocol% == U (
    goto open_in_udp_port
) else if %protocol% == u (
    goto open_in_udp_port
) else if %protocol% == A (
    goto open_in_tcp_and_udp_port
) else if %protocol% == a (
    goto open_in_tcp_and_udp_port
) else (
    echo.
    echo ERROR: Se esperaba T, U o A
    echo.
    pause
    goto helpPanel
)

:open_in_tcp_port
netsh advfirewall firewall add rule name="%rule_name%" protocol=TCP dir=in localport=%port_number% action=allow

goto quehacer

:open_in_udp_port
netsh advfirewall firewall add rule name="%rule_name%" protocol=UDP dir=in localport=%port_number% action=allow

goto quehacer

:open_in_tcp_and_udp_port
echo.
echo [+] Abriendo puerto %port_number% TCP
echo.
netsh advfirewall firewall add rule name="%rule_name%" protocol=TCP dir=in localport=%port_number% action=allow

echo.
echo [+] Abriendo puerto %port_number% UDP
echo.
netsh advfirewall firewall add rule name="%rule_name%" protocol=UDP dir=in localport=%port_number% action=allow

echo [+] Puerto %port_number% abierto tanto en TCP como en UDP

goto quehacer
REM FINALIZA LAS OPCIONES PARA ABRIR UN PUERTO DE ENTRADA
REM -----------------------------------------------------------------------------------------------------------------


REM -----------------------------------------------------------------------------------------------------------------
REM OPCIONES PARA ABRIR UN PUERTO DE SALIDA
:open_out_port
echo.
set /p protocol=Introduce el protocolo del puerto %port_number% [T = TCP / U = UDP / A = All]: 
echo.

if %protocol% == T (
    goto open_out_tcp_port
) else if %protocol% == t (
    goto open_out_tcp_port
) else if %protocol% == U (
    goto open_out_udp_port
) else if %protocol% == u (
    goto open_out_udp_port
) else if %protocol% == A (
    goto open_out_tcp_and_udp_port
) else if %protocol% == a (
    goto open_out_tcp_and_udp_port
) else (
    echo.
    echo ERROR: Se esperaba T, U o A
    echo.
    pause
    goto helpPanel
)

:open_out_tcp_port
netsh advfirewall firewall add rule name="%rule_name%" protocol=TCP dir=out localport=%port_number% action=allow

goto quehacer

:open_out_udp_port
netsh advfirewall firewall add rule name="%rule_name%" protocol=UDP dir=out localport=%port_number% action=allow

goto quehacer

:open_out_tcp_and_udp_port
echo.
echo [+] Abriendo puerto %port_number% TCP
echo.
netsh advfirewall firewall add rule name="%rule_name%" protocol=TCP dir=out localport=%port_number% action=allow

echo.
echo [+] Abriendo puerto %port_number% UDP
echo.
netsh advfirewall firewall add rule name="%rule_name%" protocol=UDP dir=out localport=%port_number% action=allow

echo [+] Puerto %port_number% abierto tanto en TCP como en UDP

goto quehacer
REM FINALIZA LAS OPCIONES PARA ABRIR UN PUERTO DE SALIDA
REM -----------------------------------------------------------------------------------------------------------------

:close_port
echo.
set /p port_number=Introduce el numero del puerto a cerrar: 
echo.
set /p in_or_out=Desea cerrar un puerto de entrada o de salida? [I = Entrada / O = Salida]: 
echo.
set /p rule_name=Introduce el nombre de la regla que agregaras para cerrar el puerto: 

if %in_or_out% == I (
    goto close_in_port
) else if %in_or_out% == i (
    goto close_in_port
) else if %in_or_out% == O (
    goto close_out_port
) else if %in_or_out% == o (
    goto close_out_port
) else (
    echo.
    echo ERROR: Se esperaba I u O
    echo.
    pause
)

REM -----------------------------------------------------------------------------------------------------------------
REM OPCIONES PARA BLOQUEAR UN PUERTO DE ENTRADA
:close_in_port
echo.
set /p protocol=Introduce el protocolo del puerto %port_number% [T = TCP / U = UDP / A = All]: 
echo.

if %protocol% == T (
    goto close_in_tcp_port
) else if %protocol% == t (
    goto close_in_tcp_port
) else if %protocol% == U (
    goto close_in_udp_port
) else if %protocol% == u (
    goto close_in_udp_port
) else if %protocol% == A (
    goto close_in_tcp_and_udp_port
) else if %protocol% == a (
    goto close_in_tcp_and_udp_port
) else (
    echo.
    echo ERROR: Se esperaba T, U o A
    echo.
    pause
    goto helpPanel
)

:close_in_tcp_port
netsh advfirewall firewall add rule name="%rule_name%" protocol=TCP dir=in localport=%port_number% action=block

goto quehacer

:close_in_udp_port
netsh advfirewall firewall add rule name="%rule_name%" protocol=UDP dir=in localport=%port_number% action=block

goto quehacer

:close_in_tcp_and_udp_port
echo.
echo [+] Bloqueando el acceso al puerto %port_number% TCP
echo.
netsh advfirewall firewall add rule name="%rule_name%" protocol=TCP dir=in localport=%port_number% action=block

echo.
echo [+] Bloqueando el acceso al puerto %port_number% UDP
echo.
netsh advfirewall firewall add rule name="%rule_name%" protocol=UDP dir=in localport=%port_number% action=block

echo [+] Puerto %port_number% bloqueado tanto en TCP como en UDP

goto quehacer
REM FINALIZA LAS OPCIONES PARA BLOQUEAR UN PUERTO DE ENTRADA
REM -----------------------------------------------------------------------------------------------------------------


REM -----------------------------------------------------------------------------------------------------------------
REM OPCIONES PARA BLOQUEAR UN PUERTO DE SALIDA
:close_out_port
echo.
set /p protocol=Introduce el protocolo del puerto %port_number% [T = TCP / U = UDP / A = All]: 
echo.

if %protocol% == T (
    goto close_out_tcp_port
) else if %protocol% == t (
    goto close_out_tcp_port
) else if %protocol% == U (
    goto close_out_udp_port
) else if %protocol% == u (
    goto close_out_udp_port
) else if %protocol% == A (
    goto close_out_tcp_and_udp_port
) else if %protocol% == a (
    goto close_out_tcp_and_udp_port
) else (
    echo.
    echo ERROR: Se esperaba T, U o A
    echo.
    pause
    goto helpPanel
)

:close_out_tcp_port
netsh advfirewall firewall add rule name="%rule_name%" protocol=TCP dir=out localport=%port_number% action=block

goto quehacer

:close_out_udp_port
netsh advfirewall firewall add rule name="%rule_name%" protocol=UDP dir=out localport=%port_number% action=block

goto quehacer

:close_out_tcp_and_udp_port
echo.
echo [+] Bloqueando el acceso al puerto %port_number% TCP
echo.
netsh advfirewall firewall add rule name="%rule_name%" protocol=TCP dir=out localport=%port_number% action=block

echo.
echo [+] Bloqueando el acceso al puerto %port_number% UDP
echo.
netsh advfirewall firewall add rule name="%rule_name%" protocol=UDP dir=out localport=%port_number% action=block

echo [+] Puerto %port_number% abierto tanto en TCP como en UDP

goto quehacer
REM FINALIZA LAS OPCIONES PARA BLOQUEAR UN PUERTO DE SALIDA
REM -----------------------------------------------------------------------------------------------------------------

:dns_add
REM Opcionpara agregar un DNS
echo.
set /p dns_name=Introduce el nombre del DNS a agregar: 
echo.
set /p ip_address=Introduce la IP del servidor DNS %dns_name%: 

netsh interface ip add dns name="%dns_name%" addr=%ip_address%

if errorlevel == 0 (
    echo [+] El servidor DNS "%dns_name%" cuya IP es "%ip_address%" ha sido agregado correctamente
) else (
    goto error
)

:allow_disallow_icmp_eco
REM Opcion para permitir o bloquear las solicitudes eco request por ICMP de ping
echo.
set /p allow_or_disallow=Quieres activar o bloquear las peticiones eco ICMP [A = Activar / B = Bloquear]: 

if %allow_or_disallow% == A (
    goto allow_eco_icmp
) else if %allow_or_disallow% == a (
    goto allow_eco_icmp
) else if %allow_or_disallow% == B (
    goto block_eco_icmp
) else if %allow_or_disallow% == b (
    goto block_eco_icmp
) else (
    echo.
    echo [!] ERROR: Se esperaba A o b
    echo.
    pause
    goto quehacer
)

REM -----------------------------------------------------------------------------------------------------------------
REM OPCIONES PARA HABILITAR LAS PETICIONES ECO ICMP DE ENTRADA Y/O DE SALIDA
:allow_eco_icmp
echo.
set /p in_or_out_icmp=Quieres permitir las peticiones eco ICMP de entrada o de salida [I = Entrada / O = Salida / A = Ambas]: 

if %in_or_out_icmp% == I (
    goto allow_eco_in
) else if %in_or_out_icmp% == i (
    goto allow_eco_in
) else if %in_or_out_icmp% == O (
    goto allow_eco_out
) else if %in_or_out_icmp% == o (
    goto allow_eco_out
) else if %in_or_out_icmp% == A (
    goto allow_eco_in_out
) else if %in_or_out_icmp% == a (
    goto allow_eco_in_out
) else (
    echo.
    echo [!] ERROR: Se esperaba I, O o A
    echo.
    pause
    goto quehacer
)

:allow_eco_in
REM Opcion que permite habilitar las peticiones eco request por ICMPv4 de entrada
echo.
set /p rule_icmp_name=Introduce el nombre de la regla que agregaras para permitir las solicitudes eco ICMP de entrada: 

echo.
echo [+] Agregando regla "%rule_icmp_name%" de entrada
netsh advfirewall firewall add rule name="%rule_icmp_name%" dir=in action=allow protocol=icmpv4

goto quehacer

:allow_eco_out
REM Opcion que permite habilitar las peticiones eco request por ICMPv4 de entrada
echo.
set /p rule_icmp_name=Introduce el nombre de la regla que agregaras para permitir las solicitudes eco ICMP de salida: 

echo.
echo [+] Agregando regla "%rule_icmp_name%" de salida
netsh advfirewall firewall add rule name="%rule_icmp_name%" dir=out action=allow protocol=icmpv4

goto quehacer

:allow_eco_in_out
REM Opcion que permite habilitar las peticiones eco request por ICMPv4 de entrada y de salida
echo.
set /p rule_icmp_name_in=Introduce el nombre de la regla que agregaras para permitir las solicitudes eco ICMP de entrada:  
echo.
set /p rule_icmp_name_out=Introduce el nombre de la regla que agregaras para permitir las solicitudes eco ICMP de salida: 

echo.
echo [+] Agregando regla "%rule_icmp_name_in%" de entrada
netsh advfirewall firewall add rule name="%rule_icmp_name_in%" dir=in action=allow protocol=icmpv4

echo.
echo [+] Agregando regla "%rule_icmp_name_out%" de salida
netsh advfirewall firewall add rule name="%rule_icmp_name_out%" dir=out action=allow protocol=icmpv4

goto quehacer

REM -----------------------------------------------------------------------------------------------------------------
REM OPCIONES PARA BLOQUEAR LAS PETICIONES ECO ICMP DE ENTRADA Y/O DE SALIDA
:block_eco_icmp
echo.
set /p in_or_out_icmp=Quieres bloquear las peticiones eco ICMP de entrada o de salida [I = Entrada / O = Salida / A = Ambas]: 

if %in_or_out_icmp% == I (
    goto block_eco_in
) else if %in_or_out_icmp% == i (
    goto block_eco_in
) else if %in_or_out_icmp% == O (
    goto block_eco_out
) else if %in_or_out_icmp% == o (
    goto block_eco_out
) else if %in_or_out_icmp% == A (
    goto block_eco_in_out
) else if %in_or_out_icmp% == a (
    goto block_eco_in_out
) else (
    echo.
    echo [!] ERROR: Se esperaba I, O o A
    echo.
    pause
    goto quehacer
)


:block_eco_in
REM Opcion que permite bloquear las peticiones eco request por ICMPv4 de entrada
echo.
set /p rule_icmp_name=Introduce el nombre de la regla que agregaras para bloquear las solicitudes eco ICMP de entrada: 

echo.
echo [+] Agregando regla "%rule_icmp_name%" de entrada
netsh advfirewall firewall add rule name="%rule_icmp_name%" dir=in action=block protocol=icmpv4

goto quehacer

:block_eco_out
REM Opcion que permite habilitbloquearar las peticiones eco request por ICMPv4 de entrada
echo.
set /p rule_icmp_name=Introduce el nombre de la regla que agregaras para bloquear las solicitudes eco ICMP de salida: 

echo.
echo [+] Agregando regla "%rule_icmp_name%" de salida
netsh advfirewall firewall add rule name="%rule_icmp_name%" dir=out action=block protocol=icmpv4

goto quehacer

:block_eco_in_out
REM Opcion que permite bloquear las peticiones eco request por ICMPv4 de entrada y de salida
echo.
set /p rule_icmp_name_in=Introduce el nombre de la regla que agregaras para bloquear las solicitudes eco ICMP de entrada:  
echo.
set /p rule_icmp_name_out=Introduce el nombre de la regla que agregaras para bloquear las solicitudes eco ICMP de salida: 

echo.
echo [+] Agregando regla "%rule_icmp_name_in%" de entrada
netsh advfirewall firewall add rule name="%rule_icmp_name_in%" dir=in action=block protocol=icmpv4

echo.
echo [+] Agregando regla "%rule_icmp_name_out%" de salida
netsh advfirewall firewall add rule name="%rule_icmp_name_out%" dir=out action=block protocol=icmpv4

goto quehacer

:allow_disallow_firewall
REM Opcion para deshabilitar el firewall
echo.
set /p allow_or_disallow_firewall=Desea habilitar o deshabilitar el firewall de Windows en todos los perfiles? [A = Habilitar / D = Deshabilitar]: 

if %allow_or_disallow_firewall% == A (
    goto allow_firewall
) else if %allow_or_disallow_firewall% == a (
    goto allow_firewall
) else if %allow_or_disallow_firewall% == D (
    goto disallow_firewall
) else if %allow_or_disallow_firewall% == d (
    goto disallow_firewall
) else (
    echo.
    echo [!] ERROR: Se esperaba A o D
    echo.
    pause
    goto quehacer
)

:allow_firewall
REM Opcion para habilitar el firewall de Windows en todos los perfiles
netsh advfirewall set allprofiles state on

goto quehacer
:disallow_firewall
REM Opcion para deshabilitar el firewall de Windows en todos los perfiles
echo.
set /p sure=Esta seguro que quiere deshabilitar el firewall en todos los perfiles? [S = Si / N = No]: 

if %sure% == S (
    goto disallow_firewall_yes
) else if %sure% == s (
    goto disallow_firewall_yes
) else if %sure% == N (
    goto quehacer
) else if %sure% == n (
    goto quehacer
) else (
    echo.
    echo [!] ERROR: Se esperaba S o n
    echo.
    pause
    goto quehacer
)

:disallow_firewall_yes
netsh advfirewall set allprofiles state off

goto quehacer

:reset_settings_firewall
REM Opcion para reconfigurar a las opciones por defecto del firewall
echo.
set /p sure_reset=Esta seguro que desea restablecer la configuracion de las opciones del firewall? NO podra volver a atras [S = Si / N = No]: 

if %sure_reset% == S (
    goto reset_settings_firewall_yes
) else if %sure_reset% == s (
    goto reset_settings_firewall_yes
) else if %sure_reset% == N (
    goto quehacer
) else if %sure_reset% == n (
    goto quehacer
) else (
    echo.
    echo [!] ERROR: Se esperaba S o n
    echo.
    pause
    goto quehacer
)

:reset_settings_firewall_yes
netsh advfirewall reset

goto quehacer

:capture_packets
REM Opcion que permite empezar o terminar la captura de paquetes
echo.
set /p capture_start_or_stop=Desea empezar o terminar la captura de paquetes [E = Empezar / T = Terminar]: 

if %capture_start_or_stop% == E (
    goto capture_packet_start
) else if %capture_start_or_stop% == e (
    goto capture_packet_start
) else if %capture_start_or_stop% == T (
    goto capture_packet_stop
) else if %capture_start_or_stop% == t (
    goto capture_packet_stop
) else (
    echo.
    echo [!] ERROR: Se esperaba E o T
    echo.
    pause
    goto quehacer
)

:capture_packet_start
echo.
set /p complete_path=Introduzca la ruta (sin la extension) del fichero en el que desea capturar paquetes: 
echo.
set /p maxsize=Introduzca el tamaño maximo en bites del fichero de captura de paquetes: 

echo.
echo [+] Fichero %complete_path% preparado para capturar paquetes
echo.
echo [+] Aqui tienes un poco de informacion sobre el fichero: 

netsh trace start capture=yes tracefile=%complete_path%.etl persistent=yes maxsize=%maxsize%

goto quehacer

:capture_packet_stop
echo.
set /p sure_capture_stop=Esta seguro de que desea parar la captura de paquetes? [S = Si / N = No]: 
echo.

if %sure_capture_stop% == S (
    goto capture_packet_stop_yes
) else if %sure_capture_stop% == s (
    goto capture_packet_stop_yes
) else if %sure_capture_stop% == N (
    goto quehacer
) else if %sure_capture_stop% == n (
    goto quehacer
) else (
    echo.
    echo [!] ERROR: Se esperaba S o N
    echo.
    pause
    goto quehacer
)

:capture_packet_stop_yes
echo [!] Parando la captura de paquetes ...
echo.
netsh trace stop
echo.

goto quehacer

:show_help_netsh
REM Opcion que visualiza el panel de ayuda del comando netsh
echo.
echo [+] Visualizando el panel de ayuda de netsh

netsh /?

:quehacer
echo.
set /p quehacer=Que desea hacer ahora? [V = Volver al menu principal / S = Salir del programa]: 
echo.

if %quehacer% == V (
    goto helpPanel
) else if %quehacer% == v (
    goto helpPanel
) else if %quehacer% == S (
    goto salir
) else if %quehacer% == s (
    goto salir
) else (
    echo.
    echo [!] ERROR: Se esparaba V o s
    echo.
    pause
    goto quehacer
)

:error
echo.
echo [!] ERROR: Algo ha ido mal ...
echo.
pause

goto quehacer

:salir
echo [!] Saliendo ...