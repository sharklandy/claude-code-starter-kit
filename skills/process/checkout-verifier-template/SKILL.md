<!-- Source : docs/guide-complet.md, Partie 7, Cas 1 (checkout-verifier) — généralisé, sans référence à l'entreprise fictive d'origine -->
---
name: checkout-verifier-template
description: >
  Verify any change touching the checkout flow, payment form, or cart
  summary before declaring it done. Trigger on changes to
  <TODO: chemin des composants checkout>/**, <TODO: chemin des
  composants payment>/**, or any file importing your payment provider's
  SDK.
---

# Vérifier le tunnel de paiement

1. Démarrer l'environnement de dev avec des clés de test du fournisseur
   de paiement (<TODO: nom du fournisseur, ex. Stripe, Adyen...>).
2. Ajouter un article au panier, aller jusqu'au formulaire de paiement.
3. Soumettre avec une carte de test valide (<TODO: numéro de carte de
   test à utiliser>) — confirmer que la commande passe en statut
   "confirmée".
4. Soumettre avec une carte de test de refus (<TODO: numéro de carte de
   test de refus>) — confirmer qu'un message d'erreur clair s'affiche
   et qu'aucune commande n'est créée en base.
5. Vérifier dans la table/le store d'événements de paiement
   (<TODO: nom de la table, ex. payment_events>) que l'état enregistré
   correspond à l'état affiché à l'écran.
6. Vérifier la console navigateur : zéro nouvelle erreur.
7. Capturer une vidéo du parcours complet.

Si une étape échoue, corriger et reprendre depuis l'étape 1.

## Gotchas

- Le staging peut renvoyer 200 même quand le webhook du fournisseur de
  paiement n'a pas réellement été traité. Toujours vérifier l'état réel
  côté base de données, jamais uniquement le code HTTP.
- La carte de test de refus doit être testée à chaque fois : une
  régression peut casser uniquement le chemin d'échec sans toucher au
  chemin de succès.
- <TODO: ajoutez ici tout gotcha découvert lors de l'intégration d'un
  second moyen de paiement — un cas fréquent est qu'un nouveau provider
  fasse régresser silencieusement l'état enregistré pour le premier.>
