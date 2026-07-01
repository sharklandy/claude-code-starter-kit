<!-- Source : docs/guide-complet.md, Partie 1.2 (Boucle turn-based) -->
---
name: verify-frontend-change
description: Verify any UI change end-to-end before declaring it done. Trigger whenever a task touches a component, page, button, form control, or any other visible frontend behavior.
---

# Verifying frontend changes

Never report a UI change as complete based on a successful edit alone.
Verify it the way a human reviewer would:

1. Start the dev server and open the edited page in the browser.
2. Interact with the change directly. For a new control (button, input,
   toggle): click it, confirm the expected state change, and screenshot
   before/after.
3. Check the browser console: zero new errors or warnings.
4. Use the Chrome Devtools MCP, run a performance trace and audit
   Core Web Vitals.

If any step fails, fix the issue and rerun from step 1 — do not hand
back partially verified work.

## Gotchas

- <TODO: décrivez ici le premier piège récurrent rencontré sur votre
  stack frontend — par exemple un délai d'apparition d'un message de
  confirmation, un état de chargement à attendre plutôt qu'un délai
  fixe, etc.>
- <TODO: ajoutez une ligne à chaque fois que Claude rate un cas
  particulier malgré ce skill, plutôt que de vous contenter de corriger
  le cas isolé (voir docs/guide-complet.md, Partie 1.6).>
