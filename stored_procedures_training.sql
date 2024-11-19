--------------------------------------------------------------------------------
--
-- Sql Command File For Creating And Populating The Property-
-- System Database.-  For use with UNIT 1 - SQL Guide version 1
--
-- Written By: Sue Stirk                                                 -
-- Jan 2002
-- Updated By: R L Warrender
-- July 2015 
-- Amended By : D Nelson
-- September 2023                                                              -
-------------------------------------------------------------------------------
DROP TABLE lease CASCADE CONSTRAINTS;

DROP TABLE viewing CASCADE CONSTRAINTS;

DROP TABLE tenant CASCADE CONSTRAINTS;

DROP TABLE inspection CASCADE CONSTRAINTS;

DROP TABLE prop_type CASCADE CONSTRAINTS;

DROP TABLE prop_for_rent CASCADE CONSTRAINTS;

DROP TABLE owner CASCADE CONSTRAINTS;

DROP TABLE staff CASCADE CONSTRAINTS;

DROP TABLE branch CASCADE CONSTRAINTS;

CREATE TABLE branch
(branch_no NUMBER(3) NOT NULL PRIMARY KEY,
br_street VARCHAR2(25) NOT NULL,
br_area VARCHAR2(20),
br_town VARCHAR2(20) NOT NULL,
br_pcode VARCHAR2(8) NOT NULL,
br_telno VARCHAR2(12));

CREATE TABLE staff
(staff_no NUMBER(5) PRIMARY KEY,
branch_no NUMBER(3) REFERENCES branch(branch_no),
staff_surname VARCHAR2(25) NOT NULL,
staff_forenames VARCHAR2(25) NOT NULL,
staff_street VARCHAR2(25) NOT NULL,
staff_area VARCHAR2(20),
staff_town VARCHAR2(20) NOT NULL,
staff_pcode VARCHAR2(8) NOT NULL,
staff_telno VARCHAR2(12),
staff_gender CHAR(1),
staff_salary NUMBER(8,2));

CREATE TABLE owner
(owner_no NUMBER(5) NOT NULL PRIMARY KEY,
ow_surname VARCHAR2(25) NOT NULL,
ow_forenames VARCHAR2(25) NOT NULL,
ow_street VARCHAR2(25) NOT NULL,
ow_area VARCHAR2(20),
ow_town VARCHAR2(20) NOT NULL,
ow_pcode VARCHAR2(8) NOT NULL,
ow_fee NUMBER(6,2));

CREATE TABLE prop_type
(prop_type CHAR(1) NOT NULL PRIMARY KEY,
type_desc VARCHAR2(15) NOT NULL);

CREATE TABLE prop_for_rent
(property_no NUMBER(5) NOT NULL PRIMARY KEY,
prop_street VARCHAR2(25) NOT NULL,
prop_area VARCHAR2(20),
prop_town VARCHAR2(20) NOT NULL,
prop_pcode VARCHAR2(8) NOT NULL,
prop_type CHAR(1) NOT NULL REFERENCES prop_type (prop_type),
prop_rooms NUMBER(2) NOT NULL,
prop_rent_pm NUMBER(7,2) NOT NULL,
prop_council_tax NUMBER(6,2),
owner_no NUMBER(5) NOT NULL REFERENCES owner(owner_no),
staff_no NUMBER(5) REFERENCES staff(staff_no), 
branch_no NUMBER(3) NOT NULL REFERENCES branch(branch_no),
available VARCHAR2(1),
comments VARCHAR2(150));

CREATE TABLE tenant
(tenant_no NUMBER(5) NOT NULL PRIMARY KEY,
t_surname VARCHAR2(25) NOT NULL,
t_forenames VARCHAR2(25) NOT NULL,
t_street VARCHAR2(25) NOT NULL,
t_area VARCHAR2(20),
t_town VARCHAR2(20) NOT NULL,
t_postcode VARCHAR2(8) NOT NULL,
t_telno VARCHAR2(12),
t_pref_type CHAR(1),
t_max_rent NUMBER(6,2));

CREATE TABLE lease
(lease_no NUMBER(5) NOT NULL PRIMARY KEY,
property_no NUMBER(5) NOT NULL REFERENCES prop_for_rent(property_no),
tenant_no NUMBER(5) NOT NULL REFERENCES tenant(tenant_no),
rent_pm NUMBER(6,2),
payment_method CHAR(1) NOT NULL,
deposit_amount NUMBER(6,2),
deposit_paid CHAR(1),
stdate DATE NOT NULL,
enddate DATE);

