@echo off
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM EJERCICIO 18
REM Realiza un programa para comprobar si uno o varios equipos son accesibles a traves de su DNS o IP
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------

:helpPanel
cls
echo.
echo *********************************************************
echo                    IP OR DNS CHECKER
echo *********************************************************
echo            [1] Ver mis configuracion de red
echo            [2] Comprobar la red
echo            [3] Salir
echo *********************************************************
echo.

choice /c 123 /N /M "Introduce una opcion: [1,2,3]: "

if errorlevel == 3 (
    goto salir
) else if errorlevel == 2 (
    goto net_check
) else if errorlevel == 1 (
    goto net_settings
)

:net_settings
REM Opcion para visualizar la configuracion de las tarjetas de red (ipconfig /all)
echo.
echo [+] Visualizando la configuracion de red
ipconfig /all
echo.
pause

goto quehacer

:net_check
REM Opcion para comprobar la conectividad en la red
cls
echo.
echo *********************************************************
echo               OPCIONES PARA COMPROBAR LA RED
echo *********************************************************
echo            [1] Comprobar una IP
echo            [2] Comprobar un PC del aula
echo            [3] Comprobar todo el aula
echo            [4] Volver
echo *********************************************************
echo.

choice /C 1234 /N /M "Introduce una opcion: [1,2,3,4]: "

if errorlevel == 4 (
    goto helpPanel
) else if errorlevel == 3 (
    goto aula_check
) else if errorlevel == 2 (
    goto pc_check
) else if errorlevel == 1 (
    goto ip_check
)

:ip_check
REM Opcion para comprobar si una IP esta disponible
echo.
set /p ip=Introduce la IP o DNS a comprobar [V para volver]: 

if %ip% == V (
    goto net_check
) else if %ip% == v (
    goto net_check
)

echo.
echo [+] Comprobando la disponibilidad de "%ip%"

ping -n 1 %ip% >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El dispositivo no esta activo
    echo.
    pause
    goto quehacer
) else if errorlevel == 0 (
    echo.
    echo [+] El dispositivo esta activo
    echo.
    pause
    goto quehacer
)

:pc_check
REM Opcion para comprobar si un PC esta disponible
echo.
set /p ip=introduce el numero del equipo [V para volver]: 

if %ip% == V (
    goto net_check
) else if %ip% == v (
    goto net_check
)

REM Sacamos la IP con este for
for /f "tokens=17" %%a in ('ipconfig ^| findstr IPv4') do set _IPaddr=%%a

REM Sacamos la red con este for
for /f "tokens=1-3 delims=." %%b in ("%_IPaddr%") do set net=%%b.%%c.%%d

echo.
echo [+] Comprobando conectividad con %net%.%ip% ...
ping -n 1 %net%.%ip% >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El dispositivo no esta activo
    echo.
    pause
    goto quehacer
) else if errorlevel == 0 (
    echo.
    echo [+] El dispositivo esta activo
    echo.
    pause
    goto quehacer
)

REM ------------------------------------------------------------------------------
REM COMIENZA LAS OPCIONES DE AULA CHECK

:aula_check
REM Opcion para comprobar que dispositivos de mi red estan disponible
echo.
set /p first_number_ip=Introduce el numero del primer dispositivo a escanear: 

if 1%first_number_ip% neq +1%first_number_ip% (
    goto first_error_aula_check
) else if %first_number_ip% gtr 254 (
    goto first_error_aula_check
) else if %first_number_ip% lss 1 (
    goto first_error_aula_check
)

:second_aula_check
echo.
set /p last_number_ip=Introduce el numero del ultimo dispositivo a escanear: 

if 1%last_number_ip% neq +1%last_number_ip% (
    goto second_error_aula_check
) else if %last_number_ip% gtr 254 (
    goto second_error_aula_check
) else if %last_number_ip% lss 1 (
    goto second_error_aula_check
) else if %first_number_ip% gtr %last_number_ip% (
    echo.
    echo [!] ERROR: Introduce un numero mayor a "%first_number_ip%"
    echo.
    pause
    goto second_aula_check
)

ipconfig | findstr /I "IPv4" > networks.txt 2>nul

for /f "tokens=17" %%b in (networks.txt) do (
    echo            - %%b >> ipv4.txt
)

set parameter_counter=0
for /f %%x in (networks.txt) do (
    set /a parameter_counter=1+parameter_counter
)

set numero_lineas=%parameter_counter%

if %numero_lineas% gtr 1 (
    goto mas_de_una_interfaz
)

echo.

REM Sacamos la IP con este for
for /f "tokens=17" %%a in ('ipconfig ^| findstr IPv4') do set _IPaddr=%%a

REM Sacamos la red con este for
for /f "tokens=1-3 delims=." %%b in ("%_IPaddr%") do set net=%%b.%%c.%%d

:net_scanning
echo.
echo [+] Escaneando desde la "%net%.%first_number_ip%" hasta la "%net%.%last_number_ip%" ...

for /L %%a in (%first_number_ip% 1 %last_number_ip%) do (
    ping -n 1 %net%.%%a >nul 2>nul

    if errorlevel == 1 (
        echo        - %net%.%%a >> not_available_ip.txt.tmp
    ) else if errorlevel == 0 (
        echo        - %net%.%%a >> available_ip.txt.tmp
    )
)

echo.
echo [+] Listando ordenadores activos de la red %net%.0

if not exist available_ip.txt.tmp (
    echo [!] Todos los dispositivos estan inactivos, por lo que no hay ningun dispositivo activo
)

echo.
type available_ip.txt.tmp 2>nul

echo.
echo [+] Listando ordenadores no activos de la red %net%.0

if not exist not_available_ip.txt.tmp (
    echo [!] Todos los dispositivos estan activos, por lo que no hay ningun dispositivo inactivo
)

echo.
type not_available_ip.txt.tmp 2>nul

pause

if exist networks.txt (
    del networks.txt
)

if exist ipv4.txt (
    del ipv4.txt
)

if exist available_ip.txt.tmp (
    del available_ip.txt.tmp >nul 2>nul
)

if exist not_available_ip.txt.tmp (
    del not_available_ip.txt.tmp >nul 2>nul
)

goto quehacer

:mas_de_una_interfaz
REM Opcion por si tiene mas de una interfaz

if exist networks.txt (
    del networks.txt
)

echo.
echo [+] Tienes mas de una interfaz de red
echo.
pause

:menu_mas_de_una_interfaz
echo.
echo *********************************************
echo        INTERFACES DE RED DISPONIBLES
echo *********************************************
type ipv4.txt
echo *********************************************
echo.

set /p interfaz=Que interfaz de red deseas escanear?: 

type ipv4.txt | find /I "%interfaz%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] Elige una interfaz de red disponible
    echo.
    pause
    goto menu_mas_de_una_interfaz
)

REM Sacamos la red de la IP que nos ha dado el usuario con este for
for /f "tokens=1-3 delims=." %%b in ("%interfaz%") do set net=%%b.%%c.%%d

goto net_scanning

:first_error_aula_check
echo.
echo [!] ERROR: Introduce un numero entre 1-254
echo.
pause
goto aula_check

:second_error_aula_check
echo.
echo [!] ERROR: Introduce un numero entre 1-254
echo.
pause
goto second_aula_check

REM COMIENZA LAS OPCIONES DE AULA CHECK
REM ------------------------------------------------------------------------------

:quehacer
echo.
choice /VS /N /M "Que desea hacer? [V = Volver al menu / S = Salir]: "

if errorlevel == 1 (
    goto helpPanel
)

:salir
echo.
echo [!] Saliendo ...
echo.