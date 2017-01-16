# HotPursuit
Hot Pursuit GTA-V FiveReborn Gamemode

[Ordre des choses]
Quand le joueur se connecte, verifier s'il y a une crouse en cours.
	s'il y en a une, mettre le joueur en specateur
		en appuyant sur une touche, il passe d'un joueur a l'autre
	s'il y en a pas le faire appraitre normalement
Mettre le joueur avec un niveau de recherche a 0
Les joueurs choisissent une voiture (a choisir dans un menu - s'inpirer d'une version simplifié de vehshop)
	Des qu'ils arrisent dans le jeux un menu apparait et ils sont dans le magasin de voiture
Determiner que quand un joueur a choisis sa voiture, il apparait directement dedans et il est "pret"
Les voiture ne peuvent pas bouger en attendant les autres joueurs
Quand tous les joueurs sont prêt afficher un compte a rebourg et commencer la courses
Determiner le point d'arrivé
Mettre tous les joueurs avec un niveau de recherche a 5
Quand un joueur est mort il devient spectateur
	Mettre son niveau de recherche a 0
Si un joueur atteind le point d'arriver, il a gagné
	Afficher qu'il a gagné chez tout le monde et mettre les niveau de recherche a 0

[INFOS SERVEUR]
Nombre de joueur
Joueur Pret
Nombre de joueur en course
Partie en cours ou pas
Recuperer nom du joueur gagnant


[OK]
->Placer les joueurs
->Placer des voitures
->Les faires être prêt quand ils entrent dans une voiture
->Les joueurs sont directement recherché niveau 5

[A VERIFIER]
-Détecter quand un joueur s'est fait tué/quand il a finit une course
-Mettre ce joueur en spectateur

[A FAIRE]
-Definir un objectif aleatoire parmis une liste
-Changer de personne a suivre avec les fleches droite et gauche("del" actuellement)
-S'il ne reste qu'un joueur, il a gagné et tout le monde re-apparait
-Donner un point au dernier en vie
-Dessiner un tableau des scores

[A VOIR]
-Mettre des Check Point (10-15 a voir ceux present sur la map "race-test" en les faisant apparaitre sur la map via des blip ect...)
-Donner 1 point par Checkpoint passé au joueur qui le passe

