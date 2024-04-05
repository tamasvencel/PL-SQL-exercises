DROP TABLE Foglalasok;
DROP TABLE Szallodak;
DROP TABLE Turistak;
DROP TABLE Udulohely;
DROP TABLE Orszagok;

CREATE TABLE Orszagok(
	OrszagID number(4) PRIMARY KEY,
	OrszagNev VARCHAR(30)
);

INSERT into Orszagok VALUES (1, 'Romania');
INSERT into Orszagok VALUES (2, 'Magyarorszag');
INSERT into Orszagok VALUES (3, 'Ausztria');
INSERT into Orszagok VALUES (4, 'Olaszorszag');
INSERT into Orszagok VALUES (5, 'Franciaorszag');
INSERT into Orszagok VALUES (6, 'Csehorszag');

CREATE TABLE Udulohely(
	UdhID number(4) PRIMARY KEY,
	Nev VARCHAR(30),
	OrszagID number(4) REFERENCES Orszagok (OrszagID)
);

INSERT into Udulohely VALUES (1, 'Szovata',1);
INSERT into Udulohely VALUES (2, 'Tusnad',1);
INSERT into Udulohely VALUES (3, 'Gyula',2);
INSERT into Udulohely VALUES (4, 'H-Szoboszlo',2);
INSERT into Udulohely VALUES (5, 'Rimini',4);
INSERT into Udulohely VALUES (6, 'Catania',4);


CREATE TABLE Turistak(
	TurID number(4) PRIMARY KEY, 
	TNev VARCHAR(30),
	TTelefon VARCHAR(15),
	EmailCim VARCHAR(30)
);

INSERT into Turistak VALUES(1, 'Antal Attila', NULL, 'attila@email.com');
INSERT into Turistak VALUES(2, 'Kelemen Melinda', NULL, 'melinda@email.com');
INSERT into Turistak VALUES(3, 'Gergely Emese', NULL, 'emese@email.com');
INSERT into Turistak VALUES(4, 'Kovacs Annamaria', NULL, 'anna@email.com');
INSERT into Turistak VALUES(5, 'Horvath Levente', NULL, 'levente@email.com');
INSERT into Turistak VALUES(6, 'Bereczki Gergely', NULL, 'gergely@email.com');
INSERT into Turistak VALUES(7, 'Incze Istvan', NULL, 'istvan@email.com');
insert into Turistak values(8, 'Nagy Ildiko',NULL,'ildiko@email.com');

CREATE TABLE Szallodak(
	SzallID number(4) PRIMARY KEY,
	SzallNev VARCHAR(30),
	SzallCim VARCHAR (30),
	UdhID number(4) REFERENCES Udulohely (UdhID),
	Csillag number(4), 
	SzobakSzama number(4),
	NapiArSzoba number(4)
);

INSERT into Szallodak VALUES (1, 'Szalloda1', null, 3, 2, 5, 25);
INSERT into Szallodak VALUES (2, 'Szalloda2', null, 4, 2, 10, 20);
INSERT into Szallodak VALUES (3, 'Szalloda3', null, 4, 4, 5, 31);
INSERT into Szallodak VALUES (4, 'Szalloda4', null, 4, 3, 10, 20);
INSERT into Szallodak VALUES (5, 'Szalloda5', null, 3, 3, 10, 12);
INSERT into Szallodak VALUES (6, 'Szalloda6', null, 1, 5, 12, 10);
INSERT into Szallodak VALUES (7, 'Szalloda7', null, 4, 3, 5, 12);
INSERT into Szallodak VALUES (8, 'Szalloda8', null, 2, 5, 5, 20);
INSERT into Szallodak VALUES (9, 'Szalloda9', null, 4, 3, 100, 12);
INSERT into Szallodak VALUES (10, 'Szalloda10', null, 2, 2, 120, 30);
INSERT into Szallodak VALUES (11, 'Szalloda11', null, 1, 3, 60, 25);
INSERT into Szallodak VALUES (12, 'Szalloda12', null, 2, 2, 80, 35);
INSERT into Szallodak VALUES (13, 'Szalloda13', null, 3, 3, 20, 10);
INSERT into Szallodak VALUES (14, 'Szalloda14', null, 4, 3, 16, 50);
INSERT into Szallodak VALUES (15, 'Szalloda15', null, 5, 3, 20, 50);
INSERT into Szallodak VALUES (16, 'Szalloda16', null, 6, 2, 40, 15);

