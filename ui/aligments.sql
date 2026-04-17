create or replace package aligment as
    page_end      constant varchar(3) := 'end';
    page_start    constant varchar(5) := 'start';
    page_center   constant varchar(6) := 'center';
    space_between constant varchar(20) := 'space-between';
    space_evenly  constant varchar(20) := 'space-evenly';
    space_around  constant varchar(20) := 'space-around';
end;
/