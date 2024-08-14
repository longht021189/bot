#!/bin/bash
set -e

pushd "$WALLET_CORE_DIR"
  ./tools/install-sys-dependencies-mac
  ./tools/install-dependencies
  ./tools/install-rust-dependencies
  ./tools/generate-files native

  cmake -H. \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
    -G Ninja -DCMAKE_MAKE_PROGRAM=ninja -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    -B$BUILD_DIR

  cmake --build $BUILD_DIR --config Release --target walletconsole -j 6 -v
  cmake --install $BUILD_DIR
popd

rm -rf $OUT_DIR
mkdir -p $OUT_DIR

mv $INSTALL_DIR/lib $OUT_DIR/lib
mv $INSTALL_DIR/include $OUT_DIR/include
mv $WALLET_CORE_DIR/rust/target/release/libwallet_core_rs.a $OUT_DIR/lib/libwallet_core_rs.a