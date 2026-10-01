#!/usr/bin/env bash
# Download the auto-nesy-bench datasets that cannot be redistributed with the
# benchmark archive, directly from their original sources.
#
#   - CIFAR-10 / CIFAR-100 (cifar10, cifar100): no explicit redistribution grant,
#     fetched from https://www.cs.toronto.edu/~kriz/cifar.html
#   - SUSHI3 (sushi): research use permitted, redistribution forbidden,
#     fetched from https://www.kamishima.net/sushi/
#
# By running this script you agree to the terms of use of each dataset.
#
# Usage: bash download_external_datasets.sh [TARGET_DIR] [DATASET ...]
#   TARGET_DIR defaults to ./data
#   DATASET is any of: cifar10 cifar100 sushi (default: all)

set -euo pipefail

TARGET_DIR="${1:-./data}"
shift || true
DATASETS=("$@")
if [ ${#DATASETS[@]} -eq 0 ]; then
    DATASETS=(cifar10 cifar100 sushi)
fi

CIFAR10_URL="https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz"
CIFAR10_MD5="c58f30108f718f92721af3b95e74349a"
CIFAR100_URL="https://www.cs.toronto.edu/~kriz/cifar-100-python.tar.gz"
CIFAR100_MD5="eb9058c3a382ffc7106e4002c42a8d85"
SUSHI_URL="https://www.kamishima.net/asset/sushi3-2016.zip"

fetch() {
    local url="$1" out="$2"
    if [ -f "$out" ]; then
        echo "[skip] $out already exists"
        return
    fi
    echo "[get ] $url"
    if command -v curl >/dev/null 2>&1; then
        curl -fL --retry 3 -o "$out.part" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -O "$out.part" "$url"
    else
        echo "error: curl or wget is required" >&2
        exit 1
    fi
    mv "$out.part" "$out"
}

check_md5() {
    local file="$1" expected="$2"
    if command -v md5sum >/dev/null 2>&1; then
        local got
        got="$(md5sum "$file" | cut -d' ' -f1)"
        if [ "$got" != "$expected" ]; then
            echo "error: checksum mismatch for $file (got $got, expected $expected)" >&2
            exit 1
        fi
        echo "[ok  ] checksum verified for $file"
    fi
}

mkdir -p "$TARGET_DIR"

for ds in "${DATASETS[@]}"; do
    case "$ds" in
        cifar10)
            mkdir -p "$TARGET_DIR/cifar10"
            fetch "$CIFAR10_URL" "$TARGET_DIR/cifar10/cifar-10-python.tar.gz"
            check_md5 "$TARGET_DIR/cifar10/cifar-10-python.tar.gz" "$CIFAR10_MD5"
            tar -xzf "$TARGET_DIR/cifar10/cifar-10-python.tar.gz" -C "$TARGET_DIR/cifar10"
            ;;
        cifar100)
            mkdir -p "$TARGET_DIR/cifar100"
            fetch "$CIFAR100_URL" "$TARGET_DIR/cifar100/cifar-100-python.tar.gz"
            check_md5 "$TARGET_DIR/cifar100/cifar-100-python.tar.gz" "$CIFAR100_MD5"
            tar -xzf "$TARGET_DIR/cifar100/cifar-100-python.tar.gz" -C "$TARGET_DIR/cifar100"
            ;;
        sushi)
            mkdir -p "$TARGET_DIR/sushi"
            fetch "$SUSHI_URL" "$TARGET_DIR/sushi/sushi3-2016.zip"
            unzip -oq "$TARGET_DIR/sushi/sushi3-2016.zip" -d "$TARGET_DIR/sushi"
            ;;
        *)
            echo "error: unknown dataset '$ds' (expected: cifar10 cifar100 sushi)" >&2
            exit 1
            ;;
    esac
done

echo "Done. Datasets are in $TARGET_DIR"
