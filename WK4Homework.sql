create procedure find_employee_salaries()
select emp_no, salary from salaries
where salary > "100000";

call find_employee_salaries 



create procedure GetEmployeeByDepartment (
in deptName varcharacter (255)
)
 select *from employees
 inner join dept_emp using (emp_no)
 inner join departments using (dept_no)
 where  departments.dept_name = deparName;
 
 
delimiter $$
create procedure years_in_job (
in employee_number int,
out years_in_job int 
)
 begin
  declare start_year int;
  declare end_year int;
 
 select year(de.from_date), year(de.to_date)
 into start_year, end_year
 from dept_emp de
 where de.emp_no = employee_number
 limit 1;
 
if end_year = 9999 then 
 set end_year = year(now()); 
end if;

select end_year - start_year into years_in_job;
end $$
 

call years_in_job(10008, @years);
select @years;
 
delimiter //

create procedure level_of_employee(
   in employee_number int
)
begin
   declare emp_type varchar(20);

   call years_in_job(employee_number, @years);

   if @years < 1 then
    set emp_type = "Rookie";
   elseif @years < 10 then
    set emp_type = "Seasoned";
   else
     set emp_type = "vetreran";
  end if;
 
 Select @years as years_in_job, emp_type, d.dept_name
 from departments d
 inner join dept_emp de using(dept_no)
 where de.emp_no = employee_number;
	
end //

call level_of_employee(10016); 


delimiter //
create procedure get_count_by_salary_amount(
   in amount int,
   out total int 
)
begin
	select count(*)
	into total 
	from salaries
	where salary = amount;
end //


call get_count_by_salary_amount(80000, @total);

select @total


Delimiter //
create procedure employe_in_department_tenYear(
in employee_tenYear int
) 
 begin
	 declare emp_ten varchar(35);
	
	 call years_in_job(employee_tenYear, @years);
    
		if @years >= 10 then
		set emp_ten = "Has Ten Years or More with Company";
	    else
	    set emp_ten = "Not Ready";
	   end if;
	  
	  Select @years as years_in_job, emp_ten, d.dept_name
      from departments d
      inner join dept_emp de using(dept_no)
      where de.emp_no = emp_ten; 
 end //
 
 call employe_in_department_tenYear(10016)
 
delimiter //
create procedure get_average_salary(
  in dept_name varchar(225),
  out avg_salary int
)
begin 
  select avg(salary)
  into avg_salary 
  from salaries
  inner join dept_emp using(emp_no)
  inner join departments using(dept_no)
  where departments.dept_name = dept_name;
end //

 

call get_average_salary('staff', @avg_salary)


select @avg_salary
   