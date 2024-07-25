--fecha de entrega: 14/6
--número de grupo: 22
--nombre de la materia: Base de datos aplicada
--nombres y DNI de los alumnos: 
							  --44.109.525 Vicente Alan
							  --42.199.899 Barreto Marilyn
							  --44.668.940 Villar Luis

------------------------------------------------------------------

USE Com5600G22
go

-------------------------------------
------Importacion de Pacientes-------
-------------------------------------
CREATE OR ALTER PROCEDURE pac.creacionSPImportacionPacientes
    @ruta varchar(250)
AS
BEGIN
    -- Eliminar la tabla si existe
    DROP TABLE IF EXISTS pac.#pacientesImport;
 
    -- Crear la tabla temporal
    CREATE TABLE pac.#pacientesImport(
        Nombre varchar(40),
		Apellido varchar(40),
		Fnac varchar(10),
		Tipo_Doc varchar(20),
		Nro_Doc varchar(9),
		Sexo char(9),
		Genero varchar(20),
		Telefono varchar(20),
		Nacionalidad varchar(30),
		Email varchar(50),
		Calle_y_Numero varchar(60),
		Localidad varchar(40),
		Provincia varchar(20),
        CONSTRAINT pk_pacientes PRIMARY KEY (Tipo_Doc, Nro_Doc)
    );
 
    -- Crear la instrucción BULK INSERT dinámica
    DECLARE @sql NVARCHAR(MAX);
 
    SET @sql = N'
    BULK INSERT pac.#pacientesImport
    FROM ''' + @ruta + '''
    WITH
    (
		FIRSTROW = 2,
        FIELDTERMINATOR = '';'',
        ROWTERMINATOR = ''\n'',
		CODEPAGE = ''65001''
    )';
 
    -- Ejecutar la instrucción BULK INSERT
    EXEC sp_executesql @sql;

	UPDATE pac.#pacientesImport SET Nombre = SUBSTRING(Nombre,2,LEN(Nombre)-1) WHERE Nombre LIKE ' %'

	INSERT INTO pac.paciente SELECT Nombre, Apellido,NULL,TRY_CONVERT(date,fnac,103),Tipo_Doc ,CAST(Nro_Doc AS INT),Sexo ,Genero ,Nacionalidad,NULL,Email, Telefono,NULL,NULL,(CAST(GETDATE() AS DATE)),(CAST(GETDATE() AS DATETIME)),NULL,(SELECT CURRENT_USER) From pac.#pacientesImport pi WHERE pi.Nro_Doc NOT IN(SELECT Nro_Doc FROM pac.paciente) 
	
	INSERT INTO pac.domicilio SELECT SUBSTRING(Calle_y_numero,1,LEN(Calle_y_numero)-1),CAST(SUBSTRING(Calle_y_numero,LEN(Calle_y_numero),LEN(Calle_y_numero)) AS INT),NULL,NULL,NULL,NULL,Provincia,Localidad,P.Id_paciente FROM pac.#pacientesImport pImp, pac.paciente p WHERE pimp.Tipo_Doc =p.Tipo_doc AND pimp.Nro_Doc = p.Nro_doc AND Calle_y_Numero LIKE '%[^0-9][0-9]'
	INSERT INTO pac.domicilio SELECT SUBSTRING(Calle_y_numero,1,LEN(Calle_y_numero)-2),CAST(SUBSTRING(Calle_y_numero,LEN(Calle_y_numero)-1,LEN(Calle_y_numero)) AS INT),NULL,NULL,NULL,NULL,Provincia,Localidad,P.Id_paciente FROM pac.#pacientesImport pImp, pac.paciente p WHERE pimp.Tipo_Doc =p.Tipo_doc AND pimp.Nro_Doc = p.Nro_doc AND Calle_y_Numero LIKE '%[^0-9][0-9][0-9]'
	INSERT INTO pac.domicilio SELECT SUBSTRING(Calle_y_numero,1,LEN(Calle_y_numero)-3),CAST(SUBSTRING(Calle_y_numero,LEN(Calle_y_numero)-2,LEN(Calle_y_numero)) AS INT),NULL,NULL,NULL,NULL,Provincia,Localidad,P.Id_paciente FROM pac.#pacientesImport pImp, pac.paciente p WHERE pimp.Tipo_Doc =p.Tipo_doc AND pimp.Nro_Doc = p.Nro_doc AND Calle_y_Numero LIKE '%[^0-9][0-9][0-9][0-9]'
	INSERT INTO pac.domicilio SELECT SUBSTRING(Calle_y_numero,1,LEN(Calle_y_numero)-4),CAST(SUBSTRING(Calle_y_numero,LEN(Calle_y_numero)-3,LEN(Calle_y_numero)) AS INT),NULL,NULL,NULL,NULL,Provincia,Localidad,P.Id_paciente FROM pac.#pacientesImport pImp, pac.paciente p WHERE pimp.Tipo_Doc =p.Tipo_doc AND pimp.Nro_Doc = p.Nro_doc AND Calle_y_Numero LIKE '%[^0-9][0-9][0-9][0-9][0-9]'
	INSERT INTO pac.domicilio SELECT SUBSTRING(Calle_y_numero,1,LEN(Calle_y_numero)-5),CAST(SUBSTRING(Calle_y_numero,LEN(Calle_y_numero)-4,LEN(Calle_y_numero)) AS INT),NULL,NULL,NULL,NULL,Provincia,Localidad,P.Id_paciente FROM pac.#pacientesImport pImp, pac.paciente p WHERE pimp.Tipo_Doc =p.Tipo_doc AND pimp.Nro_Doc = p.Nro_doc AND Calle_y_Numero LIKE '%[0-9][0-9][0-9][0-9][0-9]'

	UPDATE pac.domicilio SET Calle = SUBSTRING(Calle,1,LEN(Calle)-3) WHERE Calle LIKE '%Nº' OR Calle LIKE '%NÈ'

    DROP TABLE IF EXISTS pac.#pacientesImport;
