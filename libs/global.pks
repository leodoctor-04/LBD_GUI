
create or replace package  global as
    accountutente constant VARCHAR2(20) := 'Benedetti2526';
    root constant VARCHAR2(20) := '/apex/'|| accountutente ||'.';
    url constant VARCHAR2(100) := 'http://http://131.114.73.17:8080' || root;
end global;