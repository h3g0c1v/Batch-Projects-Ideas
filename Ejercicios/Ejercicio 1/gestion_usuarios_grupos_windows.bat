@echo off
cls
REM Programa que nos permite gestionar los usuarios y los grupos de manera sencilla con los comandos net user y net localgroup
:info_administrator
echo.
echo ******************************************************************
echo [*] Asegurate de estar corriendo el programa como Administrador
echo ******************************************************************
echo.
pause

:helpPanel
cls
echo.
echo **************************************************
echo                OPCIONES DISPONIBLES
echo **************************************************
echo                [1] Gestion de Usuarios
echo                [2] Gestion de Grupos
echo                [3] Salir
echo **************************************************
echo.

set /p option=Introduce una opcion: 

if %option% == 1 (
    goto usuarios
) else if %option% == 2 (
    goto grupos
) else if %option% == 3 (
    goto salir
) else (
    echo.
    echo [!] ERROR: Se esperaba 1, 2 o 3
    echo.
    pause
    goto helpPanel
)


REM OPCIONES DE GESTION DE USUARIOS
:usuarios
cls
echo.
echo *********************************************************************************
echo                        GESTION DE USUARIOS
echo *********************************************************************************
echo                [1] Visualizar todos los usuarios
echo                [2] Visualizar informacion de un usuario
echo                [3] Crear un usuario
echo                [4] Crear usuarios a partir de un fichero
echo                [5] Borrar un usuario
echo                [6] Borrar usuarios a partir de un fichero
echo                [7] Activar/Desactivar un usuario
echo                [8] Configurar cuando expira la cuenta de un usuario
echo                [9] Indicar si un usuario puede cambiar su password o no
echo                [10] Crear usuarios automaticamente
echo                [11] Indicar si la password de un usuario debe ser requerida o no
echo                [12] Asignar una password a un usuario
echo                [13] Asignar una password random a un usuario
echo                [14] Establecer los dias que un usuario puede iniciar sesion
echo                [15] Agregar un comentario a un usuario
echo                [16] Filtrar por alguna cadena en la informacion de un usuario
echo                [17] Volver al menu principal
echo                [18] Salir del programa
echo *********************************************************************************
echo.

set /p users_options=Introduce una opcion: 

REM Filtrado de copciones de los usuarios
if %users_options% == 1 (
    goto ver_usuarios
) else if %users_options% == 4 (
    goto crear_usuario_fichero
) else if %users_options% == 6 (
    goto borrar_usuario_fichero
) else if %users_options% == 10 (
    goto automatically_users
) else if %users_options% == 17 (
    goto helpPanel
) else if %users_options% == 18 (
    goto salir
) else if %users_options% lss 1 (
    goto error_options
)  else if %users_options% gtr 18 (
    goto error_options
)

:pregunta_user
echo.
set /p user=Introduce el nombre del usuario (V para volver): 

if %user% == V (
    goto usuarios
) else if %user% == v (
    goto usuarios
) else if %users_options% == 2 (
    goto ver_info_users
) else if %users_options% == 3 (
    goto crear_usuario
) else if %users_options% == 5 (
    goto borrar_usuario
) else if %users_options% == 7 (
    goto active_desactive_usuario
) else if %users_options% == 8 (
    goto password_expire_user
) else if %users_options% == 9 (
    goto password_change_yes_no
) else if %users_options% == 11 (
    goto password_requiered_yes_no
) else if %users_options% == 12 (
    goto password_user_change
) else if %users_options% == 13 (
    goto random_password
) else if %users_options% == 14 (
    goto users_times_login
) else if %users_options% == 15 (
    goto comment_user
) else if %users_options% == 16 (
    goto string_filter_info_user
) else (
    goto error_options
)

:error_options
echo.
echo [!] ERROR: Se esperaba un numero del 1-18
echo.
pause
goto usuarios

:ver_usuarios
REM Opcion para visualizar todos los usuarios del sistema
echo.
echo [+] Visualizando usuarios del sistema
net user | more

goto quehacer

:ver_info_users
REM Opcion para visualizar la informacion de un usuario en concreto
REM Comprobacion de si el usuario existe
net user %user% >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe ...
    echo.
    pause
    goto quehacer
)

if errorlevel == 0 (
    echo.
    echo [+] Visualizando la informacion del usuario %user%
    echo.
    net user %user%
    goto quehacer
)

