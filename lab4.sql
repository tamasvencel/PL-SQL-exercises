drop table Orarend;
drop table Tanit;
drop table Osztalyok;
drop table Tanarok;
drop table Tantargyak;

create table Osztalyok(
OsztalyID number(3) primary key,
Terem number(3),
Emelet number(3)
);

insert into Osztalyok values (5, 1, 0);
insert into Osztalyok values (6, 2, 0);
insert into Osztalyok values (7, 3, 1);
insert into Osztalyok values (8, 4, 1);

create table Tanarok(
TanarID number(3) primary key,
TNev varchar2(30),
TTfSzam varchar2(10)
);

insert into Tanarok values (1, 'Nagy Gergo', '0732067895');
insert into Tanarok values (2, 'Marton Anita', '0264789678');
insert into Tanarok values (3, 'Kollo Beata', '0260361739');
insert into Tanarok values (4, 'Halasz Istvan','0728345678');
insert into Tanarok values (5, 'Kiss Edina', '0264435672');

create table Tantargyak(
TantargyID number(3) primary key,
TaNev varchar2(20)
);

insert into Tantargyak values (1, 'Magyar');
insert into Tantargyak values (2, 'Roman');
insert into Tantargyak values (3, 'Matematika');
insert into Tantargyak values (4, 'Informatika');
insert into Tantargyak values (5, 'Testneveles');
insert into Tantargyak values (6, 'Fizika');

create table Tanit(
TanarID number(3) references Tanarok(TanarID),
TantargyID number(3) references Tantargyak(TantargyID),
Primary Key(TanarID, TantargyID)
);

insert into Tanit values (1,1);
insert into Tanit values (1,2);
insert into Tanit values (2,2);
insert into Tanit values (3,3);
insert into Tanit values (3,6);
insert into Tanit values (4,3);
insert into Tanit values (4,4);
insert into Tanit values (5,5);


create table Orarend(
ID number(3) primary key,
TanarID number(3) references Tanarok(TanarID),
TantargyID number(3) references Tantargyak(TantargyID),
OsztalyID number(3) references Osztalyok(OsztalyID),
Nap number(3) check (Nap>=1 and Nap<=5),
Ora number(3) check (Ora>=8 and Ora<=14)
);

insert into Orarend values (1, 1,1, 5, 1, 8);
insert into Orarend values (2, 1,1, 6, 1, 10);
insert into Orarend values (3, 1,1, 7, 1, 13);
insert into Orarend values (4, 1,1, 8, 1, 12);
insert into Orarend values (5, 1,2, 7, 1, 9);
insert into Orarend values (6, 1,2, 8, 1, 11);
insert into Orarend values (7, 2,2, 5, 1, 10);
insert into Orarend values (8, 2,2, 6, 1, 14);
insert into Orarend values (9, 3,3, 5, 1, 14);
insert into Orarend values (10, 3,3, 6, 1, 8);
insert into Orarend values (11, 3,3, 7, 1, 10);
insert into Orarend values (12, 3,3, 8, 1, 12);

insert into Orarend values (13, 1,1, 5, 2, 8);
insert into Orarend values (14, 1,1, 6, 2, 9);
insert into Orarend values (15, 1,1, 7, 2, 10);
insert into Orarend values (16, 1,1, 8, 2, 11);
insert into Orarend values (17, 2,2, 5, 2, 9);
insert into Orarend values (18, 2,2, 6, 2, 10);
insert into Orarend values (19, 3,3, 5, 2, 10);
insert into Orarend values (20, 3,3, 6, 2, 8);
insert into Orarend values (21, 3,6, 6, 2, 11);
insert into Orarend values (22, 3,6, 7, 2, 12);
insert into Orarend values (23, 4,4, 6, 2, 13);
insert into Orarend values (24, 4,4, 7, 2, 14);
insert into Orarend values (25, 4,3, 7, 2, 9);
insert into Orarend values (26, 4,3, 8, 2, 11);
insert into Orarend values (27, 5,5, 5, 2, 11);
insert into Orarend values (28, 5,5, 6, 2, 12);

insert into Orarend values (29, 5,5, 5, 3, 10);
insert into Orarend values (30, 1,1, 5, 4, 10);
insert into Orarend values (31, 2,2, 6, 5, 13);
insert into Orarend values (32, 5,5, 6, 5, 14);

