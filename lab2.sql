// 0.
SELECT sysdate + level - 1
FROM dual
CONNECT BY level <= sysdate + 5 - sysdate;

// 1.
CREATE OR REPLACE FUNCTION numOfWorkdays(d1 DATE, d2 DATE) return number is
    countDays NUMBER := 0;
begin
    SELECT COUNT(*) INTO countDays
    from (
        select (d1 + level - 1) as n
        from dual
        connect by level <= d2 - d1 + 1
    )
    where to_char(n, 'DY') not in ('SAT', 'SUN');
    
    return countDays;
END numOfWorkdays;
/

select numOfWorkdays(sysdate, sysdate + 10)
from dual;

// 2.
CREATE OR REPLACE FUNCTION dateIntersect(start1 DATE, end1 DATE, start2 DATE, end2 DATE) return VARCHAR2 is
BEGIN
    IF (start1 <= end2) AND 
       (start2 <= end1) THEN return 'intersect'; ELSE return 'not intersect';
    END IF;
END;
/

select isIntersect(sysdate, sysdate + 5, sysdate + 2, sysdate + 4)
from dual;

// 3.
CREATE OR REPLACE FUNCTION get_employees(dept_id NUMBER) RETURN VARCHAR2 IS
    emp_names VARCHAR2(4000);
    emp_name VARCHAR2(100);
    CURSOR c_emp_names IS
        SELECT last_name
        FROM c##hr.employees
        WHERE department_id = dept_id;
BEGIN
    emp_names := '';

    FOR employee IN c_emp_names LOOP
        IF emp_names IS NOT NULL THEN
            emp_names := emp_names || ', ';
        END IF;
        emp_names := emp_names || employee.last_name;
    END LOOP;

    RETURN emp_names;
END;
/

SELECT department_id,
get_employees(department_id) AS employees
FROM c##hr.employees
GROUP by department_id;

// 4.
/
SET SERVEROUTPUT ON
/
CREATE OR REPLACE PROCEDURE countObjectsInSchema IS
object_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO object_count
    FROM user_objects;

    IF object_count > 20 THEN
        DBMS_OUTPUT.PUT_LINE('SOK');
    ELSE
        DBMS_OUTPUT.PUT_LINE('KEVÉS');
    END IF;
END;
/
BEGIN
    countObjectsInSchema();
END;
/

///
drop table Kolcsonzesek;
drop table Kolcsonzo;
drop table FilmekDVDn;
drop table Filmek;
drop table Mufajok;
drop table DVDk;

create table Mufajok(
 MufajID number(3)  primary key,
 MufajNev varchar2(30)
 );

insert into Mufajok values (1,'romantikus');
insert into Mufajok values (2,'akcio');
insert into Mufajok values (3,'csaladi');
insert into Mufajok values (4,'kaland');
insert into Mufajok values (5,'thriller');
insert into Mufajok values (6,'drama');

create table Filmek(
 FilmID number(3)  primary key,
 FCim varchar2(30),
 Studio varchar2(30),
 MufajID number(3) references Mufajok(MufajID)
);

insert into Filmek values (1,'Nemo nyomaban','Walt Disney Pictures',3);
insert into Filmek values (2,'Transformers','DreamWorks SKG',2);
insert into Filmek values (3,'White noise','Brightlight Pictures',5);
insert into Filmek values (4,'Finding Neverland','Miramax Films',1);
insert into Filmek values (5,'Ket het mulva orokke','Castle Rock Entertainment',1);
insert into Filmek values (6,'A remeny rabjai','Castle Rock Entertainment',6);
insert into Filmek values (7,'Pillango hatas','BenderSpink',5);

create table DVDk(
 DVDID number(3)  primary key,
 NapiAr number(3));

insert into DVDk values (1,5);
insert into DVDk values (2,5);
insert into DVDk values (3,4);
insert into DVDk values (4,6);
insert into DVDk values (5,4);
insert into DVDk values (6,7);
insert into DVDk values (7,5);
insert into DVDk values (8,2);
 
create table FilmekDVDn(
 DVDID number(3) references DVDk(DVDID),
 FilmID number(3) references Filmek(FilmID),
 primary key(DVDID, FilmID)
);

