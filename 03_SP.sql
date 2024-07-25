--fecha de entrega: 14/6
--número de grupo: 22
--nombre de la materia: Base de datos aplicada
--nombres y DNI de los alumnos: 
							  --44.109.525 Vicente Alan
							  --42.199.899 Barreto Marilyn
							  --44.668.940 Villar Luis

use Com5600G22
go
-----------------------------------
---------STORE PROCEDURES----------
-----------------------------------
----ABM Paciente---
CREATE OR ALTER PROCEDURE pac.altaPaciente
	@nom varchar(40),
	@ape varchar(40),
	@ape_mat varchar(40),
	@fnac date,
	@tipoDoc varchar(20),
	@nroDoc int,
	@sexoBio char(9),
	@gen varchar(20),
	@nac varchar(30),
	@fotoPerf varchar(250),
	@mail varchar(50),
	@telFij char(13),
	@telCont char(10),
	@telLabo char(10)
AS
BEGIN
	
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc)

	IF(@validacion = 0)
		INSERT INTO pac.paciente VALUES(@nom,@ape,@ape_mat,@fnac,@tipoDoc,@nroDoc,@sexoBio,@gen,@nac,@fotoPerf,@mail,@telFij,@telCont,@telLabo,(CAST(GETDATE() AS DATE)),(CAST(GETDATE() AS DATETIME)),NULL,(SELECT CURRENT_USER))
	ELSE
		RAISERROR('Paciente encontrado', 16, 1, 'pac.altaPaciente')
END
go

CREATE OR ALTER PROCEDURE pac.altaPacienteDatosEsenciales
	@nom varchar(40),
	@ape varchar(40),
	@tipoDoc varchar(20),
	@nroDoc int
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc)

	IF(@validacion = 0)
		INSERT INTO pac.paciente VALUES(@nom,@ape,NULL,NULL,@tipoDoc,@nroDoc,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,(CAST(GETDATE() AS DATE)),(CAST(GETDATE() AS DATETIME)),NULL,(SELECT CURRENT_USER))
	ELSE
		RAISERROR('Paciente encontrado', 16, 1, 'pac.altaPacienteDatosEsenciales')
END
go

CREATE OR ALTER PROCEDURE pac.altaPacienteCargado
	@tipoDoc varchar(20),
	@nroDoc int
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NOT NULL)

	IF(@validacion = 1)
		UPDATE pac.paciente SET Fecha_Baja = NULL, Fecha_actuali = (CAST(GETDATE() AS DATETIME)) WHERE Tipo_doc = @tipoDoc AND Nro_doc = @nroDoc
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.altaPacienteCargado')
END
go

CREATE OR ALTER PROCEDURE pac.bajaPaciente
	@tipoDoc varchar(20),
	@nroDoc int
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc)
	IF(@validacion = 1)
	BEGIN
		declare @id_pac int
		SET @id_pac = (SELECT id_paciente FROM pac.paciente WHERE Tipo_doc = @tipoDoc AND Nro_doc = @nroDoc AND Tipo_doc=@tipoDoc)

		UPDATE pac.paciente SET Fecha_Baja = (CAST(GETDATE() AS DATETIME)), Fecha_actuali = (CAST(GETDATE() AS DATETIME)) WHERE id_paciente = @id_pac

		declare @estado int
		SET @estado = (SELECT id_estado FROM tur.estadoTurno WHERE nombre = 'Cancelado')

		UPDATE tur.reservaTurnoMedico SET id_estado_turno = @estado WHERE id_paciente = @id_pac AND Fecha > (CAST(GETDATE() AS DATE))
	END
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.bajaPaciente')
END
go

CREATE OR ALTER PROCEDURE pac.modifFotoPaciente
	@tipoDoc varchar(20),
	@nroDoc int,
	@fotoPerf varchar(250)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NULL)

	IF(@validacion = 1)
		UPDATE pac.paciente SET Foto=@fotoPerf, Fecha_actuali=(CAST(GETDATE() AS DATETIME)) WHERE Nro_doc = @nroDoc AND Tipo_doc=@tipoDoc
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.modifFotoPaciente')
END
go

