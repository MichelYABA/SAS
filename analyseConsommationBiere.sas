libname projet "/folders/myfolders/ProjetSAS/data";


/* Ici nous allons transposé à partir des valeurs nuq, et nous allons utiliser la variable
item et la variable value pour avoir ces valeurs dans le tableau. Cependant pour obtenir
les Noms sur les colonnes, il faudrait utiliser ID var, cette solution ne fonctionne pas
parce que les valeur r6 se repêtent pour la même valeur de nuq */
 

PROC TRANSPOSE data=projet.don2 Out=projet.table1_partieA delimiter=_;
BY nuq;
var value;
run;

/* Nous allons renommer les noms des colonnes par les valeurs présentent dans la variable var */

Data projet.biere;
set projet.table1_partieA;
rename COL1 = R2_ COL2 = R3 COL3 = cognac COL4 = R5_ COL5 = R6_1 COL6 = R6_2 COL7 = R6_3
COL8 = R6_4 COL9 = R6_5 COL10 = R6_6 COL11 = R6_7 COL12 = R6_8 COL13 = R6_9 COL14 = R6_10
COL15 = R11_1 COL16 = R11_2 COL17 = R11_3 COL18 = R11_4 COL19 = R11_5 COL20 = R11_6 COL21 = R11_7
COL22 = R11_8 COL23 = R11_9 COL24 = R11_10 COL25 = R11_11 COL26 = R11_12 COL27 = R11_13 COL28 = R11_14
COL29 = us3a_1 COL30 = us3a_2 COL31 = us3a_3 COL32 = us3a_4 COL33 = us3a_5 COL34 = us3a_6 COL35 = us3a_7
COL36 = us5a_1 COL37 = us5a_2 COL38 = us5a_3 COL39 = ia1_2 COL40 = ia1_3 COL41 = ia1_4 COL42 = ia1_5
COL43 = ia1_6 COL44 = ia1_7 COL45 = ia1_8 COL46 = ia1_9 COL47 = ia1_10 COL48 = ia1_11 COL49 = ia1_15
COL50 = ia1_17 COL51 = ia1_18 COL52 = ia1_19 COL53 = ia1_21 COL54 = ia1_22 COL55 = ia1_23 COL56 = ia1_24
COL57 = ia1_25 COL58 = ia1_30 COL59 = ia1_31 COL60 = ia1_33 COL61 = ia1_34 COL62 = ia1_35 COL63 = ia1_36
COL64 = ia1_37 COL65 = R12 COL66 = R13 COL67 = R14;

/* Nous allons declarer des format pour les sexe et la consommation */

PROC FORMAT ;
VALUE MaleFemale
1 = "Male"
2 = "Famale";
Value Consommation
1 = "Jamais"
2 = "Moins souvent"
3 = "Une fois par 4 à 6 mois"
4 = "Une fois par 2 à 3 mois"
5 = "1 à 3 fois par mois"
6 = "1 à 4 fois par semaine"
7 = "Presque Tous les jour/Souvent";
Value PresenceEnfant
1 = "Yes"
2 = "No";
run;

/* Nous l'appliquons au donnee */ 

data projet.biere_1;
set projet.biere(drop=_Name_ COL68 COL69 COL70 COL71 COL72);
format R2_ MaleFemale.;
format R5_ Consommation.;
format R14 PresenceEnfant.;
run;

/* Creation d'une variable en class d'age avec le SELECT */ 
data projet.biere_2;
set projet.biere_1;
SELECT;
	WHEN (R3 >= 20 & R3 < 35) DO;
		ClassAge = "20-34";
	END;
	WHEN (R3 > 34 & R3 < 50) DO;
		ClassAge = "35-49";
	END;
	WHEN (R3 > 49 & R3 < 66) DO;
		ClassAge = "50-65";
	END;
	OTHERWISE ClassAge = ">65";
END;
run;


/* Pour tester toutes les variables nous allons utiliser la proc freq */


PROC FREQ data=projet.biere_2;
TABLES R2_ ClassAge R12 R13 R14;
run;

