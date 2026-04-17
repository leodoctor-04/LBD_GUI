create or replace type element_list is table of uielem;
/
create or replace type ui_container under uielem(
    children element_list,

    CONSTRUCTOR FUNCTION ui_container(id varchar, class varchar, css_style varchar) RETURN SELF AS RESULT,

    MEMBER PROCEDURE add_element(self in out ui_container,e uielem),
    MEMBER PROCEDURE delete_element(self in out ui_container, idx number),
    MEMBER PROCEDURE clear_elements(self in out ui_container),

    MEMBER FUNCTION  search_element(e uielem) RETURN NUMBER,
    MEMBER FUNCTION  count_elements return number
)NOT FINAL;
/
create or replace type body ui_container is
    CONSTRUCTOR FUNCTION ui_container(id varchar, class varchar, css_style varchar) RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.children := element_list();
        return;
    end;

    MEMBER PROCEDURE add_element(self in out ui_container,e uielem) as
    BEGIN 
        self.children.extend();
        self.children(self.children.count) := e;
    END;

    MEMBER PROCEDURE delete_element(self in out ui_container, idx number) as
    BEGIN
        -- ** ad essere un gentleman in caso che idx>count dovrebbe lanciare un errore **
        -- *** oss: se esistessero i generics questa operazione potrebbe essere generalizata
        
        
        -- ** if idx = count allora basta un trim **

        self.children.delete(idx);

        -- shift a sx
        for i in idx .. self.children.count loop
            self.children(i) := self.children(i+1);
        end loop;

        -- remove void space
        self.children.trim(1);
    END;

    MEMBER PROCEDURE clear_elements as
    BEGIN
        self.children.delete;
    END;

    MEMBER FUNCTION search_element(e uielem) RETURN NUMBER as
    begin
        for i in 1 .. self.children.count loop
            if self.children(i) = e then
                return i;
            end if;
        end loop;
        return -1;
    end;

    MEMBER FUNCTION  count_elements return number as
    begin
        return self.children.count;
    end;
end;
/

create or replace type panel under ui_container(
    CONSTRUCTOR FUNCTION panel(id varchar, class varchar, css_style varchar) RETURN SELF AS RESULT,
    overriding MEMBER PROCEDURE showhtml 
);
/

create or replace type body panel is

    CONSTRUCTOR FUNCTION panel(id varchar, class varchar, css_style varchar) RETURN SELF AS RESULT as
    begin
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
            '<div '    ||
            'id= "'    || self.id          || '" ' ||
            'class="'  || self.class       || '" ' ||
            'style="'  || self.css_style   || '">' 
        );


        for i in 1 .. self.children.count loop
            self.children(i).showhtml;
        end loop;

        htp.print('</div>');

        return;
    end;
end;
/

create or replace type input_form under ui_container(
    submit_action varchar(200),

    CONSTRUCTOR FUNCTION input_form(id varchar, class varchar, css_style varchar, submit_action varchar) RETURN SELF AS RESULT,
    overriding MEMBER PROCEDURE showhtml 
);
/

create or replace type body input_form is

    CONSTRUCTOR FUNCTION input_form(id varchar, class varchar, css_style varchar, submit_action varchar) RETURN SELF AS RESULT as
    begin
        self.mem_id := SYS_GUID();
        self.id := id;
        self.class := class;
        self.css_style := css_style;
        self.children := element_list();
        self.submit_action := submit_action;
        return;
    end;

    overriding member procedure showhtml as
    begin
        htp.print(
            '<form '    ||
            'action= "' || self.submit_action   || '" ' ||
            'id= "'     || self.id              || '" ' ||
            'class="'   || self.class           || '" ' ||
            'style="'   || self.css_style       || '">' 
        );


        for i in 1 .. self.children.count loop
            self.children(i).showhtml;
        end loop;

        htp.print('</form>');

        return;
    end;
end;
/

create or replace type popup under ui_container(
    CONSTRUCTOR FUNCTION popup(id varchar, class varchar, css_style varchar) RETURN SELF AS RESULT,
    overriding MEMBER PROCEDURE showhtml 
);
/

create or replace type body popup is

    CONSTRUCTOR FUNCTION popup(id varchar, class varchar, css_style varchar) RETURN SELF AS RESULT as
    begin
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
            '<dialog '  ||
            'id= "'     || self.id              || '" ' ||
            'class="'   || self.class           || '" ' ||
            'style="'   || self.css_style       || '">' 
        );


        for i in 1 .. self.children.count loop
            self.children(i).showhtml;
        end loop;

        htp.print('</dialog>');

        return;
    end;
end;
/