rem after_build

IF "%PLATFORM%" == "mingw64" (
  CALL after_build_mingw.bat
) else (
  CALL after_build_cygwin.bat
)
