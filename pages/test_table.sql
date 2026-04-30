create or replace PROCEDURE test_table AS
    d data_table := data_table('','','','red','white');
    current_row trow := trow('','','');
begin
    d.add_header('hd1');
    d.add_header('hd2');
    d.add_header('hd3');
    d.add_header('hd4');

    current_row.add_element(label('','','','testo'));
    current_row.add_element(label('','','','testo'));
    current_row.add_element(label('','','','testo'));
    for i in 1 .. 10 loop
        d.add_row(current_row);
    end loop;


    d.showhtml;
    return;
end;