CREATE OR ALTER PROCEDURE pac.modifMailPaciente
	@tipoDoc varchar(20),
	@nroDoc int,
	@mail varchar(50)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NULL)

	IF(@validacion = 1)
		UPDATE pac.paciente SET Email=@mail, Fecha_actuali=(CAST(GETDATE() AS DATETIME)) WHERE Nro_doc = @nroDoc AND Tipo_doc=@tipoDoc
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.modifMailPaciente')
END
go

CREATE OR ALTER PROCEDURE pac.modifTelContPaciente
	@tipoDoc varchar(20),
	@nroDoc int,
	@tel varchar(13)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NULL)

	IF(@validacion = 1)
	UPDATE pac.paciente SET Telefono=@tel, Fecha_actuali=(CAST(GETDATE() AS DATETIME)) WHERE Nro_doc = @nroDoc AND Tipo_doc=@tipoDoc
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.modifTelContPaciente')
END
go

CREATE OR ALTER PROCEDURE pac.modifTelContPaciente
	@tipoDoc varchar(20),
	@nroDoc int,
	@tel varchar(10)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NULL)

	IF(@validacion = 1)
		UPDATE pac.paciente SET Tel_alter=@tel, Fecha_actuali=(CAST(GETDATE() AS DATETIME)) WHERE Nro_doc = @nroDoc AND Tipo_doc=@tipoDoc
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.modifTelContPaciente')
END
go

CREATE OR ALTER PROCEDURE pac.modifTelLabPaciente
	@tipoDoc varchar(20),
	@nroDoc int,
	@tel varchar(10)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NULL)

	IF(@validacion = 1)
		UPDATE pac.paciente SET Tel_laboral=@tel, Fecha_actuali=(CAST(GETDATE() AS DATETIME)) WHERE Nro_doc = @nroDoc AND Tipo_doc=@tipoDoc
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.modifTelLabPaciente')
END
go

---ABM USUARIO---
CREATE OR ALTER PROCEDURE pac.altaUsuario
	@tipoDoc varchar(20),
	@nrodoc int,
	@contraseña varchar(20)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NULL)
	
	IF(@validacion = 1)
	BEGIN
		declare @validacion1 bit = (SELECT COUNT(1) FROM pac.usuario u INNER JOIN pac.paciente p ON u.Id_paciente=p.Id_paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc)
		IF(@validacion1 = 0)
			BEGIN
			declare @id_pac int = (SELECT id_paciente FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc)
			INSERT INTO pac.usuario VALUES(@contraseña,(CAST(GETDATE() AS DATE)), @id_pac)
		END
		ELSE
		RAISERROR('Paciente con usuario asignado', 16, 1, 'pac.altaUsuario')
	END
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.altaUsuario')
END
go

CREATE OR ALTER PROCEDURE pac.modifContraseña
	@tipoDoc varchar(20),
	@nroDoc int,
	@contraseña varchar(10)
AS
BEGIN

	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NULL)
	
	IF(@validacion = 1)
	BEGIN
		declare @id_pac int = (SELECT id_paciente FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc)
		UPDATE pac.usuario SET contraseña=@contraseña WHERE id_paciente = @id_pac
	END
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.modifContraseña')
END
go

--ABM DOMICILIO--
CREATE OR ALTER PROCEDURE pac.altaDomicilio
	@tipoDoc varchar(20),
	@nroDoc int,
	@calle varchar(50),
	@numero int,
	@piso int,
	@departamento char(2),
	@cp char(4),
	@pais varchar(9),
	@provincia varchar(20),
	@localidad varchar(40)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NULL)
	
	IF(@validacion = 1)
	BEGIN
		declare @id_pac int = (SELECT id_paciente FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc)
		INSERT INTO pac.domicilio VALUES(@calle,@numero,@piso,@departamento,@cp,@pais,@provincia,@localidad, @id_pac)
	END
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.altaDomicilio')
END
go

