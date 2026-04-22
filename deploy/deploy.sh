#!/bin/bash
set -e

REPO_DIR="/home/qvino/voxpoint"
APP_DIR="$REPO_DIR/agentstay"
DOMAIN="lacorsasuit.com"
EMAIL="admin@$DOMAIN"

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

if ! command -v certbot &>/dev/null; then
  apt-get update -qq && apt-get install -y certbot python3-certbot-apache
fi

# ─── enable required Apache modules ──────────────────────────────────────────
echo "==> Enabling Apache modules..."
a2enmod ssl rewrite proxy proxy_http headers 2>/dev/null || true
systemctl reload apache2 2>/dev/null || true

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

# ─── stage 1: HTTP-only Apache config (for certbot) ──────────────────────────
echo "==> Adding HTTP Apache VirtualHost (for certbot)..."
mkdir -p /var/www/certbot/.well-known/acme-challenge

cat > /etc/apache2/sites-available/lacorsasuit.com.conf <<'APACHECONF'
<VirtualHost *:80>
    ServerName lacorsasuit.com
    ServerAlias www.lacorsasuit.com

    Alias /.well-known/acme-challenge/ /var/www/certbot/.well-known/acme-challenge/
    <Directory /var/www/certbot/.well-known/acme-challenge/>
        Options None
        AllowOverride None
        Require all granted
    </Directory>

    RewriteEngine On
    RewriteCond %{REQUEST_URI} !^/.well-known/acme-challenge/
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
</VirtualHost>
APACHECONF

a2ensite lacorsasuit.com.conf
apachectl configtest || die "Apache config test failed"
systemctl reload apache2

# ─── SSL cert ────────────────────────────────────────────────────────────────
echo "==> Obtaining SSL certificate..."
if [ ! -d "/etc/letsencrypt/live/$DOMAIN" ]; then
  certbot certonly --webroot -w /var/www/certbot \
    -d "$DOMAIN" -d "www.$DOMAIN" \
    --non-interactive --agree-tos -m "$EMAIL" \
    || die "Certbot failed. Check that DNS is propagated: dig +short $DOMAIN"
else
  echo "  Certificate already exists."
fi

# ─── stage 2: full HTTPS Apache config ───────────────────────────────────────
echo "==> Enabling HTTPS Apache VirtualHost..."
cp "$REPO_DIR/deploy/apache/lacorsasuit.com.conf" /etc/apache2/sites-available/lacorsasuit.com.conf
apachectl configtest || die "Apache SSL config test failed"
systemctl reload apache2

# Auto-renew cron
if ! crontab -l 2>/dev/null | grep -q certbot; then
  (crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet && systemctl reload apache2") | crontab -
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
