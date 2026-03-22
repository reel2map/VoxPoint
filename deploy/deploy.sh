#!/bin/bash
set -e

REPO_DIR="/home/qvino/voxpoint"
APP_DIR="$REPO_DIR/agentstay"
NGINX_AVAILABLE="/etc/nginx/sites-available/lacorsasuit.com"
NGINX_ENABLED="/etc/nginx/sites-enabled/lacorsasuit.com"
DOMAIN="lacorsasuit.com"
EMAIL="admin@$DOMAIN"

# ─── helpers ────────────────────────────────────────────────────────────────
die() { echo "ERROR: $*" >&2; exit 1; }

# ─── dependencies ────────────────────────────────────────────────────────────
echo "==> Checking dependencies..."

if ! command -v docker &>/dev/null; then
  echo "Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  usermod -aG docker qvino
fi

if ! docker compose version &>/dev/null 2>&1; then
  apt-get update -qq && apt-get install -y docker-compose-plugin
fi

if ! command -v nginx &>/dev/null; then
  apt-get update -qq && apt-get install -y nginx
fi

if ! command -v certbot &>/dev/null; then
  apt-get update -qq && apt-get install -y certbot python3-certbot-nginx
fi

# ─── free port 80 ────────────────────────────────────────────────────────────
echo "==> Checking port 80..."
PORT80_PID=$(ss -tlnp 'sport = :80' 2>/dev/null | awk 'NR>1 && /LISTEN/{match($0,/pid=([0-9]+)/,a); print a[1]}' | head -1)
if [ -n "$PORT80_PID" ]; then
  PORT80_PROC=$(cat /proc/$PORT80_PID/comm 2>/dev/null || echo "unknown")
  echo "  Port 80 is used by: $PORT80_PROC (pid $PORT80_PID)"
  if [[ "$PORT80_PROC" == "apache2" ]]; then
    echo "  Stopping apache2..."
    systemctl stop apache2
    systemctl disable apache2
  elif [[ "$PORT80_PROC" != "nginx" ]]; then
    die "Unknown process on port 80: $PORT80_PROC. Stop it manually and re-run."
  fi
fi

# ─── repo ────────────────────────────────────────────────────────────────────
echo "==> Updating repository..."
if [ -d "$REPO_DIR/.git" ]; then
  git -C "$REPO_DIR" pull origin claude/initial-setup-B947o
else
  git clone -b claude/initial-setup-B947o https://github.com/reel2map/VoxPoint.git "$REPO_DIR"
fi

# ─── .env ────────────────────────────────────────────────────────────────────
echo "==> Setting up .env..."
if [ ! -f "$APP_DIR/.env" ]; then
  cp "$APP_DIR/.env.production.example" "$APP_DIR/.env"
  echo ""
  echo "!!! Edit $APP_DIR/.env before continuing !!!"
  echo "    nano $APP_DIR/.env"
  echo "    → Set POSTGRES_PASSWORD and SECRET_KEY"
  echo ""
  read -rp "Press Enter after saving .env..."
fi

# ─── stage 1: HTTP-only nginx (for certbot) ──────────────────────────────────
echo "==> Configuring Nginx (HTTP only for certbot)..."
mkdir -p /var/www/certbot

cat > "$NGINX_AVAILABLE" <<NGINX
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 200 'ok';
        add_header Content-Type text/plain;
    }
}
NGINX

ln -sf "$NGINX_AVAILABLE" "$NGINX_ENABLED" 2>/dev/null || true
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true

nginx -t || die "Nginx config test failed"
systemctl enable nginx
systemctl restart nginx

# ─── SSL cert ────────────────────────────────────────────────────────────────
echo "==> Obtaining SSL certificate..."
if [ ! -d "/etc/letsencrypt/live/$DOMAIN" ]; then
  certbot certonly --webroot -w /var/www/certbot \
    -d "$DOMAIN" -d "www.$DOMAIN" \
    --non-interactive --agree-tos -m "$EMAIL" \
    || die "Certbot failed. Make sure DNS A records point to $(curl -s ifconfig.me) before running this script."
else
  echo "  Certificate already exists, skipping."
fi

# ─── stage 2: full HTTPS nginx config ────────────────────────────────────────
echo "==> Enabling HTTPS Nginx config..."
cp "$REPO_DIR/deploy/nginx/lacorsasuit.com.conf" "$NGINX_AVAILABLE"
nginx -t || die "Nginx SSL config test failed"
systemctl reload nginx

# Auto-renew cron
if ! crontab -l 2>/dev/null | grep -q certbot; then
  (crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet && systemctl reload nginx") | crontab -
  echo "  Certbot auto-renew cron added."
fi

# ─── Docker containers ───────────────────────────────────────────────────────
echo "==> Building and starting containers..."
cd "$APP_DIR"
docker compose -f docker-compose.prod.yml --env-file .env up -d --build

echo ""
echo "======================================================"
echo " Done! Site is live at https://$DOMAIN"
echo " Logs: docker compose -f $APP_DIR/docker-compose.prod.yml logs -f"
echo "======================================================"
