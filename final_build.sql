-- BMIS441; Group 2
-- Final Project
-- 11/19/19
-- final_build.sql

-- --------------------------------------------------------------------------------------
--                                       NOTE 
-- --------------------------------------------------------------------------------------
-- IF YOU HAVE A TABLE NAMED 'ITEM' FROM THE HOSPITAL PROJECT
-- 1. YOU NEED TO DROP ALL THE FOREIGN KEY CONSTRAINTS AND
-- 2. YOU NEED TO DROP THE PRIMARY KEY ON ITEM'S TABLE AND
-- 3. YOU NEED TO RENAME THAT TABLE
-- SO..
-- ALTER TABLE <table name>
-- DROP CONSTRAINT <constraint name>;
-- RENAME item TO item_MVC;
-- I had to alter patient_treatment (drop FK), item_service (drop FK), and item (drop PK)
-- --------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------
--                             READ ME
-- -----------------------------------------------------------------------
-- SO the data in inserted is for KEG Order/Deliveries
-- Kegs are ordered by people and business
-- Kegs orders are delivied to all business and delivied to some residents
-- Not all keg orders are delived. They are picked up by people
-- -----------------------------------------------------------------------

-- CLEAN BUILD
DROP TABLE item CASCADE CONSTRAINTS;
DROP TABLE customer CASCADE CONSTRAINTS;
DROP TABLE employee CASCADE CONSTRAINTS;
DROP TABLE keg CASCADE CONSTRAINTS;
DROP TABLE location CASCADE CONSTRAINTS;
DROP TABLE orderfeedback CASCADE CONSTRAINTS;
DROP TABLE order_summary CASCADE CONSTRAINTS;
DROP TABLE delivery CASCADE CONSTRAINTS;
DROP TABLE order_item CASCADE CONSTRAINTS;

-- CREATE TABLE
CREATE TABLE item (
  beer_id NUMBER(4),
  name VARCHAR2(30),
  cost NUMBER(5,2),
  retail NUMBER(5,2),
  alc_lvl NUMBER(2,1),
  ibu NUMBER(3),
  CONSTRAINT item_pk PRIMARY KEY (beer_id)
);

CREATE TABLE customer (
  customer_id NUMBER(3),
  first_name VARCHAR2(10),
  last_name VARCHAR2(15),
  email VARCHAR2(20),
  phone CHAR(12),
  street VARCHAR2(25),
  city VARCHAR2(15),
  state CHAR(2),
  zip CHAR(5),
  favorite_beer NUMBER(4) CONSTRAINT customer_item_fk REFERENCES item (beer_id),
  CONSTRAINT customer_pk PRIMARY KEY (customer_id)
);

CREATE TABLE employee (
  employee_id NUMBER(3),
  first_name VARCHAR2(10),
  last_name VARCHAR2(15),
  date_hired DATE,
  driver CHAR(1),
  payrate NUMBER(5,2),
  CONSTRAINT employee_pk PRIMARY KEY (employee_id)
);

CREATE TABLE keg (
  keg_id NUMBER(4),
  beer_id NUMBER(4) CONSTRAINT keg_item_fk REFERENCES item (beer_id),
  date_ordered DATE,
  date_returned DATE,
  CONSTRAINT keg_pk PRIMARY KEY (keg_id)
);

-- Added location Name
CREATE TABLE location (
  location_id NUMBER(3),
  loc_type VARCHAR2(10),
  loc_name VARCHAR2(20),
  steet VARCHAR2(25),
  city VARCHAR2(15),
  state CHAR(2),
  zip CHAR(5),
  CONSTRAINT location_pk PRIMARY KEY (location_id)
);

CREATE TABLE orderfeedback (
  orderfeedback_id NUMBER(3),
  payment_method VARCHAR2(5),
  rating NUMBER(1),
  comments VARCHAR2(40),
  CONSTRAINT orderfeedback_pk PRIMARY KEY (orderfeedback_id)
);

CREATE TABLE order_summary (
  order_id NUMBER(4),
  beer_id NUMBER(4) CONSTRAINT order_item_fk REFERENCES item (beer_id),
  quantity NUMBER(3),
  paid_each NUMBER(5,2),
  CONSTRAINT order_summary_pk PRIMARY KEY (order_id)
);

CREATE TABLE delivery (
  delivery_id NUMBER(4),
  order_id NUMBER(4) CONSTRAINT delivery_order_summary_fk REFERENCES order_summary (order_id),
  keg_id NUMBER(4) CONSTRAINT delivery_keg_fk REFERENCES keg (keg_id),
  location_id NUMBER(3) CONSTRAINT delivery_location_fk REFERENCES location (location_id),
  delivery_cost NUMBER(5,2),
  quantity_delivered NUMBER(3),
  CONSTRAINT delivery_pk PRIMARY KEY (delivery_id)
);

