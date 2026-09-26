## Reponse a la question architecture
=> L'agent terrain saisit les donnees meme sans connexion internet.
 Et les donnees sont enregistrees localement dans un base SQLite avec statut en attente. 
 L'application peut donc continuer a fonctionner normalement hors ligne,
  et lorsque la connection internet revient, l'application recherche les donnees avec 
  le statut en attente et les envoyees au serveur en ligne.Si l'envoi reussi, 
  le statut des donnees changent par synchronise.Et en cas d'erreur, les donnees en attente peut synchroniser
    toujours quand il y a de la connexion. Pour eviter les doublons, le serveur verifie l'identifiant 
    avant de l'enregistrer. Et en cas de conflits, on peut faire un dernier modification