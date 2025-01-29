-- For one to know where to save the csv data before we proceed upload the data into the tables
show variables like "secure_file_priv";

-- Create database, table and upload the cvs file
create database sales_project;
use sales_project;
create table sales_data
			(`DATE` varchar(50),
            `ANONYMIZED_CATEGORY` varchar(50),
            `ANONYMIZED_PRODUCT` varchar(50),
			`ANONYMIZED_BUSINESS` varchar(50),
			`ANONYMIZED_LOCATION` varchar(50),
            `QUANTITY` INT,
            `UNIT_PRICE` varchar(50)
)
;

-- To confirm if the table is properly created 
select *
from sales_data;	

describe sales_data;

-- loading data into the table but dont include 1st line as it is already in the table headers
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Case Study Data - Original.csv'
into table sales_data
	fields terminated by ','
	enclosed by '"'
	lines terminated by '\n'
	ignore 1 rows
;
-- It is always prudents to create another table and leave the original as it is. 
-- This will allow you to leave the original and use it in case of emergency
Create table sales_data1
like sales_data
;
insert sales_data1
	select *
	from sales_data
;

-- To identify MISSING VALUES
select *
from sales_data1
where QUANTITY = ''
OR QUANTITY IS NULL
;

-- We identified 39 rows of QUANTITY has to be removed coz its zero
select  count(*)
from sales_data1
where QUANTITY = ''
OR QUANTITY IS NULL
;

DELETE
from sales_data1
where QUANTITY = ''
;

-- Even if the Unit Price has 33 rows with blank or zero amount, 
-- we cannot delete in a similar manner we did above (i.e. like QUANTITY)
select *
from sales_data1
where UNIT_PRICE = 0
;

-- We can use JOIN to compare similar category then apply the same price to the missing fields
select t1.ANONYMIZED_CATEGORY, t1.UNIT_PRICE, 
		t2.ANONYMIZED_CATEGORY, t2.UNIT_PRICE
from sales_data1 as t1
	join sales_data1 as t2
    on t1.ANONYMIZED_CATEGORY = t2.ANONYMIZED_CATEGORY
where t1.UNIT_PRICE = 0
and t2.UNIT_PRICE <> 0
    ;
    
update sales_data1 as t1
	join sales_data1 as t2
    on t1.ANONYMIZED_CATEGORY = t2.ANONYMIZED_CATEGORY
set t1.UNIT_PRICE = t2.UNIT_PRICE
where t1.UNIT_PRICE = 0
and t2.UNIT_PRICE <> 0
    ;


-- to identify DUPLICATES
-- partition everything so as to confirm if there are any duplicates
select *,
row_number() Over(
			Partition By `DATE`, ANONYMIZED_CATEGORY, ANONYMIZED_PRODUCT, 
					ANONYMIZED_BUSINESS, ANONYMIZED_LOCATION, QUANTITY, UNIT_PRICE) as duplicates
	from sales_data1
	;

-- thereafter i use CTE to get the ones that have more than 1 duplicate.
-- I cannot use WHERE to filter (its used to get indiviual items) instead i use CTE
with duplicate_cte as
(
			select *,
			row_number() Over(
					Partition By `DATE`, ANONYMIZED_CATEGORY, ANONYMIZED_PRODUCT, 
						ANONYMIZED_BUSINESS, ANONYMIZED_LOCATION, QUANTITY, UNIT_PRICE) as duplicates
			from sales_data1
)
	select *
	from duplicate_cte
	where duplicates > 1
		;

-- to confirm if the duplicates are true for each individual item
select *
from sales_data1
where ANONYMIZED_CATEGORY = 'Category-121' 
		and ANONYMIZED_PRODUCT = 'Product-afb7' 
		and ANONYMIZED_BUSINESS = 'Business-610c'
        and ANONYMIZED_LOCATION = 'Location-3e32'
;

-- to remove the duplicates, i cannot DELETE directly, 
-- the figures on the duplicate colunms are not actual figures (they are formulated) 
-- instead I will create a new table with the duplicate colunm in the new table
create table sales_data2
			(`DATE` varchar(50),
            `ANONYMIZED_CATEGORY` varchar(50),
            `ANONYMIZED_PRODUCT` varchar(50),
			`ANONYMIZED_BUSINESS` varchar(50),
			`ANONYMIZED_LOCATION` varchar(50),
            `QUANTITY` INT,
            `UNIT_PRICE` varchar(50),
            `duplicates` INT
)
;

select *
from sales_data2
;

-- now copy all the data from the previous table
	insert into sales_data2
    select *,
			row_number() Over(
					Partition By `DATE`, ANONYMIZED_CATEGORY, ANONYMIZED_PRODUCT, 
						ANONYMIZED_BUSINESS, ANONYMIZED_LOCATION, QUANTITY, UNIT_PRICE) as duplicates
			from sales_data1
            ;

-- confirm the duplicates and then DELETE
select *
from sales_data2
where duplicates > 1
;
	DELETE
	from sales_data2
	where duplicates > 1
;

-- now delete the DUPLICATE column so that we are left with the original columns
	alter table sales_data2
	drop column duplicates
	;


-- creating a new DATE column to be MM-YYYY
select *
from sales_data2
;

alter table sales_data2
add column formatted_date1 varchar(50);
	update sales_data2
	set formatted_date1 = date_format(
				str_to_date(`date`, '%M %d, %Y, %h:%i %p'), '%M-%Y');
    


describe sales_data2;