CREATE TABLE viewing
(property_no NUMBER(5) NOT NULL REFERENCES prop_for_rent(property_no),
tenant_no NUMBER(5) NOT NULL REFERENCES tenant(tenant_no),
date_view DATE,
comments VARCHAR2(50),
PRIMARY KEY(property_no,tenant_no));

CREATE TABLE inspection
(property_no NUMBER(5) NOT NULL REFERENCES prop_for_rent(property_no),
staff_no NUMBER(5) NOT NULL REFERENCES staff(staff_no),
inspect_date DATE NOT NULL,
comments VARCHAR2(50),
PRIMARY KEY(property_no,staff_no,inspect_date));

INSERT INTO branch
VALUES (101,'24 Deer Street','South Hylton','Sunderland','SR5 6PF', '0191 4517892');

INSERT INTO branch
VALUES (102,'15 Amberley Street',NULL,'Newcastle','SR2 0EZ', '0191 5153127');

INSERT INTO branch
VALUES (103,'38 Front Street',NULL,'Whitburn','SR2 3ZY', '0191 5483527');

INSERT INTO branch
VALUES (104,'15 Silver Street',NULL,'Durham','DH4 5TH', '0191 5372522');



INSERT INTO staff
VALUES(201,101, 'Stewart', 'John', 'Elm Bank Road', 'Pennywell', 'Sunderland', 'SR7 6FE', '0191 7689567', 'M',12350);

INSERT INTO staff
VALUES(202,101, 'Jones', 'Janice', '63 Wells Street', 'Grindon', 'Sunderland', 'SR4 7RT', '0191 7659447', 'F', 25000);

INSERT INTO staff
VALUES(203,102, 'Murphy', 'Tina', '12 Fergie Crescent', NULL, 'Sunderland', 'SR2 3BY', '0191 7554777', 'F', 18000);

INSERT INTO staff
VALUES(204,102, 'Farrell', 'George', '3 Park Place', 'Pennywell', 'Sunderland', 'SR1 5BC', '0191 6454678', 'M', 14500);

INSERT INTO staff
VALUES(205,103, 'Kilburn', 'Michael', '2 Ryhope Road', 'Sulgrave', 'Sunderland', 'SR8 2ED', '0191 5675858', 'M', 35000);

INSERT INTO staff
VALUES(206,104, 'Shaw', 'Sally', '8 Dale Road', 'Benton', 'Sunderland', 'SR2 5AC', '0191 1254698', 'F', 22450);

INSERT INTO staff
VALUES(207,104, 'Sheldon', 'Stephanie', '125 Le Road', 'Coxhoe', 'Durham', 'DH5 5BA', '0191 2356697', 'F', 12300);

INSERT INTO owner
VALUES (1331,'Robinson','Simon', '17 Railway Road', NULL,'Sunderland','SR1 7JL', 500.00);

INSERT INTO owner
VALUES (1332,'Johnson','Matthew', '8 Rowan Drive', 'Grangetown','Sunderland','SR5 3JT',300.00);

INSERT INTO owner
VALUES (1333,'Thompson','Maggie', '87 Rowan Drive', 'Grangetown','Sunderland','SR5 3GT',250.00);

INSERT INTO owner 
VALUES (1334,'Royce','Keith', '21 Queens Road', 'Benton','Newcastle','SR2 6HE',300.00);

INSERT INTO owner
VALUES (1335,'Morgan','James', '15 Shakespeare Street',NULL,'Sunderland','SR1 2ST',300.00);

INSERT INTO owner 
VALUES (1336,'Maxwell','Jane', '23 Regent Terrace','Grindon','Sunderland','SR3 7GR',200.00);

INSERT INTO owner  
VALUES (1337,'Cliff','John', '12 Norman Road','Sulgrave','Sunderland','SR7 6FD', 750.00);

INSERT INTO owner 
VALUES (1338,'Ashwell','John', 'Elm Bank Road','Pennywell','Sunderland','SR7 6FE',525.00);

INSERT INTO owner
VALUES (1339,'Platts','Ian','16 Holyhead Road',NULL,'Sunderland','SR3 5HN',245.00);

INSERT INTO owner 
VALUES (1340, 'Calvert','Robert', '22 Sherwood Avenue',NULL, 'Newcastle', 'NE23 6HT',450.00);

