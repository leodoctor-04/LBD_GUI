create or replace package input_types as
    submit_val      constant varchar(20)    := 'submit';
    number_val      constant varchar(20)    := 'number';
    date_val        constant varchar(20)    := 'date';
    text_val        constant varchar(20)    := 'text';
    password_val    constant varchar(20)    := 'password';
    radio_val       constant varchar(20)    := 'radio';
    checkbox_val    constant varchar(20)    := 'checkbox';
    telephone_val   constant varchar(20)    := 'tel';
    textarea        constant varchar(20)    := 'textarea';
end;
/