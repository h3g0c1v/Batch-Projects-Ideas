@echo off
REM Programa que te permitirá obtener la contraseña del WIFI, al cual te has conectado con anterioridad.

for /F "tokens=2 delims=:" %%a in ('netsh wlan show profile') do (
    echo    - %%a >> wifi_list.txt
)

:show_available_wifi
cls
echo.
echo *************************************************************
echo                        WIFIS DISPONIBLES
echo *************************************************************
type wifi_list.txt
echo *************************************************************
echo.

set /p option=Introduce el nombre del alguna de las redes disponibles: 

type wifi_list.txt | find /I "%option%" 2>nul >nul

if errorlevel == 1 (
    echo.
    echo [!] La red %option% no esta disponible en las opciones, por favor, introduzca una del listado
    echo.
    pause
    
    goto show_available_wifi
)

netsh wlan show profile name="%option%" key=clear | find /I "de la clave" > password.txt 2>nul

for /F "tokens=2 delims=:" %%c in (password.txt) do (
    echo.
    echo [+] La password password para la red %option% es:%%c
    echo.
    pause
)

:quehacer
echo.
choice /C SN /N /M "Desea visualiza password de otra red? [S = Si / N = No]: "

if errorlevel == 2 (
    del wifi_list.txt >nul 2>nul
    del wifi_selected.txt >nul 2>nul
    del password.txt >nul 2>nul
    
    goto salir
) else if errorlevel == 1 (
    goto show_available_wifi
)

:salir
REM Borrando todos los ficheros creados para el correcto funcionamiento del programa
if exist wifi_list.txt (
    del wifi_list.txt
)

if exist wifi_selected.txt (
    del wifi_selected.txt
)

if exist password.txt (
    del password.txt
)