/*
-- teszteles:
-- megfelelo idopont
EXEC :eredmeny := orarend_tervezes(1,1,5,2);
print eredmeny;
SELECT * FROM orarend WHERE nap =2;
-- nem tanitja a tantargyat
EXEC :eredmeny := orarend_tervezes(1,5,5,2);
PRINT eredmeny;
-- mar meg van a 6 oraja az 1es napra
EXEC :eredmeny := orarend_tervezes(1,1,5,1);
PRINT eredmeny;
-- nem jo az idopont mert mas tanar mar tart olyan orat
EXEC :eredmeny := orarend_tervezes(4,3,7,1);
PRINT eredmeny;
show err;
-- nem letezik ilyen nap ezert egy masik napot keres
EXEC :eredmeny := orarend_tervezes(4,3,7,8);
print eredmeny;
*/

// insertLesson, isTeachingTheSubject, searchFreeHour, searchOtherFreeDate, planTimetable

set serveroutput on;

CREATE OR REPLACE PROCEDURE insertLesson(pTanarID orarend.tanarID%TYPE, pTantargyID orarend.tantargyID%TYPE, pOsztID orarend.osztalyID%TYPE, pNap orarend.nap%TYPE, pOra orarend.ora%TYPE) IS

    v_orarendCount NUMBER;
    v_orarendID orarend.ID%TYPE;
BEGIN
    SELECT COUNT(*) INTO v_orarendCount
    FROM ORAREND
    WHERE tanarID = pTanarID AND tantargyID = pTantargyID AND osztalyID = pOsztID AND nap = pNap AND ora = pOra;

    IF v_orarendCount = 0 THEN
        SELECT NVL(MAX(ID), 0) + 1 INTO v_orarendID
        FROM ORAREND;

        INSERT INTO ORAREND (ID, tanarID, tantargyID, osztalyID, nap, ora) VALUES (v_orarendID, pTanarID, pTantargyID, pOsztID, pNap, pOra);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Insertion failed, Lesson is already present!');
    END IF;
END;
/

BEGIN
    insertLesson(3, 3, 5, 3, 10);
END;
/

SELECT * FROM ORAREND;

CREATE OR REPLACE FUNCTION isTeachingTheSubject (pTanarID tanit.tanarID%TYPE, pTantargyID tanit.tantargyID%TYPE) RETURN NUMBER IS
    v_returnValue NUMBER := -1;
BEGIN
    SELECT COUNT(*) INTO v_returnValue
    FROM TANIT
    WHERE tanarID = pTanarID AND tantargyID = pTantargyID;

    return v_returnValue;
END;
/

DECLARE 
    v_returnValue NUMBER;
BEGIN
    v_returnValue := isTeachingTheSubject(3, 10);
    IF v_returnValue > 0 THEN
        DBMS_OUTPUT.PUT_LINE('The given teacher teaches the specified subject.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The given teacher does not teach the specified subject.');
    END IF;
END;
/

SELECT * FROM TANIT;

CREATE OR REPLACE FUNCTION searchFreeHour (pTanarID tanit.tanarID%TYPE, pTantargyID tantargyak.tantargyid%TYPE, pOsztID orarend.osztalyID%TYPE, pNap orarend.nap%TYPE) RETURN NUMBER IS
    v_hour orarend.ora%TYPE;
    v_hoursWorkedByTeacher NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_hoursWorkedByTeacher
    FROM ORAREND
    WHERE tanarID = pTanarID AND nap = pNap;

    IF v_hoursWorkedByTeacher >= 6 THEN
        DBMS_OUTPUT.PUT_LINE('The teacher already worked at least 6 hours! He/She should not work more.');
        RETURN -1;
    END IF;

    IF (pNap < 1 OR pNap > 5) THEN
        DBMS_OUTPUT.PUT_LINE('Given day is incorrect! (value should be from 1 to 5, meaning from Monday to Friday)');
        RETURN -1;
    END IF;

    SELECT ora INTO v_hour
    FROM( 
            (
            SELECT LEVEL + 7 AS ora
            FROM dual
            CONNECT BY LEVEL <= (SELECT NVL(MAX(ora), 0) FROM ORAREND WHERE tanarID = pTanarID)
            MINUS
            SELECT ora
            FROM ORAREND
            WHERE tanarID = pTanarID AND nap = pNap
            )
            INTERSECT
            (
            SELECT LEVEL + 7 AS ora
            FROM dual
            CONNECT BY LEVEL <= (SELECT NVL(MAX(ora), 0) FROM ORAREND WHERE tanarID = pTanarID)
            MINUS
            SELECT ora
            FROM ORAREND
            WHERE osztalyID = pOsztID AND nap = pNap
            )
        )
    WHERE ora NOT IN (
        SELECT ora
        FROM ORAREND
        WHERE tantargyID = pTantargyID
    ) AND (ora > 12 AND ora <= 14)
    ORDER BY ora
    FETCH FIRST ROW ONLY;

    return v_hour;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
    WHEN OTHERS THEN
        dbms_output.put_line('Something went wrong!');
        RETURN -2; 
END;
/

DECLARE
    v_hour NUMBER;
