create or replace type trow under ui_container(
    CONSTRUCTOR FUNCTION trow(id varchar default '', class varchar default '', css_style varchar default '') RETURN SELF AS RESULT,
    overriding member procedure showhtml
);
/

create or replace type body trow is
    CONSTRUCTOR FUNCTION trow(id varchar default '', class varchar default '', css_style varchar default '') RETURN SELF AS RESULT as
    BEGIN
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.children := element_list();
        return;
    end;

    overriding member procedure showhtml as
    begin
        htp.print(
            '<tr '      ||
            'id= "'     || self.id              || '" ' ||
            'class="'   || self.class           || '" ' ||
            'style="'   || self.css_style       || '">' 
        );

        for i in 1 .. self.children.count loop
            htp.print('<td>');
            self.children(i).showhtml;
            htp.print('</td>');
        end loop;

        htp.print('</tr>');

        return;
    end;
end;
/

create or replace type trow_list as table of trow;
/

create or replace type data_table under uielem(
    headers strings,
    trows trow_list,

    CONSTRUCTOR FUNCTION data_table(id varchar default '', class varchar default '', css_style varchar default '', h_color varchar default '', c_color varchar default '') RETURN SELF AS RESULT,

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
    CONSTRUCTOR FUNCTION data_table(id varchar default '', class varchar default '', css_style varchar default '', h_color varchar default '', c_color varchar default '') RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.headers := strings();
        self.trows := trow_list();
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
/