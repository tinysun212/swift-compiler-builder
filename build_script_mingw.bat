rem build_script

rem Build cmark
MKDIR %WORK_DIR%\build\NinjaMinGW\cmark
CD %WORK_DIR%/build/NinjaMinGW/cmark
cmake -G Ninja -D CMAKE_BUILD_TYPE=RELEASE -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ %WORK_DIR_SLASH%/cmark
ninja
cd src
cp -p libcmark.dll.a libcmark.a
cp -p libcmark.a %WORK_DIR%/swift/libcmark.a

rem llvm source (need for cmake/modules/LLVM-Config.cmake at least)
rem clang source (error at cmake/modules/SwiftSharedCMakeConfig.cmake:146)

rem Load llvm/clang lib
c:/msys64/usr/bin/mkdir -p %WORK_DIR%/build/NinjaMinGW/llvm
CD %WORK_DIR%/build/NinjaMinGW/llvm
wget -q https://ci.appveyor.com/api/projects/tinysun212/llvm-builder/artifacts/swift_llvm_bin.tar.gz
tar zxf swift_llvm_bin.tar.gz
  
rem Build swift
MKDIR %WORK_DIR%\build\NinjaMinGW\swift
CD %WORK_DIR%/build/NinjaMinGW/swift
rem cmark patch
MKDIR bin & cp -p %WORK_DIR_SLASH%/build/NinjaMinGW/cmark/src/libcmark.dll bin
cmake -G "Ninja" ../../../swift -DCMAKE_BUILD_TYPE=Release -DCMAKE_ASM_COMPILER=%WORK_DIR_SLASH%/build/NinjaMinGW/llvm/bin/clang.exe -DCMAKE_C_COMPILER=%WORK_DIR_SLASH%/build/NinjaMinGW/llvm/bin/clang.exe  -DCMAKE_CXX_COMPILER=%WORK_DIR_SLASH%/build/NinjaMinGW/llvm/bin/clang++.exe -DPKG_CONFIG_EXECUTABLE=%MINGW64_DIR%/bin/pkg-config -DICU_UC_INCLUDE_DIR=%MINGW64_DIR%include -DICU_UC_LIBRARY=%MINGW64_DIR%/lib/libicuuc.dll.a -DICU_I18N_INCLUDE_DIR=%MINGW64_DIR%/include -DICU_I18N_LIBRARY=%MINGW64_DIR%/lib/libicuin.dll.a -DSWIFT_INCLUDE_DOCS=FALSE -DSWIFT_PATH_TO_CMARK_BUILD=%WORK_DIR_SLASH%/build/NinjaMinGW/cmark -DSWIFT_PATH_TO_CMARK_SOURCE=%WORK_DIR_SLASH%/cmark -DSWIFT_PATH_TO_LLVM_SOURCE=%WORK_DIR_SLASH%/llvm -DSWIFT_PATH_TO_LLVM_BUILD=%WORK_DIR_SLASH%/build/NinjaMinGW/llvm -DSWIFT_STDLIB_ASSERTIONS:BOOL=TRUE %WORK_DIR_SLASH%/swift
ninja

rem Move *.dll.a from mingw/x86_64 to mingw
CD %WORK_DIR%/build/NinjaMinGW/swift/lib/swift/mingw/x86_64
MOVE *.dll.a ..