/* Les résultats obtenues nous permettent de déduire que :
- Par rapport au sexe, on a 73.86 % des personnes de sexe masculin 
	et 26.14 % personnes de sexe féminin.
- Par rapport à l'age, on a :
	* Il y a 18.18 % des personnes entre 20 et 34 ans.
	* Il y a 37.12 % des personnes entre 35 et 49 ans.
	* Il y a 44.70 % des personnes entre 50 et 65 ans.
- Par rapport à la situatio matrimoniale, on a :
	* 1.89 % des célibataires
	* 15.15 % des couples séparés ou veuf(ves) ou divorcés
	* 23.11 % des mariés
	* 59.85 % des autres situations
- Par rapport aux revenus, on a :
	* 19.32 des personnes qui ont moins de 10,000 £
	* 8.33 	des personnes qui ont entre  £ 10,000 et £ 19,999
	* 72.35 des personnes qui ont entre £ 20,000 et £ 29,999
- Par rapport aux persones qui ont des enfants ou pas, on a :
	* 35.98 % des personnes qui  ont des enfants
	* 64.02 % des personnes qui n'ont pas des enfants
	
*/

/* Question 5 partie a */ 
PROC FREQ data=projet.biere_2;
TABLES R2_*Cognac;
run;
/*
37.50 % des hommes consomment du cognac 1
36.36 % des hommes consomment du cognac 2

11.74 % des femmes consomment du cognac 1
14.39 % des femmes consomment du cognac 2

Du coup les hommes consomment plus de cognac que les femmes.
*/

/* Question 5 partie b */
PROC FREQ data=projet.biere_2;
TABLES Cognac*ClassAge;
run;

/*
Il y a : 
- 18.18 % des personnes entre 20 et 34 ans qui consomment le Cognac
- 37.12 % des personnes entre 35 et 49 ans qui consomment le Cognac
- 44.70 % des personnes entre 50 et 65 ans qui consomment le Cognac

On dira donc que la consommation de Cognac n'est pas identique en fonction de l'âge.
Les 50-65 en consommes plus.
*/

/*Utilisation du test de Chi-2*/
proc freq data=projet.biere_2;
tables Cognac*ClassAge / chisq ;
run;


/* PARTIE B */

PROC FORMAT;
VALUE LOS
1 = 0
2 = 0.25
3 = 0.5
4 = 0.75
5 = 1;
run;

