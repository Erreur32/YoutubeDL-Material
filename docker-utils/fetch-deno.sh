#!/bin/sh
set -e

# Deno is required by yt-dlp to solve the JavaScript challenges YouTube now presents
# (see https://github.com/yt-dlp/yt-dlp/wiki/EJS).

case $(uname -m) in
  x86_64)
    ARCH=x86_64;;
  aarch64)
    ARCH=aarch64;;
  *)
    echo "Unsupported architecture: $(uname -m)"
    exit 1
esac

echo "(INFO) Architecture detected: $ARCH"
echo "(1/4) READY - Acquire temp dependencies in deno obtain layer"
apt-get update && apt-get -y install curl unzip
echo "(2/4) DOWNLOAD - Acquire latest deno release"
curl -o deno.zip \
    --connect-timeout 5 \
    --max-time 120 \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 40 \
    -L "https://github.com/denoland/deno/releases/latest/download/deno-${ARCH}-unknown-linux-gnu.zip"
echo "(3/4) PROVISION - Extract deno binary"
unzip -o deno.zip -d /usr/local/bin
chmod +x /usr/local/bin/deno
echo "(4/4) CLEANUP - Remove temporary downloads from deno obtain layer"
apt-get -y remove curl unzip
apt-get -y autoremove
rm -f deno.zip
