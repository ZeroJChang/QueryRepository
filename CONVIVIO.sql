--DECLARE @codEmpleado INT
--DECLARE @codigoEmpleado NVARCHAR(6)
--DECLARE @idInvitacion INT
--DECLARE C CURSOR
--	FOR SELECT idInvitacion,codEmpleado,codigoEmpleado FROM tInvitacion WHERE codigoInvitacion is null 
--OPEN C
--FETCH C INTO @idInvitacion,@codEmpleado,@codigoEmpleado
--	WHILE (@@FETCH_STATUS=0)
--	BEGIN

--	UPDATE tInvitacion SET codigoInvitacion = (SELECT  CONVERT(VARCHAR(7), HashBytes('MD5', CONVERT(VARCHAR, CONCAT(idInvitacion,'|',codigoEmpleado)) ), 2) FROM tInvitacion WHERE codEmpleado=@codEmpleado) WHERE codEmpleado=@codEmpleado AND confirmacion=0

--	FETCH C INTO @idInvitacion,@codEmpleado,@codigoEmpleado
--	END
--CLOSE C
--DEALLOCATE C

--update tinvitacion set confirmacion=0  where codigoEmpleado='AL0266' and confirmacion=1
--select * from tinvitacion where codigoEmpleado in ('RM0333','RM0631')
----SELECT * FROM PINULITO_NOMINA..tEmpleado WHERE codEmpleado=2791

--SELECT * FROM tUsuarioRol WHERE codEmpleado=266

SELECT * FROM PINULITO_NOMINA..tEmpleado WHERE codempleado=52
