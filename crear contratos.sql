DECLARE @noContrato INT
DECLARE @codEmpleado INT
DECLARE @codDepto INT
DECLARE @nomPuesto NVARCHAR(MAX)
DECLARE @salarioOrdinario DECIMAL(10,2)
DECLARE @BonifDecreto DECIMAL(10,2)
DECLARE @bonifExtra DECIMAL(10,2)
DECLARE @salarioMensual DECIMAL(10,2)
DECLARE @tipoPago NVARCHAR(MAX)
DECLARE @departLab INT
DECLARE @muniLab INT
DECLARE @tipoContract NVARCHAR(MAX)
DECLARE @timeContract NVARCHAR(MAX)
DECLARE @jornadaLab NVARCHAR(MAX)
DECLARE @codEmpresa INT
DECLARE @activo INT
DECLARE @constanciaRetension DECIMAL(10,2)
DECLARE @idLoteBancario INT
DECLARE @idLiquidacionIGSS INT
DECLARE @codCentroTrabajoIGSS INT
DECLARE @codOcupacionIGSS INT
DECLARE @nuevoNumeroContrato INT
DECLARE @ocupacion NVARCHAR(MAX)
SELECT * FROM tContrato   order by noContract desc
SELECT * FROM tContrato where noContract=52003
--SELECT * FROM tContrato WHERE codEmpleado=3837
--,3839,3842,3938,3939,3909,3838,3875,3934,3935,460,3313,3843,3910,3967,29,245

--SELECT * FROM tContrato WHERE codEmpleado=3965
--SELECT * FROM TEMPLEADO WHERE codEmpleado=245

DECLARE C CURSOR
	FOR SELECT codEmpleado,noContract FROM tContrato where codEmpleado in (3964)  AND activo=1
OPEN C
FETCH C INTO @codEmpleado,@noContrato
	WHILE (@@FETCH_STATUS=0)
	BEGIN

	SET @codDepto = (SELECT codDepto FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @nomPuesto =	(SELECT nomPuesto FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @salarioOrdinario =	(SELECT salarioOrdinario FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @BonifDecreto =	(SELECT bonifDecreto FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @bonifExtra =	(SELECT bonifExtra FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @salarioMensual =	(SELECT salarioMensual FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @tipoPago =	(SELECT tipoPago FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @departLab =	(SELECT departLab FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @muniLab =	(SELECT muniLab FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @tipoContract =	(SELECT tipoContract FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @timeContract =	(SELECT timeContract FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @jornadaLab =	(SELECT jornadaLab FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @codEmpresa =	(SELECT codEmpresa FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @activo =	(SELECT activo FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @constanciaRetension =	(SELECT constanciaRetension FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @idLoteBancario =	(SELECT idLoteBancario FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @idLiquidacionIGSS =	(SELECT idLiquidacionIGSS FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @codCentroTrabajoIGSS =	(SELECT codCentroTrabajoIGSS FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @codOcupacionIGSS =	(SELECT codOcupacionIGSS FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	SET @ocupacion =	(SELECT ocupacion FROM tContrato WHERE codEmpleado=@codEmpleado AND noContract=@noContrato)
	
	UPDATE tContrato set activo=0,finContract='2022-12-31', comentario='DESPIDO/REORGANIZACION 31/12/2022',motivRetiro='DESPIDO/REORGANIZACION' WHERE noContract=@noContrato
	insert into tContrato(codEmpleado  ,codDepto  ,nomPuesto,fechaIngreso,salarioOrdinario ,bonifDecreto ,bonifExtra ,salarioMensual ,tipoPago ,tipoContract  ,departLab ,muniLab ,timeContract ,jornadaLab ,comentario,motivRetiro,recontratable,codEmpresa,activo,constanciaRetension,idLoteBancario,idLiquidacionIGSS,codCentroTrabajoIGSS,creadoPor,ocupacion)values(
	                       @codEmpleado,@codDepto,@nomPuesto,'2023-01-01',@salarioOrdinario,@BonifDecreto,@bonifExtra,@salarioMensual,@tipoPago,@tipoContract ,@departLab,@muniLab,@timeContract,@jornadaLab,''        ,''         ,1            ,@codEmpresa ,1,@constanciaRetension,@idLoteBancario,@idLiquidacionIGSS,@codCentroTrabajoIGSS,266,@ocupacion)
	select top 1 @nuevoNumeroContrato=noContract from tContrato where codEmpleado=@codEmpleado order by noContract desc
	UPDATE tEmpleado SET noContract=@nuevoNumeroContrato WHERE codEmpleado=@codEmpleado
	FETCH C INTO @codEmpleado,@noContrato
	END
CLOSE C
DEALLOCATE C


