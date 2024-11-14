#!/bin/bash
set -e

cd /root
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
. /root/.bashrc
nvm install 18
node -v

cd /app/front
npm install
npm run build
cd /app
apache2-foreground