:crear_usuario
REM Opcion para crear un usuario
REM Comprobacion de si el usuario existe
net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    net user %user% /add *
    echo [+] Usuario creado correctamente
    echo.
    pause
    goto quehacer
) else (
    echo.
    echo [!] El usuario existe actualmente
    echo.
    pause
    goto quehacer
)

:crear_usuario_fichero
REM Opcion para crear un usuario a partir de un fichero (apellido1 apellido2, nombre)
echo.
set /p password=Escribe un password para todos los usuarios: 
echo.
set /p password_validate=Escribe nuevamente la password: 

if %password% neq %password_validate% (
   echo.
   echo [!] Las passwords no coinciden
   goto crear_usuario_fichero
)

echo.
set /p filename=Introduce el nombre del fichero de usuarios: 
set /a parameter_counter=0

for /F "tokens=1,3" %%a in (%filename%) do (
    net user | find /I "%%a" >nul 2>nul

    if errorlevel == 1 (
        net user %%b%%a /add %password% >nul 2>nul
        echo %%b%%a >> users_good.txt
    ) else (
        echo    - %%b%%a >> users_fails.txt
    )
)

if not exist users_good.txt (
    goto continue_usuario_fichero
)

:lines_files_good_users
for /f %%x in (users_good.txt) do set /a parameter_counter=1+parameter_counter
set total_counter=%parameter_counter%
del users_good.txt

if exist users_fails.txt (
    echo.
    echo [!] Ha habido algunos usuarios que no se han creado correctamente
    echo.
    set /p users_fails_question=Desea visualizar que usuarios han fallado? [S = Si / N = No]: 
    goto show_users_fails
) else (
    echo.
    echo [+] La password de los usuarios creados es: %password%
    echo.
    echo [+] %parameter_counter% usuarios creados correctamente
)

goto quehacer

:continue_usuario_fichero
echo.
echo [+] %parameter_counter% usuarios creados correctamente

:show_users_fails
if %users_fails_question% == S (
    goto show_file_users_fails
) else if %users_fails_question% == s (
    goto show_file_users_fails
) else if %users_fails_question% == N (
    goto not_show_file_users_fails
) else if %users_fails_question% == n (
    goto not_show_file_users_fails
) else (
    echo.
    echo [!] ERROR: Se esperaba S o N
    pause
    goto show_users_fails
)

:show_file_users_fails
echo.
echo [+] Los usuarios que han fallado son: 
echo.
type users_fails.txt
echo.
del users_fails.txt

goto quehacer

:not_show_file_users_fails
del users_fails.txt

goto quehacer

:borrar_usuario
REM Opcion para borrar un usuario
REM Comprobacion de si el usuario existe
net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
) else (
    echo.
    net user %user% /delete
    echo [+] Usuario borrado correctamente
    echo.
    pause
    goto quehacer
)

:borrar_usuario_fichero
REM Opcion para borrar usuarios a partir de un fichero (apellido1 apellidos2,nombre)
echo.
set /p filename=Introduce el nombre del fichero de usuarios a borrar: 
set /a parameter_counter=0

for /F "tokens=1,3" %%a in (%filename%) do (
    net user | find /I "%%a" >nul 2>nul

    if errorlevel == 1 (
        echo    - %%b%%a >> users_fails_delete.txt
    ) else (
        net user %%b%%a /delete >nul 2>nul
        echo %%b%%a >> users_good_delete.txt
    )
)

if not exist users_good_delete.txt (
    goto continue_usuario_borrar_fichero
)

:lines_files_good_users_deleted
for /f %%x in (users_good_delete.txt) do set /a parameter_counter=1+parameter_counter
set total_counter=%parameter_counter%
del users_good_delete.txt

:continue_usuario_borrar_fichero
echo.
echo [+] %parameter_counter% usuarios borrados correctamente

if exist users_fails_delete.txt (
    echo.
    echo [!] Ha habido algunos usuarios que no se han creado correctamente
    echo.
    set /p users_fails_question=Desea visualizar que usuarios han fallado? [S = Si / N = No]: 
    goto show_users_fails_deleted
) else (
    echo.
    echo [+] %parameter_counter% usuarios creados correctamente
)

goto quehacer

:show_users_fails_deleted
if %users_fails_question% == S (
    goto show_file_users_fails
) else if %users_fails_question% == s (
    goto show_file_users_fails
) else if %users_fails_question% == N (
    goto not_show_file_users_fails
) else if %users_fails_question% == n (
    goto not_show_file_users_fails
) else (
    echo.
    echo [!] ERROR: Se esperaba S o N
    pause
    goto show_users_fails
)

