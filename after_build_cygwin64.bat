rem after_build

rem Convert absolute path to relative path in newlib.modulemap
CD %WORK_DIR%/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/lib/swift/cygwin/x86_64
sed -i -e 's;/cygdrive/c/cygwin64;../../../../..;' newlib.modulemap

rem Replace the linked clang headers to the real files 
CD %WORK_DIR%/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/lib/swift
rm clang
cp -rp %WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/llvm-cygwin-x86_64/lib/clang/4.0.0 clang

rem Archiving to swift.zip
CD %WORK_DIR%/build/Ninja-ReleaseAssert
mv swift-cygwin-x86_64 usr
7z a swift.zip usr/bin/swift.exe usr/bin/*.dll usr/lib/swift
mv swift.zip %APPVEYOR_BUILD_FOLDER%