END;
go

--Ejecucion para importar Pacientes--
EXEC pac.creacionSPImportacionPacientes 'F:\Documetos\UNLAM\Segundo año\BDA\TP\Datasets---Informacion-necesaria\Dataset\Pacientes.csv'
go

-------------------------------------
------Importacion de Medicos---------
-------------------------------------
CREATE OR ALTER PROCEDURE med.creacionSPImportacionMedicos
    @ruta varchar(250)
AS
BEGIN
    -- Eliminar la tabla si existe
    DROP TABLE IF EXISTS med.#medicosImport;
 
    -- Crear la tabla temporal
    CREATE TABLE med.#medicosImport(
        Nombre varchar(40),
		Apellidos varchar(40),
		Especialidad varchar(20),
		NumColegiado int
        CONSTRAINT pk_medicos PRIMARY KEY (Nombre, Apellidos, Especialidad, NumColegiado)
    );
 
    -- Crear la instrucción BULK INSERT dinámica
    DECLARE @sql NVARCHAR(MAX);
 
    SET @sql = N'
    BULK INSERT med.#medicosImport
    FROM ''' + @ruta + '''
    WITH
    (
		FIRSTROW = 2,
        FIELDTERMINATOR = '';'',
        ROWTERMINATOR = ''\n'',
		CODEPAGE = ''65001''
    )';
 
    -- Ejecutar la instrucción BULK INSERT
    EXEC sp_executesql @sql;

	UPDATE med.#medicosImport SET Nombre = SUBSTRING(Nombre,5,LEN(Nombre)-1) WHERE Nombre LIKE 'Dr. %'
	UPDATE med.#medicosImport SET Nombre = SUBSTRING(Nombre,6,LEN(Nombre)-1) WHERE Nombre LIKE 'Dra. %' OR Nombre LIKE 'Lic. %' OR Nombre LIKE 'Kgo. %'
	UPDATE med.#medicosImport SET Apellidos = SUBSTRING(Apellidos,2,LEN(Apellidos)-1) WHERE Apellidos LIKE ' %'
	INSERT INTO med.especialidad SELECT DISTINCT Especialidad From med.#medicosImport WHERE Especialidad NOT IN(SELECT Nombre FROM med.especialidad)
	INSERT INTO med.medico SELECT Apellidos, mi.Nombre, NumColegiado, e.Id_especialidad, NULL FROM med.#medicosImport mi JOIN med.especialidad e ON mi.Especialidad = e.Nombre WHERE NumColegiado NOT IN(SELECT Nro_matricula FROM med.medico)

    DROP TABLE IF EXISTS med.#medicosImport;