/* Nous allons transformer les variables d'intention d'achats avec ces valeurs */
data projet.biere_3;
set projet.biere_2;
if ia1_2 = "1" then ia1_2 = 0; if ia1_2 = "5" then ia1_2 = 1; if ia1_2 = "4" then ia1_2 = 0.75; if ia1_2 = "3" then ia1_2 = 0.5; if ia1_2 = "2" then ia1_2 = 0.25; 
if ia1_3 = "1" then ia1_3 = 0; if ia1_3 = "5" then ia1_3 = 1; if ia1_3 = "4" then ia1_3 = 0.75; if ia1_3 = "3" then ia1_3 = 0.5; if ia1_3 = "2" then ia1_3 = 0.25; 
if ia1_4 = "1" then ia1_4 = 0; if ia1_4 = "5" then ia1_4 = 1; if ia1_4 = "4" then ia1_4 = 0.75; if ia1_4 = "3" then ia1_4 = 0.5; if ia1_4 = "2" then ia1_4 = 0.25; 
if ia1_5 = "1" then ia1_5 = 0; if ia1_5 = "5" then ia1_5 = 1; if ia1_5 = "4" then ia1_5 = 0.75; if ia1_5 = "3" then ia1_5 = 0.5; if ia1_5 = "2" then ia1_5 = 0.25; 
if ia1_6 = "1" then ia1_6 = 0; if ia1_6 = "5" then ia1_6 = 1; if ia1_6 = "4" then ia1_6 = 0.75; if ia1_6 = "3" then ia1_6 = 0.5; if ia1_6 = "2" then ia1_6 = 0.25; 
if ia1_7 = "1" then ia1_7 = 0; if ia1_7 = "5" then ia1_7 = 1; if ia1_7 = "4" then ia1_7 = 0.75; if ia1_7 = "3" then ia1_7 = 0.5; if ia1_7 = "2" then ia1_7 = 0.25; 
if ia1_8 = "1" then ia1_8 = 0; if ia1_8 = "5" then ia1_8 = 1; if ia1_8 = "4" then ia1_8 = 0.75; if ia1_8 = "3" then ia1_8 = 0.5; if ia1_8 = "2" then ia1_8 = 0.25; 
if ia1_9 = "1" then ia1_9 = 0; if ia1_9 = "5" then ia1_9 = 1; if ia1_9 = "4" then ia1_9 = 0.75; if ia1_9 = "3" then ia1_9 = 0.5; if ia1_9 = "2" then ia1_9 = 0.25; 
if ia1_10 = "1" then ia1_10 = 0; if ia1_10 = "5" then ia1_10 = 1; if ia1_10 = "4" then ia1_10 = 0.75; if ia1_10 = "3" then ia1_10 = 0.5; if ia1_10 = "2" then ia1_10 = 0.25; 
if ia1_11 = "1" then ia1_11 = 0; if ia1_11 = "5" then ia1_11 = 1; if ia1_11 = "4" then ia1_11 = 0.75; if ia1_11 = "3" then ia1_11 = 0.5; if ia1_11 = "2" then ia1_11 = 0.25; 
if ia1_15 = "1" then ia1_15 = 0; if ia1_15 = "5" then ia1_15 = 1; if ia1_15 = "4" then ia1_15 = 0.75; if ia1_15 = "3" then ia1_15 = 0.5; if ia1_15 = "2" then ia1_15 = 0.25; 
if ia1_17 = "1" then ia1_17 = 0; if ia1_17 = "5" then ia1_17 = 1; if ia1_17 = "4" then ia1_17 = 0.75; if ia1_17 = "3" then ia1_17 = 0.5; if ia1_17 = "2" then ia1_17 = 0.25; 
if ia1_18 = "1" then ia1_18 = 0; if ia1_18 = "5" then ia1_18 = 1; if ia1_18 = "4" then ia1_18 = 0.75; if ia1_18 = "3" then ia1_18 = 0.5; if ia1_18 = "2" then ia1_18 = 0.25; 
if ia1_19 = "1" then ia1_19 = 0; if ia1_19 = "5" then ia1_19 = 1; if ia1_19 = "4" then ia1_19 = 0.75; if ia1_19 = "3" then ia1_19 = 0.5; if ia1_19 = "2" then ia1_19 = 0.25; 
if ia1_21 = "1" then ia1_21 = 0; if ia1_21 = "5" then ia1_21 = 1; if ia1_21 = "4" then ia1_21 = 0.75; if ia1_21 = "3" then ia1_21 = 0.5; if ia1_21 = "2" then ia1_21 = 0.25; 
if ia1_22 = "1" then ia1_22 = 0; if ia1_22 = "5" then ia1_22 = 1; if ia1_22 = "4" then ia1_22 = 0.75; if ia1_22 = "3" then ia1_22 = 0.5; if ia1_22 = "2" then ia1_22 = 0.25; 
if ia1_23 = "1" then ia1_23 = 0; if ia1_23 = "5" then ia1_23 = 1; if ia1_23 = "4" then ia1_23 = 0.75; if ia1_23 = "3" then ia1_23 = 0.5; if ia1_23 = "2" then ia1_23 = 0.25; 
if ia1_24 = "1" then ia1_24 = 0; if ia1_24 = "5" then ia1_24 = 1; if ia1_24 = "4" then ia1_24 = 0.75; if ia1_24 = "3" then ia1_24 = 0.5; if ia1_24 = "2" then ia1_24 = 0.25; 
if ia1_25 = "1" then ia1_25 = 0; if ia1_25 = "5" then ia1_25 = 1; if ia1_25 = "4" then ia1_25 = 0.75; if ia1_25 = "3" then ia1_25 = 0.5; if ia1_25 = "2" then ia1_25 = 0.25; 
if ia1_30 = "1" then ia1_30 = 0; if ia1_30 = "5" then ia1_30 = 1; if ia1_30 = "4" then ia1_30 = 0.75; if ia1_30 = "3" then ia1_30 = 0.5; if ia1_30 = "2" then ia1_30 = 0.25; 
if ia1_31 = "1" then ia1_31 = 0; if ia1_31 = "5" then ia1_31 = 1; if ia1_31 = "4" then ia1_31 = 0.75; if ia1_31 = "3" then ia1_31 = 0.5; if ia1_31 = "2" then ia1_31 = 0.25; 
if ia1_33 = "1" then ia1_33 = 0; if ia1_33 = "5" then ia1_33 = 1; if ia1_33 = "4" then ia1_33 = 0.75; if ia1_33 = "3" then ia1_33 = 0.5; if ia1_33 = "2" then ia1_33 = 0.25; 
if ia1_34 = "1" then ia1_34 = 0; if ia1_34 = "5" then ia1_34 = 1; if ia1_34 = "4" then ia1_34 = 0.75; if ia1_34 = "3" then ia1_34 = 0.5; if ia1_34 = "2" then ia1_34 = 0.25; 
if ia1_35 = "1" then ia1_35 = 0; if ia1_35 = "5" then ia1_35 = 1; if ia1_35 = "4" then ia1_35 = 0.75; if ia1_35 = "3" then ia1_35 = 0.5; if ia1_35 = "2" then ia1_35 = 0.25; 
if ia1_36 = "1" then ia1_36 = 0; if ia1_36 = "5" then ia1_36 = 1; if ia1_36 = "4" then ia1_36 = 0.75; if ia1_36 = "3" then ia1_36 = 0.5; if ia1_36 = "2" then ia1_36 = 0.25; 
if ia1_37 = "1" then ia1_37 = 0; if ia1_37 = "5" then ia1_37 = 1; if ia1_37 = "4" then ia1_37 = 0.75; if ia1_37 = "3" then ia1_37 = 0.5; if ia1_37 = "2" then ia1_37 = 0.25; 
run;

