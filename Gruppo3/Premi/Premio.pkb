create or replace package body Premi as

-- Tabella Amministrativi
procedure visualizzaPremioAmministrativo
is
begin
  htp.print('<h2 style="text-align:center;">Premi Amministrativi</h2>');
  htp.print('<table>');
  htp.print('<tr><th>Mese</th><th>Anno</th><th>Punteggio</th></tr>');

  for premio in 
    (select mese, anno, punteggio from premio_amministrativo)
  loop
    htp.print('<tr>');
    htp.print('<td>' || premio.mese || '</td>');
    htp.print('<td>' || premio.anno || '</td>');
    htp.print('<td>' || premio.punteggio || '</td>');
    htp.print('</tr>');
  end loop;

  htp.print('</table>');
end visualizzaPremioAmministrativo;

-- Tabella Istruttori
procedure visualizzaPremioIstruttore
is
begin
  htp.print('<h2 style="text-align:center;">Premi Istruttori</h2>');
  htp.print('<table>');
  htp.print('<tr><th>Mese</th><th>Anno</th><th>Punteggio</th></tr>');

  for premio in 
    (select mese, anno, punteggio from premio_istruttore)
  loop
    htp.print('<tr>');
    htp.print('<td>' || premio.mese || '</td>');
    htp.print('<td>' || premio.anno || '</td>');
    htp.print('<td>' || premio.punteggio || '</td>');
    htp.print('</tr>');
  end loop;

  htp.print('</table>');
end visualizzaPremioIstruttore;


-- Pagina Finale
procedure visualizzaPremi
is
begin
  htp.htmlOpen;
  htp.headOpen;
    htp.title('Visualizza Premi');
    Stile.stile;
  htp.headClose;

  htp.bodyOpen;

    visualizzaPremioAmministrativo;
    visualizzaPremioIstruttore;

  htp.bodyClose;
  htp.htmlClose;

end visualizzaPremi;

end Premi;