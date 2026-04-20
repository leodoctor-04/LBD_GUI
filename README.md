benvenuti alla repo del gruppo di grafica.

# struttura repo

directory:
- **libs**: pacchetti che provengano da altri gruppi
- **pages**: procedure che rappresentano le pagine del sito 
- **ui**: pacchetti che riguardano l'html e css

# sequenza di compilazione 

steps:
1. libs/global.pks
2. libs/sessioneUtente.pks e .pkb
3. ui/Stile.pks e .pkb
4. ui/baseHTML.pks e .pkb
5. ui/Componenti.pks e.pkb
6. pages/home.sql
7. pages/loginProc.sql
8. grant.sql

# esempi

esempio di url: http://131.114.73.17:8080/apex/Benedetti2526.home

nota: questa corrisponde alla procedura [home.sql](pages/home.sql)