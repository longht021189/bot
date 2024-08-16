#!/bin/bash
set -e

brew íntall cmake ninja

pushd $YALANTINGLIBS_DIR
  cmake -H. \
    -DBUILD_EXAMPLES=OFF -DBUILD_BENCHMARK=OFF -DBUILD_UNIT_TESTS=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -G Ninja -DCMAKE_MAKE_PROGRAM=ninja -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    -B$BUILD_DIR

  cmake --build $BUILD_DIR --config Release --target all -j 6 -v
  cmake --install $BUILD_DIR
popd

rm -rf $OUT_DIR
mkdir -p $OUT_DIR

mv $INSTALL_DIR/lib $OUT_DIR/lib
mv $INSTALL_DIR/include $OUT_DIR/include