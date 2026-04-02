create or replace package GUI as

root constant VARCHAR2(20) := '/apex/Benedetti2526.';
accountutente constant VARCHAR2(20) := 'Benedetti2526';

procedure mettiHeader(
    TitoloPagina IN VARCHAR2
    );
procedure mettiFooter;

procedure lista;

procedure home;

procedure visualizzaCorsi;

end GUI;