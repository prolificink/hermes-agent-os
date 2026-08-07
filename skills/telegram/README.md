# Telegram Agent — @PI_Ink_Hermes_bot

## Identity
- **Bot name:** Prolific Ink Hermes
- **Username:** @PI_Ink_Hermes_bot
- **Role:** Telegram channel operator for Hermes Agent OS
- **Reports to:** Hermes (Head of Council)
- **Owner:** Derrick Valerio

## What This Agent Does
- Receives inbound Telegram messages from Derrick
- Logs every message to Supabase (`telegram_messages` table)
- Routes messages to Hermes for decision/response
- Sends Hermes's response back through the bot

## What This Agent Does NOT Do
- Write to Notion (Hermes only writes to Notion)
- Handle customer data
- Activate without Derrick approval
- Spawn sub-agents

## Architecture

```
Derrick → Telegram → @PI_Ink_Hermes_bot
                          ↓
                   Telegram sends POST to n8n webhook
                          ↓
                   WF_TELEGRAM_INBOUND (n8n, INACTIVE until approved)
                          ↓
                   Log to Supabase (telegram_messages)
                          ↓
                   Route to Hermes internal webhook
                          ↓
                   Hermes responds
                          ↓
                   Reply sent back to Derrick via bot
```

## Workflow
| File | Status |
|---|---|
| `n8n/WF_TELEGRAM_INBOUND.json` | INACTIVE — awaiting Derrick approval |

## Supabase
| Table | Migration |
|---|---|
| `telegram_messages` | `supabase/migrations/001_telegram_messages.sql` |

## Environment Variables Required
See `.env.example`:
- `TELEGRAM_BOT_TOKEN` — from BotFather
- `HERMES_WEBHOOK_URL` — Hermes internal endpoint
- `HERMES_INTERNAL_TOKEN` — auth token for Hermes
- `SUPABASE_URL` + `SUPABASE_SERVICE_ROLE_KEY`
- `N8N_BASE_URL`

## Activation Steps (Derrick approval required)
1. Apply Supabase migration `001_telegram_messages.sql`
2. Add `TELEGRAM_BOT_TOKEN` to n8n credentials
3. Add `SUPABASE_SERVICE_ROLE_KEY` to n8n credentials
4. Import `WF_TELEGRAM_INBOUND.json` into n8n
5. Set Telegram webhook: `POST https://api.telegram.org/bot{TOKEN}/setWebhook?url={N8N_WEBHOOK_URL}`
6. Activate workflow in n8n
7. Test with a message to @PI_Ink_Hermes_bot
8. Confirm Supabase row logged + reply received

## Token Security
- `TELEGRAM_BOT_TOKEN` lives only in n8n credentials and GitHub Secrets
- Never committed to this repo
- Never logged to shared memory
- Rotate via BotFather if compromised (`/revoke` → `/token`)
