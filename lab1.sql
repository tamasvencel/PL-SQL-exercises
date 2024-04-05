CREATE TABLE error_log(
error_code INTEGER,
error_message VARCHAR2 (4000),
backtrace CLOB,
callstack CLOB,
created_on DATE,
created_by VARCHAR2 (30)
);

CREATE OR REPLACE PROCEDURE record_error
IS
PRAGMA AUTONOMOUS_TRANSACTION;
l_code PLS_INTEGER := SQLCODE;
l_mesg VARCHAR2(32767) := SQLERRM;
BEGIN
INSERT INTO error_log (error_code,
error_message,
backtrace,
callstack,
created_on,
created_by)
VALUES (l_code,
l_mesg,
sys.DBMS_UTILITY.format_error_backtrace,
sys.DBMS_UTILITY.format_call_stack,
SYSDATE,
USER);
COMMIT;
END;

/
SET SERVEROUTPUT ON
/

// 1.
DECLARE v_salary NUMBER;
BEGIN
    SELECT salary INTO v_salary
    FROM c##hr.employees
    where last_name = 'Davies';
    
    DBMS_OUTPUT.PUT_LINE('Davies salary: ' || v_salary);
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('No employee with the given name.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error');
        record_error();
END;
/

// 2.
DECLARE 
    v_salary NUMBER; 
    v_hire_date DATE;