CREATE OR ALTER PROCEDURE pac.modifDomicilio
	@tipoDoc varchar(20),
	@nroDoc int,
	@calle varchar(50),
	@numero int,
	@piso int,
	@departamento char(2),
	@cp char(4),
	@pais varchar(9),
	@provincia varchar(20),
	@localidad varchar(40)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NULL)
	declare @validacion1 bit = (SELECT COUNT(1) FROM pac.paciente p WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc AND Fecha_Baja IS NULL AND Id_paciente IN(SELECT Id_paciente FROM pac.domicilio))
	IF(@validacion = 1 AND @validacion1 = 1)
	BEGIN
		declare @id_pac int = (SELECT id_paciente FROM pac.paciente WHERE Nro_doc=@nrodoc AND Tipo_doc=@tipoDoc)
		UPDATE pac.domicilio SET Calle=@calle,Numero = @numero, Piso = @piso, Departamento = @departamento, CP = @cp, Pais = @pais, Provincia = @provincia, Localidad = @localidad WHERE Id_paciente = @id_pac
	END
	ELSE
		RAISERROR('Paciente no encontrado', 16, 1, 'pac.modifDomicilio')
END
go

--ABM PRESTADOR--
CREATE OR ALTER PROCEDURE os.altaPrestador
	@nombre varchar(15),
	@plan_prest varchar(30)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM os.prestador WHERE Nombre=@nombre AND Plan_prest=@plan_prest)

	IF(@validacion = 0)
		INSERT INTO os.prestador VALUES(@nombre,@plan_prest)
	ELSE
		RAISERROR('Prestador encontrado', 16, 1, 'os.altaPrestador')
END
go

CREATE OR ALTER PROCEDURE os.bajaPrestador
	@nombre varchar(15)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM os.prestador WHERE Nombre=@nombre)

	IF(@validacion = 1)
	BEGIN

		declare @estado int
		SET @estado = (SELECT Id_estado FROM tur.estadoTurno WHERE Nombre = 'Cancelado')
		declare @estadoOK int
		SET @estadoOK = (SELECT Id_estado FROM tur.estadoTurno WHERE Nombre = 'Atendido')
		UPDATE tur.reservaTurnoMedico SET Id_estado_turno = @estado WHERE Id_paciente IN(SELECT Id_paciente FROM os.cobertura WHERE Id_prestador IN(SELECT Id_prestador FROM os.prestador WHERE Nombre = @nombre)) AND Id_estado_turno != @estadoOK
		DELETE FROM os.cobertura WHERE Id_prestador IN(SELECT Id_prestador FROM os.prestador WHERE Nombre = @nombre)
		DELETE FROM os.prestador WHERE Nombre = @nombre
	END
	ELSE
		RAISERROR('Prestador no encontrado', 16, 1, 'os.bajaPrestador')
END
go

--ABM COBERTURA--
CREATE OR ALTER PROCEDURE os.altaCobertura
	@nroDoc int,
	@prestador varchar(15),
	@Plan varchar(30),
	@imagen varchar(250),
	@nro_socio int
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM os.cobertura WHERE Nro_socio=@nro_socio)

	declare @validacion1 bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nrodoc AND Fecha_Baja IS NULL)

	declare @validacion2 bit = (SELECT COUNT(1) FROM os.prestador WHERE @prestador=Nombre)

	declare @validacion3 bit = (SELECT COUNT(1) FROM os.cobertura c INNER JOIN pac.paciente p ON c.Id_paciente = p.Id_paciente WHERE @nroDoc = Nro_doc AND c.Fecha_Baja IS NULL)
	IF(@validacion = 0 AND @validacion1 = 1 AND @validacion2 = 1 AND @validacion3 = 0)
	BEGIN
		declare @id_pac int
		SET @id_pac = (SELECT Id_paciente FROM pac.paciente WHERE Nro_doc = @nroDoc)
		declare @id_prestador int
		SET @id_prestador = (SELECT Id_prestador FROM os.prestador WHERE Nombre = @prestador AND Plan_prest = @Plan)
	
		INSERT INTO os.cobertura VALUES(@imagen,@nro_socio,(CAST(GETDATE() AS DATE)), NULL,@id_pac,@id_prestador)
	END
	ELSE
		RAISERROR('Prestador o paciente no encontrado / Paciente dado de baja / nro de socio ocupado', 16, 1, 'os.altaCobertura')
END
go

CREATE OR ALTER PROCEDURE os.modifImgCobertura
	@nro_socio int,
	@imagen varchar(250)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM os.cobertura WHERE Nro_socio=@nro_socio)

	IF(@validacion = 1)
	UPDATE os.cobertura SET Imagen_credencial = @imagen WHERE Nro_socio=@nro_socio
	ELSE
		RAISERROR('Cobertura no encontrada', 16, 1, 'os.modifImgCobertura')
