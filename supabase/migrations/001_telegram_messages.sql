-- Migration: 001_telegram_messages
-- Purpose: Persistent log of all Telegram events routed through PI_Ink_Hermes_bot
-- RLS: Enabled. No customer PII stored here — operator messages only.
-- Rollback: DROP TABLE IF EXISTS telegram_messages;

CREATE TABLE IF NOT EXISTS telegram_messages (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chat_id         BIGINT NOT NULL,
  telegram_user_id BIGINT,
  username        TEXT,
  direction       TEXT NOT NULL CHECK (direction IN ('inbound', 'outbound')),
  message_text    TEXT,
  raw_payload     JSONB,
  status          TEXT NOT NULL DEFAULT 'received' CHECK (status IN ('received', 'routed', 'responded', 'failed')),
  hermes_response TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  responded_at    TIMESTAMPTZ,
  workflow_run_id TEXT
);

-- Indexes
CREATE INDEX idx_telegram_messages_chat_id ON telegram_messages(chat_id);
CREATE INDEX idx_telegram_messages_created_at ON telegram_messages(created_at DESC);
CREATE INDEX idx_telegram_messages_status ON telegram_messages(status);

-- RLS
ALTER TABLE telegram_messages ENABLE ROW LEVEL SECURITY;

-- Only the service role (n8n/Hermes) can insert/update. No anonymous reads.
CREATE POLICY "service_role_all" ON telegram_messages
  FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');

COMMENT ON TABLE telegram_messages IS
  'Operator-only Telegram event log. No customer PII. Owned by Hermes/Telegram agent.';
