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
    p{ font-size: clamp(20px, 1.5vw, 2vw); }

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


    /* Pagina ituoi corsi */
    label[for="parametri"] {
        font-size: 1vw;
    }

    select[name="parametri"] {
        padding: 1vw 1vw;
        font-size: clamp(20px, 1.5vw, 1.5vw);
        width: 70%;
        border-radius: 5vw;
        cursor: pointer;
    }
    select[name="parametri"] option {
        font-size: clamp(15px, 1vw, 20px);
    }

    button{
        font-size: clamp(30px, 2vw, 2vw);
        padding: 0.75vw 1.5vw;
        border-radius: 1vw; 
        border: none; /* Consiglio: rimuove il bordo predefinito dei browser */
        cursor: pointer; /* Consiglio: mostra la manina al passaggio del mouse */"
    }
    </style>
    ');

end stile;
end Stile;