if db_id('ics_db') is null
begin
	create database ics_db
end;

use ics_db;

-- "tmp" - Schema for temporary objects

if schema_id('tmp') is null
	exec ('create schema tmp authorization [dbo]')

if object_id(N'tmp.Employee_CsvJob1', N'U') IS NULL
	create table tmp.Employee_CsvJob1 (
			ID int
			,Name varchar(50)
			,Age int
	)

if object_id(N'tmp.Department_CsvJob1', N'U') IS NULL
	create table tmp.Department_CsvJob1 (
		ID int
		,DepartmentName varchar(50)
		,Salary decimal(10, 2)
	)

-- "ta" - Target Area schema

if schema_id('ta') is null
	exec ('create schema ta authorization [dbo]')

if object_id(N'ta.Employee', N'U') IS NULL
	create table ta.Employee (
		ID int primary key
		,Name varchar(50)
		,Age int
	)

if object_id(N'ta.Department', N'U') IS NULL
	create table ta.Department (
		ID int primary key
		,DepartmentName varchar(50)
		,Salary decimal(10, 2)
	)