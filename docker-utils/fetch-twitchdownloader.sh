#!/bin/sh
set -e

# THANK YOU TALULAH (https://github.com/nottalulah) for your help in figuring this out
# and also optimizing some code with this commit.
# xoxo :D

case $(uname -m) in
  x86_64)
    ARCH=Linux-x64;;
  aarch64)
    ARCH=LinuxArm64;;
  *)
    echo "Unsupported architecture: $(uname -m)"
    exit 1
esac

echo "(INFO) Architecture detected: $ARCH"
echo "(1/5) READY - Install unzip"
apt-get update && apt-get -y install unzip curl libicu74
# Read the tag from the release redirect: the unauthenticated GitHub API is rate limited on shared CI runners.
LATEST_URL=$(curl --silent --fail --location --output /dev/null --write-out '%{url_effective}' "https://github.com/lay295/TwitchDownloader/releases/latest")
VERSION=${LATEST_URL##*/}
echo "(2/5) DOWNLOAD - Acquire twitchdownloader"
curl -o twitchdownloader.zip \
    --connect-timeout 5 \
    --max-time 120 \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 40 \
    -L "https://github.com/lay295/TwitchDownloader/releases/download/$VERSION/TwitchDownloaderCLI-$VERSION-$ARCH.zip"
unzip twitchdownloader.zip
chmod +x TwitchDownloaderCLI
echo "(3/5) Smoke test"
# --help exits with a non-zero status by design (CommandLineParser convention),
# so it can't be checked under set -e; only used here to confirm the binary runs.
./TwitchDownloaderCLI --help || true
cp ./TwitchDownloaderCLI /usr/local/bin/TwitchDownloaderCLI
