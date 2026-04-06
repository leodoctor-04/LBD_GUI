create or replace PROCEDURE lesson(isTeacher BOOLEAN,course VARCHAR, teacher VARCHAR, startH VARCHAR , endH VARCHAR) is
    bg_color VARCHAR;
BEGIN
    bg_color := case when isTeacher then '#ffc7d1' else '#c3edd5' end;

    htp.print(
        utl_lms.format_message(
        '
        <div class="lesson" onclick="this.children[3].showModal();">
            <p style="font-size: 2vw;grid-column: span 2;">%s</p>
            <p style="font-size: 1.7vw;">start: %s</p>
            <p style="font-size: 1.7vw;">end: %s</p>

            <dialog class="lesson_popup" style=" background:%s">
                <p>corso: </p><a href="" style="grid-column: span 2;">%s</a> 
                <p>istruttore: </p><a href="" style="grid-column: span 2;">%s</a>  

                <p>start: %s</p>
                <p></p>
                <p>end: %s</p>
            </dialog>
        </div>

        ',course,startH,endH,bg_color,course,teacher,startH,endH)
    );
END;