-- Migration: 002_add_telegram_alert_channel
-- Purpose: Expand alert_routes channel constraint to include 'telegram'
--          and add Telegram alert routes for @PI_Ink_Hermes_bot
-- Rollback:
--   DELETE FROM alert_routes WHERE channel = 'telegram';
--   ALTER TABLE alert_routes DROP CONSTRAINT alert_routes_channel_check;
--   ALTER TABLE alert_routes ADD CONSTRAINT alert_routes_channel_check
--     CHECK (channel = ANY (ARRAY['sms','slack','email','all']));

ALTER TABLE alert_routes DROP CONSTRAINT IF EXISTS alert_routes_channel_check;
ALTER TABLE alert_routes ADD CONSTRAINT alert_routes_channel_check
  CHECK (channel = ANY (ARRAY['sms'::text, 'slack'::text, 'email'::text, 'all'::text, 'telegram'::text]));

INSERT INTO alert_routes (severity, vertical, channel, destination, active)
VALUES
  ('fatal',    'ALL', 'telegram', '@PI_Ink_Hermes_bot', true),
  ('critical', 'PI',  'telegram', '@PI_Ink_Hermes_bot', true);
