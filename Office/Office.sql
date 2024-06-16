CREATE DATABASE OFFICE;
GO

CREATE TABLE Department(
Department_Id		INT IDENTITY (1,1),
Department_Name		VARCHAR(200)
CONSTRAINT PK_Department_Department_Id	PRIMARY KEY (Department_Id));

CREATE TABLE Staff(
Staff_Id			INT IDENTITY(1,1),
Department_Id		INT,
Staff_Name			VARCHAR(200),
Address				VARCHAR(100),
Salary				Decimal(20,2),
CONSTRAINT PK_Staff_Staff_Id PRIMARY KEY (Staff_Id),
CONSTRAINT FK_Department_Department_Id FOREIGN KEY (Department_Id) REFERENCES Department (Department_Id));


INSERT INTO Department VALUES('HR'),('Web Design'),('Softwere Devloper'),('IT'),('Product Manager');
INSERT INTO Department VALUES('Game Designer');

INSERT INTO Staff VALUES (1,'Prasad','JubliHills',5000.00),
(2,'Bunny','Sai Nagar',8000.00),
(3,'Sowmya','Sai Nagar',10000.00),
(4,'Prasad','Pragathi Nagar',20000.00),
(4,'Cherry','Sr Nagar',30000.00),
(5,'Cherry','Begampet',40000.00),
(2,'Manju','Begampet',50000.00),
(1,'Sruti','Rk Beach',50000.00),
(3,'Prasad','Metro Station',90000.00),
(4,'Satya','123 Street',100000.00);
INSERT INTO Staff VALUES(2,'Cherry','Metro Station',90000.00),
(5,'Nihira','Gokulam Strret',60000.00),
(1,'Bittu','Amerpet',30000.00),
(1,'Harish','Mainroad',50000.00);

SELECT * FROM Staff WHERE salary > 40000.00 ORDER BY Salary DESC;


Select top 8 * from Staff where Salary > 30000.00 ORDER BY Salary DESC;

 Select top 10 staff_name, salary from Staff ORDER BY Salary DESC
select * from Staff where salary=(select Min(salary) from Staff);


SELECT  Salary FROM Staff ORDER BY Salary DESC OFFSET 9 ROWS FETCH NEXT 1 ROWS ONLY;

SELECT D.Department_Name,S.Salary
FROM Department AS D
INNER JOIN Staff AS S
ON D.Department_Id = S.Department_Id ORDER BY Salary DESC OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY;

--Grouping By--

SELECT COUNT(Staff_Id), Staff_Name FROM Staff GROUP BY Staff_Name;

SELECT STAFF_NAME, COUNT(*) FROM Staff GROUP BY Staff_Name


SELECT STAFF_NAME, COUNT(*) as counts FROM Staff GROUP BY Staff_Name HAVING COUNT (*)>1

SELECT
  staff_name,
  salary,
  CASE
    WHEN salary > 100000 THEN 'High'
    WHEN salary > 50000 THEN 'Medium'
    ELSE 'Low'
  END AS salary_category
FROM
  Staff;


  
SELECT
  staff_name,
  salary,
  CASE
    WHEN salary > 99000 THEN 'High'
    WHEN salary > 49000 THEN 'Medium'
    WHEN Salary < 50000 THEN 'Low'
  END AS salary_category
FROM
  Staff;
   
   ----Grouping Sets----
   SELECT staff_name, SUM(salary) AS Sa FROM Staff GROUP BY staff_name;

   SELECT Sum(Salary) As Sa from Staff


  ---Filter---

SELECT DISTINCT Staff_name
FROM Staff
WHERE Staff_Id % 2 = 0;

----------------------------------------------------SubQuery---------------------------------------------------------------------------------
Select Staff_name from Staff where Department_Id IN (1,3,4,5,7,8) ORDER BY Staff_Name

select Department_id, staff_name ,salary from Staff where Department_Id IN (select Department_Id from Department where Department_Name = 'HR');

--Find the staff who's salary is more than the average salary earned by all staff ?
--Find the avg salary
--filter the staff based on the above result

select AVG(salary) from Staff

select * from Staff where Salary > 45214.285714 --Hard Coding

select * from Staff /*oute query/main querry*/  where salary > (select AVG(salary) from Staff);--Subquery/inner query

--Scalar Subquery ---------
--It always return one row and one column
--Scalar multiple query we use different places---
--Select--
select staff_id,salary,(select AVG(salary) from Staff) as avg_salary from Staff;
--Where--
select * from Staff where salary > (select AVG(salary) from Staff);
---Join---
select * from Staff s
join  (select AVG(salary)  as sal from staff) avg_sal
on s.salary > avg_sal.sal;


select s. * from Staff s
join  (select AVG(salary)  as sal from staff) avg_sal
on s.salary > avg_sal.sal;

--In expression--
select staff_name, salary * (1.3) AS increased_sal from staff;

----Multiple Row Subquery ---
--Subquery which returns multiple column and multiple row
--subquery which returns only one column and multiple rows
--Find the staff who earn the highest salary in each department ?
select max(salary) from Staff

select department_id , max(salary) from Staff group by Department_Id;

select d.department_name , max(salary) from Department as d
join Staff as s 
on d.department_Id = s.Department_Id group by d.department_name

select * from staff where (salary) in (select  max(salary) from Staff group by Department_Id);


