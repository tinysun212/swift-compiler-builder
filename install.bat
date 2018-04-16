rem install

IF "%PLATFORM%" == "mingw64" (
  CALL %APPVEYOR_BUILD_FOLDER%\install_mingw.bat
) else (
  CALL %APPVEYOR_BUILD_FOLDER%\install_cygwin.bat
)
