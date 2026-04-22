# AgentStay — Прямое бронирование жилья для людей и AI-агентов

**Слоган:** Book directly. No platform fees.

AgentStay — платформа прямого бронирования апартаментов, оптимизированная одновременно для людей и AI-агентов (Claude, ChatGPT, Manus, Perplexity).

## Что есть на сайте

- **Каталог** — красивые карточки апартаментов с фото, рейтингами и ценами
- **Листинги** — полные страницы с Trust Card (рейтинги Airbnb + Booking.com + Google), фотогалереей, ценами по сезонам
- **Блог** — SEO-статьи с карточками апартаментов внутри контента
- **REST API** — полная OpenAPI 3.1 спецификация со Swagger UI
- **MCP сервер** — подключение к Claude Desktop / Manus
- **AI Plugin** — совместимость с ChatGPT plugins
- **Agent Card** — A2A стандарт

---

## Быстрый старт

### 1. Запуск через Docker

```bash
cd agentstay
docker compose up -d
```

### 2. Заполнение базы данных

```bash
# Подождать пока API запустится (~10 сек), затем:
docker compose exec api python api/seed.py

# Или напрямую если запускаете локально:
pip install -r api/requirements.txt
DATABASE_URL=postgresql+asyncpg://agentstay:agentstay@localhost:5432/agentstay python api/seed.py
```

### 3. Открыть сайт

- **Каталог:** http://localhost:8000
- **Листинг:** http://localhost:8000/l/elegant-apartment-near-duomo
- **Блог:** http://localhost:8000/blog
- **API Docs:** http://localhost:8000/docs
- **Health:** http://localhost:8000/api/v1/health

---

## Структура проекта

```
agentstay/
├── api/
│   ├── main.py              # FastAPI app + middleware
│   ├── models.py            # SQLAlchemy модели (6 таблиц)
│   ├── routes/
│   │   ├── listings.py      # Каталог + листинг + availability
│   │   ├── bookings.py      # Бронирования
│   │   ├── pages.py         # HTML страницы
│   │   ├── discovery.py     # ai-plugin, agent-card, sitemap, robots
│   │   └── health.py        # Здоровье системы
│   ├── services/
│   │   ├── pricing.py       # Сезонные цены + скидки
│   │   └── availability.py  # Проверка дат
│   ├── templates/           # Jinja2 шаблоны
│   ├── static/style.css     # CSS
│   └── seed.py              # Демо данные
└── mcp-server/              # TypeScript MCP сервер
    └── src/
        ├── index.ts         # MCP Server + stdio
        ├── tools.ts         # 6 инструментов
        └── api-client.ts    # HTTP клиент
```

---

## API Endpoints

### Поиск и листинги

```bash
# Список апартаментов во Флоренции
curl "http://localhost:8000/api/v1/listings?city=florence"

# С фильтрами
curl "http://localhost:8000/api/v1/listings?city=florence&guests=4&max_price=200&sort=price_asc"

# Детали листинга
curl "http://localhost:8000/api/v1/listings/elegant-apartment-near-duomo"

# Проверка доступности и цен
curl "http://localhost:8000/api/v1/listings/elegant-apartment-near-duomo/availability?check_in=2026-06-01&check_out=2026-06-07&guests=2"
```

### Бронирование

```bash
# Создать запрос на бронирование
curl -X POST "http://localhost:8000/api/v1/bookings" \
  -H "Content-Type: application/json" \
  -d '{
    "listing_slug": "elegant-apartment-near-duomo",
    "check_in": "2026-06-01",
    "check_out": "2026-06-07",
    "guest": {
      "name": "Иван Иванов",
      "email": "ivan@example.com",
      "num_guests": 2,
      "message": "Приедем поздно вечером"
    }
  }'

# Статус бронирования
curl "http://localhost:8000/api/v1/bookings/{booking_id}"
```

### Системные

