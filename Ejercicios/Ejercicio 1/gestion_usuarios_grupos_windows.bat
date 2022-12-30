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
echo                [8] Configurar cuando expira una password de un usuario
echo                [9] Indicar si un usuario puede cambiar su password o no
echo                [10] Asignar una password random a un usuario
echo                [11] Establecer los dias que un usuario puede iniciar sesion
echo                [12] Agregar un comentario a un usuario
echo                [13] Filtrar por alguna cadena en la informacion de un usuario
echo                [14] Volver al menu principal
echo                [15] Salir del programa
echo *********************************************************************************
echo.

set /p users_options=Introduce una opcion: 

REM Filtrado de copciones de los usuaris
if %users_options% == 1 (
    goto ver_usuarios
) else if %users_options% == 2 (
    goto ver_info_users
) else if %users_options% == 3 (
    goto crear_usuario
) else if %users_options% == 4 (
    goto crear_usuario_fichero
) else if %users_options% == 5 (
    goto borrar_usuario
) else if %users_options% == 6 (
    goto borrar_usuario_fichero
) else if %users_options% == 7 (
    goto active_desactive_usuario
) else if %users_options% == 8 (
    goto password_expire_user
) else if %users_options% == 9 (
    goto password_change_yes_no
) else if %users_options% == 10 (
    goto random_password
) else if %users_options% == 11 (
    goto users_times_login
) else if %users_options% == 12 (
    goto comment_user
) else if %users_options% == 13 (
    goto string_filter_info_user
) else if %users_options% == 14 (
    goto helpPanel
) else if %users_options% == 15 (
    goto salir
) else (
    echo.
    echo [!] ERROR: Se esperaba un numero del 1-14
    echo.
    pause
    goto usuarios
)


:ver_usuarios
REM Opcion para visualizar todos los usuarios del sistema
echo.
echo [+] Visualizando usuarios del sistema
net user

goto quehacer

:ver_info_users
REM Opcion para visualizar la informacion de un usuario en concreto
echo.
set /p user=Introduce el nombre del usuario a visualizar: 

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
echo.
set /p user=Introduce el nombre del usuario a crear: 

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
echo.
set /p user=Introduce el nombre del usuario a borar: 

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
echo.
set /p user=Introduce el nombre del usuario: 

net user %user% >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe
    goto quehacer
)

if errorlevel == 1 (
    goto active_or_desactive_usuario
)

:active_or_desactive_usuario
REM Si esta activo el %errorlevel% == 0
REM Si NO esta activa el %errorlevel% == 1
net user %user% | find /I "parameter_counter activa" | find /I "no" >nul 2>nul

if errorlevel == 1 (
    echo.
    set /p desactive_user=[!] El usuario esta activo. Deseas desactivarlo? [S = Si / N = No]: 
    goto desactive_usuario
) 

if errorlevel == 0 (
    echo.
    set /p active_user=[!] El usuario esta desactivado. Deseas activarlo? [S = Si / N = No]: 
    goto active_usuario
)

:desactive_usuario
if %desactive_user% == S (
    goto desactive_usuario_yes
) else if %desactive_user% == s (
    goto desactive_usuario_yes
) else if %desactive_user% == N (
    goto quehacer
) else if %desactive_user% == n (
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
echo.
set /p user=Introduce el nombre del usuario: 

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
echo.
set /p user=Introduce el nombre del usuario por el cual quieres filtrar informacion: 

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
echo.
set /p user=Introduce el nombre del usuario: 

net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
) 

:question_day
echo.
set /p day=Introduce el dia en el que caducara la password del usuario (Introduce N para que no expire nunca): 

if %day% == N (
    goto never_expired
) else if %day% == n (
    goto never_expired
) else if %day% gtr 31 (
    goto error_day
) else if %day% lss 1 (
    goto error_day
)

:question_month
echo.
set /p month=Introduce el mes en el que caducara la password del usuario: 

if %month% gtr 12 (
    goto error_month
) else if %month% lss 0 (
    goto error_month
)

:question_year
echo.
set /p year=Introduce el ano en la que caducara la password del usuario: 

if %year% lss 0 (
    echo.
    echo [!] No puedes introducir un valor menor a 0
    goto question_year
)

net user %user% /expires:%day%/%month%/%year%

goto quehacer

:never_expired
echo.
net user %user% /expires:never

echo.
echo [+] El usuario %user% ahora no le caducara la password nunca
goto quehacer

:error_day
echo.
echo [!] ERROR: Debes introducir un numero entre 1-31
pause
goto question_day

:error_month
echo.
echo [!] ERROR: Debes introducir un numero entre 1-12
pause
goto question_month