/*Nous allons utiliser l'analyse en composante principale (PCA) */ 
PROC FACTOR DATA=projet.biere_3 n=4 outstat=projet.stat_pca out = table_pca plot=all rotate=varimax;
VAR ia1_2 ia1_3 ia1_4 ia1_5 ia1_6 ia1_7 ia1_8 ia1_9 ia1_10 ia1_11 ia1_15 ia1_17 ia1_18 ia1_19 ia1_21 ia1_22 
ia1_23 ia1_24 ia1_25 ia1_30 ia1_31 ia1_33 ia1_34 ia1_35 ia1_36 ia1_37;
run;

/* Pour choisir les NFacteur on a le critère du coude, dans notre PCA Nous avons une chute importante jusqu'a 4 puis la courbe se stabilise 
Nous avons donc choisis 4 facteurs.
*/

/*
Il y a deux manières pour déterminer le nombre d’axes à prendre en compte :
- Un critère “absolu” : ne retenir que les axes dont les valeurs propres sont supérieures à 1 
(c’est le critère de Kaiser).
- Un critère “relatif” : retenir les valeurs propres qui “dominent” les autres.

En partant du critère Kaiser et en regardant le graphe des valeurs propres,
on constate que la valeur propre est supérieur à 1 quand le nombre de facteurs est de 4.
*/

/* Pour choisir les NFacteur on le critère du coude, dans notre PCA Nous une chute importante jusqu'a 4 puis la courbe se stabilise 
Nous avons donc choisis 4 facteurs
*/

/* Question 3 */

proc factor data = projet.biere_3 outstat=projet.stat_pca out = projet.table_pca_par6 nfactors = 6 corr scree ev rotate = varimax method = prin priors = smc plot=all;
VAR ia1_2 ia1_3 ia1_4 ia1_5 ia1_6 ia1_7 ia1_8 ia1_9 ia1_10 ia1_11 ia1_15 ia1_17 ia1_18 ia1_19 ia1_21 ia1_22 
ia1_23 ia1_24 ia1_25 ia1_30 ia1_31 ia1_33 ia1_34 ia1_35 ia1_36 ia1_37;
run;

