@echo off

setlocal EnableDelayedExpansion

set QT_VERSION=5.11.1
set QT_FILE=qt-unified-windows-x86-3.0.4-online.exe

call :DetectQt foundQt
if "!foundQt!" == "false" (
  wget %WGET_ARGS% %BASEURL%%QT_FILE%
  echo "Installing Qt, this will take a while."
  echo "Ignore warnings about QtAccount credentials."
  echo "Do not click on the setup interface, it is controlled by a script."
  %QT_FILE% --script qt-noninteractive-install-win.qs
  del %QT_FILE%
)
call :DetectQt foundQt
if "!foundQt!" == "false" (
  echo Qt installation failed, please re-run this script to try again.
  echo Or you can manually install with the Qt online installer and select
  echo the 64-bit Visual Studio 2017 and QtWebEngine components of
  echo %QT_VERSION%.
  exit /b 1
)
else (
  echo Qt %QT_VERSION% installed.
)
exit /b 0

:DetectQt
set "%~1=true"
set QT_SDK_DIR=C:\Qt%QT_VERSION%
set QT_SDK_DIR2=C:\Qt\Qt%QT_VERSION%
set QT_SDK_DIR3=C:\Qt\%QT_VERSION%
if not exist %QT_SDK_DIR% (
  if not exist %QT_SDK_DIR2% (
    if not exist %QT_SDK_DIR3% (
      set "%~1=false"
    )
  )
)
exit /b 0