insert into FilmekDVDn values (1,1);
insert into FilmekDVDn values (1,2);
insert into FilmekDVDn values (1,3);
insert into FilmekDVDn values (1,4);
insert into FilmekDVDn values (1,5);

insert into FilmekDVDn values (2,2);
insert into FilmekDVDn values (2,3);
insert into FilmekDVDn values (2,4);
insert into FilmekDVDn values (2,5);
insert into FilmekDVDn values (2,6);

insert into FilmekDVDn values (3,1);
insert into FilmekDVDn values (3,4);
insert into FilmekDVDn values (3,6);
insert into FilmekDVDn values (3,7);

insert into FilmekDVDn values (4,1);
insert into FilmekDVDn values (4,2);
insert into FilmekDVDn values (4,5);
insert into FilmekDVDn values (4,6);

insert into FilmekDVDn values (5,3);
insert into FilmekDVDn values (5,5);

insert into FilmekDVDn values (6,1);

insert into FilmekDVDn values (7,7);

insert into FilmekDVDn values (8,2);
insert into FilmekDVDn values (8,3);

create table Kolcsonzo(
 KID number(3)  primary key,
 Nev varchar2(30),
 Cim varchar2(30),
 Telefon varchar2(10)	
);

insert into Kolcsonzo values(1,'Szilagyi Jeno','Kolozsvar, Scortarilor 79','0732067895');
insert into Kolcsonzo values (2,'Andras Mihaly','Kolozsvar, Gr. Alexandrescu 5','0264435672');
insert into Kolcsonzo values (3,'Kiraly Lorand','Kolozsvar, Unirii 1','0264789678');
insert into Kolcsonzo values (4,'Csizmar Karoly','Nagyvarad, Closca 90','0260361739');
insert into Kolcsonzo values (5,'Balogh Imre','Kolozsvar, Paris 3','0728345678');
insert into Kolcsonzo values (6,'Andras Hannah','Kolozsvar, Gr. Alexandrescu 5','0264435672');
insert into Kolcsonzo values (7,'Andor Zoltan','Kolozsvar, Fantanele 34','0780345678');
insert into Kolcsonzo values (8,'Nagy Ildiko','Kolozsvar, Motilor 2','0751234786');
insert into Kolcsonzo values (9,'Kollo Ingrid','Szatmarnemeti, Somesul 67','0261868685');
insert into Kolcsonzo values (10,'Petok Ilona','Nagykaroly, Agoston 52','0728798789');

create table Kolcsonzesek(
 KID number(3) references Kolcsonzo(KID),
 DVDID number(3) references DVDk(DVDID),
 DatumKi date, 
 DatumVissza date, 
 Ertek int,
 Primary key(KID, DVDID, DatumKi)
 );
 
select sysdate from dual;

INSERT INTO Kolcsonzesek VALUES (2, 1, to_date('2021-06-15','YYYY-MM-DD'), to_date('2021-06-20','YYYY-MM-DD'), 250)  ; 
INSERT INTO Kolcsonzesek VALUES (1, 1, to_date('2021-06-20','YYYY-MM-DD'), to_date( '2021-06-25','YYYY-MM-DD'), 250);
INSERT INTO Kolcsonzesek VALUES (1, 1, to_date('2021-06-30','YYYY-MM-DD'), to_date( '2021-07-02','YYYY-MM-DD'), 10);
INSERT INTO Kolcsonzesek VALUES (3, 1, to_date('2021-07-02', 'YYYY-MM-DD'), to_date('2021-07-12','YYYY-MM-DD'), 100);
INSERT INTO Kolcsonzesek VALUES (3, 1, to_date('2021-07-12', 'YYYY-MM-DD'), to_date('2021-07-15','YYYY-MM-DD'), 15);
INSERT INTO Kolcsonzesek VALUES (4, 1, to_date('2021-07-20', 'YYYY-MM-DD'), to_date('2021-07-22', 'YYYY-MM-DD'),10);
INSERT INTO Kolcsonzesek VALUES (10, 1, to_date('2021-07-27','YYYY-MM-DD'), to_date( '2021-07-30', 'YYYY-MM-DD'),15);
INSERT INTO Kolcsonzesek VALUES (5, 1, to_date('2021-08-05', 'YYYY-MM-DD'), to_date('2021-08-15', 'YYYY-MM-DD'),100);
INSERT INTO Kolcsonzesek VALUES (3, 1, to_date('2021-09-01', 'YYYY-MM-DD'), to_date('2021-09-12','YYYY-MM-DD'), 20);

