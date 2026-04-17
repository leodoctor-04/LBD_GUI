create or replace package layout AS
    function hlist(gap number default 0, valign varchar default 'start', halign varchar default 'start') return varchar;
    function vlist(gap number default 0, valign varchar default 'start', halign varchar default 'start') return varchar;
    function grid(grow NUMBER default -1 ,gcolumn NUMBER default -1,gap number default 0) return VARCHAR;

    function add_size(width varchar default '', height varchar default '') return varchar;
end;
/

create or replace package body layout as
    function hlist(gap number default 0, valign varchar default 'start', halign varchar default 'start') return varchar is
    BEGIN
        return 'display: flex;flex-direction: row;flex-flow: 1;column-gap: '|| gap || ';align-content:' || halign || ';justify-content:' || valign || ';';
    end;

    function vlist(gap number default 0, valign varchar default 'start', halign varchar default 'start') return varchar is
    BEGIN
        return 'display: flex;flex-direction: column;flex-flow: 1;row-gap: ' || gap || ';align-content:' || halign || ';justify-content:' || valign || ';';
    end;

    function grid(grow NUMBER default -1,gcolumn NUMBER default -1,gap number default 0) return VARCHAR is
    begin

        if(grow = -1 and gcolumn = -1) then
            -- deault grid
            return 'display: grid;grid-template-rows: repeat(' || grow || ',1fr);grid-template-columns: repeat('|| gcolumn || ',1fr);gap: '|| gap || ';';
        else
            if(grow = -1) then
                -- row in auto adjust
                return 'display: grid;grid-template-columns: repeat('|| gcolumn || ',1fr);gap: '|| gap || ';';
            else 
                if(gcolumn = -1) then
                    -- column in auto adjust
                    return 'display: grid;grid-template-rows: repeat(' || grow || ',1fr);gap: '|| gap || ';';
                else
                    return 'display: grid;grid-template-rows: repeat(' || grow || ',1fr);grid-template-columns: repeat('|| gcolumn || ',1fr);gap: '|| gap || ';';
                end if; 
            end if;
        end if;
    end;

    function add_size(width varchar default '', height varchar default '') return varchar is
        res VARCHAR(200) := '';
    begin
        if(width != '') then
            res := res + ( 'width:' || width);
        end if;

        if(height!= '') then
            res := res + ('height' || height);
        end if;

        return res + ';';
    end;

    function add_internal_spacing(spacing varchar default '') return varchar is
    begin
        return 'padding:' || spacing ||';';
    end;

    function add_external_spacing(spacing varchar default '') return varchar is
    begin
        return 'margin:' || spacing ||';';
    end;
end;