/*1) 1- Création d'une librairie sas TP1 */ 
libname tp1 "/folders/myfolders/TP1";

/*2- Création d'une librairie sas TP1 avec la version V8 de sas (option V8)*/
libname tp1 v8 "/folders/myfolders";


/*3- Lecture de données dans une étape data : 
création d'une table client dans la librairie courante
contenant le nom, l’âge et le sexe à partir de ces données
IDCLT NOM AGE SEXE
1 Jean 23 M
2 Sabrina 45 F
3 Luc 17 M
*/

data client;
input IDCLT NOM $ AGE SEXE $;
cards;
1 Jean 23 M
2 Sabrina 45 F
3 Luc 17 M
;
run;


/*4- Création d'une table test dans la librairie TP1 contenant les variables 
IDCLT NOM AGE SEXE
*/

 data tp1.test;
 set client;
 run;

 
 /*5- A partir de la table test, créer une nouvelle table test1 contenant que 
 les 2 premières observations*/
data tp1.test1;
set tp1.test(obs=2);
run;

/*6. Création d'une table test2 à partir de la table test commençant par la deuxième 
observation*/
data tp1.test2;
set tp1.test(firstobs=2);
run;

/*7. utilisation de l'instruction Keep pour ne garder que les variables 
IDCLT, NOM, AGE de la table test dans une nouvelle table test3
*/
data tp1.test3;
keep IDCLT NOM AGE;
set tp1.test;
run;

data tp1.test3_bis;
set tp1.test(keep=IDCLT NOM AGE);
run;

/*
8. Utilisation de l'instruction DROP pour supprimer les variables AGE de la table test
dans une nouvelle table test4.
*/
data tp1.test4;
drop AGE;
set tp1.test;
run;

data tp1.test4_bis;
set tp1.test(drop= AGE);
run;

/*
9. Création d'une table test5 en renommant la variable IDCLT en identifiant_client
*/
data tp1.test5;
rename IDCLT=identifiant_client;
set tp1.test;
run;

data tp1.test5_bis;
set tp1.test(rename=(IDCLT=identifiant_client));
run;

/*
10. Création d'une nouvelle variable TP dans la table test
qui a pour valeur 2. Une nouvelle variable table qui a pour valeur produit.
Une variable date qui a pour valeur "02OCT2015"d
*/
data tp1.test;
set tp1.test;
TP=2;
table="produit";
date="02OCT2015"d;
run;

/*
11. Création d'une variable double_age qui a pour valeur le double de l'age
*/
data tp1.test;
set tp1.test;
double_age=2*age;
run;

/*
12. Utilisation de l'instruction where ou l'option where pour garder dans la table
que les personnes qui ont un age inférieur à 25 et créer une nouvelle variable triple_age
pour ces personnes
*/
data tp1.test;
set tp1.test;
where age<25;
triple_age = 3*age;
run;