INSERT INTO Kolcsonzesek VALUES (2, 2,to_date( '2021-06-15','YYYY-MM-DD'), to_date( '2021-06-20','YYYY-MM-DD'), 250) ;  
INSERT INTO Kolcsonzesek VALUES (1, 2, to_date('2021-06-20', 'YYYY-MM-DD'), to_date('2021-06-25', 'YYYY-MM-DD'),250);
INSERT INTO Kolcsonzesek VALUES (1, 2, to_date('2021-06-30','YYYY-MM-DD'), to_date( '2021-07-02', 'YYYY-MM-DD'),10);
INSERT INTO Kolcsonzesek VALUES (3, 2, to_date( '2021-07-02', 'YYYY-MM-DD'), to_date('2021-07-12', 'YYYY-MM-DD'),100);
INSERT INTO Kolcsonzesek VALUES (3, 2, to_date('2021-07-12', 'YYYY-MM-DD'), to_date('2021-07-15','YYYY-MM-DD'), 15);
INSERT INTO Kolcsonzesek VALUES (4, 2, to_date('2021-07-20','YYYY-MM-DD'), to_date( '2021-07-22', 'YYYY-MM-DD'),10);
INSERT INTO Kolcsonzesek VALUES (10, 2, to_date('2021-07-27', 'YYYY-MM-DD'), to_date('2021-07-30','YYYY-MM-DD'), 15);
INSERT INTO Kolcsonzesek VALUES (5, 2, to_date( '2021-08-05', 'YYYY-MM-DD'), to_date('2021-08-15', 'YYYY-MM-DD'),100);
INSERT INTO Kolcsonzesek VALUES (3, 2, to_date('2021-09-01', 'YYYY-MM-DD'), to_date('2021-09-12','YYYY-MM-DD'), 20);

INSERT INTO Kolcsonzesek VALUES (2, 3,to_date( '2021-06-15','YYYY-MM-DD'), to_date( '2021-06-20', 'YYYY-MM-DD'),250)  ; 
INSERT INTO Kolcsonzesek VALUES (1, 3, to_date('2021-06-20', 'YYYY-MM-DD'), to_date('2021-06-25','YYYY-MM-DD'), 250);
INSERT INTO Kolcsonzesek VALUES (1, 3, to_date('2021-06-30', 'YYYY-MM-DD'), to_date('2021-07-02','YYYY-MM-DD'), 10);
INSERT INTO Kolcsonzesek VALUES (3, 3,to_date( '2021-07-02','YYYY-MM-DD'), to_date( '2021-07-12', 'YYYY-MM-DD'),100);
INSERT INTO Kolcsonzesek VALUES (3, 3, to_date('2021-09-01', 'YYYY-MM-DD'), to_date('2021-09-15','YYYY-MM-DD'), 20);

INSERT INTO Kolcsonzesek VALUES (2, 4, to_date('2021-06-15', 'YYYY-MM-DD'), to_date('2021-06-20','YYYY-MM-DD'), 250) ;  
INSERT INTO Kolcsonzesek VALUES (1, 4, to_date('2021-06-20','YYYY-MM-DD'), to_date( '2021-06-25','YYYY-MM-DD'), 250);
INSERT INTO Kolcsonzesek VALUES (3, 4, to_date('2021-09-01', 'YYYY-MM-DD'), to_date('2021-09-09','YYYY-MM-DD'), 20);