CREATE TABLE order_item (
  customer_id NUMBER(3) CONSTRAINT order_item_customer_fk REFERENCES customer (customer_id),
  delivery_id NUMBER(4) CONSTRAINT order_item_delivery_fk REFERENCES delivery (delivery_id),
  employee_id NUMBER(3) CONSTRAINT order_item_employee_fk REFERENCES employee (employee_id),
  orderfeedback_id NUMBER(3) CONSTRAINT order_item_orderfeedback_fk REFERENCES orderfeedback (orderfeedback_id),
  CONSTRAINT order_item_pk PRIMARY KEY (
    customer_id, 
    delivery_id,
    employee_id,
    orderfeedback_id
  )
);

-- INSERT INTO
INSERT ALL
  INTO item VALUES (1000, 'Born And Raised', 57.85, 110.95, 7.0, 85)
  INTO item VALUES (1001, 'Big Juicy', 42.10, 100.95, 6.1, 55)
  INTO item VALUES (1002, 'Red, White And No-Li Pale Ale', 46.50, 100.95, 6.1, 35)
  INTO item VALUES (1003, 'Wrecking Ball', 78.00, 120.29, 9.5, 100)
  INTO item VALUES (1004, 'Amber', 40.65, 100.29, 5.0, 10)
SELECT 1 FROM DUAL; 

INSERT ALL
  INTO customer VALUES(101, 'Allen', 'Allenson', 'imAllen@gmail.com', '509-499-6534', '64 1st Ave', 'Spokane','WA', '99202', 1000)
  INTO customer VALUES(102, 'Bob', 'Burgers', 'bobbyB@gmail.com', '509-123-4567', '54 Hotdog Ln', 'Spokane', 'WA', '99207', 1004)
  INTO customer VALUES(103, 'Carry', 'Weight', 'cweight@gmail.com', '509-234-3456', '1319 N Astor', 'Spokane', 'WA', '99205', 1002)
  INTO customer VALUES(104, 'Dasiy', 'Flowur', 'prettyFlower@msn.com', '206-732-5831', '514 E Main St', 'Everett', 'WA', '98805', 1003)
  INTO customer VALUES(105, 'Fredrick', 'Gurmon', 'freddyG@windows.com', '406-742-9942', '416 E 32nd St', 'Missola', 'MT', '80845', 1000)
  INTO customer VALUES(106, 'Gary', 'Smith', 'Gsmith@apple.com', '206-235-0040', '444 W 216th ST', 'Bothell', 'WA', '98805', 1000)
  INTO customer VALUES(107, 'Harry', 'Gooding', 'gooding@hotmail.com', '509-482-0283', '1 Division St', 'Spokane', 'WA', '99201', 1003)
  INTO customer VALUES(108, 'Isac', 'Moore', 'mooreI@gmail.com', '508-991-8392', '13 Author Rd', 'Spokane', 'WA', '99200', 1004)
  INTO customer VALUES(109, 'Jacie', 'McFlurry', 'McFlurry@apple.com', '206-886-3355', '3115 E Everet St', 'Seattle', 'WA', '98205', 1002)
  INTO customer VALUES(110, 'Katie', 'Hanson', 'KHanson@gmail.com', '509-883-7673', '1456 N Indian Trail Rd', 'Mead', 'WA', '99209', 1001)
  INTO customer VALUES(111, 'Louis', 'Jefferies', 'Lefferies@gmail.com', '305-886-4456', '78 28th St Apt 12', 'Portland', 'OR', '76004', 1000)
  INTO customer VALUES(112, 'Marry', 'Johnson', 'JohnsonM@yahoo.com', '509-321-4321', '19193 Sherman Br', 'Cheney', 'WA', '99004', 1002)
SELECT 1 FROM DUAL;

INSERT ALL 
  INTO employee VALUES (501, 'Nathan', 'Nelson', DATE '2012-06-13', 'N', '27.50')
  INTO employee VALUES (502, 'Olsen', 'Strling', DATE '2015-01-01', 'N', '15.86')
  INTO employee VALUES (503, 'Patrick', 'Williams', DATE '2015-01-17', 'N', '16.25')
  INTO employee VALUES (504, 'Quin', 'Whitman', DATE '2013-10-26', 'Y', '13.25')
  INTO employee VALUES (505, 'Regan', 'Ronald', DATE '2018-03-18', 'Y', '13.25')
  INTO employee VALUES (506, 'Sarah', 'Fix', DATE '2014-05-19', 'N', '20.00')
  INTO employee VALUES (507, 'Tim', 'Elito', DATE '2016-11-20', 'N', '19.75')
SELECT 1 FROM DUAL;