INSERT INTO owner
VALUES (1341,'Best','Marilyn','35 Jerome Street',NULL, 'Sunderland', 'SR4 6GH',300.00);

INSERT INTO owner
VALUES (1342,'Green','Harold','8 London Road','Ryhope', 'Sunderland', 'SR3HY',434.00);


INSERT INTO prop_type
VALUES('B','Bungalow');

INSERT INTO prop_type
VALUES('C','Cottage');

INSERT INTO prop_type
VALUES('D','Detatched');

INSERT INTO prop_type
VALUES('E','End-Terrace');

INSERT INTO prop_type
VALUES('F','Flat');

INSERT INTO prop_type
VALUES('M','Mid-Terrace');

INSERT INTO prop_type
VALUES('S','Semi-Detatched');

INSERT INTO prop_for_rent
VALUES(1001,'The Cedars','East Mickley','Newcastle','NE76 7YU', 'F',5,650,250.25,1342,
201,101, 'Y', 'Ground Floor Flat with shared main entrance.  Newly decorate. Fitted kitchen.');

INSERT INTO prop_for_rent
VALUES(1002, 'Belmont Road','Gosforth','Newcastle','NE12 7BY', 'B',4,550,350.70,1333,
201,101, 'N','Deceptively spacious bungalow set in 3rd acre with extensive country views');

INSERT INTO prop_for_rent
VALUES(1003, 'Bromsmere Court', 'Grangetown','Sunderland','SR2 5BK', 'M',3,450,300,1331,
203,103, 'Y','1950s mid terrace. 25 ft lounge. Fully modernised.');

INSERT INTO prop_for_rent
VALUES(1004, 'Lassiter Drive',NULL,'Sunderland','SR6 12K', 'F',2,450,200.50,1332,
204,102, 'Y', 'Centrally situated.  Shared Entrance');

INSERT INTO prop_for_rent
VALUES(1005, 'Stretton Avenue', 'Gosforth','Newcastle','NE8 3LK', 'S',3,450,200,1334,
204,102, 'Y', 'Modern semi with well equipped kitchen. Garage and Garden');


INSERT INTO prop_for_rent
VALUES(1006, 'Sharp Rise', NULL,'Durham','DH5 9LT', 'D',4,550.00,325.67,1335,
206,104, 'N', 'Large family house with double glazing and gas fired central heating');

INSERT INTO prop_for_rent
VALUES(1007, 'The Oaks' , 'Gosforth','Tyne and Wear','NE8 3HS', 'F',1,300,175,1335,
205,103, 'Y','One bedroom flat.  Suit single person');

INSERT INTO prop_for_rent
VALUES(1008, 'Chatham Road' , NULL,'Durham','DH6 3HT', 'D',4,600,480,1336,
206,104, 'Y', 'Well maintained family house in popular area.  Mature gardens and double garage');

INSERT INTO prop_for_rent
VALUES(1009, 'Prudhoe Road' , 'Sulgrove','Sunderland','SR5 4TB', 'E',3,400,246,1337,
206,101, 'Y', 'Large post-war terrace. Well equipped kitchen');

INSERT INTO prop_for_rent
VALUES(1010, 'Charles Drive' ,NULL,'Houghton-Le-Spring','DH7 6LB', 'S',4,650,367,1338,
204,104, 'Y', 'Fully equipped property.  Close to schools and local shops');

INSERT INTO prop_for_rent
VALUES(1011, 'Chatham Road' , NULL,'Durham','DH6 3HV', 'B',2,600,380,1336,
206,101, 'Y','Small family bungalow in popular area');

INSERT INTO prop_for_rent
VALUES(1012, 'Stretton Avenue', 'Gosforth','Newcastle','NE8 3LB', 'S',3,450,285,1334,
204,102, 'Y', 'Modern semi with Garage and Garden');

INSERT INTO tenant
VALUES(3001, 'Riddell','James', ' 95 Torver Street',NULL,'Sunderland','SR6 8UP', NULL, 'H',500);

INSERT INTO tenant
VALUES(3002, 'Matthews','Peter', '67 Stretton Avenue', 'Gosforth', 'Newcastle','NE6 7RT', '0191 8674252', 'H',650);

INSERT INTO tenant
VALUES(3003, 'Jackson','James', '6 Strackon Road', NULL,'Durham', 'DH6 6ET', '0191 6876752', 'F',400);