:show_file_users_fails
echo.
echo [+] Los usuarios que han fallado son: 
echo.
type users_fails_delete.txt
echo.
del users_fails_delete.txt

goto quehacer

:not_show_file_users_fails
del users_fails_delete.txt

goto quehacer

:active_desactive_usuario
REM Opcion para activar o desactivar un usuario
net user %user% >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe
    goto quehacer
)

:active_or_desactive_usuario
REM Si esta activo el %errorlevel% == 0
REM Si NO esta activa el %errorlevel% == 1
net user %user% | find /I "activa" | find /I "no" >nul 2>nul

if errorlevel == 1 (
    set v1=activo
    set v2=desactivarlo
    set v3=no
    set v4=desactive_usuario_yes
) else (
    set v1=desactivado
    set v2=activarlo
    set v3=yes
    set v4=active_usuario_yes
)

echo.
set /p active_or_desactive_user=[!] El usuario esta %v1%. Deseas %v2%? [S = Si / N = No]: 

if %active_or_desactive_user% == S (
    goto %v4%
) else if %active_or_desactive_user% == s (
    goto %v4%
) else if %active_or_desactive_user% == N (
    goto quehacer
) else if %active_or_desactive_user% == n (
    goto quehacer
) else (
    echo.
    echo ERROR: Se esperaba S o N
    echo.
    pause
    goto quehacer
)

:desactive_usuario_yes
echo.
echo [+] Desactivando usuario ...

net user %user% /active:no

echo [+] Usuario desactivado correctamente
echo.

goto quehacer

:active_usuario
if %active_user% == S (
    goto active_usuario_yes
) else if %active_user% == s (
    goto active_usuario_yes
) else if %active_user% == N (
    goto quehacer
) else if %active_user% == n (
    goto quehacer
) else (
    echo.
    echo ERROR: Se esperaba S o N
    echo.
    pause
    goto quehacer
)

:active_usuario_yes
echo.
echo [+] Activando usuario ...

net user %user% /active

echo [+] Usuario activado correctamente
echo.

goto quehacer
REM ------------------------------------------------------------------------------------------------------
REM FINALIZA LAS OPCIONES DE ACTIVAR O DESACTIVAR USUARIOS

:comment_user
REM Opcion para poner un comentario a un usuario
net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] ERROR: El usuario no existe actualmente
    echo.
    goto quehacer
)

echo.
set /p comment_to_user=Introduce el comentario a agregar al usuario %user%: 

net user %user% /comment:"%comment_to_user%"

goto quehacer

:string_filter_info_user
REM Opcion para filtrar por alguna cadena de texto en la informacion de un usuario (net user %user%)
REM Comprobacion de si el usuario existe
net user | find /I "%user%" >nul 2>nul
echo.
echo [+] Comprobando si el usuario existe ...

if errorlevel == 1 (
    echo.
    echo [!] ERROR: El usuario no existe actualmente
    echo.
    goto quehacer
)

echo.
set /p string=Introduce la cadena de texto que quieres filtrar: 

echo.
echo [+] Filtrando por la cadena "%string%" en el usuario "%user%"
echo.
net user %user% | find /I "%string%"
echo.
pause
goto quehacer

:password_expire_user
REM Opcion para configurar cuando expira la password de un usuario
net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
) 

for /F "tokens=4 delims= " %%x in ('net user %user% ^| find /i "cuenta expira"') do (
    echo.
    echo [+] La cuenta %user% expira el: %%x
    echo.
    pause
)

echo.
set /p si_o_no_cambiar=Desea cambiarla? [S/N]: 

if %si_o_no_cambiar% == N (
    goto helpPanel
) else if %si_o_no_cambiar% == n (
    goto helpPanel
)

:question_expired_date
echo.
set /p expired_date=Introduce la fecha de caducidad del usuario %user% (DD/MM/YY) (Introduce N para que no expire nunca) (V para volver): 

if %expired_date% == N (
    goto never_expired
) else if %expired_date% == n (
    goto never_expired
)

echo %expired_date% > date.txt

findstr /r [0-9][0-9][/][0-9][0-9][/][0-9][0-9] date.txt >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] ERROR: El formato de la fecha es incorrecto "DD/MM/YY"
    echo.
    pause
    goto question_expired_date
)

set day=%expired_date:~0,2%
set month=%expired_date:~3,2%
set year=%expired_date:~6,2%
set actual_year=%date:~8,2%