:password_change_yes_no
REM Opcion para configurar si un usuario puede cambiar su password o no
echo.
set /p user=Introduce el nombre de usuario: 

net user | find /I "%user%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
)

:question_change_password
REM Pregunta para saber si lo que quieres es que pueda cambiar la password o no
echo.
set /p change_password_user=Desea que el usuario pueda cambiar la password? [S = Si / N = No]: 

if %change_password_user% == S (
    goto change_password_yes
) else if %change_password_user% == s (
    goto change_password_yes
) else if %change_password_user% == N (
    goto change_password_no
) else if %change_password_user% == n (
    goto change_password_no
) else (
    echo.
    echo [!] ERROR: Se esperaba S o N
    pause
    goto question_change_password
)

:change_password_yes
REM Opcion para configurar que el usuario pueda cambiar la password

net user | find /I "%user%" >nul 2>nul

if errorlevel == 0 (
    echo.
    net user %user% /passwordchg:yes
    echo [+] El usuario %user% ahora puede cambiar su password
    echo.
    pause
    goto quehacer
) else (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
)

:change_password_no
REM Opcion para configurar que el usuario no pueda cambiar la password

net user | find /I "%user%" >nul 2>nul

if errorlevel == 0 (
    echo.
    net user %user% /passwordchg:no
    echo [+] El usuario %user% ahora no puede cambiar su password
    echo.
    pause
    goto quehacer
) else (
    echo.
    echo [!] El usuario no existe actualmente
    echo.
    pause
    goto quehacer
)

:random_password
REM Opcion para asignarle una password random a un usuario
echo.
set /p user=Introduce el nombre del usuario: 

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
echo [+] Password random asignada correctamente al usuario %user%
echo.
pause
goto quehacer

:users_times_login
REM Opion para configurar cuando puede iniciar sesion un usuario
echo.
set /p user=Introduce el nombre del usuario: 

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
cls
echo.
echo ****************************************************************
echo                    OPCIONES PARA LOS DIAS 
echo ****************************************************************
echo                        L = Lunes
echo                        M = Martes
echo                        X = Miercoles
echo                        J = Jueves
echo                        V = Viernes
echo                        S = Sabado
echo                        D = Domingo
echo                        A = Todos los dias
echo                        N = Nunca
echo ****************************************************************
echo.

:question_times_day
set /p init_day=Desde que dia de la semana puede %user% iniciar sesion: 

if %init_day% == L (
    goto question_times_day_two
) else if %init_day% == L (
    goto question_times_day_two
)  else if %init_day% == M (
    goto question_times_day_two
)  else if %init_day% == m (
    goto question_times_day_two
)  else if %init_day% == X (
    goto question_times_day_two
)  else if %init_day% == x (
    goto question_times_day_two
)  else if %init_day% == J (
    goto question_times_day_two
)  else if %init_day% == j (
    goto question_times_day_two
) else if %init_day% == V (
    goto question_times_day_two
)  else if %init_day% == v (
    goto question_times_day_two
) else if %init_day% == S (
    goto question_times_day_two
)  else if %init_day% == s (
    goto question_times_day_two
)  else if %init_day% == D (
    goto question_times_day_two
)  else if %init_day% == d (
    goto question_times_day_two
) else if %init_day% == A (
    goto all_days
) else if %init_day% == a (
    goto all_days
) else if %init_day% == N (
    goto never_days
) else if %init_day% == n (
    goto never_days
)

:question_times_day_two
echo.
set /p end_day=Hasta que dia de la semana puede %user% iniciar sesion: 

if %end_day% == L (
    goto question_hours_times
) else if %end_day% == L (
    goto question_hours_times
)  else if %end_day% == M (
    goto question_hours_times
)  else if %end_day% == m (
    goto question_hours_times
)  else if %end_day% == X (
    goto question_hours_times
)  else if %end_day% == x (
    goto question_hours_times
)  else if %end_day% == J (
    goto question_hours_times
)  else if %end_day% == j (
    goto question_hours_times
) else if %end_day% == V (
    goto question_hours_times
)  else if %end_day% == v (
    goto question_hours_times
) else if %end_day% == S (
    goto question_hours_times
)  else if %end_day% == s (
    goto question_hours_times
)  else if %end_day% == D (
    goto question_hours_times
)  else if %end_day% == d (
    goto question_hours_times
) else if %end_day% == A (
    goto all_days
) else if %end_day% == a (
    goto all_days
) else if %end_day% == N (
    goto never_days
) else if %end_day% == n (
    goto never_days
)

