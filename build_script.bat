rem build_script

IF "%PLATFORM%" == "mingw64" (
  CALL build_script_mingw.bat
) else (
  CALL build_script_cygwin.bat
)