if %month% neq 4 if %month% neq 6 if %month% neq 9 if %month% neq 11 if %month% neq 2 set max_day=31 & goto date_check

if %month% equ 2 (
    for /l %%a in (24,4,99) do (
        if %%a == %year% (
            set max_day=29
            goto date_check
        ) else (
            set max_day=28
        )
    )
) else (
    set max_day=30
)

:date_check
if %day% lss 1 (
    goto error_day
) else if %day% gtr %max_day% (
    goto error_day
) else if %month% gtr 12 (
    goto error_month
) else if %month% lss 1 (
    goto error_month
)  else if %year% lss %actual_year% (
    goto error_year
)

net user %user% /expires:%day%/%month%/%year% 2>nul

goto quehacer

:never_expired
echo.
net user %user% /expires:never 2>nul >nul
echo.

echo [+] El usuario %user% ahora no le caducara nunca la cuenta.
goto quehacer

:error_day
echo.
echo [!] ERROR: El dia es incorrecto
echo.
pause
goto question_expired_date

:error_month
echo.
echo [!] ERROR: El mes es incorrecto
echo.
pause
goto question_expired_date

:error_year
echo.
echo [!] ERROR: Debes introducir un numero mayor al año actual
echo.
pause
goto question_expired_date

:password_change_yes_no
REM Opcion para configurar si un usuario puede cambiar su password o no
net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
)

REM Pregunta para saber si lo que quieres es que pueda cambiar la password o no
net user %user% | find /i "cambiar" | find /I "no" >nul 2>nul

if errorlevel == 1 (
    goto change_password_yes
) else (
    goto change_password_no
)


:change_password_yes
REM Opcion para configurar que el usuario pueda cambiar la password
echo.

set /p question_change=El usuario puede cambiar la password. Deseas que no que pueda cambiarla? [S/N]:

if %question_change% == S (
    goto change_password_no_command
) else if %question_change% == s (
    goto change_password_no_command
) else if %question_change% == N (
    goto usuarios
) else if %question_change% == n (
    goto usuarios
)

:change_password_no_command
net user %user% /passwordchg:no

echo [+] El usuario %user% ahora no puede cambiar la password
echo.
goto quehacer

:change_password_no
REM Opcion para configurar que el usuario no pueda cambiar la password
echo.
set /p question_change=El usuario no puede cambiar la password. Deseas que pueda cambiarla? [S/N]:

if %question_change% == S (
    goto change_password_yes_command
) else if %question_change% == s (
    goto change_password_yes_command
) else if %question_change% == N (
    goto usuarios
) else if %question_change% == n (
    goto usuarios
)

:change_password_yes_command
net user %user% /passwordchg:yes

echo [+] El usuario %user% ahora puede cambiar la password
echo.
goto quehacer

:automatically_users
REM PREGUNTAS
REM Nombre de los usuarios
REM Nº del que empezar
REM Cuantos usuarios quieres crear

echo.
set /p usernames=Introduce el nombre de los usuarios (V para volver): 

if %usernames% == V (
    goto quehacer
) else if %usernames% == v (
    goto quehacer
)

echo.
set /p first_number=Por que numero quieres empezar? (V para volver): 

if %first_number% == V (
    goto quehacer
) else if %first_number% == v (
    goto quehacer
)

echo.
set /p how_much_users=Cuantos usuarios quieres crear? (V para volver): 

if %how_much_users% == V (
    goto quehacer
) else if %how_much_users% == v (
    goto quehacer
)

echo.
echo [+] Creando usuarios, porfavor espere ...

set parameter_counter=0

set /a last_number=%first_number%+%how_much_users%

for /L %%y in (%first_number% 1 %last_number%) do (
    net user %usernames%%%y /add >nul 2>nul

    if errorlevel == 1 (
        set /a parameter_counter=parameter_counter+1
        echo    - %usernames%%%y >> bad_usernames.txt
    )
)

if exist bad_usernames.txt (
    goto usernames_not_creates
)

echo [+] Todos los usuarios se han creado correctamente
echo.
pause

goto quehacer

:usernames_not_creates
echo.
set /p show_bad_usernames=%parameter_counter% usuarios que no se han creado correctamente. Deseas visualizarlo? [S/N]: 