select * from staff s where salary = (select  max(salary) from Staff where Department_Id = s.Department_Id);
--or--
select * from staff s
join(select Department_id, max(salary) as maxsalary 
from Staff group by Department_Id)as d
on s.Department_Id = d.Department_Id AND s.Salary = d.maxsalary

--Find the department who do not have staff ?
Select * from Department where Department_Id not in (Select Distinct Department_Id from Staff);

(Select Distinct Department_Id from staff);

--Correlated Subquery----
--Find the staff in each department who earn more than the average salary in that department ?

select * from staff s1 where salary > (select avg(salary) from staff s2 where s2.department_id = s1.department_id);

--Find department who do not have any staff ?
Select * From Department d where not exists (Select 1 from Staff s where s.department_id = d.department_id);

Select * from Department d where EXISTS (Select staff_name,salary from Staff s where s.Staff_Id = d.Department_Id) 

SELECT 
    s.staff_id,
    s.staff_name,
	s.salary,
    (SELECT d.department_id FROM Department d WHERE s.Staff_id = d.Department_Id) AS department_id,
    (SELECT d.Department_Name FROM Department d WHERE s.Staff_id = d.Department_Id) AS department_name
FROM staff s;

--Nested Subquery--
--Subquery inside a subquery inside subquery inside--
--find the staff who's salary where better than the average salary across the staff ?
--1) find the total salary for each department
--2)find avg salary for all the department
--3)compare 1&2
SELECT Department_Name, AVG(Staff.Salary) AS avg_each_dep_sal
FROM Department
JOIN Staff ON Department.Department_Id = Staff.Department_Id
GROUP BY Department_Name;


--1)
select Department. Department_name, sum(staff.salary) as each_dep_sal from Department
join staff on Department.Department_Id = staff.staff_id
group by Department. Department_Name;

SELECT Department.Department_Name, SUM(Staff.Salary) AS each_dep_sal /*this one is correct syntax*/
FROM Department
JOIN Staff ON Department.Department_Id = Staff.Department_Id
GROUP BY Department.Department_Name;

--2)
SELECT AVG(each_dep_sal) AS avg_salary_all_departments
FROM (SELECT Department.Department_Name, SUM(Staff.Salary) AS each_dep_sal FROM Department
    JOIN Staff ON Department.Department_Id = Staff.Department_Id
    GROUP BY Department.Department_Name
) x;

SELECT Department_Name, AVG(Staff.Salary) AS avg_each_dep_sal /* This is one is correct syntax*/
FROM Department
JOIN Staff ON Department.Department_Id = Staff.Department_Id
GROUP BY Department_Name;

--3)
select * from  (select Department_name, sum(staff.salary) each_dep_sal from Department--wrong query--
			 join staff on Department.Department_Id = staff.staff_id
			 group by Department_Name) s
 join (select AVG(each_dep_sal) as x
	from(select Department_name, sum(staff.salary) as each_dep_sal from Department
	join staff on Department.Department_Id = staff.Staff_Id
	group by Department_Name)  x) avg_sal 
	on s.each_dep_sal > avg_sal.x;
--or--
-- to wite multiple way sql sub query statement this is much better write sql statement 
	
  WITH salary AS (
    SELECT Department.Department_Name, SUM(staff.Salary) AS  Total_sal 
    FROM Department
    JOIN Staff ON Department.Department_Id = Staff.Department_Id
    GROUP BY Department.Department_Name)

SELECT * FROM salary
JOIN ( SELECT AVG( Total_sal  ) AS AverageSalary FROM salary ) AS avsal
		ON salary. Total_sal  > avsal.AverageSalary;


--Different Clause IN Subquery--
--SELECT
--FROM
--WHERE
--HAVING

--Using a Subquery in select Clause
/* Fetch all staff details and add remark to those staff who earn more than the avg pay*/

select * , (case when salary >(select avg(salary) from Staff) then 'High'
		else 'null'
		end ) as remark
		 from staff;
		 -- this not best method writing this query


select * , (case when salary > AVG_sal then 'High' --This much better write a query

		else 'null'
		end ) as remark
		 from staff
cross join (select avg(salary) avg_sal from Staff) Avg_salary;
--Having
--select query in the having clause--
--Find the stores who have sold more units than the average units sold by all stores
--Find the department who have high salary more than the average salary by  staff

select Department_id , sum(salary) from Staff group by Department_Id
having sum(salary) > (select AVG(salary) from Staff);

--Sql commands which allow subquery---
--Insert
--update
--delete



---------INDEX----------
--single table only can have one clusterd index
--a single can have multiple non cluster index
/*-----Clustered Index----- which will help us to improve the table performance our query performance so once ypu create 
a clustered index on in a table it going to store the data physical order either ascending or descending order and it
going to specify the order also in the file in the internal.*/

-- if staff pk automatically create cluster index
--we can create cluster multiple column
--we have to create multiple tables of the non-cluster
create index myindex on staff (staff_name)


create index myindex2 on staff (staff_name,salary)

drop index staff.myindex2

select * from Department 

            
-----------Regular Expression---------------
--A Regular Expression is popularly known as RegEx, 
--is a generalized expression that is used to match patterns with various sequences of characters.

SELECT * FROM staff WHERE Staff_Name LIKE 's%';

SELECT * FROM staff WHERE Staff_Name LIKE 'sa%' OR Staff_Name LIKE 'sa_';
