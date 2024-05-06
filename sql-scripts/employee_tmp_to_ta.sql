use ics_db;

merge ta.Employee as t
using tmp.Employee_CsvJob1 as s on s.ID = t.ID
when matched then
	update 
	set
		t.Name = s.Name
		,t.Age = s.Age
when not matched then
	insert (ID, Name, Age)
	values (s.Id, s.Name, s.Age);