/* 
Le tableau "Représentation de facteur" aide à interpréter les facteurs, c'est-à-dire identifier 
ce que les facteurs représentent. À partir du tableau "Représentation de facteur", on peut voir que 
la plupart des variables ont des charges élevées sur le facteur 1  par rapport à d'autres facteurs.
Néanmoins il n'est pas évident d'en tirer des conclusions. L'interprétation est plus plus claire après la rotation.

L'analyse du tableau "Représentation de facteur" après la rotation nous permet de déduire que :
- Le facteur 1 a des charges plus élevées sur les variables ia1_4, ia1_5, ia1_8, ia1_11, ia1_15, ia1_17, ia1_18 et ia1_19
- Le facteur 2 a des charges plus élevées sur les variables ia1_2, ia1_3, ia1_6, ia1_7, ia1_9 et ia1_10
- Le facteur 3 a des charges plus élevées sur les variables ia1_33, ia1_34 et ia1_35
- Le facteur 4 a des charges plus élevées sur les variables ia1_36, ia1_37, ia1_21, ia1_22 et ia1_23
- Le facteur 5 a des charges plus élevées sur les variables ia1_30, ia1_24 et ia1_25
- Le facteur 6 a la charges la plus élevée uniquement sur la variable ia1_31

Or, en s'appuyant sur le contenu du fichier excel et les images fournies, on constate que :
- ia1_2 => M7 ( courvoisier vs cognac)
- ia1_3 => V13 (courvoisier vs op fine champagne cognac)
- ia1_4 => L14 (courvoisier xo imperial cognac)
- ia1_5 => Q18 (Hennessy fine de cognac)
- ia1_6 => E27 (hennessy vs cognac)
- ia1_7 => S28 (hennessy vs op cognac)
- ia1_8 => K31 (Hennessy xo cognac)
- ia1_9 => L41 (Martell vs Cognac)
- ia1_10 => C43 (Martell vs op Medaillon Cognac)
- ia1_11 => T45 (Martell XO Cognac)
- ia1_15 => R59 (Remy Martin Coeur de Cognac)
- ia1_17 => D70 (Remy Martin vs op)
- ia1_18 => I74 (Remy Martin XO )
- ia1_19 => D83 (Hine Antique Brandy)
- ia1_21 => L86 (Armagnac)
- ia1_22 => N95 (Dessert wines)
- ia1_23 => H91 (Port)
- ia1_24 => U5 (Glenfiddich 18 years old whisky)
- ia1_25 => o51 (Lavagulin 16 years old Whisky)
- ia1_30 => N72 (Mount Gay XO RUM)
- ia1_31 => C13 (Appleton 12 years old RUM)
- ia1_33 => L79 (Russian Standard  Platinum Vodka)
- ia1_34 => W20 (Grey Goose Vodka)
- ia1_35 => F62 (Absolut Level Vodka)
- ia1_36 => R85 (Hendrick's Gin)
- ia1_37 => G37 (Tanqueray 10 Gin)

- le facteur 1 a un fort taux avec les produia1_4, ia1_8, ia1_11, ia1_15, ia1_18 its et un faible taux
avec les produits ia1_10, ia1_21, ia1_5, ia1_17 et ia1_19.
ia1_4, ia1_8, ia1_11, ia1_15, ia1_18  correspondent respectivement aux produits L14, K31, T45, R59, I74 d'après les images et le fichier excel.
Sachant que L14 correspond à Courvoisier XO imperial cognac, K31 à Hennesy XO Cognac, T45 à Martell XO Cognac, R59 à Remy Martel coeur de Cognac 
et I74 à Remy Martin XO, ce facteur peut être généralisé dans la catégorie des Cognac XO

- le facteur 2 a un fort taux avec les produits ia1_2, ia1_3, ia1_6, ia1_7, ia1_9 
et un faible taux des produits ia1_5 et ia1_10 qu'il partage avec le facteur 1.
ia1_2, ia1_3, ia1_6, ia1_7, ia1_9  correspondent respectivement aux produits M7(Courvoisier vs Cognac), V13(courvoisier vs op fine champagne cognac),
E27(Hennessy vs Cognac), S28(Hennessy vs Op Cognac), L41(Martell vs Cognac) d'après les images et le fichier excel.
De ce fait, ce facteur peut être généralisé dans la catégorie des Cognac Vs.

- le facteur 3 a un fort taux avec les produits ia1_33, ia1_34, ia1_35 qui correspondent
respectivement aux produits L79(Russian Standard Platinum Vodka), W20(Grey Goose Vodka), F62(Absolute Level Vodka) d'après les images et le fichier excel.
De ce fait, ce facteur peut être généralisé dans la catégorie des Vodka.

- le facteur 4 a un fort taux avec les produits ia1_36, ia1_37 et minoritairement ia1_17, ia1_19, ia1_21, ia1_22, ia1_23.
ia1_36 et ia1_37 qui correspondent  respectivement aux produits R85(Hendrick's Gin), G37(Tanqueray 10 Gin) d'après les images et le fichier excel.
De ce fait, ce facteur peut être généralisé dans la catégorie des Gin.

- le facteur 5 a un fort taux avec les produits ia1_24, ia1_25 et minoritairement  ia1_30(N72 ==> Rhum).
ia1_24 et ia1_25 qui correspondent  respectivement aux produits N72(Glenfiddish 18 years old Whisky), C31(Lagavulin 16 years old Whisky) d'après les images et le fichier excel.
De ce fait, ce facteur peut être généralisé dans la catégorie des Whisky.

- le facteur 6 a un taux de représentation, certes, faibles avec les produits  ia1_30 et ia1_31.
ia1_30 et ia1_31 qui correspondent  respectivement aux produits N72(Mount Gay Rum), C13(Appleton 12 years Rum) d'après les images et le fichier excel.
De ce fait, ce facteur peut être généralisé dans la catégorie des Rum.
*/

