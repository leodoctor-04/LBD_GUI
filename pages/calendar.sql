create or replace procedure calendario(p_idSessione in number default null, p_startDate in date default null, p_msg in varchar DEFAULT null)AS
    -- constants
    dayRange constant number := 7;

    -- types
    type dname_array is varray(dayRange) of varchar(10);
    type lesson is record(
        id_lesson number,
        teach BOOLEAN,
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
    function lesson_toArray(p_startDate date, p_idUtente number, p_idIstruttore number default null)return dayXlessons is
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
            SELECT corso.idistruttore,lezione.idLezione,corso.titolo,utente.nome,utente.cognome,lezione.DATAINIZIO,lezione.datafine
            FROM lezione,corso,utente
            WHERE 
                --join
                lezione.idCorso = corso.idCorso and
                corso.idistruttore =  utente.idutente and
                -- data check
                lezione.datainizio between monday and (monday + 7)
                and
                -- ck subscr.
                corso.idCorso in (
                    SELECT idcorso
                    from ISCRIZIONE_CORSO
                    where idutente = p_idUtente
                )
            ORDER BY lezione.datainizio,lezione.datafine
        ) loop
            d := (c_row.datainizio - monday ) + 1;
            res(d).extend;
            res(d)(res(d).count) := lesson(
                id_lesson  => c_row.idLezione,
                teach => false,
                course_title  => c_row.titolo,
                instructor_name  => c_row.nome,
                instructor_surname => c_row.cognome,
                startD => c_row.datainizio,
                endD => c_row.datafine
            );

            if(c_row.idistruttore = p_idistruttore) then
                res(d)(res(d).count).teach := true;
            end if;
        end loop;

        return res;
    end;


    function new_lesson_popup(l lesson) return panel is
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

        info_popup popup := popup(
            class=>'lesson_popup'
        );

        info_ct panel := panel( 
            css_style => layout.vlist  || layout.add_minSize(height => '60px', width => '60px') || layout.add_internal_spacing('10px')
        );

        act_buttons panel := panel(
            css_style => layout.hlist(gap=>'10px',halign => aligment.space_around) 
        );
    BEGIN 
        if(l.teach) then
            main_p.class := main_p.class || ' teach';
        else
            main_p.class := main_p.class || ' attend';
        end if;


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

        -- add info dialog 

        ---- info corso
        info_ct.add_element(
            label(
                text => 'corso:' || l.course_title
            )    
        );
        info_ct.add_element(
            label(
                text => utl_lms.format_message('istruttore: %s %s' , initcap(l.instructor_name),initcap(l.instructor_surname) )
            )    
        );

        info_ct.add_element(h_panel);

        ---- act buttons
        act_buttons.add_element(
            button(
                class => 'clearButton',
                text => '<i class="material-icons">check</i>',
                onclick => 'location = ...... ' 
            )
        );
        act_buttons.add_element(
            button(
                class => 'clearButton',
                text => 'bt2'
            )
        );
        act_buttons.add_element(
            button(
                class => 'clearButton',
                text => 'bt3'
            )
        );
        info_ct.add_element(act_buttons);

        ---- final adds
        info_popup.add_element(info_ct);
        main_p.add_element(info_popup);

        return main_p;
    END;

    function insertLesson_popup(id_inst number, id_ses number, cDate date) return popup is
        res popup := popup();
        f input_form := input_form( 
            submit_action => global.root || 'add_lesson',
            css_style => 
                layout.vlist                                            || 
                layout.add_minSize(height => '60px', width => '15vh')   || 
                layout.add_internal_spacing('10px')
        );
        input_ct panel; 
        inopt option_menu;
        roomSelectP panel;
    begin
        -- hidden data for the riderect
        f.add_element(
            hiddenInput(
                in_name => 'p_idSessione',
                in_value => '' || id_ses
            )
        );
        f.add_element(
            hiddenInput(
                in_name => 'p_cdata',
                in_value => to_char(cdate,'dd-mon-yy') 
            )
        );

        -- data
        input_ct := panel(css_style => layout.hlist);
        input_ct.add_element(label(text => 'data'));
        input_ct.add_element(
            dateInput(
                in_name  => 'p_data',
                in_value => '' 
        ));
        f.add_element(input_ct);

        -- ora inizio
        input_ct := panel(css_style => layout.hlist);
        input_ct.add_element(label(text => 'inizio'));
        input_ct.add_element(
            timeInput(
                in_name  => 'p_inizio',
                in_value => ora(00,00)
        ));
        f.add_element(input_ct);

        -- ora fine
        input_ct := panel(css_style => layout.hlist);
        input_ct.add_element(label(text => 'fine'));
        input_ct.add_element(
            timeInput(
                in_name  => 'p_fine',
                in_value => ora(00,11)
        ));
        f.add_element(input_ct);

        -- corso
        input_ct := panel(css_style => layout.hlist);
        input_ct.add_element(label(text => 'corso'));

        ---- query
        inopt := option_menu(
            id => 'courseSelect',
            in_name => 'p_idcorso'
        );
        for c in (
            SELECT titolo,idcorso
            from corso
            where corso.idistruttore = id_inst
        ) loop
            inopt.add_option(opt => c.titolo, val => c.idCorso);
        end loop;
        input_ct.add_element(inopt);

        f.add_element(input_ct);

        -- sala
        input_ct := panel(css_style => layout.hlist);
        input_ct.add_element(label(text => 'sala'));

        ----- query
        roomSelectP := panel(
            id => 'roomSelect_div',
            css_style => layout.hlist
        );
        for c in (
            SELECT idcorso,maxPartecipanti
            from corso
            where corso.idistruttore = id_inst
        ) loop
            -- 1 opt per corso
            inopt := option_menu();
            for s in (
                select idSala
                from sala_corsi
                where capienzaMassima > c.maxPartecipanti
            ) loop
                inopt.add_option(s.idSala);
            end loop;

            roomSelectP.add_element(inopt);
        end loop;
        input_ct.add_element(roomSelectP);

        f.add_element(input_ct);
        -- submit + final add
        f.add_element(
            submit_butt(
                in_name => 'create'
        ));
        res.add_element(f);

        return res;
    end;

