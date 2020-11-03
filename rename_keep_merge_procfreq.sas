/*création de la bibliothèque tp2*/
libname tp2 "/folders/myfolders/TP2";

/*création de la table produit dans tp2 à partir de sashelp.prdsal2*/
data tp2.produit;
set sashelp.prdsal2;
run;

/*créer une variable ID de type numérique incrémental qui servira d'identifiant
pour chaque produit*/

data tp2.produit;
id = _N_;
set tp2.produit;
run;


/*Renommer la variable predict en prix et la variable product en produit*/
data tp2.produit;
rename predict=prix product=produit;
set tp2.produit;
id = _N_;
run;

data tp2.produit; 
set tp2.produit(rename=(predict=prix product=produit));
run;


/*
Garder que les colonnes id, prix et produit (en utilisant drop et ensuite keep)
*/

data tp2.var_sup;
drop country state county actual prodtype year quarter month monyr;
set tp2.produit;
run;

data tp2.produit;
keep id produit prix;
set tp2.produit;
id=_N_;
run;


/*
Ne Garder que les 100 lignes en commençant par la 10 ème
*/
data tp2.cent_produit;
set tp2.produit(obs=109 firstobs=10);
id=_N_;
run;

/*
Ne garder que les 50 lignes en commençant par la 50ème
*/
data tp2.cinquante_produit;
set tp2.produit(obs=99 firstobs=50);
id=_N_;
run;

/*Création de la table catégorisation de prix*/
data tp2.categorisation_prix;
set tp2.produit;
length niveau_prix $20;
if prix<500 then niveau_prix="Moins de 500$";
else if 500<=prix<=1500 then niveau_prix="Entre 500 et 1500$";
else niveau_prix="Supérieur à 1500$";
run;

data tp2.categorisation_prix_2;
set tp2.produit;
length niveau_prix $20;
select;
	when(prix < 500) niveau_prix="Moins de 500$";
	when(500<=prix<=1500) niveau_prix="Entre 500 et 1500$";
	otherwise niveau_prix="Supérieur à 1500$";
end;
run;

/*
Déterminer le nombre d'élément dans chaque catégorie de prix en utilisant la proc freq
*/
proc freq data=tp2.categorisation_prix;
tables niveau_prix;
run;

proc format;
value intPrix
low-500 = 'Moins de 500$'
500-1500= 'Entre 500 et 1500$'
1500-high='Supérieur à 1500$';
run;

data tp2.categorisation_prix_3;
set tp2.produit;
niveau_prix= put(prix, intPrix.);
run;

proc freq data=tp2.categorisation_prix_3;
tables niveau_prix;
run;

/*Jointures*/
/*
- Faire l'union des deux tables cent_produit et cinquante_produit pour créer 
une table cent_cinquante_produits en utilisant l'instruction set
*/
data tp2.cent_cinquante_produits;
set tp2.cent_produit tp2.cinquante_produit;
run;

/*
créer une table jointure_100_50 à partir de la table   cent_produit et 
cinquante_produit (garder que les variables id et produits) sur la clé identifiant 
ID On veut garder que les éléments qui sont dans les 2 tables.
*/
data tp2.jointure_100_50;
/*keep id produit;*/
merge tp2.cent_produit tp2.cinquante_produit(keep= id produit);
by id;
run;

/*
créer une table jointure_100_50 à partir de la table cent_produit (garder que les 
variables id et produits) et cinquante_produit sur la clé identifiant ID
On veut garder tous les éléments qui sont dans la table cent_produit. 
Que remarquez-vous dans la table résultante ?
*/
data tp2.jointure_100_50_2;
merge tp2.cent_produit(keep=id produit) tp2.cinquante_produit;
by id;
run;
/*on remarque une duplication des observations communes aux 2 tables*/

/*
créer une table jointure_100_50 à partir de la table cent_produit et 
cinquante_produit (garder que les variables id et produits) sur les clés 
identifiant ID et produit on veut garder tous les éléments qui sont dans la table 
cinquante_produit et obtenir les prix de ces produits à partir de la table 
cent_produit.
*/
data tp2.jointure_100_50_3;
set tp2.cent_produit tp2.cinquante_produit(keep=id produit);
by id produit;
run;

/*
créer une table jointure_50_categorie à partir de la table tp2.categorisation_prix2
 et cinquante_produit sur la clé identifiant ID pour obtenir les catégories de prix
 pour ces cinquante produits.
*/
data tp2.jointure_50_categorie;
merge tp2.cinquante_produit tp2.categorisation_prix2;
by id;
run;