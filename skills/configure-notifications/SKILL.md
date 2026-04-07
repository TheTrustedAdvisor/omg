---
name: configure-notifications
description: "Set up notification integrations — Telegram, Discord, Slack alerts for long-running tasks"
tags:
  - utility
  - notifications
---

## When to Use

- User wants to be notified when long tasks complete
- User says "configure notifications", "setup telegram/discord/slack"

## Supported Channels

| Channel | Method | What You Need |
|---------|--------|---------------|
| **Telegram** | Bot API | Bot token + chat ID |
| **Discord** | Webhook | Webhook URL |
| **Slack** | Webhook | Incoming webhook URL |

## Workflow

### 1. Select Channel

If not specified in prompt, ask via `ask_user`:
```
Which notification service?
1. Telegram — Bot token + chat ID
2. Discord — Webhook URL
3. Slack — Incoming webhook URL
```

### 2. Collect Credentials

#### Telegram
1. Ask: "Do you have a Telegram bot token? If not, open Telegram → search @BotFather → /newbot"
2. Collect bot token via `ask_user`
3. Collect chat ID: "Send any message to your bot, then I'll fetch your chat ID"
4. Test: `bash: curl -s "https://api.telegram.org/bot{TOKEN}/getMe"` → should return bot info

#### Discord
1. Ask: "Paste your Discord webhook URL"
2. Test: `bash: curl -s -o /dev/null -w "%{http_code}" "{WEBHOOK_URL}"` → should return 200

#### Slack
1. Ask: "Paste your Slack incoming webhook URL"
2. Test: `bash: curl -s -o /dev/null -w "%{http_code}" -X POST -d '{"text":"omg test"}' "{WEBHOOK_URL}"` → should return 200

### 3. Save Configuration

Write to `.omg/research/notifications-config.json`:
```json
{
  "provider": "telegram|discord|slack",
  "telegram": { "botToken": "...", "chatId": "..." },
  "discord": { "webhookUrl": "..." },
  "slack": { "webhookUrl": "..." },
  "enabled": true
}
```

Index via `store_memory` key `omg:notifications` → `{ "provider": "telegram", "enabled": true }`.

### 4. Send Test Notification

```bash
# Telegram
curl -s -X POST "https://api.telegram.org/bot{TOKEN}/sendMessage" \
  -d "chat_id={CHAT_ID}&text=omg notification configured successfully"

# Discord
curl -s -X POST "{WEBHOOK_URL}" -H "Content-Type: application/json" \
  -d '{"content":"omg notification configured successfully"}'

# Slack
curl -s -X POST "{WEBHOOK_URL}" -H "Content-Type: application/json" \
  -d '{"text":"omg notification configured successfully"}'
```

### 5. Usage in Skills

Autopilot/ralph/team can send notifications on completion:
```bash
# Read config
CONFIG=$(cat .omg/research/notifications-config.json)
# Send based on provider
```

## Security Notes

- Bot tokens and webhook URLs are secrets — do NOT commit to git
- `.omg/` is in .gitignore so config stays local
- Use `--secret-env-vars` in CI to protect tokens

## Checklist

- [ ] Channel selected
- [ ] Credentials collected and tested
- [ ] Config saved to `.omg/research/notifications-config.json`
- [ ] Test notification sent successfully
- [ ] Indexed in `store_memory`
