CREATE TABLE price_list 
(product_id NUMBER (10,0) NOT NULL,
price number (10,2) NOT NULL,
primary key (product_id)
);

CREATE TABLE product_directory
   (	"product_id NUMBER(2,0) NOT NULL, 
	DATE_OF_SALE DATE, 
	PRODUCT_NAME VARCHAR2(20 CHAR) NOT NULL, 
	 PRIMARY KEY ("PRODUCT_ID")
     );
    
insert into product_directory (product_id, date_of_sale, product_name) values ('1', '13-06-2021', 'Socks');
insert into product_directory (product_id, date_of_sale, product_name) values ('2', '12-06-2021', 'T-Shirt');
insert into product_directory (product_id, date_of_sale, product_name) values ('3', '11-06-2021', 'Pants');
insert into product_directory (product_id, date_of_sale, product_name) values ('4', '10-06-2021', 'Cardigan');
insert into product_directory (product_id, date_of_sale, product_name) values ('5', '09-06-2021', 'Socks');

alter table price_list
add constraint F_KEY 
FOREIGN KEY (product_id)
REFERENCES product_directory (product_id);

insert into price_list (product_id, price) values ('1', '100');
insert into price_list (product_id, price) values ('2', '200');
insert into price_list (product_id, price) values ('3', '300');
insert into price_list (product_id, price) values ('4', '450');
insert into price_list (product_id, price) values ('5', '600');

select * from product_directory p1, price_list p2 where p1.product_id = p2.product_id;

CREATE TABLE managers_list
( product_id numeric(10,0) not null,
  manager_firstname varchar2(50) not null,
  manager_lastname varchar2(50) not null,
  CONSTRAINT F_key2  FOREIGN KEY (product_id)
    REFERENCES product_directory (product_id)
);

insert into managers_list (product_id, manager_firstname, manager_lastname) values ('1', 'Denis', 'Kutov');
insert into managers_list (product_id, manager_firstname, manager_lastname) values ('2', 'Sergey', 'Nosov');
insert into managers_list (product_id, manager_firstname, manager_lastname) values ('3', 'Alexey', 'Pushkin');
insert into managers_list (product_id, manager_firstname, manager_lastname) values ('4', 'Denis', 'Ivanov');
insert into managers_list (product_id, manager_firstname, manager_lastname) values ('5', 'Pavel', 'Kutov');

select p2.product_id, m.manager_firstname, m.manager_lastname, p1.price, p2.date_of_sale, p2.product_name
from managers_list_sale m, price_list p1, product_directory p2 where m.product_id = p1.product_id and m.product_id = p2.product_id;

CREATE SEQUENCE test_seq START WITH 6 INCREMENT BY 1;
drop SEQUENCE test_seq;

insert into managers_list (product_id, manager_firstname, manager_lastname) values (test_seq.nextval, 'Denis', 'Pavlov');
insert into managers_list (product_id, manager_firstname, manager_lastname) values (test_seq.nextval, 'Sergey', 'Nazarov');
insert into managers_list (product_id, manager_firstname, manager_lastname) values (test_seq.nextval, 'Denis', 'Pavlov');
insert into managers_list (product_id, manager_firstname, manager_lastname) values (test_seq.nextval, 'Aleksandr', 'Sidorov');

insert into product_directory (product_id, date_of_sale, product_name) values (test_seq.nextval, '10-06-2021', 'Hat');
insert into product_directory (product_id, date_of_sale, product_name) values (test_seq.nextval, '11-06-2021', 'Socks');
insert into product_directory (product_id, date_of_sale, product_name) values (test_seq.nextval, '10-02-2021', 'Hat');
insert into product_directory (product_id, date_of_sale, product_name) values (test_seq.nextval, '08-06-2019', 'Jacket');

insert into price_list (product_id, price) values (test_seq.nextval, '380');
insert into price_list (product_id, price) values (test_seq.nextval, '1250');
insert into price_list (product_id, price) values (test_seq.nextval, '300');
insert into price_list (product_id, price) values (test_seq.nextval, '900');

CREATE PUBLIC SYNONYM ML FOR managers_list_sale;
CREATE PUBLIC SYNONYM PL FOR price_list;
CREATE PUBLIC SYNONYM PD FOR product_directory;

select * from pd;

BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'test_job3',
   job_type           =>  'PLSQL_BLOCK',
   job_action         =>  'insert into product_directory SELECT * from PD;',
   auto_drop          =>   FALSE,
   job_class          =>  'SYS.DEFAULT_JOB_CLASS',
   comments           =>  'extract data');
END;

create table test_SQL_Loader 
( 
  id_num number primary key, 
  text_var varchar2(30),
  values_num number (10,0)
);

--LOAD DATA  
 --INFILE 'D:\oracleBD\dbhomeXE\bin\load\data.txt'  "str '\n'"
   --badfile     'D:\oracleBD\dbhomeXE\bin\load\bad.txt' 
   --discardfile 'D:\oracleBD\dbhomeXE\bin\load\discard.txt'
   --replace
   --into table test_sql_loader
   --fields terminated by ';' optionally enclosed by '"'
   --(
    --id_num INTEGER EXTERNAL,     
    --text_var char,
    --values_num INTEGER EXTERNAL
   --)
   
   --sqlldr.exe userid=C##D_Pastukhov/123@XE Control=D:\oracleBD\dbhomeXE\bin\load\control.txt errors=100 bad=D:\oracleBD\dbhomeXE\bin\load\bad.txt
   
   CREATE TABLE managers_list
( manager_firstname varchar2(50) not null,
  manager_lastname varchar2(50) not null,
  hierarchy number not null,
  MANAGER_ID number not null primary key
);
  
Begin
insert into managers_list (manager_firstname, manager_lastname, hierarchy, manager_id) values ('Denis', 'Kutov', '1', '1');
insert into managers_list (manager_firstname, manager_lastname, hierarchy, manager_id) values ('Denis', 'Ivanov', '2', '2');
insert into managers_list (manager_firstname, manager_lastname, hierarchy, manager_id) values ('Pavel', 'Kutov', '2', '3');
insert into managers_list (manager_firstname, manager_lastname, hierarchy, manager_id) values ('Sergey', 'Nazarov', '3', '4');
insert into managers_list (manager_firstname, manager_lastname, hierarchy, manager_id) values ('Sergey', 'Nosov', '3', '5');
insert into managers_list (manager_firstname, manager_lastname, hierarchy, manager_id) values ('Denis', 'Pavlov', '3', '6');
insert into managers_list (manager_firstname, manager_lastname, hierarchy, manager_id) values ('Alexey', 'Pushkin', '4', '7');
insert into managers_list (manager_firstname, manager_lastname, hierarchy, manager_id) values ('Alexandr', 'Sidorov', '4', '8');
END;
/

alter table Managers_list_sale 
add MANAGER_ID number;

alter table Managers_list_sale 
add CONSTRAINT M_ID 
  FOREIGN KEY (MANAGER_ID)
  REFERENCES Managers_list (Manager_ID)
  
  SELECT manager_firstname, manager_lastname, hierarchy, manager_id, level FROM managers_list
START WITH Hierarchy = 2
CONNECT BY nocycle PRIOR Hierarchy = MANAGER_ID
ORDER siblings BY hierarchy;
   
   