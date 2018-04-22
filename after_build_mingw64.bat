rem after_build

rem Convert absolute path to relative path in mingw_crt.modulemap
CD %WORK_DIR%/build/NinjaMinGW/swift/lib/swift/mingw/x86_64
sed -i -e 's;c:/msys64;../../../../..;' mingw_crt.modulemap
rem Archiving to swift.zip
CD %WORK_DIR%/build/NinjaMinGW
mv swift usr
7z a swift.zip usr/bin/swift.exe usr/bin/swift-demangle.exe usr/bin/*.dll usr/lib/swift
mv swift.zip %APPVEYOR_BUILD_FOLDER%