```bash
# Здоровье системы
curl "http://localhost:8000/api/v1/health"

# Города
curl "http://localhost:8000/api/v1/cities"
```

### Discovery для AI

```bash
curl "http://localhost:8000/.well-known/ai-plugin.json"    # ChatGPT plugin
curl "http://localhost:8000/.well-known/agent-card.json"   # A2A card
curl "http://localhost:8000/sitemap.xml"                   # Sitemap
curl "http://localhost:8000/robots.txt"                    # Robots
```

---

## Подключение MCP к Claude Desktop

### 1. Сборка MCP сервера

```bash
cd mcp-server
npm install
npm run build
```

### 2. Конфигурация Claude Desktop

Добавьте в `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) или `%APPDATA%\Claude\claude_desktop_config.json` (Windows):

```json
{
  "mcpServers": {
    "agentstay": {
      "command": "node",
      "args": ["/абсолютный/путь/к/agentstay/mcp-server/dist/index.js"],
      "env": {
        "API_BASE_URL": "http://localhost:8000"
      }
    }
  }
}
```

### 3. Перезапустите Claude Desktop

После перезапуска в Claude Desktop появятся инструменты AgentStay.

---

## Тестирование через AI

### Примеры промптов для Claude Desktop (с MCP)

```
Найди апартаменты во Флоренции для 2 гостей на 5 ночей с 1 по 6 июня 2026

Покажи детали апартамента elegant-apartment-near-duomo

Проверь доступность и посчитай стоимость для elegant-apartment-near-duomo
с 1 по 7 июня 2026 для 2 гостей

Забронируй elegant-apartment-near-duomo на 1-7 июня 2026 для
Ивана Иванова (ivan@example.com), 2 гостя

Покажи список городов с доступными апартаментами
```

### Для ChatGPT (через ai-plugin.json)

В ChatGPT Plus добавьте плагин по URL: `http://localhost:8000/.well-known/ai-plugin.json`

---

## MCP Tools

| Tool | Описание |
|------|----------|
| `search_listings` | Поиск по городу, датам, гостям, цене, удобствам |
| `get_listing_details` | Полная информация об апартаменте |
| `check_availability` | Доступность дат + детальный расчёт цены |
| `create_booking_request` | Создание запроса на бронирование |
| `get_booking_status` | Статус бронирования (pending/approved/declined) |
| `list_cities` | Список городов с количеством апартаментов |

---

## Переменные окружения

| Переменная | По умолчанию | Описание |
|-----------|------|----------|
| `DATABASE_URL` | postgresql+asyncpg://agentstay:agentstay@db:5432/agentstay | URL БД |
| `SITE_BASE_URL` | http://localhost:8000 | Базовый URL сайта |
| `TELEGRAM_BOT_TOKEN` | (пусто) | Токен для уведомлений хосту |
| `SECRET_KEY` | (dev key) | Секретный ключ |

---

## Trust Card

Каждый листинг содержит Trust Card — агрегированные рейтинги с нескольких платформ:
- Airbnb рейтинг + количество отзывов + ссылка на оригинал
- Booking.com оценка + количество + ссылка
- Google рейтинг + количество + ссылка
- AI-сгенерированное резюме отзывов
- Топ-3 отзыва с именами гостей и датами

---

## Блог-воронка

Статьи оптимизированы для Google AI Overviews и LLM-цитирования:
- Конкретные данные в первом абзаце (расстояния, цены)
- Карточки реальных апартаментов прямо в тексте
- FAQPage schema.org (+60% к AI Overviews)
- Article + BreadcrumbList schema
- CTA с формой поиска дат

---

## Развитие / расширение

- Добавить новые листинги: копируйте паттерн из `seed.py`
- Добавить город: создайте листинги с нужным `city`
- Telegram уведомления: установите `TELEGRAM_BOT_TOKEN` в .env
- Production: смените `SECRET_KEY`, настройте HTTPS, установите `SITE_BASE_URL`
