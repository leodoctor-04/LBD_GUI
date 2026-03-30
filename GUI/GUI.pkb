create or replace package body GUI as

procedure mettiHeader(
    TitoloPagina IN VARCHAR2
    )
is
begin

htp.htmlOpen;
  htp.headOpen;
    htp.title(TitoloPagina);
    htp.print('<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">');
    Stile.stile;
  htp.headClose;

  htp.bodyOpen;
  
    htp.print('
      <header>
        <h1>'|| TitoloPagina ||'</h1>
        <nav>
          <button>
            Accedi
          </button>
          <img src="C:\Users\leona\Desktop\LBD\00_FitZone\GUI\PasseroStilosoGiulio.png" alt="icona" onerror="this.src=''https://cdn-icons-png.flaticon.com/512/149/149071.png'';">
          
        </nav>
    </header>
      ');
  
end mettiHeader;

procedure panoramica is BEGIN

  mettiHeader('Fitzone');
  htp.print('
        <div id="panoramica">
            <div>
                <h1>Benvenuti in FitZone</h1>
                <p>In FitZone, non siamo solo una palestra, ma una vera community dedicata al benessere e al superamento dei propri limiti. Nati con l''obiettivo di rendere il fitness accessibile, motivante e orientato ai risultati, offriamo uno spazio all''avanguardia dove tecnologia e passione si incontrano. Che tu sia un atleta esperto o stia muovendo i tuoi primi passi nel mondo dell''allenamento, il nostro team di professionisti è pronto a guidarti con programmi personalizzati e un supporto costante. In FitZone, ogni goccia di sudore è un passo verso la versione migliore di te stesso: entra a far parte del movimento e trasforma la tua routine in uno stile di vita.</p>
            </div>
            <div>
              <h1>Dove trovarci</h1>
              <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2883.5198577321453!2d10.404643375660863!3d43.72052634807441!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x12d591e2e9573113%3A0x1e8d4d52d7be933b!2sPolo%20Fibonacci!5e0!3m2!1sit!2sit!4v1774861849189!5m2!1sit!2sit" style="border:0; width: 100%; height: 70%;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
            </div>
        </div>
        
        <div>
            <h1 style="text-align: center; color:white;">I nostri corsi</h1>
            <div id="mostracorsi">
                ');
              Corsi.visualizza;
  htp.print('
            </div>
        </div>
    ');


  htp.bodyClose;
  htp.htmlClose;
end panoramica;

end GUI;