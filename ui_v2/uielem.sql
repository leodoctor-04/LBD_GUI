CREATE OR REPLACE TYPE UIELEM AS OBJECT(
    mem_id raw(16),
    id VARCHAR(100),
    class VARCHAR(100),
    css_style VARCHAR(500),

    CONSTRUCTOR FUNCTION uielem(id varchar, class varchar, css_style varchar) RETURN SELF AS RESULT,
    NOT FINAL MEMBER PROCEDURE showhtml,
    MAP MEMBER FUNCTION get_ref RETURN raw
    -- map e' la funzione che utilizza durante le compare tra elementi
)NOT FINAL;
/

CREATE OR REPLACE TYPE BODY UIELEM IS
    CONSTRUCTOR FUNCTION uielem(id varchar, class varchar, css_style varchar) RETURN SELF AS RESULT as
    begin
        -- sys_guid restituisce un id che rappresenta l'instanza nella memoria virtuale
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        return;
    end;

    MEMBER PROCEDURE showhtml AS 
    BEGIN
        return;
    END;

    map member function get_ref return raw is
    begin
        return self.mem_id;
    end; 
END;
/

create or replace type label under uielem(
    text VARCHAR(100),
    
    CONSTRUCTOR FUNCTION label(id varchar, class varchar, css_style varchar, text varchar) RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace TYPE BODY label IS
    CONSTRUCTOR FUNCTION label(id varchar, class varchar, css_style varchar, text varchar) RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.text := text;
        return;
    end;
    OVERRIDING MEMBER PROCEDURE showhtml as
    BEGIN
        htp.print( 
            '<p '       ||
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '">' ||
            self.text   || '</p>'
        );

        return;
    END;
END;
/

create or replace type button under uielem(
    text VARCHAR(100),
    onclick varchar(100),
    
    CONSTRUCTOR FUNCTION button(id varchar, class varchar, css_style varchar, text varchar,onclick varchar) RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml
);
/

create or replace TYPE BODY button IS
    CONSTRUCTOR FUNCTION button(id varchar, class varchar, css_style varchar, text varchar,onclick varchar) RETURN SELF AS RESULT as 
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.text := text;
        self.onclick := onclick;
        return;
    end;
    OVERRIDING MEMBER PROCEDURE showhtml as
    BEGIN
        htp.print(
            '<button '  ||
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '">' ||
            self.text   || '</button>'
        );
        return;
    END;
END;
/

create or replace type html_link under uielem(
    src VARCHAR(100),
    text varchar(100),
    
    CONSTRUCTOR FUNCTION html_link(id varchar, class varchar, css_style varchar, text varchar,src varchar) RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace TYPE BODY html_link IS
    CONSTRUCTOR FUNCTION html_link(id varchar, class varchar, css_style varchar, text varchar,src varchar) RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.text := text;
        self.src:= src;
        return;
    end;

    OVERRIDING MEMBER PROCEDURE showhtml as
    BEGIN
        htp.print(
            '<a href="' || self.src         || '" ' || 
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '">' ||
            self.text   || '</a>'
        );

        return;
    END;
END;
/

create or replace type option_list is table of varchar(100);
/
create or replace type option_menu under uielem(
    options option_list,

    CONSTRUCTOR FUNCTION option_menu(id varchar, class varchar, css_style varchar) RETURN SELF AS RESULT,

    MEMBER PROCEDURE add_option(SELF IN OUT option_menu, opt varchar),
    MEMBER PROCEDURE delete_option(SELF IN OUT option_menu, idx number),
    MEMBER PROCEDURE clear_options(SELF IN OUT option_menu),

    MEMBER FUNCTION  search_option(opt varchar) return number,
    MEMBER FUNCTION  count_options return number,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace TYPE BODY option_menu is
    CONSTRUCTOR FUNCTION option_menu(id varchar, class varchar, css_style varchar) RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
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
            'style="'   || self.css_style   || '">'
        );

        for i in 1 .. self.options.count loop
            htp.print( '<option value=' || self.options(i) || '>' || self.options(i) ||'</option>' );
        end loop;

        htp.print('</select>');

        return;
    END;
END;
/

create or replace type f_input under uielem(
    
    in_name VARCHAR(100),
    in_type varchar(100),
    in_value varchar(100),
    
    CONSTRUCTOR FUNCTION f_input (id varchar, class varchar, css_style varchar, in_type varchar, in_name varchar, in_value varchar) RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace TYPE BODY f_input IS
    CONSTRUCTOR FUNCTION f_input (id varchar, class varchar, css_style varchar, in_type varchar, in_name varchar, in_value varchar) RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.in_name := in_name;
        self.in_type := in_type;
        self.in_value := in_value;
        return;
    end;

    OVERRIDING MEMBER PROCEDURE showhtml as
    BEGIN
        if (self.in_type = 'textarea') then
            htp.print(
                '<textarea '|| 
                'id="'      || self.id          || '" ' ||
                'class="'   || self.class       || '" ' ||
                'style="'   || self.css_style   || '" ' ||
                'name ="'   || self.in_name     || '" ' ||
                '>'         || self.in_value    || '</textarea>'
            );
        else
            htp.print(
                '<input '   || 
                'id="'      || self.id          || '" ' ||
                'class="'   || self.class       || '" ' ||
                'style="'   || self.css_style   || '" ' ||
                'name ="'   || self.in_name     || '" ' ||
                'type ="'   || self.in_type     || '" ' ||
                'value="'   || self.in_value    || '" ' ||
                '>'
            );
        end if;
        return;
    END;
END;
/