INSERT INTO Kolcsonzesek VALUES (5, 5,to_date( '2021-06-30','YYYY-MM-DD'), to_date( '2021-07-01','YYYY-MM-DD'), 4);
INSERT INTO Kolcsonzesek VALUES (9, 5, to_date('2021-07-12','YYYY-MM-DD'), to_date( '2021-07-15', 'YYYY-MM-DD'),12);
INSERT INTO Kolcsonzesek VALUES (10, 5, to_date('2021-07-20','YYYY-MM-DD'), to_date( '2021-07-22','YYYY-MM-DD'),8);
INSERT INTO Kolcsonzesek VALUES (5, 5, to_date('2021-07-25','YYYY-MM-DD'), to_date( '2021-07-31','YYYY-MM-DD'), 24);
INSERT INTO Kolcsonzesek VALUES (8, 5, to_date('2021-07-31','YYYY-MM-DD'), to_date( '2021-08-05', 'YYYY-MM-DD'),20);
INSERT INTO Kolcsonzesek VALUES (4, 5, to_date('2021-08-05','YYYY-MM-DD'), to_date( '2021-08-15','YYYY-MM-DD'), 40);
INSERT INTO Kolcsonzesek VALUES (3, 5, to_date('2021-09-01', 'YYYY-MM-DD'), to_date('2021-09-10','YYYY-MM-DD'), 20);
INSERT INTO Kolcsonzesek VALUES (4, 5, to_date('2021-09-10', 'YYYY-MM-DD'), to_date('2021-09-15', 'YYYY-MM-DD'),40);

INSERT INTO Kolcsonzesek VALUES (5, 6, to_date('2021-06-30','YYYY-MM-DD'), to_date( '2021-07-01','YYYY-MM-DD'), 4);
INSERT INTO Kolcsonzesek VALUES (9, 6,to_date( '2021-07-12','YYYY-MM-DD'), to_date( '2021-07-15','YYYY-MM-DD'), 12);
INSERT INTO Kolcsonzesek VALUES (10, 6, to_date('2021-07-20', 'YYYY-MM-DD'), to_date('2021-07-22','YYYY-MM-DD'), 8);
INSERT INTO Kolcsonzesek VALUES (8, 6, to_date('2021-07-31','YYYY-MM-DD'), to_date( '2021-08-05', 'YYYY-MM-DD'),20);
INSERT INTO Kolcsonzesek VALUES (4, 6,to_date('2021-08-05','YYYY-MM-DD'), to_date( '2021-08-15', 'YYYY-MM-DD'),40);
INSERT INTO Kolcsonzesek VALUES (3, 6, to_date('2021-09-01','YYYY-MM-DD'), to_date( '2021-09-10','YYYY-MM-DD'), 20);
INSERT INTO Kolcsonzesek VALUES (4, 6,to_date( '2021-09-10', 'YYYY-MM-DD'), to_date('2021-09-15', 'YYYY-MM-DD'),40);

INSERT INTO Kolcsonzesek VALUES (1, 8,to_date( '2021-06-20','YYYY-MM-DD'), to_date( '2021-06-25', 'YYYY-MM-DD'),250);
INSERT INTO Kolcsonzesek VALUES (1, 8, to_date('2021-06-30','YYYY-MM-DD'), to_date( '2021-07-02', 'YYYY-MM-DD'),10);
INSERT INTO Kolcsonzesek VALUES (3, 8, to_date('2021-07-02','YYYY-MM-DD'), to_date( '2021-07-12', 'YYYY-MM-DD'),100);
INSERT INTO Kolcsonzesek VALUES (3, 8, to_date('2021-09-01','YYYY-MM-DD'), to_date( '2021-09-15','YYYY-MM-DD'), 20);

/*--Tesztadatok
--parameterek: pFilmID, pKolcsonzoNev, pKCim, pKTel, pDatumKi, pNapokSzama

--az adott periodusban van kikolcsonozheto film, melyen szerepel a megadott film
1, 'Szilagyi Jeno','Kolozsvar, Scortarilor 79','0732067895', '2021-07-28', 2
visszateritesi ertek: 0
DVDID: 3,4,6
Ertek: 8(3-as DVD eseten)

6, 'Szilagyi Jeno','Kolozsvar, Scortarilor 79','0732067895', '2021-08-01', 15
visszateritesi ertek: 0
DVDID: 3,4
Ertek: 60(3-as DVD eseten)

--az adott periodusban az osszes DVD ki van kolcsonozve, melyen szerepel az adott film
--kikolcsonozheto olyan DVD, melyen szerepel pFilmID-ju filmmel azonos mufaju film
--pl:
4, 'Szilagyi Jeno','Kolozsvar, Scortarilor 79','0732067895', '2021-06-30', 2
4, 'Szilagyi Jeno','Kolozsvar, Scortarilor 79','0732067895', '2021-06-30', 13
4, 'Szilagyi Jeno','Kolozsvar, Scortarilor 79','0732067895', '2021-07-02', 10
@outLehetsegesDVD erteke: 4
visszateritesi ertek: -1

3, 'Szilagyi Jeno','Kolozsvar, Scortarilor 79','0732067895', '2021-08-05', 10
@outLehetsegesDVD erteke: 3,7
visszateritesi ertek: -1

--egy DVD sem felel meg a felteteleknek(FilmID es/vagy mufaj)
4, 'Szilagyi Jeno','Kolozsvar, Scortarilor 79','0732067895', '2021-06-15', 10
5, 'Szilagyi Jeno','Kolozsvar, Scortarilor 79','0732067895', '2021-09-01', 10 
5, 'Szilagyi Jeno','Kolozsvar, Scortarilor 79','0732067895', '2021-09-06', 3 
visszateritesi ertek: 2
*/