/*4. Donner un nom à chacun des facteurs (groupe de produits)
D'après l'analyse précédente, 
  - factor1 sera renommé cognac_xo car la plupart des produits (avec les charges les plus élevées) qui y sont projetés sont de type cognac_xo
  - factor2 sera renommé cognac_vs car la plupart des produits (avec les charges les plus élevées) qui y sont projetés sont de type cognac_vs
  - factor3 sera renommé vodka car la plupart des produits (avec les charges les plus élevées) qui y sont projetés sont de type vodka
  - factor4 sera renommé gin car la plupart des produits (avec les charges les plus élevées) qui y sont projetés sont de type gin
  - factor5 sera renommé whisky car la plupart des produits (avec les charges les plus élevées) qui y sont projetés sont de type whisky
  - factor6 sera renommé rum car la plupart des produits (avec les charges les plus élevées) qui y sont projetés sont de type rum
*/


/* Question 4  Rénommage*/ 
data projet.pca;
set projet.stat_pca(rename=(_Name_ = Name));
if Name = "Factor1" then Name = "cognac_xo";
if Name = "Factor2" then Name = "cognac_vs";
if Name = "Factor3" then Name = "vodka";
if Name = "Factor4" then Name = "gin";
if Name = "Factor5" then Name = "whisky";
if Name = "Factor6" then Name = "rum";
run;

/* Question 5 */ 

data projet.bierebis;
set projet.biere_3;
Proba_F1 = (ia1_4 + ia1_5 + ia1_8 + ia1_11 + ia1_15 + ia1_17 + ia1_18 + ia1_19)/8;
Proba_F2 = (ia1_2 + ia1_3 + ia1_6 + ia1_7 + ia1_9 + ia1_10)/6;
Proba_F3 = (ia1_33  + ia1_34 + ia1_35)/3;
Proba_F4 = (ia1_36 + ia1_37 + ia1_21 + ia1_22 + ia1_23)/5;
Proba_F5 = (ia1_30 + ia1_24 + ia1_25)/3;
Proba_F6 = ia1_31;
run;


/*6. Appliquer un label à ces facteurs en fonction du nom donné ci-dessus.*/
PROC CONTENTS DATA=projet.bierebis;
RUN;
/*La procédure Contents nous permet d'avoir les informations sur une table
En l'appliquant sur la table bierebis, on remarque bel et bien que cette dernière
n'a pas des libellés*/

