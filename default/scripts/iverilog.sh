cd iverilog
sed -i "s/\$(CC) \$(CFLAGS) -o draw_tt/gcc \$(CFLAGS) -o draw_tt/g" vvp/Makefile.in
sh autoconf.sh
if [ ${ARCH} == 'windows-x64' ]; then
    sed -i "s/EXTRALIBS=/EXTRALIBS=-lssp/g" configure
fi
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/*.a
