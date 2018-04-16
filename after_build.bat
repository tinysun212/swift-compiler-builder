rem after_build

IF "%PLATFORM%" == "mingw64" (
  CALL %APPVEYOR_BUILD_FOLDER%\after_build_mingw.bat
) else (
  CALL %APPVEYOR_BUILD_FOLDER%\after_build_cygwin.bat
)
