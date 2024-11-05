@echo off
setlocal EnableDelayedExpansion

REM Set the HOST_PROJECT_PATH to the current directory and replace backslashes with forward slashes
set HOST_PROJECT_PATH=%CD%
set HOST_PROJECT_PATH=%HOST_PROJECT_PATH:\=/%

REM Calculate MD5 hash for ./dev/docker/make/Dockerfile and get the first 8 characters
FOR /F "skip=1 tokens=*" %%A IN ('certutil -hashfile ".\dev\docker\make\Dockerfile" MD5') DO (
    set MD5_HASH=%%A
    goto :break_make
)
:break_make
set MD5_MAKE=!MD5_HASH:~0,8!

REM Calculate MD5 hash for ./dev/docker/nodejs/Dockerfile and get the first 8 characters
FOR /F "skip=1 tokens=*" %%A IN ('certutil -hashfile ".\dev\docker\nodejs\Dockerfile" MD5') DO (
    set MD5_HASH=%%A
    goto :break_nodejs
)
:break_nodejs
set MD5_NODEJS=!MD5_HASH:~0,8!

REM Calculate MD5 hash for ./dev/docker/postgres/Dockerfile and get the first 8 characters
FOR /F "skip=1 tokens=*" %%A IN ('certutil -hashfile ".\dev\docker\postgres\Dockerfile" MD5') DO (
    set MD5_HASH=%%A
    goto :break_postgres
)
:break_postgres
set MD5_POSTGRES=!MD5_HASH:~0,8!

REM Run the Docker Compose command with the calculated environment variables
docker compose run ^
  --rm --no-deps ^
  -v /var/run/docker.sock:/var/run/docker.sock ^
  -e HOST_PROJECT_PATH="%HOST_PROJECT_PATH%" ^
  -e MD5_MAKE="%MD5_MAKE%" ^
  -e MD5_NODEJS="%MD5_NODEJS%" ^
  -e MD5_POSTGRES="%MD5_POSTGRES%" ^
  -e CHOKIDAR_USEPOLLING="true" ^
  make ^
  make %*

endlocal
