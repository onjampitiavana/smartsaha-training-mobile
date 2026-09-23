# Analyse j1
 ## hypothese 1 : Connexion lente
la nouvelle valeur est enregistree mais la connexion peut etre lente, l'ecran peut donc afficher l'ancien valeur
 verification: 
     Actualiser la page et verifie si la nouvelle valeur affiche
     verifie si le requete de recuperation pends beaucoup du temps
     Verifie aussi la connexion internet si l'acces au serveur a besoin de connexion internet
 Strategie de correction:
     Optimiser le requete pour reduire le temps de reponse ou ajouter des index et assurer que les donnees actualisent automatuquement apres la modification ou insertion

 ## hypothese 2 :  Le SELECT ne fonctionne pas correctement
 La nouvelle valeur est enregistree mais la requete SELECT peut recuperer l'ancienne valeur
 verification :
     Executer directement la requete dans la base de donnees et verifie le resultat retournee
 Strategie de correction:
     Corrger la requete SELECT si elle contient des erreurs