----------------------------------------------------------------------------------------------
--CODE
----------------------------------------------------------------------------------------------

BEGIN
    if(p_idSessione is null) then
        basehtml.redirect(global.root || 'home');
        return;
    end if;

    -- setup 
    if (p_startDate is null) then
        nxt_monday := NEXT_DAY(SYSDATE-7, 'MONDAY');
    else
        nxt_monday := NEXT_DAY(p_startDate-7, 'MONDAY');
    end if;

    select sessioni.idutente into v_idUtente 
    from sessioni 
    where sessioni.idSessione = p_idSessione;
    
    if(sessioneUtente.controllaIstruttore(p_idSessione)) then
        lessons := lesson_toArray(nxt_monday,v_idUtente,v_idUtente);
    else
        lessons := lesson_toArray(nxt_monday,v_idUtente);
    end if;

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

        .lesson_popup {
            background-color: transparent;
            border: none;
            padding: 0;
            box-shadow: none;
        }

        .lesson_popup:focus {
            outline: none;
        }

        .lesson_popup>div{
            border-radius: 10%;
            background-color: #ffc7d1;
            box-shadow: 1px 1px grey;
            padding: 0px 5px;
        }
    ');

    -- ui
    basehtml.apriPagina( titolo => 'calendario', p_idsessione =>p_idSessione);

    --toolPn.add_element(add_button);
    toolPn.add_element(
        button(
            class => 'clearButton',
            text => '<i class="material-icons">arrow_back_ios</i>',
            onclick => 'window.location.href=''' || global.url || 'calendario?p_idSessione=' || p_idSessione || chr(38) || 'p_startDate=' || TO_CHAR(nxt_monday-7,'dd-mon-yy') || ''''
    ));
    toolPn.add_element(
        label(
            text => utl_lms.format_message('%s -- %s',TO_CHAR(nxt_monday, 'DD mon'), TO_CHAR(nxt_monday+7, 'DD mon'))
    ));
        
    toolPn.add_element(
        button(
            class => 'clearButton',
            text => '<i class="material-icons">arrow_forward_ios</i>',
            onclick => 'window.location.href=''' || global.url || 'calendario?p_idSessione=' || p_idSessione || chr(38) || 'p_startDate=' || TO_CHAR(nxt_monday+7,'dd-mon-yy') || ''''
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
                new_lesson_popup(lessons(i)(j))
            );
        end loop;

        currp.add_element(
            currLessClm
        );
        -- add to the result
        days.add_element(currP);
    end loop;
    days.showhtml;

    if(sessioneUtente.controllaIstruttore(p_idSessione)) then
        currP := panel (
            css_style => 
                    'position:sticky;'               ||
                    'z-index:111;'                   ||
                    'bottom:0px;right:50px;'         ||
                    layout.hlist(halign => aligment.page_end) ||
                    layout.add_size(height=>'0px')
        );
        currP.add_element(add_button);
        currP.add_element(insertLesson_popup(v_idUtente,p_idsessione,nxt_monday));
        currP.showhtml;
    end if;

    -- script to open the popup on onclick of items with the class lesson
    baseHtml.aggiungi_script(script =>
    '
        var courseSelect    = document.getElementById("courseSelect");
        var roomSelects_div = document.getElementById("roomSelect_div");

        function update_roomSelect(index) {
            for(idx in roomSelects_div.children){
                if(index == idx){
                    roomSelects_div.children[idx].name = "p_idsala"
                    roomSelects_div.children[idx].style.display = "block"
                }
                else{ 
                    roomSelects_div.children[idx].name = ""
                    roomSelects_div.children[idx].style.display = "none"
                }
            }
        }

        courseSelect.addEventListener("change", () => {
            var index = courseSelect.selectedIndex;
            update_roomSelect(index);
        })

        update_roomSelect(courseSelect.selectedIndex);
    '
    );

    baseHtml.aggiungi_script(script =>
    '
        function openPopup(parent,idx){
            parent.children[idx].showModal();
        }

        var ls = document.getElementsByClassName("lesson");

        for(l of ls){
            l.onclick = function(event){ openPopup(event.target,2)};
        }
    '
    );

    basehtml.chiudiPagina;
end;
/