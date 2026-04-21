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

create or replace type strings as table of varchar(200);
/
create or replace type strings as table of varchar(200);
create or replace type trow_list as table of trow(200);
/

create or replace type data_table under uielem(
    headers_color varchar(100),
    cell_color varchar(100),
    headers strings,
    trows trow_list,

    CONSTRUCTOR FUNCTION data_table(id varchar, class varchar, css_style varchar, h_color varchar, c_color varchar) RETURN SELF AS RESULT,

    MEMBER PROCEDURE add_header(SELF IN OUT data_table, hd varchar),
    MEMBER PROCEDURE delete_header(SELF IN OUT data_table, idx number),

    MEMBER PROCEDURE add_row(SELF IN OUT data_table, tr trow),
    MEMBER PROCEDURE delete_row(SELF IN OUT data_table, idx number),
    MEMBER PROCEDURE clear_rows(SELF IN OUT data_table),

    MEMBER FUNCTION  search_row(tr trow) return number,
    MEMBER FUNCTION  count_rows return number,
    OVERRIDING MEMBER PROCEDURE showhtml 
);
/

create or replace type body data_table is
    CONSTRUCTOR FUNCTION data_table(id varchar, class varchar, css_style varchar, h_color varchar, c_color varchar) RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.headers := strings();
        self.trows := trow_list();
        self.headers_color := h_color;
        self.cell_color := c_color;
        return;
    end;

    MEMBER PROCEDURE add_header(SELF IN OUT data_table, hd varchar) as
    begin
        self.headers.extend();
        self.headers(self.headers.count) := hd;
    end;

    MEMBER PROCEDURE delete_header(SELF IN OUT data_table, idx number) as
    begin
        self.headers.delete(idx);

        -- shift a sx
        for i in idx .. self.trows.count loop
            self.headers(i) := self.headers(i+1);
        end loop;

        -- remove void space
        self.headers.trim(1);
    end;

    MEMBER PROCEDURE add_row(SELF IN OUT data_table, tr trow) as
    begin
        self.trows.extend();
        self.trows(self.trows.count)  :=  tr;
        return;
    end;
    MEMBER PROCEDURE delete_row(SELF IN OUT data_table, idx number) as
    begin
        self.trows.delete(idx);

        -- shift a sx
        for i in idx .. self.trows.count loop
            self.trows(i) := self.trows(i+1);
        end loop;

        -- remove void space
        self.trows.trim(1);
    end;
    MEMBER PROCEDURE clear_rows(SELF IN OUT data_table) as
    begin
        self.trows.delete;
    end;
    MEMBER FUNCTION  search_row(tr trow) return number as
    BEGIN
        for i in 1 .. self.trows.count loop
            if self.trows(i) = tr then
                return i;
            end if;
        end loop;
        return -1;
    end;

    MEMBER FUNCTION  count_rows return number as
    BEGIN
        return self.trows.count;
    end;

    OVERRIDING MEMBER PROCEDURE showhtml as
    BEGIN
        htp.print(
            '<td '      || 
            'id="'      || self.id          || '" ' ||
            'class="'   || self.class       || '" ' ||
            'style="'   || self.css_style   || '">'
        );


        htp.print('<thead> <tr>');
        for i in 1 .. self.headers.count loop
            htp.print( '<th>' || headers(i) || '</th>' );
        end loop;
        htp.print('</tr></thead>');

        htp.print('<tbody>') ;
        for i in 1 .. self.trows.count loop
            self.trows(i).showhtml;
        end loop;
        htp.print('</tbody>') ;

        htp.print('</td>');

        return;
    end;
end;