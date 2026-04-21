create or replace procedure calendar(startDate in date default null )AS
    toolPn panel := Panel(
        '',
        '',
        layout.HLIST('10px',aligment.page_center)|| 'background:red'
    );
    days panel := Panel(
        '',
        '',
        layout.HLIST('',aligment.page_start)|| 'background:blue'
    );
    currP panel;
    nxt_monday date;
BEGIN
    -- setup 
    if (startDate is null) then
        nxt_monday := NEXT_DAY(SYSDATE-7, 'MONDAY');
    else
        nxt_monday := NEXT_DAY(startDate-7, 'MONDAY');
    end if;

    --- query

    -- ui
    basehtml.apriPagina( titolo => 'calendar');

    toolPn.add_element(button(
        '','','',
        '<i class="material-icons">arrow_back_ios</i>'
        ,'window.location.href=''' || global.url || 'calendar?startdate=' || TO_CHAR(nxt_monday-7,'dd-mon-yy' || '''')
    ));
    toolPn.add_element(label(
                                '',
                                '',
                                '',
                                utl_lms.format_message('%s -- %s',TO_CHAR(nxt_monday, 'DD mon'), TO_CHAR(nxt_monday+7, 'DD mon'))
                    ));
        
    toolPn.add_element(button(
        '','','',
        '<i class="material-icons">arrow_forward_ios</i>'
        ,'window.location.href=''' || global.url || 'calendar?startdate=' || TO_CHAR(nxt_monday+7,'dd-mon-yy' || '''')
    ));
    toolpn.showhtml;

    for i in  1 .. 5 loop
        -- generate day column
        currP := panel(
                '',
                '',
                layout.vlist('0px',aligment.page_center,aligment.page_start) || 'background:blue;' || 'flex-grow:1;' || 'width:100%;'
            );

        currP.add_element(label('','','text-align:center;','days'));
        ---- add lessons
        currp.add_element(
            panel(
                '',
                '',
                layout.vlist('5px',aligment.page_center,aligment.page_start) || 'background:yellow;' || 'min-height:20vw;'
            )
        );

        -- add to the result
        days.add_element(currP);
    end loop;

    days.showhtml;

    basehtml.chiudiPagina;
end;