if %show_bad_usernames% == S (
    goto yes_show_bad_usernames
) else if %show_bad_usernames% == s (
    goto yes_show_bad_usernames
) else if %show_bad_usernames% == N (
    goto no_show_bad_usernames
) else if %show_bad_usernames% == n (
    goto no_show_bad_usernames
)

:yes_show_bad_usernames
echo.
type bad_usernames.txt
echo.
pause

del bad_usernames.txt
goto quehacer

:no_show_bad_usernames
goto quehacer
del bad_usernames.txt

:password_requiered_yes_no
REM Opcion para configurar si una cuenta de usuario requiere una contraseña o no
net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
)

net user %user% | find /I "requerida" | find /I "no" >nul 2>nul

if errorlevel == 1 (
    set yes_or_not=SI
    set not_or_yes_req=NO
    set params_no_yes=no
) else if errorlevel == 0 (
    set yes_or_not=NO
    set not_or_yes_req=SI
    set params_no_yes=yes
)

:password_req
REM Opcion para deshabilitar el requerimiento de la password
echo.
set /p question_password_req=La password para el usuario "%user%" %yes_or_not% esta requerida. Desea %not_or_yes_req% requerirla? [S/N]: 

if %question_password_req% == S (
    goto change_password_req
) else if %question_password_req% == s (
    goto change_password_req
) else if %question_password_req% == N (
    goto question_password_req
) else if %question_password_req% == n (
    goto question_password_req
) else (
    echo.
    echo [!] ERROR: Se esperaba S o N
)

:change_password_req
net user %user% /passwordreq:%params_no_yes%

echo [+] Ahora la password del usuario "%user%" %not_or_yes_req% sera requerida
echo.
pause

goto quehacer

:password_user_change
REM Opcion para cambiar la password a un usuario
net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
)

echo.
net user %user% *
echo [+] La password del usuario %user% ha sido cambiada correctamente
echo.
pause

goto quehacer

:random_password
REM Opcion para asignarle una password random a un usuario
net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
)

echo.
net user %user% /random > random_password.txt
type random_password.txt | find /i "es:"
echo.
del random_password.txt
echo [+] Password random asignada correctamente al usuario %user%
echo.
pause
goto quehacer

:users_times_login
REM Opion para configurar cuando puede iniciar sesion un usuario
net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
) else (
    goto menu_dias
)

:menu_dias
echo.
net user %user% | find /I "horas de inicio"& net user %user% | find /I "lunes" & net user %user% | find /I "martes" & net user %user% | find /I "rcoles" & net user %user% | find /I "jueves" & net user %user% | find /I "viernes" & net user %user% | find /I "bado" & net user %user% | find /I "domingo"
echo.
pause

echo.
set /p yes_or_not_change_days=Deseas cambiar los dias de conexion? [S/N]: 

if %yes_or_not_change_days% == S (
    goto question_times_day
) else if %yes_or_not_change_days% == s (
    goto question_times_day
) else if %yes_or_not_change_days% == N (
    goto quehacer
) else if %yes_or_not_change_days% == n (
    goto quehacer
)

:question_times_day
echo.
set /p init_day=Desde que dia de la semana puede "%user%" iniciar sesion [L/M/X/J/V/S/D/A/N/C]: 
echo %init_day% | findstr /r [LMXJVSDANClmxjvsdanc] >nul 2>nul

if errorlevel == 1 (
    goto error_user_times_days
) else if %init_day% == A (
    goto all_days
) else if %init_day% == a (
    goto all_days
) else if %init_day% == N (
    goto never_days
) else if %init_day% == n (
    goto never_days
) else if %init_day% == C (
    goto salir
) else if %init_day% == c (
    goto salir
)

:question_times_day_two
echo.
set /p end_day=Hasta que dia de la semana puede "%user%" iniciar sesion [L/M/X/J/V/S/D/A/N/C]: 
echo %end_day% | findstr /r [LMXJVSDANClmxjvsdanc] >nul 2>nul

if errorlevel == 1 (
    goto error_user_times_days_two
) else if %end_day% == A (
    goto all_days
) else if %end_day% == a (
    goto all_days
) else if %end_day% == N (
    set %end_day%=%init_day%
) else if %end_day% == n (
    set %end_day%=%init_day%
) else if %end_day% == C (
    goto salir
) else if %end_day% == c (
    goto salir
)

echo.
set /p yes_or_not_question_hours_times=Desea indica las horas de inicio de sesion? [S/N]: 

if %yes_or_not_question_hours_times% == N (
    goto command_net_user_times_without_hours
) else if %yes_or_not_question_hours_times% == n (
    goto command_net_user_times_without_hours
)

