rem install

rem Set Environment
echo %PLATFORM% & time /t
SET PATH_ORIGINAL=%PATH%
SET "PATH_MINGW64=c:\msys64\mingw64\bin;c:\msys64\usr\bin"
SET PATH=%PATH_MINGW64%;%PATH_ORIGINAL%
SET MINGW64_DIR=c:/msys64/mingw64
SET WORK_DIR=c:\projects
SET WORK_DIR_SLASH=c:/projects
SET GIT_TAG_OR_BRANCH=swift-4.0.3+mingw.20180212
SET TAG_OR_BRANCH_IN_FOLDER=swift-4.0.3-mingw.20180212  
CD %WORK_DIR%
  
rem Install packages
pacman -S --noconfirm mingw-w64-x86_64-cmake
pacman -S --noconfirm mingw-w64-x86_64-ninja
pacman -S --noconfirm mingw-w64-x86_64-clang
pacman -S --noconfirm mingw-w64-x86_64-icu         
pacman -S --noconfirm mingw-w64-x86_64-libxml2     
pacman -S --noconfirm mingw-w64-x86_64-wineditline 
pacman -S --noconfirm mingw-w64-x86_64-winpthreads 
pacman -S --noconfirm mingw-w64-x86_64-pkg-config  
pacman -S --noconfirm mingw-w64-x86_64-dlfcn
pacman -S --noconfirm python                       
pacman -S --noconfirm mingw-w64-x86_64-python2
  
rem Patch GCC header
rem __float128 is undefined in clang (https://github.com/Alexpux/MINGW-packages/pull/1833)
sed -i "s;defined(_GLIBCXX_USE_FLOAT128)$;defined(_GLIBCXX_USE_FLOAT128) \&\& !defined\(__clang__\);" %MINGW64_DIR%/include/c++/*/type_traits
sed -i "s;defined(_GLIBCXX_USE_FLOAT128)$;defined(_GLIBCXX_USE_FLOAT128) \&\& !defined\(__clang__\);" %MINGW64_DIR%/include/c++/*/bits/std_abs.h
  
rem Download source
rem llvm source
wget -q -O llvm_src.tar.gz https://github.com/tinysun212/swift-llvm/archive/%GIT_TAG_OR_BRANCH%.tar.gz
tar zxf llvm_src.tar.gz
MOVE swift-llvm-%TAG_OR_BRANCH_IN_FOLDER% llvm

rem clang source
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
git clone https://github.com/apple/swift-cmark.git %WORK_DIR%/cmark
CD %WORK_DIR%/cmark & git checkout -qf master & cd ..

rem swift source
git clone https://github.com/tinysun212/swift-windows.git %WORK_DIR%/swift
CD %WORK_DIR%/swift & git checkout -qf %GIT_TAG_OR_BRANCH% & cd ..