INSERT ALL
  INTO keg VALUES (2000, 1000, DATE '2015-06-03', DATE '2015-06-05')
  INTO keg VALUES (2001, 1000, DATE '2014-09-02', DATE '2014-09-09')
  INTO keg VALUES (2002, 1000, DATE '2017-10-29', NULL)
  INTO keg VALUES (2003, 1001, DATE '2019-11-20', NULL)
  INTO keg VALUES (2004, 1001, DATE '2019-03-18', DATE '2019-04-18')
  INTO keg VALUES (2005, 1001, DATE '2017-06-03', DATE '2017-06-05')
  INTO keg VALUES (2006, 1002, DATE '2014-12-30', NULL)
  INTO keg VALUES (2007, 1002, DATE '2013-07-15', DATE '2013-07-23')
  INTO keg VALUES (2008, 1002, DATE '2015-02-06', DATE '2015-02-10')
  INTO keg VALUES (2009, 1003, DATE '2019-04-24', DATE '2019-05-18')
  INTO keg VALUES (2010, 1003, DATE '2018-11-23', DATE '2018-12-03')
  INTO keg VALUES (2011, 1003, NULL, NULL)
  INTO keg VALUES (2012, 1004, DATE '2017-05-12', DATE '2017-05-28')
  INTO keg VALUES (2013, 1004, DATE '2019-06-03', DATE '2019-06-05')
  INTO keg VALUES (2014, 1000, DATE '2018-12-01', DATE '2019-01-07')
  INTO keg VALUES (2015, 1002, NULL, NULL)
SELECT 1 FROM DUAL;

INSERT ALL
  INTO location VALUES (201, 'Bar', 'Jack and Dans', '54 Hamilton St', 'Spokane', 'WA', '99202')
  INTO location VALUES (202, 'Restraunt', 'Zola', '12 Riverside Ave', 'Spokane', 'WA', '99206')
  INTO location VALUES (203, 'Resident', NULL, '13 Author Rd', 'Spokane', 'WA', '99200')
  INTO location VALUES (204, 'Resident', NULL, '1 Division St', 'Spokane', 'WA', '99201')
  INTO location VALUES (205, 'Bar', 'Fast Eddies', '451 N Ruby St', 'Spokane', 'WA', '99202')
  INTO location VALUES (206, 'Resident', NULL, '1456 N Indian Trail Rd', 'Mead', 'WA', '99209')
  INTO location VALUES (207, 'Restraunt', 'The Wave', '4809 N Howard St', 'Spokane', 'WA', '99201')
  INTO location VALUES (208, 'Resident', NULL, '64 1st Ave', 'Spokane','WA', '99202')
SELECT 1 FROM DUAL;

INSERT ALL
  INTO orderfeedback VALUES (401, 'Card', 5, 'Love No-Li')
  INTO orderfeedback VALUES (402, 'Card', 5, 'Excelent')
  INTO orderfeedback VALUES (403, 'Card', 4, 'Big Fan')
  INTO orderfeedback VALUES (404, 'Cash', 4, 'Ooo That was Amazing')
  INTO orderfeedback VALUES (405, 'Cash', 5, 'I cant believe its not butter')
  INTO orderfeedback VALUES (406, 'Card', 5, 'Favorite brewery for sure')
  INTO orderfeedback VALUES (407, 'Cash', 3, 'It was alright')
  INTO orderfeedback VALUES (408, 'Card', 1, 'Gross, I was throwing up all night')
  INTO orderfeedback VALUES (409, 'Card', 5, 'No-Li for ever')
SELECT 1 FROM DUAL;

INSERT ALL
  INTO order_summary VALUES (2100, 1000, 1, 110.95)
  INTO order_summary VALUES (2101, 1004, 2, 100.29)
  INTO order_summary VALUES (2102, 1002, 1, 100.29)
  INTO order_summary VALUES (2103, 1000, 2, 110.95)
  INTO order_summary VALUES (2104, 1003, 2, 120.29)
  INTO order_summary VALUES (2105, 1001, 1, 100.95)
  INTO order_summary VALUES (2106, 1000, 1, 110.95)
  INTO order_summary VALUES (2107, 1004, 1, 100.29)
  INTO order_summary VALUES (2108, 1003, 1, 120.29)
  INTO order_summary VALUES (2109, 1001, 1, 100.29)
  INTO order_summary VALUES (2110, 1000, 3, 110.95)
  INTO order_summary VALUES (2111, 1002, 1, 100.29)
SELECT 1 FROM DUAL;

INSERT ALL
  INTO delivery VALUES (9000, 2100, 2000, 201, 1, 20.00)
  INTO delivery VALUES (9001, 2101, 2012, 202, 2, 30.00)
  INTO delivery VALUES (9002, 2102, 2007, 203, 1, 20.00)
  INTO delivery VALUES (9003, 2103, 2001, 204, 2, 30.00)
  INTO delivery VALUES (9004, 2104, 2009, 205, 2, 30.00)
  INTO delivery VALUES (9005, 2105, 2004, 206, 1, 20.00)
  INTO delivery VALUES (9006, 2106, 2001, 207, 1, 20.00)
  INTO delivery VALUES (9007, 2107, 2013, 208, 1, 20.00)
SELECT * FROM DUAL;

INSERT ALL
  INTO order_item VALUES (102, 9000, 505, 402)
  INTO order_item VALUES (106, 9001, 505, 401)
  INTO order_item VALUES (108, 9002, 504, 406)
  INTO order_item VALUES (107, 9003, 505, 404)
  INTO order_item VALUES (112, 9004, 504, 408)
  INTO order_item VALUES (110, 9005, 505, 403)
  INTO order_item VALUES (103, 9006, 504, 407)
  INTO order_item VALUES (101, 9007, 504, 405)
SELECT 1 FROM DUAL;