DATA  projet.bierebis;
   SET projet.bierebis;
   LABEL  Proba_F1 ="Courvoisier, Hennessy, Martell et Remy Martin"
          Proba_F2 ="Courvoisier, Hennessy et Martell"
          Proba_F3 ="Vodka"
          Proba_F4 ="Gin"
          Proba_F5 ="Whisky et Rhum"
          Proba_F6 ="Rhum"
          ;
RUN;

PROC CONTENTS DATA=projet.bierebis;
RUN;

/*7. Calculer les moyennes des variables Proba_F1 à Proba_F6 selon le sexe et la classe
d’âge (créée à l’exercice A3) – Commenter*/

proc means data=projet.bierebis mean;
var Proba_F1 Proba_F2 Proba_F3 Proba_F4 Proba_F5 Proba_F6;
class r2_ classAge;
output out=projet.moyennesProba;
run;

/*
L'analyse des moyennes nous permet de déduire que :
  - Chez les hommes,
  		* les 20-34 ans consomment plus de Cognac ensuite le Rhum puis le Whisky, 
  			la vodka et enfin le Gin
  		* les 35-49 ans consomment plus de Cognac, ensuite le Whisky, le Rhum, le Gin et enfin la vodka
  		* les 50-65 ans consomment plus de Cognac, ensuite le Whisky, le Gin, le Rhum et enfin la vodka
  - Ches les femmes,
  		* les 20-34 ans consomment plus de Cognac, ensuite la vodka, le Gin, le Rhum et enfin le Whisky
  		* les 35-49 ans consomment plus de Cognac, ensuite le Whisky, la Vodka, le gin et enfin le Rhum
  		* les 50-65 ans consomment plus de Cognac, ensuite la vodka, le Gin, le Whisky et enfin le Rhum.
*/


/*Partie C */ 

/*Question 1 */
PROC CLUSTER data=projet.bierebis method=WARD outtree=projet.TREE PLOTS(MAXPOINTS=300);
VAR PROBA_F1 Proba_F2 Proba_F3 Proba_F4 Proba_F5 Proba_F6;
ID NUQ;
run;

/* Arbre */
/*
PROC TREE data=projet.Tree;
run;
*/


/* D'après le dendogramme donné dans le projet, nous observons une classification hierarchique 
de plusieurs classes, nous avons choisis 4 classé car nous obtenons un R carré partiel plus petite 
Nous avons donc des classes plus homogène mais l'inertie entre les classe soit la plus petit possible
ce qui nous donne donc 4 classes
*/

/* Question 3 */ 
/*PROC VARCLUS DATA=projet.bierebis minclusters=5 maxclusters=5
hierarchy outstat=projet.stat_hierarchy outtree=tree2;
run;
*/
/*a. Calculez l’effectif des classes*/
 
proc tree data=projet.TREE out=projet.tree2 nclusters=5  noprint;
run;
 
proc freq data=projet.tree2 ;  
table clusname ; 
run ;

/*
b. Descriptif des classes en termes de variables qui ont construit les classes (les
variables Proba_F1 à Proba_F6)
*/
proc varclus data=projet.bierebis maxclusters=5;
   var PROBA_F1-Proba_F6;
run;

/*
c. Descriptif des classes en termes de sexe, classe d’âge et de consommation de
vins spiritueux (question R5).
*/
proc varclus data=projet.bierebis maxclusters=5;
   var r2_  r5_ r3; /*L'utilisation de la variable classAge ne marche pas*/
run;

/*d.*/

/*i.*/ 
/*
En supposant que les 3 indicatrices correspondent aux variables 
 - us5a_1 pour « Pure, no ice »
 - us5a_2 pour « Pure with ICE »
 - us5a_3 pour « dans un cocktail »
Ces 3 indicatrices auront pour valeur soit :
  - 1=Oui qui traduit "Souvent" ou "Très Souvent" 
  - 0=Non si ce n'est pas le cas
Or "Souvent" et "Très souvent" correspondent respectivement aux valeurs 4 et 5 
des variables us5a_1, us5a_2 et us5a_3.
Les 3 indicateurs seront nommés ind1, ind2 et ind3.
Avec : - ind1 pour indicateur de us5a_1
 	   - ind2 pour indicateur de us5a_2
 	   - ind3 pour indicateur de us5a_3
*/
data projet.bierebis;
set projet.bierebis;
if us5a_1 = "4" | us5a_1 = "5" then ind1=1; else ind1=0;
if us5a_2 = "4" | us5a_2 = "5" then ind2=1; else ind2=0;
if us5a_3 = "4" | us5a_3 = "5" then ind3=1; else ind3=0;
run;

