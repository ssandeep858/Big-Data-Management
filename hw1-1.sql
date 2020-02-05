CREATE SCHEMA `hw1`;
USE `hw1`;

-- PART1

CREATE TABLE `hw1`.`Customer`(
c_id int not null PRIMARY KEY,
c_name varchar(100),
credit_limit int,
income_level char(1),
gender char(1));

CREATE TABLE `hw1`.`Warehouses`(
warehouse_id int not null primary key,
location varchar(100));

CREATE TABLE `hw1`.`Inventories`(
product_id int not null primary key,
warehouse_id int,
quantity_on_hand int ,
foreign key(warehouse_id) references Warehouses(warehouse_id)); 

CREATE TABLE `hw1`.`Orders`(
order_id int not null primary key,
order_date date,
c_id int not null,
order_status varchar(100),
foreign KEY(c_id) REFERENCES Customer(c_id));

CREATE TABLE `hw1`.`Orderitems`(
order_id int not null,
product_id int not null,
unit_prize int,
quantity int,
primary key(order_id, product_id),
FOREIGN KEY(order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
FOREIGN KEY(product_id) REFERENCES Inventories(product_id));

CREATE TABLE `hw1`.`ProductInformation`(
product_id int not null primary key,
warranty_period int ,
purchase_prize int ,
FOREIGN KEY(product_id) REFERENCES Inventories(product_id));



insert into `Customer` value(1, 'Jamas', 1000, 'L', 'F');
insert into `Customer` value(2,'Christan',2000,'M','M');
insert into `Customer` value(3,'Saywer',5000,'H','F');
insert into `Customer` value(4,'Kropy',5000,'H','M');
insert into `Customer` value(5,'Lock',2000,'M','M');
insert into `Customer` value(6,'Mando',1000,'L','F');

insert into `Warehouses` value(1,'Los Angles');
insert into `Warehouses` value(2,'Chicago');
insert into `Warehouses` value(3,'New York');

insert into `Inventories` value(1,1,14);
insert into `Inventories` value(2,1,25);
insert into `Inventories` value(3,3,9);
insert into `Inventories` value(4,2,67);
insert into `Inventories` value(5,2,50);
insert into `Inventories` value(6,1,9);
insert into `Inventories` value(7,3,90);
insert into `Inventories` value (8,3,20);
insert into `Inventories` value(9,3,35);

insert into `ProductInformation` value(1,90,60);
insert into `ProductInformation` value(2,120,80);
insert into `ProductInformation` value(3,365,100);
insert into `ProductInformation` value(4,30,15);
insert into `ProductInformation` value(5,365,70);
insert into `ProductInformation` value(6,90,300);
insert into `ProductInformation` value(7,60,200);
insert into `ProductInformation` value(8,90,150);
insert into `ProductInformation` value(9,120,100);

insert into `Orders` value(1,'2019-09-01',1,'Processing');
insert into `Orders` value(2,'2019-08-27',2,'Complete');
insert into `Orders` value(3,'2019-06-20',3,'Complete');
insert into `Orders` value(4,'2019-08-01',4,'Complete');
insert into `Orders` value(5,'2019-08-31',1,'Processing');
insert into `Orders` value(6,'2019-09-01',4,'Processing');
insert into `Orders` value (7,'2019-08-20',6,'Complete');
insert into `Orders` value(8,'2019-08-11',2,'Complete');

insert into `Orderitems` value(1,1,80,1);
insert into `Orderitems` value(1,2,90,1);
insert into `Orderitems` value(2,1,70,1);
insert into `Orderitems` value(3,4,20,2);
insert into `Orderitems` value(3,2,100,3);
insert into `Orderitems` value(3,8,160,1);
insert into `Orderitems` value(4,4,20,12);
insert into `Orderitems` value(5,2,100,2);
insert into `Orderitems` value(5,8,250,1);
insert into `Orderitems` value(6,9,160,10);
insert into `Orderitems` value(7,5,100,3);
insert into `Orderitems` value(7,7,250,1);
insert into `Orderitems` value(8,4,35,2);




-- PART2
-- Queston 1
select c_name 'Customer' , avg(credit_limit) 'Average'  
from Customer where income_level='M' group by c_name;

-- question 2 

-- A PART 
Select c.c_name, count(o.order_id)
from Orders o , Customer c 
where (c.c_id=o.c_id) group by c.c_name
having count(order_id) =
(	
	Select max(order_count)
	from
    (Select c_id, count(order_id) as order_count
from orders group by c_id) as T
) ;


 select c.c_name , count(order_id) as items
from Customer c , Orders o
where ( c.c_id=o.c_id )
group by c.c_id
order by count(order_id) desc  ;

-- B part 
select c.c_name 'Names' ,max(oi.quantity) 'Quantity'
from Customer c, Orderitems oi, Orders o 
where (
o.order_id=oi.order_id and o.c_id=c.c_id
)group by c_name
order by max(oi.quantity) desc 
limit 1;

 
-- quesion 3

select w.location  , sum(i.quantity_on_hand) 'Total Products in Stock'
from Warehouses w , Inventories i
where (
w.warehouse_id=i.warehouse_id 

) group by location 
order by sum(i.quantity_on_hand) desc
LIMIT 1 ;

-- question 4 

select c.c_name 'names',sum(oi.quantity) 'quantity'
from Customer c , Orders o , Orderitems oi 
where ( o.order_id=oi.order_id and 
c.c_id=o.c_id and gender='F' )
group by c.c_name
having (sum(oi.quantity)>=3)
order by c.c_name desc;


-- question 5 
-- part a 
select sum(oi.unit_prize*oi.quantity) 'Total Sum' 
from Orders o , Orderitems oi
where (o.order_id=oi.order_id and o.order_status='Complete'
);
-- part b 
select (sum(oi.unit_prize*oi.quantity)-sum(p.purchase_prize*oi.quantity)) 'profit' 
from Orders o , Orderitems oi ,ProductInformation p 
where (o.order_id=oi.order_id and o.order_status='Complete' and p.product_id=oi.product_id
);

-- question 6

select c_name 'Customers' from (
select c.c_name, c.credit_limit, o.c_id, sum(oi.unit_prize*oi.quantity) as amount
from Orders o , Orderitems oi , Customer c
where (
o.order_id=oi.order_id and c.c_id=o.c_id)
group by o.c_id 
having amount>=(c.credit_limit/2)) as T ;

-- question 7
select oi.order_id ,o.c_id, o.order_date,p.warranty_period
from Orders o ,Orderitems oi,ProductInformation p
where (P.PRODUCT_ID=OI.PRODUCT_ID and  o.order_id=oi.order_id and o.order_status='Complete' and  
(DATE_ADD(o.order_date,INTERVAL p.warranty_period day)<sysdate()));	

-- question 8 

select c.c_name 'Names' ,o.order_date 'date', count(o.order_id) as count
from Customer c , Orders o 
where ( o.order_date >= "2019-08-01" and  o.order_date <= "2019-08-31" and o.c_id=c.c_id )
group by c.c_id
having count(o.order_id)>=2;


-- question 9
select c.c_name,count(distinct(w.warehouse_id)) as count
from Customer c ,Warehouses w ,Inventories i,Orderitems oi,Orders o 
where (
c.c_id=o.c_id and 
o.order_id=oi.order_id and 
oi.product_id=i.product_id and
i.warehouse_id=w.warehouse_id )
group by oi.order_id
having count>=2;


-- question10
select c_name 'Name' from customer where c_id not in(select  o.c_id
from Orderitems oi,Orders o , Warehouses w,Inventories i 
where ( o.order_id=oi.order_id
and oi.product_id=i.product_id
 and w.warehouse_id=i.warehouse_id 
 and w.location='New York')) and c_id in (select c_id from orders);
 
-- question 11
select t.income_level , t.product_id ,max(func) from 
(select c.income_level,oi.product_id,sum(oi.quantity) as func
from Orderitems oi , Customer c ,Orders o 
where ( o.order_id=oi.order_id and 
o.c_id=c.c_id)
group by c.income_level , oi.product_id
order by sum(oi.quantity) desc) as t 
group by t.income_level;

-- question 12 

select oi.product_id 'product_id',count(distinct(o.c_id)) as bought_by 
from Orderitems oi, Orders o 
where oi.order_id=o.order_id group by oi.product_id order by bought_by desc limit 1 ;

-- PART 3
-- question 1
update Customer 
set credit_limit=credit_limit * 0.5
where gender='F' ;  

-- question 2
DELETE FROM Orders where c_id IN (select t.c_id from (select o.c_id ,c.credit_limit,sum(oi.quantity*oi.unit_prize) as summ 
from Orders o , Orderitems oi, Customer c 
where (o.order_id=oi.order_id and c.c_id=o.c_id and o.order_status='Processing')
group by o.c_id having summ>=c.credit_limit) t);

--  question 3
update Inventories i, Orders o , Orderitems oi
set i.quantity_on_hand=i.quantity_on_hand-oi.quantity
where (o.order_id=oi.order_id and oi.product_id=i.product_id and order_status='Processing');

-- question 4 
delete from Orderitems where product_id=3;
delete from ProductInformation where product_id=3;
delete from Inventories where product_id=3;

-- question 5
update Inventories i , Warehouses w , ProductInformation pi
set pi.warranty_period=pi.warranty_period - 30
where (i.product_id=pi.product_id and w.warehouse_id=i.warehouse_id and w.location='Chicago');  
 
 -- PART 4 
 drop table Orderitems;
  drop table Orders;
   drop table ProductInformation;
    drop table Inventories;
     drop table Customer;
      drop table Warehouses;
