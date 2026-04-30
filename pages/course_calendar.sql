
create or replace procedure calendario_corso(p_idcourse in number, p_startDate in date default null)AS
    -- constants
    dayRange constant number := 7;

    -- types
    type dname_array is varray(dayRange) of varchar(10);
    type lesson is record(
        id_lesson number,
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
        css_style => layout.HLIST('10px',halign => aligment.page_center)
    );
    days panel := Panel(
        css_style =>    layout.HLIST || 
                        layout.add_size(height => '100%') ||
                        'position:relative'
    );
    add_button button := button(
        class => 'add_button',
        text => '+',
        css_style => layout.add_size('100px','100px') || 'position:relative;top:-150;right:50',
        onclick => 'openPopup(this.parentElement,1)'
    );

    currP panel;
    currLessClm panel;
    nxt_monday date;
    lessons dayXlessons;
    v_idUtente number;

-----------------------------------------------------------------------------------------
-- functions & procedures 
-----------------------------------------------------------------------------------------

    -- give the lesson in the week where exist p_startDate.
    function lesson_toArray(p_startDate date, p_idcorso number)return dayXlessons is
        monday date;
        d number; 
        res dayXlessons := dayXlessons(); 
    begin

        monday := NEXT_DAY(p_startDate-7, 'MONDAY');
        --generate tables
        for i in 1 .. dayRange loop
            res.extend;
            res(i) := lesson_list();
        end loop;

        --add lesson to the table
        for c_row in (
            SELECT lezione.idLezione,corso.titolo,utente.nome,utente.cognome,lezione.DATAINIZIO,lezione.datafine
            FROM lezione,corso,utente
            WHERE 
                --join
                lezione.idCorso = corso.idCorso and
                corso.idistruttore =  utente.idutente and
                -- data check
                lezione.datainizio between monday and (monday + 7) and
                lezione.idCorso = p_idcorso
            ORDER BY lezione.datainizio,lezione.datafine
        ) loop
            d := (c_row.datainizio - monday ) + 1;
            res(d).extend;
            res(d)(res(d).count) := lesson(
                id_lesson  => c_row.idLezione,
                course_title  => c_row.titolo,
                instructor_name  => c_row.nome,
                instructor_surname => c_row.cognome,
                startD => c_row.datainizio,
                endD => c_row.datafine
            );
        end loop;

        return res;
    end;

    function lesson_ct(l lesson) return panel is
        main_p panel := panel(
            class => 'lesson',
            css_style =>    layout.vlist(gap => '10px') || 
                            layout.add_minSize(height=> '100px') || 
                            layout.add_size(width => '80%') || 
                            layout.add_external_spacing('0px auto') ||
                            layout.add_internal_spacing('10px')
        );

        h_panel panel := panel(
            css_style => layout.hlist(halign => aligment.space_between) || layout.add_size(width => '100%')
        );

    BEGIN 
        main_p.add_element(
            label(text=> l.course_title)
        );

        -- add hour
        h_panel.add_element(
            label(
                css_style => 'font-size:0.8 rem;',
                text => utl_lms.format_message('start %s ',TO_CHAR(l.startD, 'HH24:MI')) 
        ));
        h_panel.add_element(
            label(
                css_style => 'font-size:0.8 rem;',
                text => utl_lms.format_message('end %s ',TO_CHAR(l.endD, 'HH24:MI')) 
        ));

        main_p.add_element(h_panel);
        return main_p;
    END;
----------------------------------------------------------------------------------------------
--CODE
----------------------------------------------------------------------------------------------
BEGIN
    -- setup 
    if (p_startDate is null) then
        nxt_monday := NEXT_DAY(SYSDATE-7, 'MONDAY');
    else
        nxt_monday := NEXT_DAY(p_startDate-7, 'MONDAY');
    end if;

    lessons := lesson_toArray(nxt_monday,p_idcourse);
    basehtml.aggiungi_Stile('

        .controls_panel{
            margin: 0px;
            padding: 3px;
            background-color: var(--colore-primario);
            gap: 10px;
        }

        .add_button{
            background:black;
            border-radius:50%;
            color:white;
        }

        .clearButton{
            background: none;
            border: none;
            color: grey;
        }

        .clearButton:active{
            color: black;
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
            background-color: #B2FFFF;
            box-shadow: 1px 1px grey;
            padding: 0px 5px;
        }

    ');

    -- ui

    toolPn.add_element(
        button(
            class => 'clearButton',
            text => '<i class="material-icons">arrow_back_ios</i>',
            onclick => ''
    ));
    toolPn.add_element(
        label(
            text => utl_lms.format_message('%s -- %s',TO_CHAR(nxt_monday, 'DD mon'), TO_CHAR(nxt_monday+7, 'DD mon'))
    ));
        
    toolPn.add_element(
        button(
            class => 'clearButton',
            text => '<i class="material-icons">arrow_forward_ios</i>',
            onclick => ''
    ));
    toolpn.showhtml;

    for i in  1 .. dayRange loop
        -- generate day column
        currP := panel(
            css_style => layout.vlist || 'flex-grow:1;' || 'border: 1px black solid;'
        );

        currP.add_element(label(
            class => 'day_label',
            css_style => 'text-align:center;', 
            text => dname(i))
        );
        ---- add lessons
        currLessClm := panel(
            css_style => 
                layout.vlist('5px',valign => aligment.page_start, halign => aligment.page_center) || 
                layout.add_minSize(height => '20vw;')   ||
                layout.add_internal_spacing('5px 0px')  ||
                'background:white; flex-grow:1;'
        );

        for j in 1 .. lessons(i).count loop
            currLessClm.add_element(
                lesson_ct(lessons(i)(j))
            );
        end loop;

        currp.add_element(
            currLessClm
        );
        -- add to the result
        days.add_element(currP);
    end loop;
    days.showhtml;
end;
/
GRANT EXECUTE ON calendario_corso TO anonymous;