/*ii. Caractériser les 5 classes avec ces 3 nouvelles variables.*/
proc varclus data=projet.bierebis maxclusters=5;
   var ind1 ind2 ind3; 
run;

/*D. Régression logistique.*/

data projet.bierebis;
set projet.bierebis;
if ind1=1 & ind2=1 & ind3=1 then classe5 = 1;
else classe5 = 0;
run;

/*D. Régression logistique.*/
proc logistic data=projet.bierebis descending;
 	class classAge; /*Variable catégorielle*/
	model classe5 = r2_ classAge us5a_1 us5a_2 us5a_3 r12 r13 r14;
run;

/* Observations et Commentaires */
/*
L'application de la regression logistique sur la table bierebis
en analyse descendante nous renvoie 10 tableaux qui nous sont 
essentiels à notre analyse.
Il s'agit des tableaux :
	1 - Informations sur le modèle
	2 - Le profil de réponse
	3 - Informations sur le niveau de classe
	4 - Etat de la convergence du modèle
	5 - Statistique d'ajustement du modèle
	6 - Test d'hypothèse nulle
	7 - Analyse des effets Type 3
	8 - Analyse des valeurs estimées du maximum de vraisemblance
	9 - Estimation du rapport de cotes
	10 - Association des probabilités prédites et des réponses observées

- Le tableau 1 nous indique qu'on fait notre regression
sur la table bierebis, on regresse la variable classeInd de cette table. Cette dernière a 
2 valeurs possibles. Sur les 264 observations seules 248 sont utilisées.

- Le tableau 2 nous donne les modalités de la variable régressée et la fréquence de chacune d'elles.
15 individus utilisent souvent ou très souvent  « Pure, no ice » ET « Pure with
ICE » ET « dans un cocktail » contre 233 qui ne l'utilisent pas.
C'est la probabilité de "souvent ou très souvent utilisé « Pure, no ice » ET « Pure with
ICE » ET « dans un cocktail »" qui est analysée dans ce modèle, ceci grâce à l'option descending.
Les 16 observations manquantes dans les 264 ont été supprimées à cause
de manque des valeurs pour les variables réponse ou explicatives.

- Le tableau 4 nous indique que le critère de convergence du modèle est bien
respecté. C'est-à-dire que le modèle est convergent.

- Dans le tableau 5, les valeurs des critères d'Aikaike(AIC), de Schwartz(SC) et du rapport des
maxima de vraissemblance(-2 Log L) étant inférieures pour notre modèle que dans le cas de la 
constante seule, on peut en déduire que notre modèle n'est a priori pas trop mauvais.

- Dans le tableau 6, des 3 tests d'hypothèse nulle (), seules les 2 premiers 
(le test du rapport de vraissemblance et le score) qui rejetent l'hypothèse de nullité car inférieur
au seuil 0.001. Ce qui n'est pas le cas du test de Wald car 0.4498 > 0.001.
On peut en déduire que le modèle n'est pas globalement valide.

- Dans le tableau 8, tous les coefficients ne sont pas significativement égales à 0. Leur estimation
est positive pour les coefficients us5a_1, us5a_2 et us5a_3 mais elle est négative pour les autres
coefficients. 

- La table 10 nous indique que les prévisions coincident à 99.2 % avec la réalité observée.
On peut donc dire que le modèle est bien adaptée.
*/


/*Question 2. */

/*
Suite à l'analyse faite à la question précédente, on en déduit que les variables à utiliser pour aboutir à un modèle convenable
sont les variables us5a_1, us5a_2 et us5a_3.
*/