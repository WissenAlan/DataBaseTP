--fecha de entrega: 14/6
--número de grupo: 22
--nombre de la materia: Base de datos aplicada
--nombres y DNI de los alumnos: 
							  --44.109.525 Vicente Alan
							  --42.199.899 Barreto Marilyn
							  --44.668.940 Villar Luis

use master
go
DROP DATABASE IF EXISTS Com5600G22
go
CREATE DATABASE Com5600G22
go
use Com5600G22
go

---------- schemas ------
CREATE SCHEMA pac
go
CREATE SCHEMA os
go
CREATE SCHEMA tur
go
CREATE SCHEMA med
go
CREATE SCHEMA sed
go
-------------- TABLAS ------------------
if not exists (
	select* from sys.tables
	where name = 'paciente'
	and schema_id = schema_id('pac')
)
BEGIN
CREATE TABLE pac.paciente(
	Id_paciente int identity(1,1) primary key clustered,
	Nombre varchar(40) NOT NULL,
	Apellido varchar(40) NOT NULL,
	Apellido_Materno varchar(40),
	Fecha_nac date,
	Tipo_doc varchar(20) NOT NULL,
	Nro_doc int NOT NULL,
	Sexo char(9),
	Genero varchar(20),
	Nacionalidad varchar(30),
	Foto varchar(250),
	Email varchar(50),
	Telefono varchar(20),
	Tel_alter char(10),
	Tel_laboral char(10),
	Fecha_registro date,
	Fecha_actuali datetime,
	Fecha_Baja datetime,
	Usuario_actuali varchar(30)
);
END
go

if not exists (
	select* from sys.tables
	where name = 'usuario'
	and schema_id = schema_id('pac')
)
BEGIN
CREATE TABLE pac.usuario(
	Id_usuario int identity(1,1) primary key clustered,
	Contraseña varchar(20) NOT NULL,
	Fecha_creacion date,
	Id_paciente int REFERENCES pac.paciente(Id_paciente)
);
END
GO

if not exists (
	select* from sys.tables
	where name = 'domicilio'
	and schema_id = schema_id('pac')
)
BEGIN
CREATE TABLE pac.domicilio(
	Id_domicilio int identity(1,1) primary key clustered,
	Calle varchar(50),
	Numero int,
	Piso int,
	Departamento char(2),
	CP char(4),
	Pais varchar(9),
	Provincia varchar(20),
	Localidad varchar(40),
	Id_paciente int REFERENCES pac.paciente(Id_paciente)
);
END
GO

if not exists (
	select* from sys.tables
	where name = 'prestador'
	and schema_id = schema_id('os')
)
BEGIN
CREATE TABLE os.prestador(
	Id_prestador int identity(1,1) primary key clustered,
	Nombre varchar(15) NOT NULL,
	Plan_prest varchar(30)
);
END
GO

if not exists (
	select* from sys.tables
	where name = 'cobertura'
	and schema_id = schema_id('os')
)
BEGIN
CREATE TABLE os.cobertura(
	Id_cobertura int identity(1,1) primary key clustered,
	Imagen_credencial varchar(250),
	Nro_socio int UNIQUE,
	Fecha_registro date,
	Fecha_Baja date,
	Id_paciente int REFERENCES pac.paciente(Id_paciente),
	Id_prestador int REFERENCES os.prestador(Id_prestador)
);
END
GO

if not exists (
	select* from sys.tables
	where name = 'estudio'
	and schema_id = schema_id('pac')
)
BEGIN
CREATE TABLE pac.estudio(
	Id_estudio int identity(1,1) primary key clustered,
	Fecha date,
	Nombre varchar(60),
	Autorizado bit,
	Doc_resultado varchar(250),
	Imagen_resultado varchar(250),
	Id_paciente int REFERENCES pac.paciente(Id_paciente)
);
END
GO

if not exists (
	select* from sys.tables
	where name = 'estadoTurno'
	and schema_id = schema_id('tur')
)
BEGIN
CREATE TABLE tur.estadoTurno(
	Id_estado int identity(1,1) primary key clustered,
	Nombre char(9) UNIQUE
);
END
GO

INSERT INTO tur.estadoTurno VALUES
('Atendido'),
('Ausente'),
('Cancelado');
go

if not exists (
	select* from sys.tables
	where name = 'tipoTurno'
	and schema_id = schema_id('tur')
)
BEGIN
CREATE TABLE tur.tipoTurno(
	Id_tipoTurno int identity(1,1) primary key clustered,
	Nombre char(10) UNIQUE
);
END
GO

INSERT INTO tur.tipoTurno VALUES
('Presencial'),
('Virtual');
go

if not exists (
	select* from sys.tables
	where name = 'especialidad'
	and schema_id = schema_id('med')
)
BEGIN
CREATE TABLE med.especialidad(
	Id_especialidad int identity(1,1) primary key clustered,
	Nombre varchar(20) NOT NULL UNIQUE
);
END
GO

if not exists (
	select* from sys.tables
	where name = 'medico'
	and schema_id = schema_id('med')
)
BEGIN
CREATE TABLE med.medico(
	Id_medico int identity(1,1) primary key clustered,
	Nombre varchar(40) NOT NULL,
	Apellido varchar(40) NOT NULL,
	Nro_matricula int UNIQUE,
	Especialidad int REFERENCES med.especialidad(Id_especialidad),
	Fecha_baja date
);
END
GO

if not exists (
	select* from sys.tables
	where name = 'sedeDeAtencion'
	and schema_id = schema_id('sed')
)
BEGIN
CREATE TABLE sed.sedeDeAtencion(
	Id_sede int identity(1,1) primary key clustered,
	Nombre VARCHAR(20) UNIQUE,
	Direccion VARCHAR(50)
);
END
GO

if not exists (
	select* from sys.tables
	where name = 'reservaTurnoMedico'
	and schema_id = schema_id('tur')
)
BEGIN
CREATE TABLE tur.reservaTurnoMedico(
	Id_turno int identity(1,1) primary key clustered,
	Fecha date,
	Hora time,
	Id_medico int,
	Id_especialidad int,
	Id_paciente int,
	Id_direccionAtencion int,
	Id_estado_turno int, 
	Id_tipoTurno int,
	CONSTRAINT Fk_med foreign key (Id_medico) REFERENCES med.medico (Id_medico),
	CONSTRAINT Fk_esp foreign key (Id_especialidad) REFERENCES med.especialidad (Id_especialidad),
	CONSTRAINT Fk_paciente foreign key (Id_paciente) REFERENCES pac.paciente (Id_paciente),
	CONSTRAINT Fk_sede foreign key (Id_direccionAtencion) REFERENCES sed.sedeDeAtencion (Id_sede),
	CONSTRAINT Fk_estTur foreign key (Id_estado_turno) REFERENCES tur.estadoTurno(Id_estado),
	CONSTRAINT Fk_tipoTur foreign key (Id_tipoTurno) REFERENCES tur.tipoTurno(Id_tipoTurno)
);
END
GO

if not exists (
	select* from sys.tables
	where name = 'diaXsede'
	and schema_id = schema_id('sed')
)
BEGIN
CREATE TABLE sed.diaXsede(
	Id_sede int,
	Id_medico int,
	dia date,
	hora time,
	CONSTRAINT Pk_sede primary key (Id_sede, Id_medico, dia),
	CONSTRAINT Fk_med foreign key (Id_medico) REFERENCES med.medico (Id_medico),
	CONSTRAINT Fk_sede foreign key (Id_sede) REFERENCES sed.sedeDeAtencion (Id_sede)
);
END
GO