:question_hours_times
echo.
set /p init_hours=Desde que hora, el usuario "%user%", puede iniciar sesion [00-24/V]: 
echo %init_hours% | findstr /r [0-9]* || findstr /r [V] >nul 2>nul

if errorlevel == 1 (
    goto error_user_times_hours
) else if %init_hours% == V (
    goto quehacer
) else if %init_hours% == v (
    goto quehacer
) else if %init_hours% gtr 24 (
    goto error_user_times_hours
) else if %init_hours% lss 0 (
    goto error_user_times_hours
)

:question_hours_times_two
echo.
set /p end_hours=Hasta que hora el usuario "%user%" puede iniciar sesion [00-24/N/V]: 
echo %end_hours% | findstr /r [0-9]* || findstr /r [N] || findstr /r [V] >nul 2>nul

if errorlevel == 1 (
    goto error_user_times_hours_two
) else if %end_hours% == N (
    set end_hours=%init_hours%
) else if %end_hours% == n (
    set end_hours=%init_hours%
) else if %end_hours% == V (
    goto quehacer
) else if %end_hours% == v (
    goto quehacer
) else if %end_hours% gtr 24 (
    goto error_user_times_hours_two
) else if %end_hours% lss 0 (
    goto error_user_times_hours_two
)

net user %user% /time:%init_day%-%end_day%,%init_hours%-%end_hours% >nul

echo [+] Ahora el usuario "%user%" podra iniciar sesion entre %init_day%-%end_day% y entre las horas %init_hours%-%end_hours%
echo.   

goto quehacer

:command_net_user_times_without_hours
set init_hours=00
set end_hours=24
net user %user% /time:%init_day%-%end_day%,%init_hours%-%end_hours% >nul

echo [+] Ahora el usuario "%user%" podra iniciar sesion entre %init_day%-%end_day%
echo.

goto quehacer

:all_days
net user %user% /times:all >nul
echo.
echo [+] El usuario %user% podra iniciar sesion todos los dias
echo.
goto quehacer

:never_days
net user %user% /times: >nul
echo.
echo [+] El usuario %user% no podra iniciar sesion ninguno de los dias
echo.
goto quehacer

:error_user_times_days
echo.
echo [!] ERROR: Se esperaba L, M, X, J, V, S, D, A, N o C
echo.
pause
goto question_times_day

:error_user_times_days_two
echo.
echo [!] ERROR: Se esperaba L, M, X, J, V, S, D, A, N o C
echo.
pause
goto question_times_day_two

:error_user_times_hours
echo.
echo [!] ERROR: Se esperaba un numero entre 0-24 o V
echo.
pause
goto question_hours_times

:error_user_times_hours_two
echo.
echo [!] ERROR: Se esperaba un numero entre 0-24, V o N
echo.
pause
goto question_hours_times_two

:grupos
REM OPCIONES DE GESTION DE GRUPOS
cls
echo.
echo *********************************************************************************
echo                        GESTION DE GRUPOS
echo *********************************************************************************
echo                [1] Visualizar todos los grupos locales
echo                [2] Visualizar informacion de un grupo local
echo                [3] Crear un grupo local
echo                [4] Crear grupos locales a partir de un fichero
echo                [5] Borrar un grupo local
echo                [6] Borrar grupos locales a partir de un fichero
echo                [7] Agregar un usuario a un grupo local
echo                [8] Eliminar un usuario a un grupo local
echo                [9] Agregar un comentario a un grupo local
echo                [10] Filtrar por alguna cadena en la informacion de un grupo local
echo                [11] Volver al menu principal
echo                [12] Salir del programa
echo *********************************************************************************
echo.

set /p groups_options=Introduce una opcion: 

REM Filtrado de copciones de los usuaris
if %groups_options% == 1 (
    goto ver_grupos
) else if %groups_options% == 4 (
    goto crear_grupos_fichero
) else if %groups_options% == 6 (
    goto borrar_grupos_fichero
) else if %groups_options% == 11 (
    goto helpPanel
) else if %groups_options% == 12 (
    goto salir
) else if %groups_options% gtr 12 (
    goto error_groups
) else if %groups_options% lss 1 (
    goto error_groups
)

:pregunta_grupos
echo.
set /p group_name=Introduce el nombre del grupo local (V para volver): 

