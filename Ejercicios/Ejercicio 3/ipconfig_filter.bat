@echo off
REM Esto es un programa el cual te filtra por las direcciones IPv4 e IPv6, direcciones MAC, interfaces de red disponibles y servidores DHCP

:helpPanel
cls
echo.
echo *****************************************************
echo            OPCIONES DISPONIBLES
echo *****************************************************
echo        [1] Mostrar interfaces de red
echo        [2] Mostrar tarjetas de red
echo        [3] Mostrar nombre de este equipo
echo        [4] Mostrar IPv4 o IPv6
echo        [5] Mostrar direcciones MAC
echo        [6] Mostrar servidores DHCP
echo        [7] Salir del programa
echo *****************************************************
echo.

choice /C 1234567 /N /M "Introduce una opcion disponible: "

if errorlevel == 7 (
    goto salir
) else if errorlevel == 6 (
    goto show_dhcp_servers
) else if errorlevel == 5 (
    goto show_mac_address
) else if errorlevel == 4 (
    goto show_ipv4_or_ipv6
) else if errorlevel == 3 (
    goto show_hostname
) else if errorlevel == 2 (
    goto show_net_cards
) else if errorlevel == 1 (
    goto show_net_interfaces
)

:show_net_interfaces
REM Opcion para visualizar las interfaces de red
echo.
echo [*] Visualizando las interfaces de red disponibles: 
echo.

for /F "tokens=1 delims=:" %%a in ('ipconfig /all ^| find /I "Adaptador de"') do (
    echo    - %%a
)

goto quehacer

:show_net_cards
REM Opcion para visualizar las interfaces de red
echo.
echo [*] Visualizando las tarjetas de red disponibles: 
echo.

for /F "tokens=2 delims=:" %%a in ('ipconfig /all ^| findstr Descripci') do (
    echo    - %%a
)

goto quehacer

:show_hostname
echo.
choice /C LD /N /M "Desea visualiz el nombre del equipo local o del dominio [L = Local / D = Dominio]: "

if errorlevel == 2 (
    goto show_domain_hostname
) else if errorlevel == 1 (
    goto show_local_hostname
)

:show_local_hostname
echo.
echo [*] El nombre local para este equipo es : "%computername%"

goto quehacer

:show_domain_hostname
echo.
echo [*] El nombre de dominio para este equipo es : "%userdomain%"

goto quehacer

:show_ipv4_or_ipv6
REM Opcion para visualizar las direcciones IPv4 o IPv6
echo.
choice /c 46 /N /M "Deseas visualizar direcciones IPv4 o IPv6 [4 = IPv4 / 6 = IPv6]: "

if errorlevel == 2 (
    goto show_ipv6
) else if errorlevel == 1 (
    goto show_ipv4
)

:show_ipv4
REM Opcion para visualizar las direcciones IPv4
echo.
echo [*] Visualizando direcciones IPv4 disponibles: 
echo.

for /F "tokens=2 delims=:" %%b in ('ipconfig ^| findstr IPv4') do (
    echo    - %%b
)

goto quehacer

:show_ipv6
REM Opcion para visualizar las direcciones IPv6
echo.
echo [*] Visualizando direcciones IPv6 disponibles: 
echo.

for /F "tokens=8" %%c in ('ipconfig ^| findstr IPv6') do (
    echo    - %%c
)

goto quehacer

:show_mac_address
REM Opcion para visualizar las direcciones MAC
echo.
echo [*] Visualizando direcciones MAC disponibles: 
echo.

for /F "tokens=1" %%d in ('getmac ^| find /V /I "Direcci" ^| find /V /I "="') do (
    echo    - %%d
)

goto quehacer

:show_dhcp_servers
REM Opcion para visualizar los servidores DHCP
echo.
echo [*] Visualizando los servidores DHCP disponibles: 
echo.

for /F "tokens=2 delims=:" %%e in ('ipconfig /all ^| find /I "servidor dhcp"') do (
    echo    - %%e
)

goto quehacer

:quehacer
REM Opcion para saber si salir o volver al menu principal
echo.
choice /C SN /N /M "Desea salir del programa? [S = Si / N = No]: "

if errorlevel == 2 (
    goto helpPanel
) else if errorlevel == 1 (
    goto salir
)

:salir
echo.
echo [!] Saliendo ...