END
go

CREATE OR ALTER PROCEDURE os.bajaCobertura
	@nro_socio int
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM os.cobertura WHERE Nro_socio=@nro_socio)

	IF(@validacion = 1)
	UPDATE os.cobertura SET Fecha_baja = (CAST(GETDATE() AS DATE)) WHERE Nro_socio=@nro_socio
	ELSE
		RAISERROR('Cobertura no encontrada', 16, 1, 'os.bajaCobertura')
	END
go

--ABM ESTUDIO--
CREATE OR ALTER PROCEDURE pac.altaEstudio
	@nroDoc int,
	@nombreEst varchar(60),
	@autorizado bit,
	@doc_res varchar(250),
	@imagen_res varchar(250)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nroDoc AND Fecha_Baja IS NULL)

	IF(@validacion = 1)
	BEGIN
	declare @id_pac int
	SET @id_pac = (SELECT Id_paciente FROM pac.paciente WHERE Nro_doc = @nroDoc)
	
	INSERT INTO Pac.estudio VALUES((CAST(GETDATE() AS DATE)),@nombreEst,@autorizado,@doc_res,@imagen_res,@id_pac)
	END
	ELSE
		RAISERROR('Paciente no encontrado / Dado de baja', 16, 1, 'pac.altaEstudio')
END
go

CREATE OR ALTER PROCEDURE pac.autorizarEstudio
	@nroDoc int,
	@nombreEst varchar(60),
	@fecha date
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM pac.estudio E JOIN pac.paciente p ON E.Id_paciente = p.Id_paciente WHERE Nro_doc = @nroDoc AND E.Nombre = @nombreEst AND Fecha = @fecha)

	IF(@validacion = 1)
	BEGIN
		declare @id_pac int
		SET @id_pac = (SELECT Id_paciente FROM pac.paciente WHERE Nro_doc = @nroDoc)
	
		UPDATE pac.estudio SET Autorizado=1 WHERE Id_paciente = @id_pac AND Nombre = @nombreEst AND Fecha = @fecha
	END
	ELSE
		RAISERROR('Paciente o estudio no encontrado', 16, 1, 'pac.autorizarEstudio')
END
go

--INSERT ESPECIALIDAD--
CREATE OR ALTER PROCEDURE med.altaEspecialidad
	@nombreEspecialidad varchar(20)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM med.especialidad WHERE Nombre=@nombreEspecialidad)

	IF(@validacion = 0)
	INSERT INTO med.especialidad VALUES(@nombreEspecialidad)
	ELSE
		RAISERROR('Especialidad encontrada', 16, 1, 'med.altaEspecialidad')
END
go

--ABM MEDICO--
CREATE OR ALTER PROCEDURE med.altaMedico
	@nom varchar(40),
	@ape varchar(40),
	@nro_matricula int,
	@especialidad varchar(20)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM med.medico WHERE Nro_matricula=@nro_matricula)

	IF(@validacion = 0)
	BEGIN
	declare @id_esp int
	SET @id_esp = (SELECT Id_especialidad FROM med.especialidad WHERE Nombre = @Especialidad)
	
	INSERT INTO med.medico VALUES(@nom,@ape,@nro_matricula,@id_esp, NULL)
	END
	ELSE
		RAISERROR('Nro Matricula encontrada', 16, 1, 'med.altaMedico')
END
go

CREATE OR ALTER PROCEDURE med.bajaMedico
	@nro_matricula int,
	@especialidad varchar(20)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM med.medico WHERE Nro_matricula=@nro_matricula)

	IF(@validacion = 1)
	BEGIN
	declare @id_esp int
	SET @id_esp = (SELECT Id_especialidad FROM med.especialidad WHERE Nombre = @especialidad)
	
	declare @id_med int
	SET @id_med = (SELECT Id_medico FROM med.medico WHERE Nro_matricula=@nro_matricula AND Especialidad = @id_esp)
	
	declare @estado int
	SET @estado = (SELECT Id_estado FROM tur.estadoTurno WHERE Nombre = 'Cancelado')


	UPDATE med.medico SET Fecha_baja = (CAST(GETDATE() AS DATE)) WHERE id_medico = @id_med AND Especialidad = @id_esp
	DELETE FROM sed.diaXsede WHERE Id_medico = @id_med AND Dia > (CAST(GETDATE() AS DATE))
	UPDATE tur.reservaTurnoMedico SET Id_estado_turno = @estado WHERE Id_medico = @id_med AND Fecha > (CAST(GETDATE() AS DATETIME))
	END
	ELSE
		RAISERROR('Nro Matricula no encontrada', 16, 1, 'med.bajaMedico')
