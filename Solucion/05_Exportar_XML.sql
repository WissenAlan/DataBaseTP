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
---------------------------------------
---------- EXPORTAR XML --------------
---------------------------------------
CREATE OR ALTER PROCEDURE tur.exportarTurnos
	@obraSocial VARCHAR(20),
	@fInicio DATE,
	@fFinal DATE
AS
BEGIN
	declare @xmlResult XML;
	set @xmlResult = (SELECT p.Apellido, P.Nombre, Nro_doc, m.Nombre, m.Apellido, Nro_matricula, Fecha, Hora, e.Nombre
	FROM tur.reservaTurnoMedico rtm INNER JOIN pac.paciente p ON p.Id_paciente = rtm.Id_paciente 
		INNER JOIN med.medico m ON rtm.Id_medico = m.Id_medico
		INNER JOIN med.especialidad e ON m.Especialidad = e.Id_especialidad
		INNER JOIN tur.estadoTurno et ON et.Id_estado = rtm.Id_estado_turno
		INNER JOIN os.cobertura c ON c.Id_paciente =p.Id_paciente
	WHERE et.Nombre = 'Atendido'
		AND rtm.Fecha BETWEEN @fInicio AND @fFinal
		AND c.Id_prestador IN(SELECT Id_prestador FROM os.prestador WHERE @obraSocial = Nombre)
	FOR XML raw('Turno'), elements)

	SELECT @xmlResult AS resultadoXML;
END;
go

EXEC tur.exportarTurnos 'Medicus', '2025-01-01','2025-01-31'
go