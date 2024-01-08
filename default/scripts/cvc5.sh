cd cvc5
patch -p1 < ${PATCHES_DIR}/cvc5.diff
cp ${PATCHES_DIR}/get-antlr-3.4 contrib/.
mkdir -p deps/install
cp -r ${BUILD_DIR}/libpoly/yosyshq/* deps/install/. 
cp -r ${BUILD_DIR}/cadical/yosyshq/* deps/install/.
cp -r ${BUILD_DIR}/symfpu/yosyshq/* deps/install/.
export MACHINE_TYPE=x86_64
if [ ${ARCH_BASE} != 'windows' ]; then
    sed -i -re 's,rm -rf src/antlr3debughandlers.c \&\& touch src/antlr3debughandlers.c,rm -rf src/antlr3debughandlers.c \&\& touch src/antlr3debughandlers.c \&\& cp  /usr/share/misc/config.* . ,g' ./contrib/get-antlr-3.4
fi
ANTLR_CONFIGURE_ARGS="--host=${CROSS_NAME} --build=`gcc -dumpmachine`"  ./contrib/get-antlr-3.4
git clone https://github.com/uiri/toml.git
cd toml
git checkout 5706d3155f4da8f3b84875f80bfe0dfc6565f61f
cd ..
export PYTHONPATH=$PYTHONPATH:`pwd`/toml
if [ ${ARCH_BASE} == 'windows' ]; then
    export CMAKE_TOOLCHAIN_FILE=${PATCHES_DIR}/Toolchain-mingw64.cmake
fi
sed -i -re 's,cmake \"\$root_dir\" \$cmake_opts,cmake \"\$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\},g' configure.sh
CXXFLAGS=-fPIC CFLAGS=-fPIC ./configure.sh --static --no-static-binary --prefix=${INSTALL_PREFIX} --no-unit-testing
cd build
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install
cd ..
mkdir -p ${OUTPUT_DIR}/dev
mkdir -p ${OUTPUT_DIR}/dev/build/deps/lib
cp -r src ${OUTPUT_DIR}/dev/.
cp -r build/src ${OUTPUT_DIR}/dev/build/.
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
cp -r ${BUILD_DIR}/libpoly/yosyshq/lib/*.a ${OUTPUT_DIR}/dev/build/deps/lib/.
cp -r ${BUILD_DIR}/cadical/yosyshq/lib/*.a ${OUTPUT_DIR}/dev/build/deps/lib/.