if %group_name% == V (
    goto grupos
) else if %group_name% == v (
    goto grupos
) else if %groups_options% == 2 (
    goto ver_info_grupo
) else if %groups_options% == 3 (
    goto crear_grupo
) else if %groups_options% == 5 (
    goto borrar_grupo
) else if %groups_options% == 7 (
    goto add_users_to_localgroup
) else if %groups_options% == 8 (
    goto delete_users_to_localgroup
) else if %groups_options% == 9 (
    goto comment_to_group
) else if %groups_options% == 10 (
    goto string_filter_info_grupo
)

:error_groups
echo.
echo [!] ERROR: Se esperaba un numero del 1-12
echo.
pause
goto grupos

:ver_grupos
REM Opcion para visualizar los grupos locales del sistema
echo.
echo [+] Visualizando grupos del sistema
net localgroup | more

goto quehacer

:ver_info_grupo
REM Opcion para visualizar la informacion de un grupo local del sistema
REM Comprobacion de si el grupo existe
net localgroup | find /I "%group_name%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El grupo no existe ...
    echo.
    pause
    goto quehacer
)

echo.
echo [+] Visualizando la informacion del grupo %group_name%
echo.

net localgroup %group_name%
goto quehacer

:crear_grupo
REM Opcion para crear un grupo local del sistema
REM Comprobacion de si el grupo existe
net localgroup "%group_name%" >nul 2>nul

if errorlevel == 2 (
    echo.
    net localgroup %group_name% /add 2>nul >nul
    echo [+] Grupo creado correctamente
    echo.   
    pause
    set groups_options=7
    goto continue_if_u_create_group_before
) else if errorlevel == 0 (
    echo.
    echo [+] El grupo existe actualmente
    echo.
    goto quehacer
)

:crear_grupos_fichero
REM Opcion para crear grupos a partir de un fichero (nombre del grupo)
echo.
set /p filename=Introduce el nombre del fichero de grupos: 
set /a parameter_counter=0

for /F %%a in (%filename%) do (
    net localgroup | find /I "%%a" >nul 2>nul

    if errorlevel == 1 (
        net localgroup %%a /add >nul 2>nul
        echo %%a >> groups_good.txt
    ) else (
        echo    - %%b%%a >> groups_fails.txt
    )
)

if not exist groups_good.txt (
    goto continue_usuario_fichero
)

:lines_files_good_groups
for /f %%x in (groups_good.txt) do set /a parameter_counter=1+parameter_counter
set total_counter=%parameter_counter%
del groups_good.txt

if exist groups_fails.txt (
    echo.
    echo [!] Ha habido algunos grupos que no se han creado correctamente
    echo.
    set /p groups_fails_question=Desea visualizar que grupos han fallado? [S = Si / N = No]: 
    goto show_groups_fails
) else (
    echo.
    echo [+] %parameter_counter% grupos creados correctamente
)

goto quehacer

:continue_usuario_fichero
echo.
echo [+] %parameter_counter% grupos creados correctamente

:show_groups_fails
if %groups_fails_question% == S (
    goto show_file_groups_fails
) else if %groups_fails_question% == s (
    goto show_file_groups_fails
) else if %groups_fails_question% == N (
    goto not_show_file_groups_fails
) else if %groups_fails_question% == n (
    goto not_show_file_groups_fails
) else (
    echo.
    echo [!] ERROR: Se esperaba S o N
    pause
    goto show_groups_fails
)

:show_file_groups_fails
echo.
echo [+] Los grupos que han fallado son: 
echo.
type groups_fails.txt
echo.
del groups_fails.txt

goto quehacer

:not_show_file_groups_fails
del groups_fails.txt

goto quehacer


:borrar_grupo
REM Opcion para borrar un grupo local del sistema
REM Comprobacion de si el grupo existe
net localgroup | find /I "%group_name%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [+] El grupo no existe actualmente
    echo.
    goto quehacer
) else (
    echo.
    net localgroup %group_name% /delete
    echo [+] Grupo borrado correctamente
    echo.
    pause
    goto quehacer
)

:borrar_grupos_fichero
REM Opcion para borrar grupos a partir de un fichero (nombre del grupo)
echo.
set /p filename=Introduce el nombre del fichero de grupos a borrar: 
set /a parameter_counter=0

for /F %%a in (%filename%) do (
    net localgroup | find /I "%%a" >nul 2>nul

    if errorlevel == 1 (
        echo    - %%a >> groups_fails_delete.txt
    ) else (
        net localgroup %%a /delete >nul 2>nul
        echo %%b%%a >> groups_good_delete.txt
    )
)

