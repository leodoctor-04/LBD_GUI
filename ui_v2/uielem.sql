-- utils
create or replace type strings as table of varchar(200);
/

-- ui types
CREATE OR REPLACE TYPE UIELEM AS OBJECT(
    mem_id raw(16),
    id varchar (100),
    class VARCHAR(100),
    css_style VARCHAR(1000),

    CONSTRUCTOR FUNCTION uielem(id varchar default '', class varchar default '', css_style varchar default '') RETURN SELF AS RESULT,
    NOT FINAL MEMBER PROCEDURE showhtml,
    MAP MEMBER FUNCTION get_ref RETURN raw
    -- map e' la funzione che utilizza durante le compare tra elementi
)NOT FINAL;
/

CREATE OR REPLACE TYPE BODY UIELEM IS
    CONSTRUCTOR FUNCTION uielem(id varchar default '', class varchar default '', css_style varchar default '') RETURN SELF AS RESULT as
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
    text VARCHAR(1000),
    
    CONSTRUCTOR FUNCTION label(id varchar default '', class varchar default '', css_style varchar default '',  text varchar default '') RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace TYPE BODY label IS
    CONSTRUCTOR FUNCTION label(id varchar default '', class varchar default '', css_style varchar default '',  text varchar default '') RETURN SELF AS RESULT as
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
    onclick varchar(500),
    
    CONSTRUCTOR FUNCTION button(id varchar default '', class varchar default '', css_style varchar default '', text varchar default '',onclick varchar default '') RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml
);
/

create or replace TYPE BODY button IS
    CONSTRUCTOR FUNCTION button(id varchar default '', class varchar default '', css_style varchar default '', text varchar default '',onclick varchar default '') RETURN SELF AS RESULT as 
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
            'style="'   || self.css_style   || '" ' ||
            'onclick="' || self.onclick     || '">' ||
            self.text   || '</button>'
        );
        return;
    END;
END;
/

create or replace type html_link under uielem(
    src VARCHAR(100),
    text varchar(100),
    
    CONSTRUCTOR FUNCTION html_link(id varchar default '', class varchar default '', css_style varchar default '', text varchar default '', src varchar default '') RETURN SELF AS RESULT,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace TYPE BODY html_link IS
    CONSTRUCTOR FUNCTION html_link(id varchar default '', class varchar default '', css_style varchar default '', text varchar default '', src varchar default '') RETURN SELF AS RESULT as
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
