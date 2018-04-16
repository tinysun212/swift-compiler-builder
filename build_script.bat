rem build_script

IF "%PLATFORM%" == "mingw64" (
  CALL %APPVEYOR_BUILD_FOLDER%\build_script_mingw.bat
) else (
  CALL %APPVEYOR_BUILD_FOLDER%\build_script_cygwin.bat
)
