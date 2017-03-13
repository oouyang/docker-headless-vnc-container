#!/usr/bin/env bash
### every exit != 0 fails the script
set -e
export GENY_VERSION=2.8.1

echo "Install Chromium Browser"
apt-get update 
apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg
apt-get clean -y
ln -s /usr/bin/chromium-browser /usr/bin/google-chrome
### fix to start chromium in a Docker container, see https://github.com/ConSol/docker-headless-vnc-container/issues/2
echo "CHROMIUM_FLAGS='--no-sandbox --start-maximized --user-data-dir'" > $HOME/.chromium-browser.init

echo "Install Genymotion"
apt-get update && apt-get install -y --no-install-recommends \
                                  ca-certificates \
                                  linux-headers-4.4.0-22-generic \
                                  openssl \
                                  wget \
               && wget -q --directory-prefix=/tmp/ "http://files2.genymotion.com/genymotion/genymotion-${GENY_VERSION}/genymotion-${GENY_VERSION}-linux_x64.bin" \
               && echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list \
               && wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add - \
               && wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add - \
               && apt-get update && apt-get install -y virtualbox-5.1 \
               && mkdir -p /opt/genymotion/ \
               && apt-get install -y --no-install-recommends \
                                  bzip2 \
                                  libgstreamer-plugins-base0.10-dev \
                                  libxcomposite-dev \
                                  libxslt1.1 \
               && chmod +x /tmp/genymotion-${GENY_VERSION}-linux_x64.bin \
               && mkdir -p /root/.Genymobile/ \
               && sync \
               && echo 'Y' | /tmp/genymotion-${GENY_VERSION}-linux_x64.bin -d /opt  \
               && rm -f /tmp/genymotion-${GENY_VERSION}-linux_x64.bin \
               && apt-get clean \
               && rm -rf /var/lib/apt/lists/* \