if not exist groups_good_delete.txt (
    goto continue_usuario_borrar_fichero
)

:lines_files_good_groups_deleted
for /f %%x in (groups_good_delete.txt) do set /a parameter_counter=1+parameter_counter
set total_counter=%parameter_counter%
del groups_good_delete.txt

:continue_usuario_borrar_fichero
echo.
echo [+] %parameter_counter% grupos borrados correctamente

if exist groups_fails_delete.txt (
    echo.
    echo [!] Ha habido algunos grupos que no se han creado correctamente
    echo.
    set /p groups_fails_question=Desea visualizar que grupos han fallado? [S = Si / N = No]: 
    goto show_groups_fails_deleted
) else (
    echo.
    echo [+] %parameter_counter% grupos creados correctamente
)

goto quehacer

:show_groups_fails_deleted
if %groups_fails_question% == S (
    goto show_file_groups_fails
) else if %groups_fails_question% == s (
    goto show_file_groups_fails
) else if %groups_fails_question% == N (
    goto not_show_file_groups_fails
) else if %groups_fails_question% == n (
    goto not_show_file_groups_fails
) else (
    echo.
    echo [!] ERROR: Se esperaba S o N
    pause
    goto show_groups_fails
)

:show_file_groups_fails
echo.
echo [+] Los grupos que han fallado son: 
echo.
type groups_fails_delete.txt
echo.
del groups_fails_delete.txt

goto quehacer

:not_show_file_groups_fails
del groups_fails_delete.txt

goto quehacer

:comment_to_group
REM Opcion para poner un comentario a un grupo local
net localgroup | find /I "%group_name%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] ERROR: El grupo no existe actualmente
    echo.
    goto quehacer
)

echo.
set /p comment_to_group=Introduce el comentario a agregar al grupo %group_name%: 

net localgroup %group_name% /comment:"%comment_to_group%"

goto quehacer

:string_filter_info_grupo
REM Opcion para filtrar por alguna cadena de texto en la informacion de un grupo (net localgroup %user%)
REM Comprobacion de si el usuario existe
echo.
echo [+] Comprobando si el grupo existe ...

net localgroup | find /I "%group_name%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] ERROR: El grupo no existe actualmente
    echo.
    goto quehacer
)

echo.
set /p string_group=Introduce la cadena de texto que quieres filtrar: 

echo.
echo [+] Filtrando por la cadena "%string%" en el usuario "%group_name%"
echo.
net localgroup %group_name% | find /I "%string_group%"
echo.
pause
goto quehacer

:add_users_to_localgroup
REM Opcion para agregar a un usuario dentro de un grupo local
net localgroup | find /I "%group_name%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [+] El grupo no existe actualmente
    echo.
    goto quehacer
)

:continue_if_u_create_group_before
echo.
set /p user=Introduce el nombre del usuario para agregar al grupo "%group_name%": 

net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe acutalmente
    echo.
    pause
    goto quehacer
)

net localgroup %group_name% | find "%user%" >nul 2>nul

if errorlevel == 1 (
    net localgroup %group_name% %user% /add 2>nul >nul

    echo.
    echo [+] Se ha agregado el usuario "%user%" correctamente al grupo "%group_name%"
    echo.
    pause

    goto helpPanel
) else if errorlevel == 0 (
    echo.
    echo [!] El usuario "%user%" ya pertenece al grupo "%group_name%"
    echo.
    pause

    goto helpPanel
)

:delete_users_to_localgroup
REM Opcion para eliminar a un usuario de de un grupo local
net localgroup | find /I "%group_name%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [+] El grupo no existe actualmente
    echo.
    goto quehacer
)

echo.
set /p user=Introduce el nombre del usuario: 

net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe acutalmente
    echo.
    pause
    goto quehacer
)

net localgroup %group_name% %user% /delete

:quehacer
REM Opcion por si el usuario ha finalizado la tarea o si se ha equivocado en alguna cosa
set /p quehacer=Que desea hacer ahora? [V = Volver al menu / S = Salir]: 

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
    echo [!] ERROR: Se esperaba V = Volver al menu / S = Salir del programa
    echo.
    pause
    goto quehacer
)

:error
REM Todos los que tengan algun fallo general, vendran aqui
echo.
echo [!] ERROR: Ha habido algun problema ...
echo.
pause

goto quehacer

:salir
echo.
echo [+] Saliendo ...
