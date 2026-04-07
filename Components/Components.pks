create or replace package Components as

PROCEDURE calendar(startDate IN DATE);
PROCEDURE lesson(isTeacher BOOLEAN,course VARCHAR, teacher VARCHAR, startH VARCHAR , endH VARCHAR);

END Components;