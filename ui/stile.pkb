create or replace package body Stile as

    PROCEDURE stile is begin
    htp.print('
    <style>
    :root {
            /* Definiamo le variabili colore */
            --colore-primario: #8ACE00;
            --colore-primario-scuro: #4B6E00;
            --colore-secondario: #333;
        }

    h1{ font-size: clamp(40px, 3.5vw, 3.5vw); margin:0px; }
    p{ font-size: clamp(20px, 1.5vw, 2vw); text-color: white; }

    body{
        background: var(--colore-secondario);
        margin: 0px;
    }

    header{
        background: var(--colore-primario);
        color: white;
        padding: 0px 5%;
        display: flex;
        justify-content: space-between; /* Spinge gli elementi ai lati opposti */
        align-items: center; /* Allinea verticalmente al centro */
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        height: 6vw;
    }
    header nav{
        display: flex;
        gap: 1vw;
        align-items: center;
    }

    header button{
        background: var(--colore-secondario);
        font-size: clamp(30px, 2vw, 2vw);
        padding: 0.5vw 1vw;
        color: white;
        border-radius: 5vw; 
        border: none; /* Consiglio: rimuove il bordo predefinito dei browser */
        cursor: pointer; /* Consiglio: mostra la manina al passaggio del mouse */
    }

    header img {
        height: clamp(60px, 4vw, 4vw); /* Altezza dell''icona */
        width: auto;
        border-radius: 50%; /* Se vuoi l''immagine circolare */
    }

    footer {
        background: var(--colore-primario);
        display: flex;
        flex-direction: column;
        justify-content: space-evenly;
        align-items: center;
        padding: 20px;
    }

    footer h1, header p {
        margin: 0px;
        color: white;
    }

    /*Homepage*/

    #panoramica{
        margin: 2vw;
        display: flex;
        justify-content: space-evenly;
        gap: 1vw;
    }
    #panoramica div{
        background: white;
        width: 40%;
        border: 0.25vw solid var(--colore-primario);
        border-radius: 1vw;
        text-align: center;
        padding: 0vw 3vw;
        padding-bottom: 2vw;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }

    /*div lista*/
    #lista {
        margin: 2vw 3.5vw;
        display: flex;
        flex-direction: column;
        gap: 0.5vw;
        padding: 0.5vw;
        border-radius: 1vw;
        background:white;
        align-items: center;
        border: 0.25vw solid var(--colore-primario);
    }
    #lista p {
        background-color: var(--colore-primario);
        width:95%;
        border-radius: 1vw;
        text-align: center;
        padding: 0.25vw;
        margin: 0px;
        border: 0.25vw solid var(--colore-primario-scuro);
    }

    /*div griglia*/
    #griglia{
        display:grid;
        grid-template-columns:repeat( 3, 1fr);
        gap:24px;
    }


    button{
        font-size: clamp(30px, 2vw, 2vw);
        padding: 0.75vw 1.5vw;
        border-radius: 1vw; 
        border: none; /* Consiglio: rimuove il bordo predefinito dei browser */
        cursor: pointer; /* Consiglio: mostra la manina al passaggio del mouse */"
    }

    /*
        calendar style
    */
    .calendar{
        display: grid;
        grid-template-columns: repeat(5,1fr);
        grid-template-rows: 1fr 1fr 20fr;
        gap: 0px;

        border: 1px black solid;
    }

    .control_panel{
        margin: 0px;
        padding: 3px;
        background-color: var(--colore-primario);
        grid-column: span 5;
        display: flex;
        flex-direction: row;
        flex-flow: 1;
        justify-content: center;
        gap: 10px;
    }

    .control_panel button{
        background: none;
        border: none;
        color: grey;
    }


    .control_panel button:active{
        color: black;
    }

    .control_panel button{
        background: none;
        border: none;
    }

    .day_label{
        display: flex;
        margin: 0px;

        background-color: antiquewhite;
        border: 1px solid grey;

        height: 100%;
        width: 100%;

        font-size: 1.9rem;
        justify-content: center;
        align-items: center;   
    }

    .lesson_column{
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 10px;
        border: 1px solid grey;
        padding-top: 10px;
    }

    .lesson{
        border-radius: 10%;
        background-color: #ffc7d1;
        box-shadow: 1px 1px grey;
        display: grid;
        grid-template-columns: repeat(2,1fr);
        grid-template-columns: repeat(2,1fr);
        gap: 0px 10px;
        padding: 0px 5px;
    }


    .attend{
        background-color: #ffc7d1;
    }
    .teach{
        background-color: #c3edd5;
    }

    .lesson_popup[open]{
        width: 50vh;
        background-color: olive;
        border: 1px;
        border-radius: 10px;
        display: grid;
        grid-template-rows: repeat(3,1fr);
        grid-template-columns: repeat(3,1fr);
        gap: 0px;
        font-size: 2vh;
        box-shadow: 3px 3px grey;
    }

    .lesson_popup p{
        text-align: center;
    }
    .lesson_popup a{
        display: flex;
        align-items: center;
    }

    /*
        login style
    */
    #loginPopup {
            position: fixed;
            top: 25%;
            border: 0.25vw solid var(--colore-primario);
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            z-index: 1000;
            background: white;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
        }
        #loginPopup form {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
        }
        #loginPopup p {
            color: black;
        }
        #loginPopup button {
            color: var(--colore-primario);
        }


    #sidebar{
        position:fixed;
        top:0;
        left:0;
        width:250px;
        height:100%;
        background: var(--colore-secondario);
        padding:20px;
        transform:translateX(-100%);
        transition:transform 0.3s ease;
        z-index:999;
        box-shadow:2px 0px 5px rgba(0,0,0,0.3);
    }

    </style>
    ');

end stile;
end Stile;