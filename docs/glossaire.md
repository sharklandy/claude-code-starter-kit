# Glossaire

> Extrait des Annexes de [`guide-complet.md`](./guide-complet.md), pour un accès rapide sans charger tout l'ebook.

| Terme | Définition |
|---|---|
| **Boucle (loop)** | Un agent qui répète des cycles de travail jusqu'à ce qu'une condition d'arrêt soit remplie. |
| **Harnais (harness)** | L'échafaudage logiciel autour du modèle : décide comment une tâche est planifiée, découpée, vérifiée et exécutée. |
| **Workflow dynamique** | Un harnais écrit par Claude lui-même, à la volée, sous forme de programme (JavaScript), sur mesure pour la tâche en cours. |
| **Workflow statique** | Un harnais construit à l'avance par un humain (via le Claude Agent SDK ou `claude -p` en boucle), générique pour couvrir tous les cas. |
| **Skill** | Un dossier d'instructions, de scripts et de ressources qu'un agent peut découvrir et utiliser pour accomplir des tâches plus précisément et efficacement. |
| **Paresse agentique** | Mode de défaillance où Claude déclare une tâche complexe terminée après un progrès seulement partiel. |
| **Biais d'auto-préférence** | Tendance de Claude à privilégier ses propres résultats quand il évalue son propre travail. |
| **Dérive (drift)** | Perte progressive du fil de l'objectif initial au fil d'une session longue. |
| **Divulgation progressive** | Structurer un skill en plusieurs fichiers, lus par Claude uniquement au moment pertinent, plutôt que de tout charger d'un coup. |
| **Gotchas** | Section d'un skill listant les pièges et erreurs récurrentes rencontrées, considérée comme le contenu au plus fort signal d'un skill. |