BEGIN
SELECT salary, hire_date INTO v_salary, v_hire_date
    FROM c##hr.employees
    WHERE last_name = 'Davies';
    
    -- print salary
    DBMS_OUTPUT.PUT_LINE('Davies salary: ' || v_salary);

    -- print in format 'YYYY.MM.DD'
    DBMS_OUTPUT.PUT_LINE('Davies hire date: ' || TO_CHAR(v_hire_date, 'YYYY.MM.DD'));

    -- print in format 'YYYY-MONTH-DD'
    DBMS_OUTPUT.PUT_LINE('Davies hire date: ' || TO_CHAR(v_hire_date, 'YYYY-MONTH-DD'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employee with the given name.');
    WHEN OTHERS THEN
        record_error();
END;
/

///
CREATE TABLE rally (
nev VARCHAR2(25) Primary Key,
nemzetiseg VARCHAR2(20),
feladatkor VARCHAR2(9),
minosites NUMBER(3),
partner VARCHAR2(25)
);

INSERT INTO rally VALUES ('Gyula' ,'HUN' ,'PILOT' ,50, '---');
INSERT INTO rally VALUES ('White' ,'GBR' ,'PILOT' ,72, '---');
INSERT INTO rally VALUES ('van Glut' ,'NED' ,'PILOT' ,60, '---');
INSERT INTO rally VALUES ('S�ndor' ,'HUN' ,'PILOT' ,67, '---');
INSERT INTO rally VALUES ('Piere' ,'FRA' ,'PILOT' ,57, '---');
INSERT INTO rally VALUES ('Mikl�s' ,'HUN' ,'PILOT' ,80, '---');
INSERT INTO rally VALUES ('Wraclaw' ,'POL' ,'NAVIGATOR',55, '---');
INSERT INTO rally VALUES ('Nitzky' ,'POL' ,'NAVIGATOR',76, '---');
INSERT INTO rally VALUES ('ONeil' ,'GBR' ,'NAVIGATOR',67, '---');
INSERT INTO rally VALUES ('Kert�sz' ,'HUN' ,'NAVIGATOR',55, '---');

// 1.
CREATE OR REPLACE PROCEDURE addContestant(v_name IN VARCHAR2,
    v_nationality IN VARCHAR2, v_job VARCHAR2, v_qualification IN NUMBER,
    v_partner IN VARCHAR2) IS
BEGIN
    INSERT INTO rally (nev, nemzetiseg, feladatkor, minosites, partner) VALUES (v_name, v_nationality, v_job, v_qualification, v_partner);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: The contestant already exists (' || v_name || ').');
    WHEN OTHERS THEN
        record_error();
END;
/
BEGIN
    addContestant('Saul', 'USA', 'PILOT', 44, 'REDBULL');
END;
/
select * from rally;

// 2.
CREATE OR REPLACE PROCEDURE updateContestant(v_name IN VARCHAR2,
    v_nationality IN VARCHAR2, v_job VARCHAR2, v_qualification IN NUMBER,
    v_partner IN VARCHAR2) IS
    
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM rally
    WHERE nev = v_name;

    IF v_count = 0 THEN
        -- if contestant does not exist
        DBMS_OUTPUT.PUT_LINE('Error: The contestant (' || v_name || ') does not exist.');
    ELSE
        -- Update contestant data
        UPDATE rally
        SET nemzetiseg = v_nationality,
            feladatkor = v_job,
            minosites = v_qualification,
            partner = v_partner
        WHERE nev = v_name;
        
        DBMS_OUTPUT.PUT_LINE('Successfully updated: ' || v_name);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        record_error();
END;
/
BEGIN
    updateContestant('Gyula', 'HUN', 'NAVIGATOR', 49, '---');
END;
/
select * from rally;

// 3.
CREATE OR REPLACE PROCEDURE deleteContestant(v_name IN VARCHAR2) IS
    
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM rally
    WHERE nev = v_name;

    IF v_count = 0 THEN
        -- if contestant does not exist
        DBMS_OUTPUT.PUT_LINE('Error: The contestant (' || v_name || ') does not exist.');
    ELSE
        -- Delete contestant
        DELETE FROM rally
        WHERE nev = v_name;
        
        DBMS_OUTPUT.PUT_LINE('Successfully deleted: ' || v_name);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        record_error();
END;
/
BEGIN
    deleteContestant('Kert�sz');
END;
/
call deleteContestant('nonExistingName');

select * from rally;

// 4.
CREATE OR REPLACE PROCEDURE findContestantNationalityAndJob(v_name IN VARCHAR2) IS
    v_count NUMBER;
    v_nationality VARCHAR2(20);
    v_job VARCHAR2(9);
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM rally
    WHERE nev = v_name;

    IF v_count = 0 THEN
        -- if contestant does not exist
        DBMS_OUTPUT.PUT_LINE('Error: The contestant (' || v_name || ') does not exist.');
    ELSE
        SELECT nemzetiseg, feladatkor INTO v_nationality, v_job
        FROM rally
        where nev = v_name;
        
        DBMS_OUTPUT.PUT_LINE('Nationality: ' || v_nationality || chr(10) || 'Job:' || v_job);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        record_error();
END;
/
BEGIN
    findContestantNationalityAndJob('White');
END;
/

// 5.
CREATE OR REPLACE FUNCTION findPartner(v_name IN VARCHAR2) RETURN VARCHAR2 IS
    v_count NUMBER;
    v_partner VARCHAR2(25);
BEGIN
    v_count := 0;

    SELECT COUNT(*)
    INTO v_count
    FROM rally
    WHERE nev = v_name;

    IF v_count = 0 THEN
        -- if contestant does not exist
        INSERT INTO rally (nev) VALUES (v_name);
        DBMS_OUTPUT.PUT_LINE('Contestant (' || v_name || ') not yet exists, insertion was executed.');
    ELSE
        SELECT partner INTO v_partner
        FROM rally
        WHERE nev = v_name;
    END IF;
            RETURN v_partner;
EXCEPTION
    WHEN OTHERS THEN
        record_error();
        RETURN v_partner;
END;
/
DECLARE v_partner VARCHAR2(25);
BEGIN
    v_partner := findPartner('teszt');
    DBMS_OUTPUT.PUT_LINE('Partner: ' || v_partner);
END;
/
SELECT * FROM rally;

// 6.
CREATE OR REPLACE PROCEDURE updatePilotToPilota IS
    numOfModifiedRows NUMBER;
BEGIN
    UPDATE rally
    SET feladatkor = 'PILOTA'
    WHERE feladatkor = 'PILOT';

    numOfModifiedRows := SQL%ROWCOUNT;
    
    DBMS_OUTPUT.PUT_LINE('Number of modified rows: ' || numOfModifiedRows);
EXCEPTION
    WHEN OTHERS THEN
        record_error();
END;
/
BEGIN
    updatePilotToPilota;
END;
/
SELECT * FROM rally;

// 7.
DECLARE 
    CURSOR c1 IS
        SELECT last_name, salary 
        FROM c##hr.employees
        WHERE department_id = 10;
BEGIN
    FOR person IN c1
    LOOP
        DBMS_OUTPUT.PUT_LINE ('Name = ' || person.last_name || ', salary = ' ||
person.salary);
    END LOOP;
END;
/

// 10.
CREATE TABLE temp (
nev VARCHAR2(25) Primary Key,
nemzetiseg VARCHAR2(20),
feladatkor VARCHAR2(9),
minosites NUMBER(3),
partner VARCHAR2(25)
);

CREATE OR REPLACE PROCEDURE top5Pilots IS
    numOfTopPilots NUMBER;
BEGIN
    SELECT COUNT(*) INTO numOfTopPilots 
    FROM rally
    WHERE feladatkor = 'PILOTA';
    
    IF numOfTopPilots >= 5  THEN
        DELETE FROM temp;
        
        INSERT INTO temp (nev, nemzetiseg, feladatkor, minosites, partner)
        SELECT *
        FROM rally
        WHERE feladatkor = 'PILOTA'
        ORDER BY minosites DESC
        FETCH FIRST 5 ROWS ONLY;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('There are less than 5 pilots in the database.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        record_error();
END;
/
BEGIN
    top5Pilots;
END;
/
SELECT * FROM temp;
