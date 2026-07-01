<!-- Source : docs/guide-complet.md, Tutoriel 1 (Créer un skill de vérification de A à Z) -->
---
name: verify-form-change
description: >
  Verify any form or input change end-to-end before declaring it done.
  Trigger this whenever a task touches a <form>, an input validation
  rule, or a submit handler.
---

# Vérifier un changement de formulaire

Ne jamais déclarer un changement de formulaire terminé sur la seule base
d'une édition réussie. Vérifier comme le ferait un relecteur humain :

1. Démarrer le serveur de dev et ouvrir la page concernée dans le
   navigateur.
2. Remplir le formulaire avec des données valides, soumettre, et
   confirmer que le message de succès attendu s'affiche.
3. Remplir le formulaire avec des données invalides (champ vide,
   format incorrect) et confirmer que les messages d'erreur attendus
   s'affichent, sans soumission.
4. Vérifier la console du navigateur : zéro nouvelle erreur ou warning.
5. Prendre une capture d'écran avant/après pour les cas valide et
   invalide.

Si une étape échoue, corriger le problème et reprendre depuis l'étape 1
— ne jamais rendre la main sur un travail partiellement vérifié.

## Gotchas

- Le message de succès met environ 400ms à apparaître (attendre un
  état, pas un délai fixe).
- Le champ email accepte à tort les adresses sans TLD en dev — vérifier
  aussi ce cas si le formulaire concerne un email.
- <TODO: ajoutez ici les pièges spécifiques à votre propre stack de
  formulaires (librairie de validation utilisée, comportement de votre
  environnement de dev, etc.).>