:question_hours_times
cls
echo.
echo ****************************************************************
echo                 INSTRUCCIONES PARA LA HORA
echo ****************************************************************
echo.
echo [!] Deberas introducir la hora en formato 24h. Ejemplo: 23 para las 11 de la noche u 11 para las 11 de la mañana
echo.
pause

echo.
set /p init_hours=Desde que hora el usuario %user% puede iniciar sesion: 

if %init_hours% gtr 23 (
    goto error_user_times_hours
) else if %init_hours% lss 0 (
    goto error_user_times_hours
)

:question_hours_times_two
echo.
set /p end_hours=Hasta que hora el usuario %user% puede iniciar sesion: 

if %end_hours% gtr 23 (
    goto error_user_times_hours
) else if %end_hours% lss 0 (
    goto error_user_times_hours
)

net user %user% /times:%init_day%-%end_day%,%init_hours%-%end_hours%

goto quehacer

:all_days
net user %user% /times:all
echo.
echo [+] El usuario %user% podra iniciar sesion todos los dias
echo.
goto quehacer

:never_days
net user %user% /times:
echo.
echo [+] El usuario %user% no podra iniciar sesion ninguno de los dias
echo.
goto quehacer

:error_user_times_days
echo.
echo [!] ERROR: Se esperaba L, M, X, J, V, S, D, A o N
pause
goto menu_dias

:error_user_times_days_two
echo.
echo [!] ERROR: Se esperaba L, M, X, J, V, S, D, A o N
pause
goto menu_dias

:error_user_times_hours
echo.
echo [!] ERROR: Se esperaba un numero entre 0-23
pause
goto question_hours_times

:error_user_times_hours_two
echo.
echo [!] ERROR: Se esperaba un numero entre 0-23
pause
goto question_hours_times_two

:quehacer_users_times


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
) else if %groups_options% == 2 (
    goto ver_info_grupo
) else if %groups_options% == 3 (
    goto crear_grupo
) else if %groups_options% == 4 (
    goto crear_grupos_fichero
) else if %groups_options% == 5 (
    goto borrar_grupo
) else if %groups_options% == 6 (
    goto borrar_grupos_fichero
) else if %groups_options% == 7 (
    goto add_users_to_localgroup
) else if %groups_options% == 8 (
    goto delete_users_to_localgroup
) else if %groups_options% == 9 (
    goto comment_to_group
) else if %groups_options% == 10 (
    goto string_filter_info_grupo
) else if %groups_options% == 11 (
    goto helpPanel
) else if %groups_options% == 12 (
    goto salir
) else (
    echo.
    echo [!] ERROR: Se esperaba un numero del 1-8
    echo.
    pause
    goto usuarios
)

:ver_grupos
REM Opcion para visualizar los grupos locales del sistema
echo.
echo [+] Visualizando grupos del sistema
net localgroup

goto quehacer
:ver_info_grupo
REM Opcion para visualizar la informacion de un grupo local del sistema

echo.
set /p group_name=Introduce el nombre del grupo a visualizar su informacion: 

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
echo.
set /p group_name=Introduce el nombre del grupo a crear: 

REM Comprobacion de si el grupo existe
net localgroup | find /I "%group_name%" >nul 2>nul

if errorlevel == 1 (
    echo.
    net localgroup %group_name% /add
    echo [+] Grupo creado correctamente
    echo.   
    pause
    goto quehacer
) else (
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
echo.
set /p group_name=Introduce el nombre del grupo que deseas borrar: 

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
echo.
set /p group=Introduce el nombre del grupo local: 

net localgroup | find /I "%group%" >nul 2>nul

if errorlevel == 1 (
    echo.
    echo [!] ERROR: El grupo no existe actualmente
    echo.
    goto quehacer
)

echo.
set /p comment_to_group=Introduce el comentario a agregar al grupo %group%: 

net localgroup %group% /comment:"%comment_to_group%"

goto quehacer

:string_filter_info_grupo
REM Opcion para filtrar por alguna cadena de texto en la informacion de un grupo (net localgroup %user%)
echo.
set /p group_name=Introduce el nombre del grupo por el cual quieres filtrar informacion: 

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
REM Opcion para añadir a un usuario dentro de un grupo local
echo.
set /p group=Introduce el nombre del grupo: 

net localgroup | find /I "%group%" >nul 2>nul

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

net localgroup %group% %user% /add

:delete_users_to_localgroup
REM Opcion para eliminar a un usuario de de un grupo local

echo.
set /p group=Introduce el nombre del grupo: 

net localgroup | find /I "%group%" >nul 2>nul

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

net localgroup %group% %user% /delete

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
echo.