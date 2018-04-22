rem build_script

rem Build cmark
MKDIR %WORK_DIR%\build\Ninja-ReleaseAssert\cmark-cygwin-x86_64
CD %WORK_DIR%/build/Ninja-ReleaseAssert/cmark-cygwin-x86_64
cmake -G Ninja -D CMAKE_BUILD_TYPE=RELEASE -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ %WORK_DIR_IN_CYGWIN%/cmark
ninja
CD src
cp -p libcmark.dll.a libcmark.a
cp -p libcmark.a %WORK_DIR_IN_CYGWIN%/swift/libcmark.a

rem Load llvm/clang lib
MKDIR %WORK_DIR%\build\Ninja-ReleaseAssert\llvm-cygwin-x86_64
CD %WORK_DIR%/build/Ninja-ReleaseAssert/llvm-cygwin-x86_64

rem Get llvm-builder-cygwin artifact
SET JOB_NAME=Environment: BUILD_TARGET=cygwin64
wget -q -O swift_llvm_bin.tar.gz https://ci.appveyor.com/api/projects/tinysun212/llvm-builder/artifacts/swift_llvm_bin.tar.gz?job="%JOB_NAME%"
tar zxf swift_llvm_bin.tar.gz

rem Make the include path `/usr/lib/gcc/i686-pc-cygwin/4.7.3/inlcude/c++/i686-pc-cygwin` exist.
CD c:/cygwin64/lib/gcc
MKLINK /D i686-pc-cygwin x86_64-pc-cygwin
CD i686-pc-cygwin
MKLINK /D 4.7.3 6.4.0
CD 4.7.3/include/c++
MKLINK /D i686-pc-cygwin x86_64-pc-cygwin
  
rem Build swift
MKDIR %WORK_DIR%\build\Ninja-ReleaseAssert\swift-cygwin-x86_64
CD %WORK_DIR%/build/Ninja-ReleaseAssert/swift-cygwin-x86_64
  
rem cmark patch
MKDIR bin
cp -p %WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/cmark-cygwin-x86_64/src/cygcmark-0.22.0.dll bin
cmake -G "Ninja" ../../../swift -DCMAKE_CXX_FLAGS="-mcmodel=large" -DCMAKE_BUILD_TYPE=Release                ^
    -DCMAKE_ASM_COMPILER=%WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/llvm-cygwin-x86_64/bin/clang.exe     ^
    -DCMAKE_C_COMPILER=%WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/llvm-cygwin-x86_64/bin/clang.exe       ^
    -DCMAKE_CXX_COMPILER=%WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/llvm-cygwin-x86_64/bin/clang++.exe   ^
    -DPKG_CONFIG_EXECUTABLE=%CYGWIN64_DIR%/bin/pkg-config                                                    ^
    -DICU_UC_INCLUDE_DIR=%CYGWIN64_DIR%/include -DICU_UC_LIBRARY=%CYGWIN64_DIR%/lib/libicuuc.dll.a           ^
    -DICU_I18N_INCLUDE_DIR=%CYGWIN64_DIR%/include -DICU_I18N_LIBRARY=%CYGWIN64_DIR%/lib/libicui18n.dll.a     ^
    -DSWIFT_INCLUDE_DOCS=FALSE                                                                               ^
    -DSWIFT_PATH_TO_CMARK_BUILD=%WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/cmark-cygwin-x86_64           ^
    -DSWIFT_PATH_TO_CMARK_SOURCE=%WORK_DIR_IN_CYGWIN%/cmark                                                  ^
    -DSWIFT_PATH_TO_LLVM_SOURCE=%WORK_DIR_IN_CYGWIN%/llvm                                                    ^
    -DSWIFT_PATH_TO_LLVM_BUILD=%WORK_DIR_IN_CYGWIN%/build/Ninja-ReleaseAssert/llvm-cygwin-x86_64             ^
    -DSWIFT_STDLIB_ASSERTIONS:BOOL=TRUE                                                                      ^
    %WORK_DIR_IN_CYGWIN%/swift
ninja

rem Build fake Glibc
CD %WORK_DIR%/build/Ninja-ReleaseAssert/swift-cygwin-x86_64/lib/swift/cygwin/x86_64
ECHO @_exported import Newlib > Glibc.swift
env ../../../../bin/swiftc -parse-as-library -emit-module Glibc.swift
  
rem Move *.dll.a from cygwin/x86_64 to cygwin
MOVE *.dll.a ..
