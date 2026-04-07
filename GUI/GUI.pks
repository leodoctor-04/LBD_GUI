create or replace package GUI as

root constant VARCHAR2(20) := '/apex/Benedetti2526.';
accountutente constant VARCHAR2(20) := 'Benedetti2526';

procedure home(IdSessione IN NUMBER DEFAULT NULL, msg IN VARCHAR2 DEFAULT NULL);

procedure visualizzaCorsi;

end GUI;