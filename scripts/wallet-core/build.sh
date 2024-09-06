#!/bin/bash
set -e

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
done

WALLET_CORE_SCRIPTS_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

if [ "$FULL_WORKSPACE" == "true" ]; then
  WALLET_CORE_DIR="$WALLET_CORE_SCRIPTS_DIR/../../../../../wallet-core"
else
  WALLET_CORE_DIR="$WALLET_CORE_SCRIPTS_DIR/source"
  rm -rf "$WALLET_CORE_DIR"
  git clone -b custom https://github.com/longht021189/wallet-core.git "$WALLET_CORE_DIR"
fi

rm -rf "$WALLET_CORE_DIR/../wallet-core-out"

BUILD_DIR="$WALLET_CORE_DIR/../wallet-core-out/build"
INSTALL_DIR="$WALLET_CORE_DIR/../wallet-core-out/install"
OUT_DIR="$WALLET_CORE_SCRIPTS_DIR/../../../../packages/core/pkg-cxx/prebuilt/wallet-core"

pushd "$WALLET_CORE_DIR"
  ./tools/install-sys-dependencies-mac
  ./tools/install-dependencies
  ./tools/install-rust-dependencies
  ./tools/generate-files native

  cmake -H. \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
    -G Ninja -DCMAKE_MAKE_PROGRAM=ninja -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    -B$BUILD_DIR

  cmake --build $BUILD_DIR --config Release --target walletconsole -j 6 -v > "$WALLET_CORE_DIR/../wallet-core-out/build.log"
  cmake --install $BUILD_DIR > "$WALLET_CORE_DIR/../wallet-core-out/install.log"
popd

rm -rf $OUT_DIR
mkdir -p $OUT_DIR

mv $INSTALL_DIR/lib $OUT_DIR/lib
mv $INSTALL_DIR/include $OUT_DIR/include