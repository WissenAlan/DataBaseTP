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
---------Lote de prueba-----------
-----------------------------------

--SP gral--

EXEC pac.altaPaciente 'Marcos','Calleri',NULL,NULL,'DNI',44109524,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL --alta de paciente con todos los datos
go

EXEC med.altaEspecialidad 'Otorrinolaringologo' --alta de la especialidad
go

EXEC med.altaMedico 'Juan', 'Perez',13000,'Otorrinolaringologo' --alta de medico con la especialidad anterior
go

EXEC sed.altaSede 'OSDE N°15','Av Gaona 1145' --alta de la sede
go

EXEC sed.medicoEnSede 13000, 'OSDE N°15','2025-01-29','14:00' --alta del dia que el medico esta en esa sede para reserva de turnos
go

Exec tur.altaReservaTurMed 44109524, 13000, 'Otorrinolaringologo', 'OSDE N°15','Presencial','2025-01-29','20:00' --reserva de turno en un rango de 8 horas del medico en sede
go


--SP tabla usuario--
EXEC pac.altaUsuario 'DNI',44109524, 'LeoMesi' --alta de usuario del paciente Messi
go
EXEC pac.ModifContraseña 'DNI',44109524, 'leomessi2' --modificacion de contraseña del usuario
go
EXEC pac.bajaPaciente 'DNI',44109524 --baja del paciente anterior por ende se modifica a cancelado el turno
go
EXEC pac.altaPacienteCargado 'DNI',44109524 --Alta de un paciente dado de baja
GO
--SP tabla Estudio--
EXEC pac.altaEstudio 25111001, 'Plantilla Ortopedica',0,NULL,NULL --alta de estudio
go

--(ACTUALIZAR LA FECHA DEL DIA QUE SE EJECUTA)
EXEC pac.autorizarEstudio 25111001, 'Plantilla Ortopedica','2024-07-07' --autorizar un estudio poniendo en 1 el campo autorizado
go

--SP baja de Medico--
Exec tur.altaReservaTurMed 25111001, 13000, 'Otorrinolaringologo', 'OSDE N°15','Presencial','2025-01-29','19:00' --alta de un turno para probar la baja del medico
go

EXEC med.bajaMedico 13000, 'Otorrinolaringologo' --baja del medico, pone en cancelado el turno y borra los datos de la tabla diaXsede
go

--SP tabla prestador y cobertura--
EXEC os.altaPrestador 'OSDE', 'Basico' --alta del prestador
go
EXEC os.altaCobertura 25111001,'OSDE','Basico',NULL,40303 --alta de paciente en cobertura
go
EXEC os.modifImgCobertura 40303, 'c:\\' --cambio de imagen
go
EXEC os.bajaCobertura 40303 --baja de cobertura
go

----------Probar la baja del prestador---------
EXEC pac.altaPacienteDatosEsenciales 'Ronaldo', 'Cristiano', 'DNI', 32700500 --alta de otro paciente para probar los datos esenciales
go
EXEC os.altaCobertura 32700500,'OSDE', 'Basico',NULL,40307 --no se creo el paciente con ese dni
go
EXEC os.altaCobertura 25111001,'OSDE', 'Basico',NULL,40306 --no se creo el paciente con ese dni
go
EXEC sed.medicoEnSede 119918, 'OSDE N°15','2025-01-29','14:00' --alta del otro medico en sede para probar la baja en  
go
Exec tur.altaReservaTurMed 25111001, 119918, 'ALERGIA', 'OSDE N°15','Presencial','2025-01-29','18:15'
go
Exec tur.altaReservaTurMed 32700500, 119918, 'ALERGIA', 'OSDE N°15','Presencial','2025-01-29','17:15'
go
EXEC os.bajaPrestador 'OSDE' --cambia a cancelado todos los turnos de los pacientes con osde
go

-----------Para ver el xml----------
EXEC os.altaCobertura 32700500,'Medicus', 'Azul',NULL,40307 --no se creo el paciente con ese dni
go
Exec tur.altaReservaTurMed 32700500, 119918, 'ALERGIA', 'OSDE N°15','Presencial','2025-01-29','17:15'
go
exec tur.turnoAtendido 32700500, 119918, 'ALERGIA', 'OSDE N°15','2025-01-29','17:15'
go