CREATE TABLE Foglalasok(
	BerlesID number(4) PRIMARY KEY,
	SzallID number(4) REFERENCES Szallodak (SzallID),
	TurID number(4) REFERENCES Turistak (TurID),
	SzobaSzam number(4),
	KezdoDatum DATE,
	NapokSzama number(4),
	Ertek number(4) 
);

select sysdate from dual;

INSERT into Foglalasok VALUES (1, 3, 1, 1, '20-jun-11', 5, 150);
INSERT into Foglalasok VALUES (2, 3, 2, 1, '30-jun-11', 2, 50);
INSERT into Foglalasok VALUES (3,3, 5, 1, '12-jul-11', 3, 60);
INSERT into Foglalasok VALUES (4, 1, 7, 1, '20-jun-11', 5, 150);
INSERT into Foglalasok VALUES (5, 3, 3, 1, '20-jul-11', 2, 50);
INSERT into Foglalasok VALUES (6,3, 4, 1, '27-jul-11', 3, 60);
INSERT into Foglalasok VALUES (7,1, 1, 1, '20-jul-11', 5, 150);
INSERT into Foglalasok VALUES (8,3, 5, 1, '5-aug-11', 2, 250);
INSERT into Foglalasok VALUES (9,1, 2, 1, '25-jun-11', 13, 60);
INSERT into Foglalasok VALUES (10,5, 8, 1, '1-aug-11', 14, 168);
INSERT into Foglalasok VALUES (11,2, 4, 1, '20-jun-11', 6, 120);
INSERT into Foglalasok VALUES (12,14, 3, 1, '2-jul-11', 5, 250);

INSERT into Foglalasok VALUES (13,3, 1, 2, '20-jun-11', 5, 150);
INSERT into Foglalasok VALUES (14,3, 2, 2, '30-jun-11', 2, 50);
INSERT into Foglalasok VALUES (15,3, 5, 2, '12-jul-11', 3, 60);
INSERT into Foglalasok VALUES (16,1, 7, 2, '20-jun-11', 5, 150);
INSERT into Foglalasok VALUES (17,3, 3, 2, '20-jul-11', 2, 50);
INSERT into Foglalasok VALUES (18,3, 4, 2, '27-jul-11', 3, 60);
INSERT into Foglalasok VALUES (19,1, 1, 2, '20-jul-11', 5, 150);
INSERT into Foglalasok VALUES (20,3, 5, 2, '5-aug-11', 2, 250);
INSERT into Foglalasok VALUES (21,1, 2, 2, '25-jun-11', 13, 60);
INSERT into Foglalasok VALUES (22,6, 3, 2, '26-jul-11', 10, 100);
INSERT into Foglalasok VALUES (23,5, 4, 2, '1-aug-11', 10, 120);
INSERT into Foglalasok VALUES (24,2, 4, 2, '20-jun-11', 6, 120);
INSERT into Foglalasok VALUES (25,14, 6, 2, '2-jul-11', 5, 250);

INSERT into Foglalasok VALUES (26,3, 1, 3, '20-jun-11', 5, 150);
INSERT into Foglalasok VALUES (27,3, 2, 3, '30-jun-11', 2, 50);
INSERT into Foglalasok VALUES (28,3, 5, 3, '12-jul-11', 3, 60);
INSERT into Foglalasok VALUES (29,1, 7, 3, '20-jun-11', 5, 150);
INSERT into Foglalasok VALUES (30,3, 3, 3, '20-jul-11', 2, 50);
INSERT into Foglalasok VALUES (31,3, 4, 3, '27-jul-11', 3, 60);
INSERT into Foglalasok VALUES (32,1, 1, 3, '20-jul-11', 5, 150);
INSERT into Foglalasok VALUES (33,3, 5, 3, '5-aug-11', 2, 250);
INSERT into Foglalasok VALUES (34,1, 2, 3, '25-jun-11', 13, 60);
INSERT into Foglalasok VALUES (35,6, 7, 3, '25-jun-11', 13, 60);
INSERT into Foglalasok VALUES (36,5, 5, 3, '1-aug-11', 10, 120);
INSERT into Foglalasok VALUES (37,14, 3, 3, '2-jul-11', 5, 250);

