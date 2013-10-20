#!/bin/sh

# turn on verbose debugging output for parabuild logs.
set -x
# make errors fatal
set -e

if [ -z "$AUTOBUILD" ] ; then 
    fail
fi

if [ "$OSTYPE" = "cygwin" ] ; then
    export AUTOBUILD="$(cygpath -u $AUTOBUILD)"
fi

# run build from root of checkout
cd "$(dirname "$0")"

# load autbuild provided shell functions and variables
set +x
eval "$("$AUTOBUILD" source_environment)"
set -x

top="$(pwd)"
case "$AUTOBUILD_PLATFORM" in
    windows*)
        if [ "$AUTOBUILD_PLATFORM" == "windows64" ]; then
            build_target="x64"
        else
            build_target="Win32"
        fi
        build_sln "glodlib.sln" "Debug|$build_target"
        build_sln "glodlib.sln" "Release|$build_target"
        mkdir -p stage/lib/{debug,release}
        cp "lib/debug/glod.lib" \
            "stage/lib/debug/glod.lib"
        cp "lib/debug/glod.dll" \
            "stage/lib/debug/glod.dll"
        cp "src/api/debug/glod.pdb" \
            "stage/lib/debug/glod.pdb"
        cp "lib/release/glod.lib" \
            "stage/lib/release/glod.lib"
        cp "lib/release/glod.dll" \
            "stage/lib/release/glod.dll"
        mkdir -p "stage/include/glod"
        cp "include/glod.h" "stage/include/glod"
    ;;
        "darwin")
			libdir="$top/stage/lib"
            mkdir -p "$libdir"/{debug,release}
			make -C src clean
			make -C src debug
			install_name_tool -id "@executable_path/../Resources/libGLOD.dylib" "lib/libGLOD.dylib" 
			cp "lib/libGLOD.dylib" \
				"$libdir/debug/libGLOD.dylib"
			make -C src clean
			make -C src release
			install_name_tool -id "@executable_path/../Resources/libGLOD.dylib" "lib/libGLOD.dylib" 
			cp "lib/libGLOD.dylib" \
				"$libdir/release/libGLOD.dylib"
		;;
        "linux")
	  		prefix="$top/stage/libraries/i686-linux"
			mkdir -p "$prefix/include/glod"
			cp "include/glod.h" "$prefix/include/glod"
			libdir="$prefix/lib"
			mkdir -p "$libdir"/{debug,release}
			export CFLAGS=-m32
			export LFLAGS=-m32
			make -C src clean
			make -C src debug
			cp "lib/libGLOD.so" "$libdir/debug/libGLOD.so"
			make -C src clean
			make -C src release
			cp "lib/libGLOD.so" "$libdir/release/libGLOD.so"
        ;;
        "linux64")
	  		prefix="$top/stage/libraries/x86_64-linux"
			mkdir -p "$prefix/include/glod"
			cp "include/glod.h" "$prefix/include/glod"
			libdir="$prefix/lib"
			mkdir -p "$libdir"/{debug,release}
			export CFLAGS=-m64
			export LFLAGS=-m64
			make -C src clean
			make -C src debug
			cp "lib/libGLOD.so" "$libdir/debug/libGLOD.so"
			make -C src clean
			make -C src release
			cp "lib/libGLOD.so" "$libdir/release/libGLOD.so"
        ;;
esac
mkdir -p stage/LICENSES
cp LICENSE stage/LICENSES/GLOD.txt

pass