// functions:
// 1. isIntersect
// 2. insertKolcsonzo (returns a number)
// 3. insertKolcsonzes
// 4. searchDVD
// 5. searchSimilarGenreMovie
// 6. main

// 1.
CREATE OR REPLACE FUNCTION dateIntersect(start1 DATE, end1 DATE, start2 DATE, end2 DATE) return NUMBER is
BEGIN
    IF (start1 <= end2) AND 
       (start2 <= end1) THEN return 1; ELSE return 0;
    END IF;
END;
/

// 2.
CREATE OR REPLACE FUNCTION insertKolcsonzo(
    pKid NUMBER,
    pNev IN VARCHAR2,
    pCim IN VARCHAR2,
    pTelefon IN VARCHAR2
) RETURN NUMBER IS
    vKID NUMBER;
BEGIN
    SELECT count(*) INTO vKID
    FROM Kolcsonzo
    WHERE kid=pKid;
        
    IF vKID = 0 THEN
        INSERT INTO Kolcsonzo (KID, Nev, Cim, Telefon)
        VALUES (pKid, pNev, pCim, pTelefon);
        RETURN pKid;
    ELSE
        RETURN pKid;
    END IF;
END;
/

DECLARE v_KID NUMBER;
BEGIN
    v_KID := insertKolcsonzo(11, 'Asd', 'Asd', '123456789');
END;
/
SELECT * FROM kolcsonzo;

// 3.
CREATE OR REPLACE PROCEDURE insertKolcsonzes (pKID NUMBER, pDvdID NUMBER, pDatumKi DATE, pDatumVissza DATE)
IS
    v_ertek NUMBER;
    v_napiar NUMBER;
BEGIN
        SELECT napiar
        INTO v_napiar
        FROM DVDk
        WHERE DVDID=pDvdID;
        
        v_ertek := (pDatumVissza - pDatumKi) *  v_napiar;
        
        INSERT INTO kolcsonzesek (KID, DVDID, DatumKi, DatumVissza, Ertek) VALUES (pKID, pDvdID, pDatumKi, pDatumVissza, v_ertek);

    EXCEPTION 
        WHEN DUP_VAL_ON_INDEX
            THEN DBMS_OUTPUT.PUT_LINE('Mar szerepel benne!');
        WHEN NO_DATA_FOUND
            THEN DBMS_OUTPUT.PUT_LINE('Nincs meg a DVD!');
        WHEN OTHERS
            THEN DBMS_OUTPUT.PUT_LINE('Mas hiba!');
            RECORD_ERROR();
END;
/

BEGIN
    insertKolcsonzes(7, 7, to_date( '2021-06-15','YYYY-MM-DD'), to_date( '2021-07-15','YYYY-MM-DD'));
END;
/

SELECT * FROM kolcsonzesek
WHERE dvdID = 7 AND KID = 7;

// 4.
CREATE OR REPLACE FUNCTION searchDVD (pFilmCim VARCHAR2, pDatum1 DATE, pDatum2 DATE)
RETURN NUMBER    
IS
    resDVD NUMBER;
