create or replace procedure calendario(p_idSessione in number default null, startDate in date default null )AS
    -- constants
    dayRange constant number := 7;

    -- types
    type dname_array is varray(dayRange) of varchar(10);
    type lesson is record(
        course_title varchar(100), -- mettere type of
        instructor_name varchar(100),
        instructor_surname varchar(100),
        startD date,
        endD date
    );
    type lesson_list is table of lesson;
    type dayXlessons is varray(dayRange) of lesson_list;


    -- variables
    dname dname_array := dname_array('Lunedi', 'Martedi', 'Mercoledi', 'Giovedi', 'Venerdi', 'Sabato', 'Domenica');

    toolPn panel := Panel(
        class => 'controls_panel',
        css_style => layout.HLIST('10px',aligment.page_center)
    );
    days panel := Panel(
        css_style => layout.HLIST('',aligment.page_start)|| 'height:100%;'
    );
    currP panel;
    currLessClm panel;
    nxt_monday date;
    lessons dayXlessons;
    v_idUtente number;

    -- functions & procedures 
    function lesson_toArray(p_startDate date, p_idUtente number)return dayXlessons is
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
            SELECT corso.titolo,utente.nome,utente.cognome,lezione.DATAINIZIO,lezione.datafine
            FROM lezione,corso,utente
            WHERE 
                --join
                lezione.idCorso = corso.idCorso and
                corso.idistruttore =  utente.idutente and
                -- data check
                lezione.datainizio between p_startDate and p_startDate+7
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
                startD => c_row.datainizio,
                endD => c_row.datafine
            );
        end loop;

        return res;
    end;

BEGIN
    if(p_idSessione is null) then
        --basehtml.redirect(global.root || 'home');
        htp.print('<script>console.log("no id ses")</script>');
    end if;

    -- setup 
    if (startDate is null) then
        nxt_monday := NEXT_DAY(SYSDATE-7, 'MONDAY');
    else
        nxt_monday := NEXT_DAY(startDate-7, 'MONDAY');
    end if;

    /*
    select sessioni.idutente into v_idUtente 
    from sessioni 
    where sessioni.idSessione = p_idSessione;
    */

    lessons := lesson_toArray(nxt_monday,1);
    htp.print('hello');
    basehtml.aggiungi_Stile('
        .controls_panel{
            margin: 0px;
            padding: 3px;
            background-color: var(--colore-primario);
            gap: 10px;
        }

        .controls_panel button{
            background: none;
            border: none;
            color: grey;
        }

        .controls_panel button:active{
            color: black;
        }

        .controls_panel button{
            background: none;
            border: none;
        }

        .day_label{
            background-color: antiquewhite;
            font-size: 2.5rem;
            margin:0px;
            padding: 5px 0px;
            border-bottom:1px solid black;
        }

        .lesson{
            border-radius: 10%;
            background-color: #ffc7d1;
            box-shadow: 1px 1px grey;
            padding: 0px 5px;
        }

        .attend{
            background-color: #ffc7d1;
        }
        .teach{
            background-color: #c3edd5;
        }
    ');

    -- ui
    basehtml.apriPagina( titolo => 'calendario');

    toolPn.add_element(
        button(
            text => '<i class="material-icons">arrow_back_ios</i>',
            onclick => 'window.location.href=''' || global.url || 'calendario?p_idSessione=' || p_idSessione || chr(38) || 'p_startDate=' || TO_CHAR(nxt_monday-7,'dd-mon-yy') || ''''
    ));
    toolPn.add_element(
        label(
            text => utl_lms.format_message('%s -- %s',TO_CHAR(nxt_monday, 'DD mon'), TO_CHAR(nxt_monday+7, 'DD mon'))
    ));
        
    toolPn.add_element(
        button(
            text => '<i class="material-icons">arrow_forward_ios</i>',
            onclick => 'window.location.href=''' || global.url || 'calendario?p_idSessione=' || p_idSessione || chr(38) || 'p_startDate=' || TO_CHAR(nxt_monday+7,'dd-mon-yy') || ''''
    ));
    toolpn.showhtml;

    for i in  1 .. dayRange loop
        -- generate day column
        currP := panel(
                css_style => layout.vlist('0px')  || 'flex-grow:1;' || 'border: 1px black solid;'
            );

        currP.add_element(label(
            class => 'day_label',
            css_style => 'text-align:center;', 
            text => dname(i))
        );
        ---- add lessons
        currLessClm := panel(
            css_style => 
                layout.vlist('5px',aligment.page_start,aligment.page_start) || 
                layout.add_minSize(height => '20vw;') ||
                'background:white; flex-grow:1;'
        );

        for j in 1 .. lessons(i).count loop
            currLessClm.add_element(
                Label(class=> 'lesson',text => 'carlito')
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
/