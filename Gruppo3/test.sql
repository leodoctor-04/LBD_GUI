create or replace procedure test IS BEGIN
    baseHTML.apriPagina('test', 5);

        Corsi.visualizzaCorso(1);
        Corsi.moduloInserisciCorso;

        baseHTML.apriTabella;
            baseHTML.inizioRiga;
                baseHTML.inserisciIntestazione('Titolo');
                baseHTML.inserisciIntestazione('Descrizione');
            baseHTML.fineRiga;

            baseHTML.inizioRiga;
                baseHTML.inserisciCella('Zumba');
                baseHTML.inserisciCella('Questo è zumba???');
            baseHTML.fineRiga;

            baseHTML.inizioRiga;
                baseHTML.inserisciCella('dario');
                baseHTML.inserisciCella('vuole trobbe rope');
            baseHTML.fineRiga;
            baseHTML.inizioRiga;
                baseHTML.inserisciCella('abc');
                baseHTML.inserisciCella('123');
            baseHTML.fineRiga;
        baseHTML.chiudiTabella;

    baseHTML.chiudiPagina;
end test;