END;
go
--Ejecucion para importar Medicos--
EXEC med.creacionSPImportacionMedicos 'F:\Documetos\UNLAM\Segundo año\BDA\TP\Datasets---Informacion-necesaria\Dataset\Medicos.csv'
go

-------------------------------------
-------Importacion de Sedes----------
-------------------------------------
CREATE OR ALTER PROCEDURE sed.creacionSPImportacionSedes
    @ruta varchar(250)
AS
BEGIN
    -- Eliminar la tabla si existe
    DROP TABLE IF EXISTS sed.#sedesImport;
 
    -- Crear la tabla temporal
    CREATE TABLE sed.#sedesImport(
        Nombre varchar(20),
		Direccion varchar(30),
		Localidad varchar(20),
		Provincia varchar(20)
        CONSTRAINT pk_sedes PRIMARY KEY (Nombre, Direccion)
    );
 
    -- Crear la instrucción BULK INSERT dinámica
    DECLARE @sql NVARCHAR(MAX);
 
    SET @sql = N'
    BULK INSERT sed.#sedesImport
    FROM ''' + @ruta + '''
    WITH
    (
		FIRSTROW = 2,
        FIELDTERMINATOR = '';'',
        ROWTERMINATOR = ''\n'',
		CODEPAGE = ''65001''
    )';
 
    -- Ejecutar la instrucción BULK INSERT
    EXEC sp_executesql @sql;

	UPDATE sed.#sedesImport SET Nombre = SUBSTRING(Nombre,2,LEN(Nombre)-1) WHERE Nombre LIKE ' %'
	UPDATE sed.#sedesImport SET Direccion = SUBSTRING(Direccion,2,LEN(Direccion)-1) WHERE Direccion LIKE ' %'
	UPDATE sed.#sedesImport SET Localidad = SUBSTRING(Localidad,2,LEN(Localidad)-1) WHERE Localidad LIKE ' %'
	UPDATE sed.#sedesImport SET Provincia = SUBSTRING(Provincia,2,LEN(Provincia)-1) WHERE Provincia LIKE ' %'
	INSERT INTO sed.sedeDeAtencion SELECT Nombre, CONCAT(Direccion,' ',Localidad, ' ',Provincia) FROM sed.#sedesImport WHERE Nombre NOT IN(SELECT Nombre FROM sed.sedeDeAtencion)

    DROP TABLE IF EXISTS sed.#sedesImport;
END;
go
--Ejecucion para importar Sedes--
EXEC sed.creacionSPImportacionSedes 'F:\Documetos\UNLAM\Segundo año\BDA\TP\Datasets---Informacion-necesaria\Dataset\Sedes.csv'
go

-------------------------------------
-----Importacion de Prestadores------
-------------------------------------
CREATE OR ALTER PROCEDURE os.creacionSPImportacionPrestadores
    @ruta varchar(250)
AS
BEGIN
    -- Eliminar la tabla si existe
    DROP TABLE IF EXISTS os.#prestadorImport;
 
    -- Crear la tabla temporal
    CREATE TABLE os.#prestadorImport(
        Nombre varchar(15),
        Plan_prest varchar(30),
        CONSTRAINT pk_prest PRIMARY KEY (Nombre, Plan_prest)
    );
 
    -- Crear la instrucción BULK INSERT dinámica
    DECLARE @sql NVARCHAR(MAX);
 
    SET @sql = N'
    BULK INSERT os.#prestadorImport
    FROM ''' + @ruta + '''
    WITH
    (
		FIRSTROW = 2,
        FIELDTERMINATOR = '';'',
        ROWTERMINATOR = '';;\n'',
		CODEPAGE = ''65001''
    )';
 
    -- Ejecutar la instrucción BULK INSERT
    EXEC sp_executesql @sql;

	INSERT INTO os.Prestador SELECT * FROM os.#prestadorImport WHERE Plan_prest NOT IN(SELECT Plan_prest FROM os.prestador)
    
    DROP TABLE IF EXISTS os.#prestadorImport;
