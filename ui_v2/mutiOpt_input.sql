-- utils
create or replace type string_pair is varray(2) of varchar(255);
/
create or replace type option_list is table of string_pair; 
/

--ui_types
create or replace type multiOptionInput under f_input(
    options option_list,

    CONSTRUCTOR FUNCTION multiOptionInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar default '') RETURN SELF AS RESULT,

    MEMBER PROCEDURE add_option(SELF IN OUT multiOptionInput, opt varchar, val varchar default null),
    MEMBER PROCEDURE delete_option(SELF IN OUT multiOptionInput, idx number),
    MEMBER PROCEDURE clear_options(SELF IN OUT multiOptionInput),

    MEMBER FUNCTION  search_option(opt varchar) return number,
    MEMBER FUNCTION  count_options return number
)NOT FINAL;
/

create or replace TYPE BODY multiOptionInput is
    CONSTRUCTOR FUNCTION multiOptionInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar default '') RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.options := option_list();
        return;
    end;

    MEMBER PROCEDURE add_option(SELF IN OUT multiOptionInput, opt VARCHAR, val varchar default null) as
    BEGIN
        self.options.extend();
        if(val is null) then
            self.options(self.options.count) := string_pair(opt,opt);
        else
            self.options(self.options.count) := string_pair(opt,val);
        end if;
        return;
    end;

    MEMBER PROCEDURE delete_option(SELF IN OUT multiOptionInput, idx number) as
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
            if self.options(i)(1) = opt then
                return i;
            end if;
        end loop;

        return -1;
    end;

    MEMBER PROCEDURE clear_options(SELF IN OUT multiOptionInput) as
    begin
        self.options.delete;
        return;
    end;

    MEMBER FUNCTION count_options return number as
    begin
        return self.options.count;
    end;
END;
/


create or replace type option_menu under multiOptionInput(
    CONSTRUCTOR FUNCTION option_menu(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar default '') RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace TYPE BODY option_menu is
    CONSTRUCTOR FUNCTION option_menu(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar default '') RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.options := option_list();
        return;
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
            htp.print( '<option value=' || self.options(i)(2) || '>' || self.options(i)(1) ||'</option>' );
        end loop;

        htp.print('</select>');

        return;
    END;
END;
/
-- nota: prima o poi mettere anche la possibilita di specificare checked
create or replace type radioOptionsInput under multiOptionInput(
    CONSTRUCTOR FUNCTION radioOptionsInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar) RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace TYPE BODY radioOptionsInput is

    CONSTRUCTOR FUNCTION radioOptionsInput(id varchar default '', class varchar default '', css_style varchar default '', in_name varchar) RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.options := option_list();
        return;
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
                'type="'    || 'radio'          || '" >' 
                || '<label for= "' || self.options(i)(2)|| '">'|| self.options(i)(1)||'</label> <br>'
            );
        end loop;
        return;
    END;
END;
/