INSERT INTO tenant
VALUES(3004, 'Stones','Jasmine', '61 Jackson Drive', 'Ryhope','Sunderland', 'SR6 7TP', '0191 4876952', 'H',500);

INSERT INTO tenant
VALUES(3005, 'Karping','Annabel', '1 Quay Park', NULL,'Newcastle', 'NE6 8OP', '0191 4974932', 'F',450);

INSERT INTO tenant
VALUES(3006, 'Stones','Julie', '8 Bristol Road', NULL,'Hartlepool', 'HL6 2LM', '0145 7776757', 'H',500);

INSERT INTO tenant
VALUES(3007, 'Barrymore','Hugh', '25 Arlington Crescent', 'Ryhope','Sunderland', 'SR3 7TY', '0191 3886352', 'H',700);

INSERT INTO tenant
VALUES(3008, 'Carling','Barry', '16 Rugby Drive', NULL,'Middlesborough', 'MB6 2PL', '0189 8886552', 'H',550);

INSERT INTO lease
VALUES(6001,1001,3003,600, 'C',100, 'Y', '12-JUN-2020','05-JUN-2022');

INSERT INTO lease
VALUES(6002,1002,3002,600, 'X',100, 'Y', '12-JUN-2023', '11-JUN-2025');

INSERT INTO lease
VALUES(6003,1002,3003,600, 'C',200, 'Y', '12-JUN-2021', '11-JUN-2023');

INSERT INTO lease
VALUES(6004,1003,3004,500, 'S',50, 'Y', '12-MAR-2019', '13-MAR-2022');

INSERT INTO lease
VALUES(6005,1004,3005,450,'S',200,'Y','21-MAY-2023', '30-MAY-2026');

INSERT INTO lease
VALUES(6006,1005,3006,500,'C',100,'Y','30-JUL-2021', '31-JUL-2023');

INSERT INTO lease
VALUES(6007,1006,3007,450,'S',100,'N','01-MAY-2022', '11-JUN-2023');

INSERT INTO lease
VALUES(6008,1005,3008,500,'S',100,'Y','21-APR-2020', '11-JUN-2023');

INSERT INTO lease
VALUES(6009,1008,3003,600,'C',100,'Y','15-MAR-2021', '16-MAR-2024');

INSERT INTO lease
VALUES(6010,1010,3003,600,'C',100,'Y','12-JUN-2023', NULL);

INSERT INTO viewing
VALUES(1001,3001,'10-JUN-2022','Flat is too small');

INSERT INTO viewing
VALUES(1001,3005,'11-JUN-2022','Too small');

INSERT INTO viewing
VALUES(1005,3001,'10-JUN-2023','Too far away from local school');

INSERT INTO viewing
VALUES(1005,3002,'15-JUN-2023','Furniture shabby');

INSERT INTO viewing
VALUES(1006,3005,'11-JUN-2023','Far too large');

INSERT INTO inspection
VALUES(1001,201,'12-JUN-2023','No problems');

INSERT INTO inspection
VALUES(1002,201,'13-JUN-2023','Crockery needs to be replaced');

INSERT INTO inspection
VALUES(1003,201,'12-JUN-2022','Broken window pane requires urgent repair');

INSERT INTO inspection
VALUES(1006,203,'21-MAR-2021','No problems');

INSERT INTO inspection
VALUES(1007,203,'01-DEC-2020','Sofa trim pulled apart by cat. Repair needed');

INSERT INTO inspection
VALUES(1003,201,'12-JUN-2023','Cracked sink in kitchen requires repair');

COMMIT;

select * from tenant;

DECLARE 
    v_property_no    lease.property_no%TYPE;
    v_start_date    lease.stdate%TYPE;
    v_end_date      lease.enddate%TYPE;
    v_surname       tenant.t_surname%TYPE;
    v_forenames     tenant.t_forenames%TYPE;
BEGIN 
    SELECT l.property_no, l.stdate, l.enddate, 
           t.t_surname, t.t_forenames
    INTO v_property_no, v_start_date, v_end_date, 
         v_surname, v_forenames
    FROM lease l
    JOIN tenant t ON l.tenant_no = t.tenant_no 
    WHERE l.property_no = &enter_property_no;
    
    DBMS_OUTPUT.PUT_LINE('Property ' || v_property_no || 
                        ' was leased from ' || v_start_date || 
                        ' to ' || v_end_date ||
                        ' by ' || v_forenames || ' ' || v_surname);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No lease found for this property');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Multiple leases exist for this property');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END;