BEGIN
    v_hour := searchFreeHour (3, 3, 5, 2); 
    DBMS_OUTPUT.PUT_LINE(v_hour);
END;
/
SELECT * FROM ORAREND;

CREATE OR REPLACE TYPE numArray IS
    VARRAY(5) OF NUMBER;
/
CREATE OR REPLACE FUNCTION searchOtherFreeDate(pTanarID tanit.tanarID%TYPE, pTantargyID tantargyak.tantargyid%TYPE, pOsztID orarend.osztalyID%TYPE) RETURN numArray IS
    v_otherDaysWithFreeHours numArray := numArray();
    v_searchHourReturn NUMBER;
BEGIN
    FOR i IN 1..5 LOOP
        SELECT
            searchFreeHour(pTanarID, pTantargyID, pOsztID, i)
        INTO v_searchHourReturn
        FROM dual;

        IF v_searchHourReturn > 0 THEN
            v_otherDaysWithFreeHours.extend;
            v_otherDaysWithFreeHours(v_otherDaysWithFreeHours.count) := i;
        END IF;
    END LOOP;

    RETURN v_otherDaysWithFreeHours;
END;
/

DECLARE
    resultArr numArray;
BEGIN
    resultArr := searchOtherFreeDate(4, 3, 7);
    dbms_output.put_line('Days with free hours:');
    FOR i IN 1..resultArr.count LOOP
        dbms_output.put_line(resultArr(i));
    END LOOP;
END;
/

CREATE OR REPLACE FUNCTION planTimetable(pTanarID tanit.tanarID%TYPE, pTantargyID tantargyak.tantargyid%TYPE, pOsztID orarend.osztalyID%TYPE, pNap orarend.nap%TYPE) RETURN NUMBER IS
    v_teachesTheSubjOrNot NUMBER;
    v_freeHour orarend.ora%TYPE;
    v_daysWithFreeHours numArray := numArray();
    v_teacherName tanarok.tnev%TYPE;
    v_dayName VARCHAR2(20);
BEGIN
    IF (pNap < 1 OR pNap > 5) THEN
        DBMS_OUTPUT.PUT_LINE('Given day is incorrect! (value should be from 1 to 5, meaning from Monday to Friday)');
        RETURN -1;
    END IF;

    v_teachesTheSubjOrNot := isTeachingTheSubject(pTanarID, pTantargyID);

    IF v_teachesTheSubjOrNot > 0 THEN
        v_freeHour := searchFreeHour(pTanarID, pTantargyID, pOsztID, pNap);

        SELECT tnev INTO v_teacherName
        FROM TANAROK 
        WHERE tanarID = pTanarID;

        CASE pNap
            WHEN 1 THEN v_dayName := 'Monday';
            WHEN 2 THEN v_dayName := 'Tuesday';
            WHEN 3 THEN v_dayName := 'Wednesday';
            WHEN 4 THEN v_dayName := 'Thursday';
            WHEN 5 THEN v_dayName := 'Friday';
        END CASE;

        IF v_freeHour > 0 THEN
            insertLesson(pTanarID, pTantargyID, pOsztID, pNap, v_freeHour);
            DBMS_OUTPUT.PUT_LINE('Lesson successfully inserted! ' || v_teacherName || ' teacher`s lesson will be on ' || v_dayName || ' at ' || v_freeHour || '.');
            RETURN 0;
        END IF;

        v_daysWithFreeHours := searchOtherFreeDate(pTanarID, pTantargyID, pOsztID);

        if v_daysWithFreeHours IS NULL OR v_daysWithFreeHours.count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('The whole week is full, no days with free hours!');
            RETURN -2;
        END IF;

        DBMS_OUTPUT.PUT_LINE('There are no free hours on the provided day, but here are the other days with free hours:');
        FOR i IN 1..v_daysWithFreeHours.count LOOP
            DBMS_OUTPUT.PUT_LINE(v_daysWithFreeHours(i));
        END LOOP;

        v_freeHour := searchFreeHour(pTanarID, pTantargyID, pOsztID, v_daysWithFreeHours(1));

        insertLesson(pTanarID, pTantargyID, pOsztID, v_daysWithFreeHours(1), v_freeHour);

        DBMS_OUTPUT.PUT_LINE('Lesson successfully inserted! ' || v_teacherName || ' teacher`s lesson will be on ' || TO_CHAR(TO_DATE(pNap, 'D'), 'Day') || ' at ' || v_freeHour || '.');

        RETURN v_freeHour;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('The given teacher does not teach the specified subject.');
    END IF;
END;
/

DECLARE
    v_freeHour NUMBER;
BEGIN
    v_freeHour := planTimetable(4, 3, 7, 3);
END;
/

SELECT * FROM ORAREND;