END;
go

EXEC OS.creacionSPImportacionPrestadores 'F:\Documetos\UNLAM\Segundo año\BDA\TP\Datasets---Informacion-necesaria\Dataset\Prestador.csv'
go

---------------------------------------
---------- IMPORTAR JSON --------------
---------------------------------------
DROP TABLE IF EXISTS os.CentroAutorizaciones;
GO

CREATE TABLE os.CentroAutorizaciones (
    Id VARCHAR(50) PRIMARY KEY,
    Area VARCHAR(255),
    Estudio NVARCHAR(255),
    Prestador VARCHAR(255),
    PlanPres NVARCHAR(255),
    PorcentajeCobertura INT CHECK (PorcentajeCobertura between  0 AND  100),
    Costo DECIMAL(10, 2),
    RequiereAutorizacion bit
);
GO

CREATE OR ALTER PROCEDURE os.importarCentroAutorizaciones
    @rutaArchivo NVARCHAR(1000)  -- Parámetro para la ruta del archivo JSON
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @json_data NVARCHAR(MAX);

    -- Construir la consulta dinámica para leer el archivo JSON
	BEGIN try
    SET @sql = 'SELECT @json_data = BulkColumn 
		FROM OPENROWSET(
		BULK ''' + @rutaArchivo + ''',
		SINGLE_CLOB,
		CODEPAGE = ''65001'')
		AS data;'; --el codepage no resuelve el error de las tildes
	END try
	BEGIN catch
		raiserror('Error al intentar leer el archivo json',16,1)
	END catch

    -- Ejecutar la consulta dinámica para leer el contenido del archivo JSON
    EXEC sp_executesql @sql, N'@json_data NVARCHAR(MAX) OUTPUT', @json_data OUTPUT;

    -- Insertar los datos en la tabla, desglosando el campo _id para obtener el valor de $oid
	BEGIN try
		INSERT INTO os.CentroAutorizaciones(Id, Area, Estudio, Prestador, PlanPres, PorcentajeCobertura, Costo, RequiereAutorizacion)
		SELECT oidData.Oid, main.Area, main.Estudio, main.Prestador, main.[Plan], main.[Porcentaje Cobertura], 
		main.Costo, main.[Requiere autorizacion]
		FROM OPENJSON(@json_data)
		WITH (
			_id NVARCHAR(MAX) AS JSON,
			Area NVARCHAR(255),
			Estudio NVARCHAR(255),
			Prestador NVARCHAR(255),
			[Plan] NVARCHAR(255),
			[Porcentaje Cobertura] INT,
			Costo DECIMAL(10, 2),
			[Requiere autorizacion] BIT
		) AS main
		CROSS APPLY OPENJSON(main._id)
		WITH (
			Oid NVARCHAR(50) '$."$oid"'
		) AS oidData;
		UPDATE os.CentroAutorizaciones SET Estudio = 'Análisis de orina'  WHERE Estudio LIKE 'An%lisis de orina'
		UPDATE os.CentroAutorizaciones SET Estudio = 'Análisis de sangre'  WHERE Estudio LIKE 'An%lisis de sangre'
		UPDATE os.CentroAutorizaciones SET PlanPres = 'Unión Personal Classic'  WHERE PlanPres LIKE 'Uni%n Personal Classic'
		UPDATE os.CentroAutorizaciones SET PlanPres = 'Unión Personal Familiar'  WHERE PlanPres LIKE 'Uni%n Personal Familiar'
	END try
	BEGIN catch
		raiserror('Error al insertar datos',16,1)
	END catch
END;
GO

EXEC os.importarCentroAutorizaciones 'F:\Documetos\UNLAM\Segundo año\BDA\TP\Datasets---Informacion-necesaria\Dataset\Centro_Autorizaciones.Estudios clinicos.json';
GO