/

--tenant stored procedure

CREATE OR REPLACE PROCEDURE print_tenant_surname (my_tenant_no 
TENANT.TENANT_NO%TYPE) AS 
 my_surname TENANT.T_SURNAME%TYPE; 
BEGIN 
 SELECT t_surname 
 INTO my_surname 
 FROM tenant 
 WHERE tenant_no = my_tenant_no; 
 DBMS_OUTPUT.PUT_LINE('Tenant''s surname: '||my_surname); 
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 DBMS_OUTPUT.PUT_LINE('No tenant with that number'); 
END; 

exec print_tenant_surname(3001);


--stored procedure with if statement

CREATE OR REPLACE PROCEDURE test_monthly_rent 
 (my_prop_no PROP_FOR_RENT.PROPERTY_NO%TYPE) AS 
 my_monthly_rent PROP_FOR_RENT.PROP_RENT_PM%TYPE;
BEGIN
 SELECT prop_rent_pm
 INTO my_monthly_rent
 FROM prop_for_rent
 WHERE property_no = my_prop_no;
 IF my_monthly_rent < 500 THEN
    DBMS_OUTPUT.PUT_LINE('Rent is less than £500 per month');
 ELSIF my_monthly_rent <= 600 THEN
    DBMS_OUTPUT.PUT_LINE('Rent is between £500 and £600 per month');
 ELSE
    DBMS_OUTPUT.PUT_LINE('Rent is more than £600 per month');
 END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Property number ' || my_prop_no || ' does not exist');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred');
END; 
/

exec test_monthly_rent(1001);


--stored procedure to calculate annual rent including council tax

CREATE OR REPLACE PROCEDURE calculate_annual_rent 
    (p_property_no IN PROP_FOR_RENT.PROPERTY_NO%TYPE) 
AS 
    v_monthly_rent      PROP_FOR_RENT.PROP_RENT_PM%TYPE;
    v_council_tax      PROP_FOR_RENT.PROP_COUNCIL_TAX%TYPE;
    v_annual_total     NUMBER;
BEGIN
    -- Get the monthly rent and council tax for the property
    SELECT prop_rent_pm, NVL(prop_council_tax, 0)
    INTO v_monthly_rent, v_council_tax
    FROM prop_for_rent
    WHERE property_no = p_property_no;
    
    -- Calculate annual total (monthly rent * 12 + annual council tax)
    v_annual_total := (v_monthly_rent * 12) + v_council_tax;
    
    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Property: ' || p_property_no);
    DBMS_OUTPUT.PUT_LINE('Monthly Rent: £' || TO_CHAR(v_monthly_rent, '999,999.99'));
    DBMS_OUTPUT.PUT_LINE('Annual Council Tax: £' || TO_CHAR(v_council_tax, '999,999.99'));
    DBMS_OUTPUT.PUT_LINE('Total Annual Cost: £' || TO_CHAR(v_annual_total, '999,999.99'));
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Property number ' || p_property_no || ' does not exist');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred');
END;
/

exec calculate_annual_rent(1001);


--using loop 

CREATE OR REPLACE PROCEDURE show_tenants AS 
BEGIN 
 FOR tenant_cursor IN 
 (SELECT t_surname, t_forenames FROM tenant) 
 LOOP 
 DBMS_OUTPUT.PUT_LINE(tenant_cursor.t_forenames|| 
 ' '||tenant_cursor.t_surname); 
 END LOOP; 
END; 
/


--stored procedure to display the full address of available properties

CREATE OR REPLACE PROCEDURE show_available_properties AS 
BEGIN 
    FOR property_cursor IN (
        SELECT prop_street || 
               CASE 
                   WHEN prop_area IS NOT NULL THEN ', ' || prop_area
                   ELSE ''
               END ||
               ', ' || prop_town || 
               ', ' || prop_pcode AS full_address,
               prop_rent_pm
        FROM prop_for_rent
        WHERE available = 'Y'
        ORDER BY prop_town, prop_street
    )
    LOOP 
        DBMS_OUTPUT.PUT_LINE('Available Property at: ' || 
                            property_cursor.full_address || 
                            ' (£' || property_cursor.prop_rent_pm || ' per month)');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

