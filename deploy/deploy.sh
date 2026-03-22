#!/bin/bash
set -e

REPO_DIR="/home/qvino/voxpoint"
APP_DIR="$REPO_DIR/agentstay"
NGINX_CONF="/etc/nginx/sites-available/lacorsasuit.com"
DOMAIN="lacorsasuit.com"

echo "==> Checking dependencies..."

if ! command -v docker &>/dev/null; then
  echo "Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  usermod -aG docker qvino
  echo "Docker installed. Re-login or run: newgrp docker"
fi

if ! command -v docker compose version &>/dev/null 2>&1 && ! docker compose version &>/dev/null 2>&1; then
  echo "Installing Docker Compose plugin..."
  apt-get update -qq && apt-get install -y docker-compose-plugin
fi

if ! command -v nginx &>/dev/null; then
  echo "Installing Nginx..."
  apt-get update -qq && apt-get install -y nginx
fi

if ! command -v certbot &>/dev/null; then
  echo "Installing Certbot..."
  apt-get update -qq && apt-get install -y certbot python3-certbot-nginx
fi

echo "==> Cloning / updating repository..."
if [ -d "$REPO_DIR/.git" ]; then
  git -C "$REPO_DIR" pull origin claude/initial-setup-B947o
else
  git clone -b claude/initial-setup-B947o https://github.com/reel2map/VoxPoint.git "$REPO_DIR"
fi

echo "==> Setting up .env..."
if [ ! -f "$APP_DIR/.env" ]; then
  cp "$APP_DIR/.env.production.example" "$APP_DIR/.env"
  echo ""
  echo "!!! Edit $APP_DIR/.env before continuing !!!"
  echo "    Set POSTGRES_PASSWORD and SECRET_KEY"
  echo ""
  read -rp "Press Enter after editing .env to continue..."
fi

echo "==> Configuring Nginx..."
mkdir -p /var/www/certbot
cp "$REPO_DIR/deploy/nginx/lacorsasuit.com.conf" "$NGINX_CONF"
ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/lacorsasuit.com

nginx -t && systemctl reload nginx

echo "==> Obtaining SSL certificate..."
if [ ! -d "/etc/letsencrypt/live/$DOMAIN" ]; then
  certbot certonly --webroot -w /var/www/certbot \
    -d "$DOMAIN" -d "www.$DOMAIN" \
    --non-interactive --agree-tos -m "admin@$DOMAIN"
  systemctl reload nginx
else
  echo "Certificate already exists, skipping."
fi

echo "==> Building and starting containers..."
cd "$APP_DIR"
docker compose -f docker-compose.prod.yml --env-file .env pull --ignore-buildable 2>/dev/null || true
docker compose -f docker-compose.prod.yml --env-file .env up -d --build

echo ""
echo "==> Done! Site is live at https://$DOMAIN"
echo "    Logs: docker compose -f $APP_DIR/docker-compose.prod.yml logs -f"
