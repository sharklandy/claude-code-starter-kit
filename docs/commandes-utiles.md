# Commandes utiles

> Extrait des Annexes de [`guide-complet.md`](./guide-complet.md), pour un accès rapide sans charger tout l'ebook.

| Commande | Rôle |
|---|---|
| `/goal <critère>, stop after N tries` | Lance une boucle goal-based avec un critère de sortie et un plafond de tentatives |
| `/goal` (sans argument) | Affiche le nombre de tours et l'usage de tokens de l'objectif en cours |
| `/loop <intervalle> <prompt>` | Relance un prompt à intervalle régulier, sur la machine locale |
| `/schedule` | Déplace une boucle time-based dans le cloud sous forme de routine |
| `/workflows` | Affiche l'usage de tokens de chaque agent d'un workflow ; permet de sauvegarder (`s`) ou d'arrêter un agent |
| `/usage` | Détaille l'usage récent, réparti par skills, sous-agents et MCPs |
| `/code-review` | Skill intégré de revue de code par un second agent à contexte frais |
| `/effort ultracode` | Force un effort de raisonnement élevé et la planification automatique de workflows pour toute la session |
| Mot-clé `"ultracode"` dans un prompt | Force la création d'un workflow dynamique pour cette tâche précise |

Voir aussi [`docs/glossaire.md`](./glossaire.md) pour les définitions des termes utilisés ci-dessus, et [`docs/guide-complet.md`](./guide-complet.md) pour le contexte théorique complet.
