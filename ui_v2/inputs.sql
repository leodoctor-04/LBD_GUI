create or replace type f_input under uielem(
    in_name VARCHAR(100),
    
    CONSTRUCTOR FUNCTION f_input (id varchar, class varchar, css_style varchar,in_name varchar) RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
)NOT FINAL;
/
     

create or replace TYPE BODY f_input IS
    CONSTRUCTOR FUNCTION f_input (id varchar, class varchar, css_style varchar,in_name varchar) RETURN SELF AS RESULT as
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

create or replace type option_list is table of varchar(100);
/
create or replace type option_menu under f_input(
    options option_list,

    CONSTRUCTOR FUNCTION option_menu(id varchar, class varchar, css_style varchar, in_name varchar) RETURN SELF AS RESULT,

    MEMBER PROCEDURE add_option(SELF IN OUT option_menu, opt varchar),
    MEMBER PROCEDURE delete_option(SELF IN OUT option_menu, idx number),
    MEMBER PROCEDURE clear_options(SELF IN OUT option_menu),

    MEMBER FUNCTION  search_option(opt varchar) return number,
    MEMBER FUNCTION  count_options return number,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace TYPE BODY option_menu is
    CONSTRUCTOR FUNCTION option_menu(id varchar, class varchar, css_style varchar,in_name varchar) RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.options := option_list();
        return;
    end;

    MEMBER PROCEDURE add_option(SELF IN OUT option_menu, opt VARCHAR) as
    BEGIN
        self.options.extend();
        self.options(self.options.count) := opt;
        return;
    end;

    MEMBER PROCEDURE delete_option(SELF IN OUT option_menu, idx number) as
    begin
        -- ** ad essere un gentleman in caso che idx>count dovrebbe lanciare un errore **
        -- *** oss: se esistessero i generics questa operazione potrebbe essere generalizata
        
        -- ** if idx = count allora basta un trim **

        self.options.delete(idx);

        -- shift a sx
        for i in idx .. self.options.count loop
            self.options(i) := self.options(i+1);
        end loop;

        -- remove void space
        self.options.trim(1);
    end;

    MEMBER FUNCTION search_option(opt varchar) return number as
    begin
        for i in 1 .. self.options.count loop
            if self.options(i) = opt then
                return i;
            end if;
        end loop;

        return -1;
    end;

    MEMBER PROCEDURE clear_options(SELF IN OUT option_menu) as
    begin
        self.options.delete;
        return;
    end;

    MEMBER FUNCTION count_options return number as
    begin
        return self.options.count;
    end;


    OVERRIDING MEMBER PROCEDURE showhtml as
    BEGIN
        htp.print(
            '<select '  || 
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '" ' ||
            'name="'    || self.in_name     || '">'
        );

        for i in 1 .. self.options.count loop
            htp.print( '<option value=' || self.options(i) || '>' || self.options(i) ||'</option>' );
        end loop;

        htp.print('</select>');

        return;
    END;
END;
/

create or replace type submit_butt under f_input(
    CONSTRUCTOR FUNCTION submit_butt(id varchar, class varchar, css_style varchar,in_name varchar) RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace type body submit_butt is
    CONSTRUCTOR FUNCTION submit_butt(id varchar, class varchar, css_style varchar,in_name varchar) RETURN SELF AS RESULT AS
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
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

    constructor function numberInput(id varchar, class varchar, css_style varchar,in_name varchar,in_value number) return self as result,
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

    constructor function textInput(id varchar, class varchar, css_style varchar,in_name varchar,in_value varchar) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body textInput IS
    constructor function textInput(id varchar, class varchar, css_style varchar,in_name varchar,in_value varchar) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
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

    constructor function passwordInput(id varchar, class varchar, css_style varchar,in_name varchar,in_value varchar) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body passwordInput IS
    constructor function passwordInput(id varchar, class varchar, css_style varchar,in_name varchar,in_value varchar) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
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

    constructor function textAreaInput(id varchar, class varchar, css_style varchar,in_name varchar,in_value varchar) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body textAreaInput IS
    constructor function textAreaInput(id varchar, class varchar, css_style varchar,in_name varchar,in_value varchar) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
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

    constructor function checkbox(id varchar, class varchar, css_style varchar,in_name varchar,in_value number) return self as result,
    overriding member procedure showhtml 
);
/
create or replace type body checkbox is

    constructor function checkbox(id varchar, class varchar, css_style varchar,in_name varchar,in_value number) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
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


-- nota: prima o poi mettere anche la possibilita di specificare checked
create or replace type radioOptionsInput under f_input(
    options option_list,

    CONSTRUCTOR FUNCTION radioOptionsInput(id varchar, class varchar, css_style varchar, in_name varchar) RETURN SELF AS RESULT,

    MEMBER PROCEDURE add_option(SELF IN OUT option_menu, opt varchar),
    MEMBER PROCEDURE delete_option(SELF IN OUT option_menu, idx number),
    MEMBER PROCEDURE clear_options(SELF IN OUT option_menu),

    MEMBER FUNCTION  search_option(opt varchar) return number,
    MEMBER FUNCTION  count_options return number,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace TYPE BODY radioOptionsInput is

    CONSTRUCTOR FUNCTION radioOptionsInput(id varchar, class varchar, css_style varchar,in_name varchar) RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.options := option_list();
        return;
    end;

    MEMBER PROCEDURE add_option(SELF IN OUT option_menu, opt VARCHAR) as
    BEGIN
        self.options.extend();
        self.options(self.options.count) := opt;
        return;
    end;

    MEMBER PROCEDURE delete_option(SELF IN OUT option_menu, idx number) as
    begin
        self.options.delete(idx);

        -- shift a sx
        for i in idx .. self.options.count loop
            self.options(i) := self.options(i+1);
        end loop;

        -- remove void space
        self.options.trim(1);
    end;

    MEMBER FUNCTION search_option(opt varchar) return number as
    begin
        for i in 1 .. self.options.count loop
            if self.options(i) = opt then
                return i;
            end if;
        end loop;

        return -1;
    end;

    MEMBER PROCEDURE clear_options(SELF IN OUT option_menu) as
    begin
        self.options.delete;
        return;
    end;

    MEMBER FUNCTION count_options return number as
    begin
        return self.options.count;
    end;


    OVERRIDING MEMBER PROCEDURE showhtml as
    BEGIN

        for i in 1 .. self.options.count loop
            htp.print(
                '<input '   || 
                'id="'      || self.id          || '" ' ||
                'class="'   || self.class       || '" ' ||
                'style="'   || self.css_style   || '" ' ||
                'name="'    || self.in_name     || '" ' ||
                'value="'   || self.in_value    || '" ' ||
                'type="'    || 'radio'          || '" >' 
                || '<label for= "' || self.options(i)|| '">'|| self.options(i) || '</label> <br>'
            );
        end loop;
        return;
    END;
END;
/

create or replace type dateInput under f_input(
    in_value date,

    constructor function dateInput(id varchar, class varchar, css_style varchar,in_name varchar,in_value date) return self as result,
    overriding member procedure showhtml 
);
/

create or replace type body dateInput IS
    constructor function dateInput(id varchar, class varchar, css_style varchar,in_name varchar,in_value date) return self as result as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_value := in_value;
    end; 
    overriding member procedure showhtml as
    begin
        htp.print(
            '<input '   || 
            'id="'      || self.id                              || '" ' ||
            'class="'   || self.class                           || '" ' ||
            'style="'   || self.css_style                       || '" ' ||
            'name="'    || self.in_name                         || '" ' ||
            'value="'   || TO_CHAR(self.in_value,'dd-mm-yyyy')  || '" ' ||
            'type="'    || 'date'                               || '" ' ||
            '>'
        );
    end; 
end;
/