BEGIN
    --osszes olyan DVD-t, amelyiken rajta van az en filmem, amelyek meg nincsenek kikolcsonozve
    SELECT MAX(dvdid)
    INTO resDVD
    FROM
    (SELECT fd.dvdid
    FROM filmek f JOIN filmekDVDn fd
    ON f.filmid = fd.filmid
    WHERE f.fcim = pFilmCim
    MINUS
    SELECT dvdid
    FROM kolcsonzesek
    WHERE dateIntersect(datumKi, datumVissza, pDatum1, pDatum2) = 1);
    
    IF resDVD is NULL
    THEN RETURN -1;
    ELSE RETURN resDVD;
    END IF;
END searchDVD;
/

DECLARE res_dvd NUMBER;
BEGIN
    res_dvd := searchDVD('Transformers', sysdate, sysdate + 10);
    DBMS_OUTPUT.PUT_LINE('Found dvd: ' || res_dvd);
END;
/
SELECT * FROM filmekdvdn;

-- 5.
CREATE TYPE StringArray IS TABLE OF VARCHAR2(30000);
/
CREATE OR REPLACE FUNCTION searchSimilarGenreMovie (pFilmCim VARCHAR2)
RETURN StringArray
IS
    cimek StringArray;
BEGIN
    SELECT fCim
    BULK COLLECT INTO cimek
    FROM filmek
    WHERE mufajID IN (SELECT mufajID FROM filmek WHERE FCim = pFilmCim)
    MINUS
    SELECT fCim 
    FROM filmek
    where fCim = pFilmCim;

    IF cimek.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No similar movies found');
        RETURN null;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Found ' || cimek.COUNT || ' similar movie(s):');
        RETURN cimek;
    END IF;
END searchSimilarGenreMovie;
/

DECLARE similarMovies StringArray;
BEGIN
    similarMovies := searchSimilarGenreMovie('White noise');

    IF similarMovies IS NOT NULL THEN
        for i in 1..similarMovies.count loop
            DBMS_OUTPUT.PUT_LINE(similarMovies(i));
        end loop;
    END IF;
END;
/

SELECT * FROM filmek;

-- 6
CREATE OR REPLACE FUNCTION main (pFCim VARCHAR2, pKolcsonzoNev VARCHAR2, pKCim VARCHAR2, pKTel VARCHAR2, pDatumKi DATE, pDatumVissza DATE)
RETURN NUMBER
IS
    v_DVDID NUMBER;
    k_Visszateritett NUMBER;
    m_filmek StringArray;
    vKID NUMBER;
BEGIN
    v_DVDID := searchDVD(pFCim, pDatumKi, pDatumVissza);

    SELECT KID INTO vKID
    FROM kolcsonzo
    WHERE Nev = pKolcsonzoNev;
    
    IF v_DVDID > 0
    THEN k_Visszateritett := insertKolcsonzo(vKID, pKolcsonzoNev, pKCim, pKTel);
    insertKolcsonzes(k_Visszateritett, v_DVDID, pDatumKi, pDatumVissza);
    RETURN v_DVDID;
    ELSE
        m_filmek := searchSimilarGenreMovie(pFCim);
        
        FOR i IN 1..m_filmek.COUNT
        LOOP
            v_DVDID := searchDVD(m_filmek(i), pDatumKi, pDatumVissza);
            
            IF v_DVDID > 0
                THEN k_Visszateritett := insertKolcsonzo(vKID, pKolcsonzoNev, pKCim, pKTel);
                    insertKolcsonzes(k_Visszateritett, v_DVDID, pDatumKi, pDatumVissza); 
                    RETURN v_DVDID;
                ELSE CONTINUE;
            END IF;
        
        END LOOP;
        
        RETURN -1;
    END IF;
        
END;
/

DECLARE 
    pFCim VARCHAR2(100) := 'Transformers';
    pKolcsonzoNev VARCHAR2(100) := 'Szilagyi Jeno';
    pKCim VARCHAR2(100) := 'Kolozsvar, Scortarilor 79';
    pKTel VARCHAR2(20) := '0732067895';
    pDatumKi DATE := TO_DATE('2021-07-28', 'YYYY-MM-DD');
    pDatumVissza DATE := TO_DATE('2021-07-30', 'YYYY-MM-DD');
    result NUMBER;
BEGIN
    result := main(pFCim, pKolcsonzoNev, pKCim, pKTel, pDatumKi, pDatumVissza);
    DBMS_OUTPUT.PUT_LINE('Result: ' || result);
END;
/
