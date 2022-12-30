@echo off

REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM EJERCICIO 21
REM Realiza un programa el cual permita enviar mensajes entre dos equipos por el servicio mesajero
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------

REM *******************************************************************************************************************************************
REM                                                     PASOS A REALIZAR
REM *******************************************************************************************************************************************
REM             [1] Desactivar el firewall de este equipo (netsh advfirewall set allprofiles state off).
REM             [2] Activar el servicio mensajero de este equipo (sc config MessagingService start=demand).
REM             [3] El usuario debera introducir el numero de IP del equipo con el que se desea comunicarse.
REM             [4] La red se obtendra automaticamente a partir de la IP local.
REM             [5] Los mensajes a la IP se enviaran con el comando MSG.
REM             [6] Cuando el usuario quiera salir del programa el servicio mensajero se desactivara y el firewall se volvera a activar.
REM *******************************************************************************************************************************************

REM *******************************************************************************************************************************************
REM                                                 VALIDACIONES A TENER EN CUENTA
REM *******************************************************************************************************************************************
REM                     [1] Si el número de IP introducida esta entre 1-254
REM                     [2] Si el dispositivo al que va a enviar tiene conectividad contigo o no (PING)
REM *******************************************************************************************************************************************

REM Advirtiendo al usuario que para poder ejecutar correctamente el programa debe de tener permisos de Administrador
cls
echo.
echo ***************************************************************
echo [!] IMPORTANTE: Asegurese de tener permisos de administrador
echo ***************************************************************
echo.
pause

cls

echo.
echo ********************************************************************
echo        PROGRAMA PARA ENVIAR MENSAJES A OTROS EQUIPOS DE TU RED
echo ********************************************************************
echo.

REM Realizando comprobaciones antes de empezar el programa
echo [*] Haciendo unas comprobaciones previas ...

REM Desactivando el firewall de este equipo
echo.
echo [*] Desactivando el firewall ...
netsh advfirewall set allprofiles state off >nul 2>nul

if errorlevel == 0 (
    echo.
    echo [+] El firewall se ha desactivado correctamente
) else (
    echo.
    echo [!] Hubo algun problema al desactivar el firewall, por favor, comprueba este problema
    
    goto salir
)

REM Activando el servicio mensajero de este equipo
echo.
echo [*] Iniciando el servicio mensajero ...
sc config MessagingService start=demand >nul 2>nul

if errorlevel == 0 (
    echo.
    echo [+] El servicio mensajero se ha activado correctamente
) else (
    echo.
    echo [!] Hubo algun problema al activar el servicio mensajero, por favor, comprueba este problema

    goto salir
)

echo.
echo [+] Comprobaciones realizadas correctamente

echo.
echo [!] IMPORTANTE: Asegurese de que el firewall del equipo destino esta desactivado.
echo [!] IMPORTANTE: Asegurese de que el servicio mensajero del equipo destino esta activado.

:question_ip_number
REM Preguntando al usuario por el numero de equipo
echo.
set /p ip_number=Introduce el numero de equipo al que desea enviar el mensaje: [S para salir]: 

if %ip_number% == S (
    goto salir
) else if %ip_number% == s (
    goto salir
)

if 1%ip_number% neq +1%ip_number% (
    echo.
    echo [!] ERROR: Introduce un numero
    echo.
    pause
    
    goto question_ip_number
)

if %ip_number% lss 1 (
    echo.
    echo [!] ERROR: Introduce un numero entre 1-254
    echo.
    pause

    goto question_ip_number
) else if %ip_number% gtr 254 (
    echo.
    echo [!] ERROR: Introduce un numero entre 1-254
    echo.
    pause

    goto question_ip_number
)

for /f "delims=" %%a in ('ipconfig ^| find /I "Ipv4"') do set "ip_first_network=%%a"&goto :stop_searching_first_network

:stop_searching_first_network
echo %ip_first_network% > netip.txt

REM Sacamos la IP de este equipo para sacar la IP de red
for /f "tokens=17" %%a in (netip.txt) do set ip_address=%%a

REM Sacamos la red de este equipo con su IP
for /f "tokens=1-3 delims=." %%b in ("%ip_address%") do set net_ip_address=%%b.%%c.%%d

REM Comprobando conectividad con el equipo introducido
echo.
echo [*] Comprobando conectividad con la IP %net_ip_address%.%ip_number% ...

ping -n 1 %net_ip_address%.%ip_number% >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] Lo sentimos el equipo %net_ip_address%.%ip_number% no esta disponible actualmente
    echo.
    pause

    goto salir
)

REM Me daba un error y es que aunque el HOST estaba activo, no me pasaba el filtro, por algun motivo, de si te pone "Host de Destino Inaccesible"
ping -n 1 11.11.11.130 | find /I "bytes=" >nul 2>nul

if errorlevel == 0 (
    goto send_message
)

REM Si no tienes conectividad pero te sale que el "Host de Destino es Inaccesible", el errorlevel se iguala a 0, por lo que hay que tener en cuenta que si sale eso en la respuesta del PING no tenemos conectividad con el equipo
ping -n 1 %net_ip_address%.%ip_number% > conectividad.txt 2>nul

type conectividad.txt | find /I "inaccesible" >nul 2>nul

if errorlevel == 0 (
    echo.
    echo [!] Lo sentimos el equipo %net_ip_address%.%ip_number% no esta disponible actualmente
    echo.
    pause
    
    goto salir
)

:send_message
REM El usuario introduce el mensaje que quiere enviar
echo.
set /p message=Introduce el mensaje completo a enviar al equipo: 

msg * /server:%net_ip_address%.%ip_number% %message%

echo.
echo [+] Mensaje enviado correctamente
echo.
pause

:question_other_message
REM Se le preguntara al usuario si quiere enviar otro mensaje, en caso de que si se volvera la pregunta de la IP, en caso de que no saldra del programa
echo.
choice /C SN /N /M "Desea enviar otro mensaje? [S = Si / N = No]: "

if errorlevel == 2 (
    goto salir
) else if errorlevel == 1 (
    cls
    goto question_ip_number
)

:salir
REM Volviendo a activar el firewall de este equipo
echo.
echo [*] Activando el firewall del equipo ...
netsh advfirewall set allprofiles state on >nul 2>nul

if errorlevel == 0 (
    echo.
    echo [+] El firewall se ha activado correctamente
) else (
    echo.
    echo [!] Hubo algun problema al activar el firewall, por favor, comprueba este problema
    
    goto salir
)

REM Deteniendo el servicio mensajero de este equipo
echo.
echo [*] Deteniendo el servicio mensajero ...
sc config MessagingService start=disabled >nul 2>nul

if errorlevel == 0 (
    echo.
    echo [+] El servicio mensajero se ha desactivado correctamente
) else (
    echo.
    echo [!] Hubo algun problema al desactivar el servicio mensajero, por favor, comprueba este problema

    goto salir
)

REM Borrando ficheros creados para el correcto funcionamiento del script
if exist netip.txt (
    del netip.txt
)

if exist conectividad.txt (
    del conectividad.txt
)

REM Si el usuario llega aqui se termina el programa
echo.
echo [!] Saliendo