create or replace package body Components as

PROCEDURE calendar(startDate IN DATE) is
    nextLun Date;
BEGIN
    nextLun := NEXT_DAY(startDate-7, 'MONDAY');
    
    --body
    htp.print(
        utl_lms.format_message('
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <div class="calendar">
            <div class ="control_panel">
                <button onclick="prev_week()"><i class="material-icons">arrow_back_ios</i></button>
                <p id="date_label"> %s -- %s</p>
                <button onclick="next_week()"><i class="material-icons">arrow_forward_ios</i></button>
            </div>
            <p class="day_label" style="">lunedi</p>
            <p class="day_label" style="">martedi</p>
            <p class="day_label" style="">mercoledi</p>
            <p class="day_label" style="">giovedi</p>
            <p class="day_label" style="">venerdi</p>
            
            <div class="lesson_column" id="lun_clm">
            </div>
            <div class="lesson_column" id="mar_clm"></div>
            <div class="lesson_column" id="mer_clm"></div>
            <div class="lesson_column" id="gio_clm"></div>
            <div class="lesson_column" id="ven_clm"></div>
        </div>
        '
        , TO_CHAR(nextLun, 'DD mon')
        , TO_CHAR(nextLun+7, 'DD mon')

        )
    );

    --script
    htp.print(
        utl_lms.format_message('
        <script>
            function check_inside(position,elem){
                let bounds = elem.getBoundingClientRect();
                return false; 
            }

            function create_lesson(isTeacher,course,teacher,start,end){
                let body = document.createElement("div");
                body.setAttribute("class",`lesson ${isTeacher? "teach" : "attend"}`);
                body.setAttribute("style",`background-color: ${isTeacher? "#ffc7d1" : "#c3edd5"}`);
                
                body.innerHTML = `
                    <p style="font-size: 2vw;grid-column: span 2;">${course}</p>
                    <p style="font-size: 1.7vw;">start: ${start}</p>
                    <p style="font-size: 1.7vw;">end: ${end}</p>

                    <dialog class="lesson_popup" style=" background:${isTeacher? "#ffc7d1" : "#c3edd5"}">
                        <p>corso: </p><a href="" style="grid-column: span 2;">${course}</a> 
                        <p>istruttore: </p><a href="" style="grid-column: span 2;">${teacher}</a>  

                        <p>start: ${start}</p>
                        <p></p>
                        <p>end: ${start}</p>
                    </dialog>
                `;
                return body;
            }

            function clear_calendar(){
                console.log("hi");
                var columns = document.getElementsByClassName("lesson_column");

                for(c of columns){
                    c.innerHTML = "";
                }
            }
            function next_week(){
            }

            function prev_week(){
            }
            //upadate_datelabel()
            document.getElementById("lun_clm").appendChild(create_lesson(true,"corsoB","paolino","12:00","13:00"));
            document.getElementById("lun_clm").appendChild(create_lesson(false,"corsoB","paolino","12:00","13:00"));
 
            for(less of document.getElementsByClassName("lesson")){
                less.addEventListener("click", function (event) {
                    console.log("hi clicked")
                    event.currentTarget.children[3].showModal();
                });
            }

            console.log("hi from pl/sql");
        </script>        
        '
        , TO_CHAR(nextLun, 'YYYY,MM,DD')
        )
    );

END;
PROCEDURE lesson(isTeacher BOOLEAN,course VARCHAR, teacher VARCHAR, startH VARCHAR , endH VARCHAR) is
    bg_color VARCHAR(8);
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

END Components;