INSERT into Foglalasok VALUES (38,3, 1, 4, '20-jun-11', 5, 150);
INSERT into Foglalasok VALUES (39,3, 2, 4, '30-jun-11', 2, 50);
INSERT into Foglalasok VALUES (40,3, 5, 4, '12-jul-11', 3, 60);
INSERT into Foglalasok VALUES (41,1, 7, 4, '20-jun-11', 5, 150);
INSERT into Foglalasok VALUES (42,3, 3, 4, '20-jul-11', 2, 50);
INSERT into Foglalasok VALUES (43,3, 4, 4, '27-jul-11', 3, 60);
INSERT into Foglalasok VALUES (44,1, 1, 4, '20-jul-11', 5, 150);
INSERT into Foglalasok VALUES (45,3, 5, 4, '5-aug-11', 2, 250);
INSERT into Foglalasok VALUES (46,1, 2, 4, '25-jun-11', 13, 60);
INSERT into Foglalasok VALUES (47,5, 7, 4, '1-aug-11', 10, 120);
INSERT into Foglalasok VALUES (48,14, 8, 4, '2-jul-11', 5, 250);

INSERT into Foglalasok VALUES (49,3, 1, 5, '20-jun-11', 5, 150);
INSERT into Foglalasok VALUES (50,3, 2, 5, '30-jun-11', 2, 50);
INSERT into Foglalasok VALUES (51,3, 5, 5, '12-jul-11', 3, 60);
INSERT into Foglalasok VALUES (52,1, 7, 5, '20-jun-11', 5, 150);
INSERT into Foglalasok VALUES (53,3, 3, 5, '20-jul-11', 2, 50);
INSERT into Foglalasok VALUES (54,3, 4, 5, '27-jul-11', 3, 60);
INSERT into Foglalasok VALUES (55,1, 1, 5, '20-jul-11', 5, 150);
INSERT into Foglalasok VALUES (56,3, 5, 5, '5-aug-11', 2, 250);
INSERT into Foglalasok VALUES (57,1, 2, 5, '25-jun-11', 13, 60);
INSERT into Foglalasok VALUES (58,5, 3, 5, '1-aug-11', 10, 120);

INSERT into Foglalasok VALUES (59,6, 6, 6, '20-jul-11', 5, 150);
INSERT into Foglalasok VALUES (60,5, 2, 6, '1-aug-11', 10, 120);
INSERT into Foglalasok VALUES (61,5, 3, 7, '1-aug-11', 10, 120);
INSERT into Foglalasok VALUES (62,5, 4, 8, '1-aug-11', 10, 120);
INSERT into Foglalasok VALUES (63,5, 5, 9, '1-aug-11', 10, 120);
INSERT into Foglalasok VALUES (64,5, 6, 10, '1-aug-11', 10, 120);
INSERT into Foglalasok VALUES (65,14, 3, 16, '2-jul-11', 5, 250);

--Tesztadatok
/*
--parameterek: pSzallodaID, pTuristaN�v, pTTel, pTemail, pDatumKezdo, pDatumVegso
--van hely az adott szallodaban:
--a kovetkezo szallodak eseten barmilyen periodusban: 7,8,9,10,11,12,14,15,16
--mas pelda:
14,'Szilagyi Jeno', '0732067895','jeno@yahoo.com', '2-jul-11','2011-07-07'
--visszateritesi ertek: 0
--SzobaSzam-5,...,15
--Ertek-250 (5-os szoba eseten)

--nincs hely az adott szallodaban:
--van hely mas szallodaban:
5,'Szilagyi Jeno', '0732067895','jeno@yahoo.com', '1-aug-11','2011-08-11' 
--@outSzalloda erteke-pl. 2,13
--visszateritesi ertek: -1

3,'Szilagyi Jeno', '0732067895','jeno@yahoo.com', '20-jun-11','25-jun-11' 
--@outSzalloda erteke - pl. 2,4,7,9,14
--visszateritesi ertek: -1

--nincs hely mas szallodaban sem:
1,'Szilagyi Jeno', '0732067895','jeno@yahoo.com', '20-jun-11','25-jun-11'
--visszateritesi ertek: -2

*/

// insertTurista, insertFoglalas, dateIntersect, keresSzoba, keresMasikHotel, main

