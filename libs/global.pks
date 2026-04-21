create or replace package  global as
    idx CONSTANT VARCHAR(33) := 'http://131.114.73.17:8080'; 
    accountutente constant VARCHAR2(20) := 'Benedetti2526';
    root constant VARCHAR2(20) := '/apex/'|| accountutente ||'.';
    url constant VARCHAR2(100) := 'http://131.114.73.17:8080' || root;
end global;