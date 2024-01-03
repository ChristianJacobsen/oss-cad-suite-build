pushd nextpnr/gowin
sed -i 's,/work/_builds/linux-x64/apicula/python3-native/yosyshq/bin/python3.11,/work/_builds/linux-x64/apicula-bba/python3-native/yosyshq/bin/python3.11,g' ${BUILD_DIR}/apicula/${INSTALL_PREFIX}/bin/gowin_bba
cp -R ${BUILD_DIR}/numpy${INSTALL_PREFIX}/lib/python3.11/site-packages/* ${BUILD_DIR}/python3-native${INSTALL_PREFIX}/lib/python3.11/site-packages/.
cp -R ${BUILD_DIR}/apicula${INSTALL_PREFIX}/lib/python3.11/site-packages/*  ${BUILD_DIR}/python3-native${INSTALL_PREFIX}/lib/python3.11/site-packages/.
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DGOWIN_BBA_EXECUTABLE=${BUILD_DIR}/apicula/${INSTALL_PREFIX}/bin/gowin_bba \
      .
make
mkdir -p ${OUTPUT_DIR}/gowin/chipdb
cp chipdb/* ${OUTPUT_DIR}/gowin/chipdb/.
popd