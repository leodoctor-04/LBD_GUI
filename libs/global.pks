
create or replace package  global as
    accountutente constant VARCHAR2(20) := 'Mugnaini2526';
    root constant VARCHAR2(20) := '/apex/'|| accountutente ||'.';
end global;