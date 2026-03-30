create or replace package body Stile as

    PROCEDURE stile is begin
    htp.print('
    <style>
    :root {
            /* Definiamo le variabili colore */
            --colore-primario: #8ACE00;
            --colore-secondario: #333;
        }

    h1{ font-size: clamp(40px, 3.5vw, 3.5vw); }
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

    
    #panoramica{
        display: flex;
        justify-content: space-evenly;
        gap: 1vw;
        margin: 1vw;
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



    #mostracorsi {
        background-color: green;
        height: 45%;
        overflow-y: scroll;
        display: flex;
        flex-direction: column;
        gap: 0.25vw;
        padding: 0.5vw;
        border-radius: 1vw;
    }
    #mostracorsi p {
        background-color: greenyellow;
        border-radius: 1vw;
        text-align: center;
        padding: 0.25vw;
        margin: 0px;
        border: 0.25vw solid black;
        
    }
    </style>
    ');

end stile;
end Stile;