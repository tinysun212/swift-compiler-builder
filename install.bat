rem install

IF "%PLATFORM%" == "mingw64" (
  CALL install_mingw.bat
) else (
  CALL install_cygwin.bat
)