create or replace function insertTurista (
    pNev IN VARCHAR2,
    pTelefon IN VARCHAR2,
    pEmail IN VARCHAR2) return number is
begin
    insert into Turistak (TurID, TNev, TTelefon, EMailCim)
        select NVL(MAX(TurID), 0) + 1, pNev, pTelefon, pEmail
        from Turistak;
        
    return  TurID;
end;
/

begin
    insertTurista('testTurista', 123456789, 'test@gmail.com');
end;
/

select * from Turistak;

// 2.
create or replace procedure insertFoglalas(
	pszallid    NUMBER,
    pturid      NUMBER,
    pszobaszam  NUMBER,
    pkezdodatum DATE,
    pnapokszama NUMBER) is
    
    v_ertek    NUMBER;
    v_berlesid NUMBER;
begin
    SELECT
        napiarszoba * pnapokszama
    INTO v_ertek
    FROM
        szallodak
    WHERE
        szallid = pszallid;
    
     SELECT
        COUNT(*) + 1
    INTO v_berlesid
    FROM
        foglalasok;

    INSERT INTO foglalasok VALUES (
        v_berlesid,
        pszallid,
        pturid,
        pszobaszam,
        pkezdodatum,
        pnapokszama,
        v_ertek
    );
end;
/

// 3.
CREATE OR REPLACE FUNCTION dateIntersect(start1 DATE, end1 DATE, start2 DATE, end2 DATE) return VARCHAR2 is
BEGIN
    IF (start1 <= end2) AND 
       (start2 <= end1) THEN return 'intersect'; ELSE return 'not intersect';
    END IF;
END;
/

// 4.
create or replace function keresSzoba(p_szall_id number, p_kezdodatum date, p_vegsodatum date) return number is
    v_szoba_id NUMBER;
begin
select szobaSzam into v_szoba_id
    from (
        select level as szobaSzam
        from dual
        connect by level <= (select szobakSzama from Szallodak where szallid = p_szall_id)
    )
    minus
    (
        select szobaszam
        from Foglalasok f
        where f.szallid = p_szall_id
        and dateIntersect(p_kezdodatum, p_vegsodatum, f.kezdodatum, f.kezdodatum + f.napokszama) = 1
    )
    fetch first row only;
    return v_szoba_id;
end;
/

// 5.
create or replace procedure keresMasikHotel(
    p_regi_szalloda_id IN NUMBER,
    v_udulo_hely IN NUMBER,
    v_csillag IN NUMBER,
    p_kezdodatum IN DATE,
    p_vegsodatum IN DATE,
    outSzabadSzalloda OUT NUMBER
) is
    v_szalloda_id Szallodak.SzallID%TYPE;
begin
    select szallid into v_szalloda_id
    from szallodak
    where szallid != p_regi_szalloda_id
    and udhid = v_udolo_hely and csillag <= v_csillag
    and keres_szabad_szoba(szallid, p_kezdodatum, p_vegsodatum) >= 0
    fetch first row only;
    
    outSzabadSzalloda := v_szalloda_id;
end;
/

// 6.
create or replace function main return number is
    v_result number;
    v_szabad_szalloda number;
begin
    -- Insert turista
        v_result := insertTurista('TestTurista2', '123456789', 'test@gmail.com');
        
        if v_result > 0 then
            -- turista inserted successfully, proceed with booking
            insertFoglalas(p_szall_id, p_tur_id, p_szoba_szam, p_kezdodatum, p_napokszama);
        
        -- check if the booking was successful
            if v_result = 0 then
                -- booking successful
                DBMS_OUTPUT.PUT_LINE('Booking successful!');
            else
                -- booking failed
                DBMS_OUTPUT.PUT_LINE('Booking failed!');
            end if;
        else
            -- turista insertion failed
            DBMS_OUTPUT.PUT_LINE('Failed to insert turista!');
        end if;
        
        -- example usage of keresMasikHotel procedure
        keresMasikHotel(p_regi_szalloda_id, v_udulo_hely, v_csillag, p_kezdodatum, p_vegsodatum, v_szabad_szalloda);
        
        -- check if another hotel was found
        if v_szabad_szalloda is not null then
            DBMS_OUTPUT.PUT_LINE('Found another hotel with available room!');
        ELSE
            DBMS_OUTPUT.PUT_LINE('No other suitable hotel found!');
        END IF;
        
        return 0;
end;
/
