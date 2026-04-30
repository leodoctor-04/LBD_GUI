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
4. ui/baseHTML.pks
5. ui/Componenti.pks
6. ui/baseHTML.pkb
7. ui/Componenti.pkb
8. pages/home.sql
9. pages/loginProc.sql
10. grant.sql

# sequenza di compilazione ui_v2
1. drop dei tipi, drop_types.sql (non sempre necessario ma per sicurezza fatelo)
2. compilare ui_v2/uielem.sql
3. compilare ui_v2/container.sql
4. compilare ui_v2/inputs.sql
5. compilare ui_v2/multiOpt_input.sql 
5. compilare ui_v2/tables.sql 
6. compilare i pacchetti di supporto(enum virtuali):
    - ui/aligments.sql
    - ui/layout.sql
    - ui_v2/inputTypes.sql

# esempi

esempio di url: http://131.114.73.17:8080/apex/Benedetti2526.home

nota: questa corrisponde alla procedura [home.sql](pages/home.sql)