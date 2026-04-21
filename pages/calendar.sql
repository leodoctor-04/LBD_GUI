create or replace procedure calendar(startDate in date default null )AS
    -- constants
    dayRange constant number := 7;

    -- types
    type dname_array is varray(dayRange) of varchar(10);
    type lesson is record(
        course_title varchar(100), -- mettere type of
        instructor_name varchar(100),
        instructor_surname varchar(100),
        startD date
    );
    type lesson_list is table of lesson;
    type dayXlessons is varray(dayRange) of lesson_list;


    -- variables
    dname dname_array := dname_array('Lunedi', 'Martedi', 'Mercoledi', 'Giovedi', 'Venerdi','Sabato','Domenica');

    toolPn panel := Panel(
        css_style => layout.HLIST('10px',aligment.page_center)|| 'background:red'
    );
    days panel := Panel(
        css_style => layout.HLIST('',aligment.page_start)|| 'background:blue;' || 'height:100%;'
    );
    currP panel;
    currLessClm panel;
    nxt_monday date;
    lessons dayXlessons;

    -- functions & procedures 
    function lesson_toArray return dayXlessons is
        monday date;
        d number; 
        res dayXlessons := dayXlessons(); 
    begin

        --generate tables
        for i in 1 .. dayRange loop
            res.extend;
            res(i) := lesson_list();
        end loop;

        --add lesson to the table
        for c_row in (
            SELECT corso.titolo,utente.nome,utente.cognome,lezione.DATAINIZIO
            FROM lezione,corso,utente
            WHERE 
                --join
                lezione.idCorso = corso.idCorso and
                corso.idistruttore =  utente.idutente and
                -- data check
                lezione.datainizio between to_date('01-jun-26','dd-mon-yy') and to_date('30-jun-26','dd-mon-yy')
            ORDER BY lezione.datainizio,lezione.datafine
            )
        loop
            monday := NEXT_DAY(c_row.datainizio-7, 'MONDAY');
            d := (c_row.datainizio - monday ) + 1;
            dbms_output.put_line(d);
            res(d).extend;
            res(d)(res(d).count) := lesson(
                course_title  => c_row.titolo,
                instructor_name  => c_row.nome,
                instructor_surname => c_row.cognome,
                startD => c_row.datainizio
            );
            
        end loop;

        return res;
    end;

BEGIN
    -- setup 
    if (startDate is null) then
        nxt_monday := NEXT_DAY(SYSDATE-7, 'MONDAY');
    else
        nxt_monday := NEXT_DAY(startDate-7, 'MONDAY');
    end if;
    lessons := lesson_toArray;

    -- ui
    basehtml.apriPagina( titolo => 'calendar');

    toolPn.add_element(
        button(
            text => '<i class="material-icons">arrow_back_ios</i>',
            onclick => 'window.location.href=''' || global.url || 'calendar?startdate=' || TO_CHAR(nxt_monday-7,'dd-mon-yy' || '''')
    ));
    toolPn.add_element(
        label(
            text => utl_lms.format_message('%s -- %s',TO_CHAR(nxt_monday, 'DD mon'), TO_CHAR(nxt_monday+7, 'DD mon'))
    ));
        
    toolPn.add_element(button(
        text => '<i class="material-icons">arrow_forward_ios</i>',
        onclick => 'window.location.href=''' || global.url || 'calendar?startdate=' || TO_CHAR(nxt_monday+7,'dd-mon-yy' || '''')
    ));
    toolpn.showhtml;

    for i in  1 .. dayRange loop
        -- generate day column
        currP := panel(
                css_style => layout.vlist('0px') || 'background:blue;' || 'flex-grow:1;'
            );

        currP.add_element(label(css_style => 'text-align:center', text => dname(i)));
        ---- add lessons
        currLessClm := panel(
            css_style => layout.vlist('5px',aligment.page_start,aligment.page_start) || 'background:yellow;' || 'min-height:20vw;' 
        );

        for j in 1 .. lessons(i).count loop
            currLessClm.add_element(
                Label(text => 'carlito')
            );
        end loop;

        currp.add_element(
            currLessClm
        );
        -- add to the result
        days.add_element(currP);
    end loop;

    days.showhtml;

    basehtml.chiudiPagina;
end;