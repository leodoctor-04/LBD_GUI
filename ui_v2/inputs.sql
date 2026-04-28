-- utils
create or replace type ora is varray(2) of number;
/

-- ui types
create or replace type f_input under uielem(
    in_name VARCHAR(100),
    
    CONSTRUCTOR FUNCTION f_input (id varchar default '', class varchar default '', css_style varchar default '', in_name varchar default '') RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
)NOT FINAL;
/
     

create or replace TYPE BODY f_input IS
    CONSTRUCTOR FUNCTION f_input (id varchar default '', class varchar default '', css_style varchar default '', in_name varchar default '') RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        return;
    end;

    OVERRIDING MEMBER PROCEDURE showhtml as
    BEGIN
        return;
    END;
END;
/

create or replace type submit_butt under f_input(
    CONSTRUCTOR FUNCTION submit_butt(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar) RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace type body submit_butt is
    CONSTRUCTOR FUNCTION submit_butt(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar) RETURN SELF AS RESULT AS
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        return;
    end;
    OVERRIDING MEMBER PROCEDURE showhtml as
    begin
        -- ho sostituito name con value perche li tratta come  se fossero la stessa cosa
        htp.print(
            '<input '   || 
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '" ' ||
            'value="'   || self.in_name     || '" ' ||
            'type ="'   || 'submit'         || '" ' ||
            '>'
        );
    end;
end;
/

create or replace type numberInput under f_input(
    in_value number,

    constructor function numberInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value number) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body numberInput IS
    constructor function numberInput(id varchar, class varchar, css_style varchar,in_name varchar,in_value number) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
        return;
    end; 
    overriding member procedure showhtml as
    begin
        htp.print(
            '<input '   || 
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '" ' ||
            'name="'    || self.in_name     || '" ' ||
            'value="'   || self.in_value    || '" ' ||
            'type="'    || 'number'         || '" ' ||
            '>'
        );
    end; 
end;
/

create or replace type textInput under f_input(
    in_value varchar(200),

    constructor function textInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value varchar) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body textInput IS
    constructor function textInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value varchar) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
        return;
    end; 
    overriding member procedure showhtml as
    begin
        htp.print(
            '<input '   || 
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '" ' ||
            'name="'    || self.in_name     || '" ' ||
            'value="'   || self.in_value    || '" ' ||
            'type="'    || 'text'         || '" ' ||
            '>'
        );
    end; 
end;
/

create or replace type passwordInput under f_input(
    in_value varchar(200),

    constructor function passwordInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value varchar) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body passwordInput IS
    constructor function passwordInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value varchar) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
        return;
    end; 

    overriding member procedure showhtml as
    begin
        htp.print(
            '<input '   || 
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '" ' ||
            'name="'    || self.in_name     || '" ' ||
            'value="'   || self.in_value    || '" ' ||
            'type="'    || 'password'       || '" ' ||
            '>'
        );
    end; 
end;
/

create or replace type textAreaInput under f_input(
    in_value varchar(500),

    constructor function textAreaInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value varchar) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body textAreaInput IS
    constructor function textAreaInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value varchar) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
        return;
    end; 
    overriding member procedure showhtml as
    begin
        htp.print(
            '<textarea '|| 
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '" ' ||
            'name ="'   || self.in_name     || '" ' ||
            '>'         || self.in_value    || '</textarea>'
        );
    end; 
end;
/

create or replace type checkbox under f_input(
    in_value number(1), -- nota: boolean non e' utilizzabile quindi deve essere un numero 0/1 (qualcosa sul non e' un dato che esiste nel sql)
    text varchar(200),

    constructor function checkbox(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value number) return self as result,
    overriding member procedure showhtml 
);
/
create or replace type body checkbox is
    constructor function checkbox(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value number) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
        return;
    end;
    overriding member procedure showhtml as
    begin
        --questa permetterebbe di far comapare 0 o 1 per ogni checkbox per segnare se segnalata o no
        --htp.print('<input type="hidden" name="'|| self.in_name||'" value="0">')
        htp.print(
            '<input '   || 
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '" ' ||
            'name="'    || self.in_name     || '" ' ||
            'value="'   || '1'              || '" ' ||
            'type="'    || 'checkbox'       || '" ' 
        );

        if(self.in_value != 0) then
            htp.print('checked >');
        else
            htp.print('>');
        end if;

        htp.print('<label for= "'|| self.in_name ||'">' || self.in_value ||'</label>'); -- domanda: br o no br?
    end;
end;
/

create or replace type dateInput under f_input(
    in_value date,

    constructor function dateInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value date) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body dateInput IS
    constructor function dateInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value date) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
        return;
    end; 
    overriding member procedure showhtml as
    begin
        htp.print(
            '<input '           || 
            'id="'              || self.id                              || '" ' ||
            'class="'           || self.class                           || '" ' ||
            'style="'           || self.css_style                       || '" ' ||
            'name="'            || self.in_name                         || '" ' ||
            'value="'           || TO_CHAR(self.in_value,'dd-mm-yyyy')  || '" ' ||
            'type="'            || 'date'                               || '" ' ||
            'placeholder ="'    || 'dd-mon-yyyy'                        || '" ' ||
            '>'
        );
    end; 
end;
/

create or replace type timeInput under f_input(
    in_value ora,

    constructor function timeInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value ora) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body timeInput IS
    constructor function timeInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value ora) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
        return;
    end; 
    overriding member procedure showhtml as
    hstr varchar(3);
    mstr varchar(3);
    begin
        if (self.in_value(1) < 10) then
            hstr := '0' || self.in_value(1);
        else 
            hstr := ''  || self.in_value(1);
        end if;

        if (self.in_value(2) < 10) then
            mstr := '0' || self.in_value(2);
        else 
            mstr := ''  || self.in_value(2);
        end if;



        htp.print(
            '<input '           || 
            'id="'              || self.id                                      || '" ' ||
            'class="'           || self.class                                   || '" ' ||
            'style="'           || self.css_style                               || '" ' ||
            'name="'            || self.in_name                                 || '" ' ||
            'value="'           || hstr || ':' || mstr                          || '" ' ||
            'type="'            || 'time'                                       || '" ' ||
            '>'
        );
    end; 
end;
/

create or replace type hiddenInput under f_input(
    in_value varchar(200),

    constructor function hiddenInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value varchar) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body hiddenInput IS
    constructor function hiddenInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar, in_value varchar) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
        return;
    end; 
    overriding member procedure showhtml as
    begin
        htp.print(
            '<input '   || 
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '" ' ||
            'name="'    || self.in_name     || '" ' ||
            'value="'   || self.in_value    || '" ' ||
            'type="'    || 'hidden'         || '" ' ||
            '>'
        );
    end; 
end;
/