END
go

--ABM SEDE--
CREATE OR ALTER PROCEDURE sed.altaSede
	@nombre varchar(20),
	@direccion varchar(50)
AS
BEGIN
	declare @validacion bit = (SELECT COUNT(1) FROM sed.sedeDeAtencion WHERE Nombre=@nombre)

	IF(@validacion = 0)
	INSERT INTO sed.sedeDeAtencion VALUES(@nombre,@direccion)
	ELSE
		RAISERROR('Sede encontrada', 16, 1, 'sed.altaSede')
END
go

--ABM diaXSede--
CREATE OR ALTER PROCEDURE sed.medicoEnSede
  @nro_matricula int,
  @sede varchar(20),
  @dia date,
  @horaInicio time
AS
BEGIN
	declare @validacion1 bit = (SELECT COUNT(1) FROM med.medico WHERE Nro_matricula=@nro_matricula AND Fecha_baja IS NULL)
	declare @validacion2 bit = (SELECT COUNT(1) FROM sed.sedeDeAtencion WHERE Nombre=@sede)
	declare @validacion3 bit = (SELECT COUNT(1) FROM sed.diaXsede dxs INNER JOIN med.medico m ON m.Id_medico = dxs.Id_medico WHERE @dia = dia AND @nro_matricula = Nro_matricula)

	IF(@validacion1 = 1 AND @validacion2 = 1 AND @validacion3 = 0)
	BEGIN
	declare @id_med int
	SET @id_med = (SELECT DISTINCT Id_medico FROM med.medico WHERE @nro_matricula = Nro_matricula)
	
	declare @id_sede int
	SET @id_sede = (SELECT Id_sede FROM sed.sedeDeAtencion WHERE Nombre = @sede)
	
	INSERT INTO sed.diaXSede VALUES(@id_sede, @id_med, @dia, @horaInicio)
	END
	ELSE
		RAISERROR('Medico o Sede no encontrada / Medico dado de baja / Medico ya esta anotado ese dia', 16, 1, 'sed.medicoEnSede')
END
go

--ABM RESERVATURNOMEDICO--
CREATE OR ALTER PROCEDURE tur.altaReservaTurMed
	@nroDoc int,
	@nro_matricula int,
	@especialidad varchar(20),
	@sede varchar(20),
	@tipoTurno char(10),
	@fechaDeTurno date,
	@horaDeTurno time
