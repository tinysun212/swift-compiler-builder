rem install

rem Set Environment
echo %PLATFORM% & time /t
SET PATH_ORIGINAL=%PATH%
SET "PATH_CYGWIN64=c:\cygwin64\bin"
SET PATH=%PATH_CYGWIN64%;%PATH_ORIGINAL%
SET WORK_DIR=c:\projects
SET WORK_DIR_IN_CYGWIN=/cygdrive/c/projects
SET CYGWIN64_DIR=/cygdrive/c/cygwin64
SET GIT_TAG_OR_BRANCH=swift-4.0.3+cygwin.20180212
SET TAG_OR_BRANCH_IN_FOLDER=swift-4.0.3-cygwin.20180212
CD %WORK_DIR%
  
rem Install packages
C:\cygwin64\setup-x86_64.exe -qnNdO -R C:/cygwin64 -s http://cygwin.mirror.constant.com -l C:/cygwin64/var/cache/setup ^
    -P cmake            ^
    -P ninja            ^
    -P clang            ^
    -P pkg-config       ^
    -P python           ^
    -P wget             ^
    -P libiconv-devel   ^
    -P libicu-devel     ^
    -P libxml2          ^
    -P libedit-devel    ^
    -P python           ^
    -P gcc              ^
    -P g++

rem workaround for llvm-tblgen.exe error "Unknown pseudo relocation protocol version 256."
wget -q http://cygwin.mirror.constant.com/x86_64/release/binutils/binutils-2.25-4.tar.xz
tar -x -C / -f binutils-2.25-4.tar.xz
      
rem Download source
CD %WORK_DIR%

rem llvm source (need for cmake/modules/LLVM-Config.cmake at least)
wget -q -O llvm_src.tar.gz https://github.com/tinysun212/swift-llvm/archive/%GIT_TAG_OR_BRANCH%.tar.gz
tar zxf llvm_src.tar.gz
MOVE swift-llvm-%TAG_OR_BRANCH_IN_FOLDER% llvm

rem clang source (error at cmake/modules/SwiftSharedCMakeConfig.cmake:146)
wget -q -O clang_src.tar.gz https://github.com/tinysun212/swift-clang/archive/%GIT_TAG_OR_BRANCH%.tar.gz
rem The Windows native symbolic link system cann't create a symbolic link to non-exist target.
rem 7z solved this problem by creating empty file.
7z x clang_src.tar.gz -so | 7z x -si -ttar -bd -bso0
MOVE pax_global_header clang_commit_id
MOVE swift-clang-%TAG_OR_BRANCH_IN_FOLDER% clang

rem link clang into llvm
CD %WORK_DIR%/llvm/tools
MKLINK /d clang ..\..\clang

rem cmark source
git clone https://github.com/apple/swift-cmark.git %WORK_DIR_IN_CYGWIN%/cmark
CD %WORK_DIR%/cmark & git checkout -qf master & CD ..

rem swift source
git clone https://github.com/tinysun212/swift-windows.git %WORK_DIR_IN_CYGWIN%/swift
CD %WORK_DIR%/swift & git checkout -qf %GIT_TAG_OR_BRANCH% & CD ..
