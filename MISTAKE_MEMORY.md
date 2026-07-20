Known failures and fixes.

1. Duplicate Notion databases: Multiple chats building their own version. Fix: Hermes is the only writer. Hermes writes to canonical DBs only.
2. Shell completion claims: Agent said "done" because UI shell existed. Fix: Completion requires backend, tests, runtime proof, independent verification.
3. Wrong token sharing: Claude Code given broad Notion write access. Fix: Remove Claude Code write access. Hermes integration only.
4. Schema mismatch breaking automations: Renamed properties broke integrations. Fix: Never rename existing properties. Only add new fields.
5. Uncontrolled agent swarms: Multiple agents running without governance. Fix: Multica enforces 3-worker max. No recursive spawning.
6. Production changes without approval: Agents activated workflows or changed settings. Fix: All workflows default inactive. Derrick approval required.
7. Customer data in shared memory: Agents logged client info in shared context. Fix: Customer data stays in Supabase under RLS only.
8. Pricing stale decisions: Old pricing still showing in Notion views. Fix: Source of Truth and Decision Log with stale detector.
9. Credential duplication: Same token shared across tools. Fix: Separate token per role with minimum permissions.
10. Workflow reactivation of dead systems: Attempted to reactivation of WF09 or WF14. Fix: Permanently banned. Notion build spec marks them Dead — Permanent.