AS
BEGIN
	declare @id_esp int
		SET @id_esp = (SELECT Id_especialidad FROM med.especialidad WHERE Nombre = @Especialidad)

	declare @validacion1 bit = (SELECT COUNT(1) FROM pac.paciente WHERE Nro_doc=@nroDoc AND Fecha_Baja IS NULL)
	declare @validacion2 bit = (SELECT COUNT(1) FROM med.medico WHERE Nro_matricula=@nro_matricula AND Fecha_Baja IS NULL AND @id_esp=Especialidad)
	declare @validacion3 bit = (SELECT COUNT(1) FROM sed.sedeDeAtencion WHERE Nombre=@sede)

	IF(@validacion1 = 1 AND @validacion2 = 1 AND @validacion3 = 1)
	BEGIN
		declare @id_pac int
		SET @id_pac = (SELECT Id_paciente FROM pac.paciente WHERE Nro_doc = @nroDoc)
	
		

		declare @id_med int
		SET @id_med = (SELECT Id_medico FROM med.medico WHERE Nro_matricula=@nro_matricula AND Especialidad=@id_esp)
	
		declare @id_sede int
		SET @id_sede = (SELECT Id_sede FROM sed.sedeDeAtencion WHERE Nombre = @sede)
	
		declare @id_ttur int
		SET @id_ttur = (SELECT Id_tipoTurno FROM tur.tipoTurno WHERE Nombre = @tipoTurno)
	
		declare @validacion int
		SET @validacion = (SELECT COUNT(*)
			WHERE DATEPART(n,@horaDeTurno) = 0 
			OR DATEPART(n,@horaDeTurno) = 30 
			OR DATEPART(n,@horaDeTurno) = 15 
			OR DATEPART(n,@horaDeTurno) = 45)

		declare @turnoOcupado int
		SET @turnoOcupado = (SELECT COUNT(*) 
			FROM tur.reservaTurnoMedico rtm INNER JOIN tur.estadoTurno et ON rtm.Id_estado_turno = et.Id_estado  
			WHERE Fecha = @fechaDeTurno 
			AND Hora = @horaDeTurno
			AND Id_medico = @id_med
			AND et.Nombre != 'Cancelado')

		declare @medicoDisp int
		SET @medicoDisp = (SELECT COUNT(*)
							FROM sed.diaXsede
							WHERE Dia = @fechaDeTurno 
							AND Id_medico = @id_med 
							AND Id_sede = @id_sede 
							AND @horaDeTurno  BETWEEN Hora AND DATEADD(HOUR, 8, Hora))

		IF (@id_pac > 0 AND @id_med > 0 AND @id_ttur > 0 AND @id_sede > 0 AND @validacion = 1 AND @turnoOcupado = 0 AND @medicoDisp > 0)
			INSERT INTO tur.reservaTurnoMedico VALUES(@fechaDeTurno, @horaDeTurno,@id_med, @id_esp,@id_pac,@id_sede,NULL,@id_ttur)
		ELSE
			RAISERROR('Turno no disponible', 16, 1, 'tur.altaReservaTurMed')
	END
	ELSE
		RAISERROR('Paciente o medico o sede no encontrada / Paciente o medico dado de baja', 16, 1, 'tur.altaReservaTurMed')
END
go

CREATE OR ALTER PROCEDURE tur.turnoAtendido
	@nroDoc int,
	@nro_matricula int,
	@especialidad varchar(20),
	@sede varchar(20),
	@fechaDeTurno date,
	@horaDeTurno time
AS
BEGIN
	declare @validacion1 bit = (SELECT COUNT(1)
		FROM pac.paciente p, med.medico m, med.especialidad e, tur.reservaTurnoMedico rtm, sed.sedeDeAtencion s
		WHERE p.Id_paciente = rtm.Id_paciente
		AND rtm.Id_medico = m.Id_medico
		AND m.Especialidad = e.Id_especialidad
		AND e.Id_especialidad = rtm.Id_especialidad
		AND s.Id_sede = rtm.Id_direccionAtencion
		AND @nroDoc = Nro_doc
		AND @nro_matricula = Nro_matricula
		AND @especialidad = E.Nombre
		AND @sede = s.Nombre
		AND @horaDeTurno = Hora
		AND @fechaDeTurno = Fecha)

	IF(@validacion1 = 1)
	BEGIN
		declare @id_pac int
		SET @id_pac = (SELECT Id_paciente FROM pac.paciente WHERE Nro_doc = @nroDoc)
	
		declare @id_esp int
		SET @id_esp = (SELECT Id_especialidad FROM med.especialidad WHERE Nombre = @Especialidad)

		declare @id_med int
		SET @id_med = (SELECT Id_medico FROM med.medico WHERE Nro_matricula=@nro_matricula AND Especialidad=@id_esp)
	
		declare @id_sede int
		SET @id_sede = (SELECT Id_sede FROM sed.sedeDeAtencion WHERE Nombre = @sede)
	
		declare @id_estadotur int
		SET @id_estadotur = (SELECT Id_estado FROM tur.estadoTurno WHERE Nombre = 'Atendido')

		UPDATE tur.reservaTurnoMedico SET Id_estado_turno = @id_estadotur 
			WHERE @fechaDeTurno = Fecha 
			AND @horaDeTurno = HORA 
			AND @id_med = Id_medico 
			AND @id_esp = Id_especialidad 
			AND @id_pac = Id_paciente 
			AND @id_sede = Id_direccionAtencion
			AND Id_estado_turno IS NULL
	END
	ELSE
		RAISERROR('Turno no encontrado', 16, 1, 'tur.altaReservaTurMed')
END
go
