@echo off
setlocal enableextensions enabledelayedexpansion

REM no arguments: script always builds Windows / Desktop / 99.9.99
set IMAGE=windows
set FLAVOR=desktop
set VERSION=
set VARIANT=

REM set destination folder
set PKG_DIR="%cd%"\package
if not exist %PKG_DIR% (
    md %PKG_DIR%
)

REM move to the repo root (script's parent directory)
cd %~dp0\..

REM determine repo name
set CURRENTDIR="%cd%"
for /F "delims=" %%i in ("%cd%") do set REPO=%%~nxi

REM check to see if there's already a built image
set TEMPFILE=%TEMP%\docker-compile~%RANDOM%.txt
docker images %REPO%:%IMAGE% --format "{{.ID}}" > %TEMPFILE%
set /p IMAGEID= < %TEMPFILE%
del %TEMPFILE%
if DEFINED IMAGEID (
    echo Found image %IMAGEID% for %REPO%:%IMAGE%.
) else (
    echo No image found for %REPO%:%IMAGE%.
)

REM get build arg env vars, if any
if defined DOCKER_GITHUB_LOGIN (
    set "BUILD_ARGS=--build-arg GITHUB_LOGIN=%DOCKER_GITHUB_LOGIN%"
    echo "!BUILD_ARGS!"
)

REM rebuild the image if necessary
docker build --tag %REPO%:%IMAGE% --file docker\jenkins\Dockerfile.%IMAGE% %BUILD_ARGS% -m 2GB .

REM set up build flags
git rev-parse HEAD > %TEMPFILE%
set /p GIT_COMMIT= < %TEMPFILE%
del %TEMPFILE%
set BUILD_ID=local

REM infer make parallelism
set "MAKEFLAGS=-j%NUMBER_OF_PROCESSORS%

REM remove previous image if it exists
set CONTAINER_ID=build-%REPO%-%IMAGE%
echo Cleaning up container %CONTAINER_ID% if it exists...
docker rm %CONTAINER_ID%

REM run compile step
for %%A in ("%cd%") do set HOSTPATH=%%~sA
docker run -it --name %CONTAINER_ID% -v %HOSTPATH%:c:/src %REPO%:%IMAGE%

REM extract logs to get filename (should be on the last line)
REM TODO

REM stop the container
docker stop %CONTAINER_ID%
echo Container image saved in %CONTAINER_ID%.
