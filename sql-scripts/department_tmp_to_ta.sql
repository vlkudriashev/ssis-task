use ics_db;

merge ta.Department as t
using tmp.Department_CsvJob1 as s on s.ID = t.ID
when matched then
	update 
	set
		t.DepartmentName = s.DepartmentName
		,t.Salary = s.Salary
when not matched then
	insert (ID, DepartmentName, Salary)
	values (s.Id, s.DepartmentName, s.Salary);
