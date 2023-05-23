DECLARE @codEmpresa INT = 8
DECLARE @fechaCalculo DATE = '2022-11-11'
DECLARE @fechaCalculoInicial DATE = @fechaCalculo
--select * from tCabeceraEmpleadoMasi WHERE codEmpleado IN (3876)
DELETE tCabeceraEmpresaMasi WHERE codEmpresa = @codEmpresa
DELETE tCabeceraEmpleadoMasi WHERE codEmpleado IN (SELECT CODEMPLEADO FROM tContrato WHERE codEmpresa=@codEmpresa AND activo=1)
DELETE tSalariosEmpleadoMasi WHERE codEmpleado IN (SELECT CODEMPLEADO FROM tContrato WHERE codEmpresa=@codEmpresa AND activo=1)
DELETE tdescuentotemporalliqui WHERE codEmpleado IN (SELECT CODEMPLEADO FROM tContrato WHERE codEmpresa=@codEmpresa AND activo=1)
DELETE tbonoAguinaldoLiqui WHERE codEmpleado IN (SELECT CODEMPLEADO FROM tContrato WHERE codEmpresa=@codEmpresa AND activo=1)

INSERT INTO tCabeceraEmpresaMasi
SELECT codEmpresa, nombre, nombreComercial, nit, nombreCorto, YEAR(GETDATE()) AS anioActual FROM tEmpresa WHERE codEmpresa = @codEmpresa

INSERT INTO tCabeceraEmpleadoMasi
SELECT t0.codEmpleado, aliasCodigo AS codigo, t1.nombreEmpleado, t1.segundoNombre, t1.apellidoEmpleado, t1.segundoApellido, t1.apellidoCasada, 
t0.nomPuesto, CONVERT(varchar, t0.fechaIngreso, 103) as fechaIngreso, CONVERT(varchar,@fechaCalculoInicial,103) as finContract, t0.salarioOrdinario, t0.bonifDecreto, t0.motivRetiro,
periodoAguinaldo = 
CASE  
	WHEN (MONTH(@fechaCalculo) = 12) THEN 
		CASE WHEN DATEFROMPARTS(YEAR(@fechaCalculo), 12, 1) > t0.fechaIngreso THEN CONVERT(varchar, DATEFROMPARTS(YEAR(@fechaCalculo), 12, 1), 103)
		ELSE CONVERT(varchar, t0.fechaIngreso, 103) END 
	ELSE 
		CASE WHEN DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 12, 1) > t0.fechaIngreso THEN CONVERT(varchar, DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 12, 1), 103)
		ELSE CONVERT(varchar, t0.fechaIngreso, 103) END
	END,
periodoBono = 
CASE  
	WHEN (MONTH(@fechaCalculo) > 6) THEN 
		CASE WHEN DATEFROMPARTS(YEAR(@fechaCalculo), 7, 1) > t0.fechaIngreso THEN CONVERT(varchar, DATEFROMPARTS(YEAR(@fechaCalculo), 7, 1), 103)
		ELSE CONVERT(varchar, t0.fechaIngreso, 103) END 
	ELSE 
		CASE WHEN DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 7, 1) > t0.fechaIngreso THEN CONVERT(varchar, DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 7, 1), 103)
		ELSE CONVERT(varchar, t0.fechaIngreso, 103) END
	END,
t1.nombreEmpleado+' '+ISNULL(t1.segundoNombre,'')+' '+ISNULL(t1.apellidoEmpleado,'')+' '+ISNULL(t1.segundoApellido,'')+' '+ISNULL(t1.apellidoCasada,'') AS empleado,
t3.nombre as centroCosto,
DATEDIFF (DAY, t0.fechaIngreso , DATEADD(DAY,1, @fechaCalculoInicial) ) as diasIndenmizacion,
null,null,null,null
FROM tContrato t0
INNER JOIN tEmpleado t1 ON t0.codEmpleado = t1.codEmpleado
INNER JOIN tDepartamento t3 ON t0.codDepto=t3.codDepto
WHERE t0.activo = 1 AND t0.codEmpresa = @codEmpresa and t0.fechaIngreso < DATEADD(MONTH,-1,@fechaCalculoInicial)
ORDER BY t0.codEmpleado



DECLARE @planillas as TABLE (
	id int identity(1,1),
	[año] int,
	mes int,
	fechaIngreso date,
	codEmpleado int,
	nombreEmpleado nvarchar(256),
	segundoNombre nvarchar(256),
	apellidoEmpleado nvarchar(256),
	segundoApellido nvarchar(256),
	apellidoCasada nvarchar(256),
	salarioMensual decimal(10,2),
	sSimples decimal(10,2),
	sDobles decimal(10,2),
	diasReal int,
	diasLiquidacion int,
	devengado decimal(10,2)
);
DECLARE @salariosTemporal as TABLE (
	id int identity(1,1),
	[año] int,
	mes int,
	fechaIngreso date,
	codEmpleado int,
	nombreEmpleado nvarchar(256),
	segundoNombre nvarchar(256),
	apellidoEmpleado nvarchar(256),
	segundoApellido nvarchar(256),
	apellidoCasada nvarchar(256),
	salarioMensual decimal(10,2),
	sSimples decimal(10,2),
	sDobles decimal(10,2),
	diasReal int,
	diasLiquidacion int,
	devengado decimal(10,2)
);
DECLARE @salarios as TABLE (
	id int identity(1,1),
	[año] int,
	mes int,
	fechaIngreso date,
	codEmpleado int,
	nombreEmpleado nvarchar(256),
	segundoNombre nvarchar(256),
	apellidoEmpleado nvarchar(256),
	segundoApellido nvarchar(256),
	apellidoCasada nvarchar(256),
	salarioMensual decimal(10,2),
	sSimples decimal(10,2),
	sDobles decimal(10,2),
	diasReal int,
	diasLiquidacion int,
	devengado decimal(10,2)
);

DECLARE @anioBono int 
DECLARE @anioAguinaldo int
DECLARE @fechaIngreso int
DECLARE @empleadoCodigo int

DECLARE C21 CURSOR
	FOR SELECT codEmpleado, YEAR(periodoAguinaldo),YEAR(periodoBono), YEAR(fechaIngreso) FROM tCabeceraEmpleadoMasi WHERE codEmpleado IN (SELECT CODEMPLEADO FROM tContrato WHERE codEmpresa=@codEmpresa AND activo=1) order by codEmpleado
OPEN C21
FETCH C21 INTO @empleadoCodigo, @anioAguinaldo, @anioBono,@fechaIngreso
	while(@@fetch_status=0)
	BEGIN

	UPDATE tCabeceraEmpleadoMasi 
	SET diasAguinaldo= DATEDIFF (DAY, periodoAguinaldo , DATEADD(DAY,1, @fechaCalculoInicial) ),
	diasBono14= DATEDIFF (DAY, periodoBono , DATEADD(DAY,1, @fechaCalculoInicial) ),
	diasVacaPropo=(
		SELECT  CASE WHEN diasVacacionesProporcionales > 364 THEN 0 ELSE diasVacacionesProporcionales END as vacacionesProporcionales FROM (
		SELECT *, DATEDIFF(DAY, ultimoPeriodo, @fechaCalculoInicial)   + 1 as diasVacacionesProporcionales FROM (
			SELECT codEmpleado, fechaIngreso, CASE
			WHEN DATEFROMPARTS(YEAR(@fechaCalculoInicial), MONTH(fechaIngreso), DAY(fechaIngreso)) < @fechaCalculoInicial THEN DATEFROMPARTS(YEAR(@fechaCalculoInicial), MONTH(fechaIngreso), DAY(fechaIngreso))
			ELSE
				DATEFROMPARTS(YEAR(@fechaCalculoInicial) - 1, MONTH(fechaIngreso), DAY(fechaIngreso))
				END ultimoPeriodo
			FROM tContrato
			WHERE codEmpresa = @codEmpresa AND codEmpleado = @empleadoCodigo AND activo=1
		) x ) k
	),
	diasVacaPendiente=(
		SELECT  periodosPagar = (CASE WHEN periodosPendientes > 5 THEN 5 ELSE periodosPendientes END)*365 FROM (
		SELECT * ,
		DATEDIFF(DAY, UltimasVacaciones, @fechaCalculoInicial) /364 as periodosPendientes
		FROM (
			SELECT TOP 1 t0.codEmpleado, t0.fechaIngreso,  ISNULL(DATEADD(YEAR, 1, DATEADD(DAY, 1,t1.ultimasVacaciones)), t0.fechaIngreso)  as UltimasVacaciones, ISNULL( (DATEADD(DAY, 1,t1.ultimasVacaciones)), t0.fechaIngreso)  as UltimasVacacionesGozadas
			FROM tContrato t0
			LEFT OUTER JOIN tVacacion t1 ON t0.codEmpleado = t1.codEmpleado AND t1.vigente=1 AND DATEADD(YEAR, 1, t1.ultimasVacaciones) > t0.fechaIngreso
			WHERE codEmpresa = @codEmpresa AND t0.activo=1 AND t0.codEmpleado = @empleadoCodigo order by t1.ultimasVacaciones desc) x ) k
	)
	where codEmpleado=@empleadoCodigo

	DELETE @planillas
	insert into @planillas
	SELECT YEAR(t3.fechaInicio) as [año], MONTH(t3.fechaInicio) as mes, t2.fechaIngreso, t1.codEmpleado,
		t1.nombreEmpleado, t1.segundoNombre, t1.apellidoEmpleado, t1.segundoApellido, t1.apellidoCasada,  AVG(t0.salarioMensual) as salarioMensual,
		SUM(sSimples) as sSimples, SUM(sDobles) as sDobles,
			CASE
		WHEN t2.fechaIngreso <= DATEFROMPARTS(YEAR(t3.fechaInicio), MONTH(t3.fechaInicio), 01) THEN 30
		ELSE 31 - DAY(fechaIngreso) END as diasReal, NULL, NULL
		FROM tPlanilla t0
		INNER JOIN tEmpleado t1 ON t0.codEmpleado = t1.codEmpleado
		INNER JOIN tContrato t2 ON t0.codEmpleado = t2.codEmpleado AND (finContract>=DATEADD(DAY,-1, @fechaCalculo) OR finContract IS NULL OR finContract='1900-01-01')
		INNER JOIN tPeriodo t3 ON t0.idPeriodo = t3.idPeriodo
		WHERE t0.idEmpresa = @codEmpresa AND t0.codEmpleado=@empleadoCodigo AND
		t3.fechaInicio >= DATEADD(YEAR, -1, @fechaCalculo) AND t2.fechaIngreso <= t3.fechaFin AND (YEAR(t3.fechaInicio)< YEAR(@fechaCalculo) OR MONTH(t3.fechaInicio) < MONTH(@fechaCalculo))
		AND t3.fechaInicio <= @fechaCalculo 
		GROUP BY t1.codEmpleado, t1.nombreEmpleado, t1.segundoNombre, t1.apellidoEmpleado, t1.segundoApellido, t1.apellidoCasada, YEAR(t3.fechaInicio) , MONTH(t3.fechaInicio), t2.fechaIngreso
	
	DELETE @salariosTemporal
	insert into @salariosTemporal
	SELECT YEAR(t3.fechaInicio) as [año], MONTH(t3.fechaInicio) as mes, t2.fechaIngreso, t1.codEmpleado,
		t1.nombreEmpleado, t1.segundoNombre, t1.apellidoEmpleado, t1.segundoApellido, t1.apellidoCasada,  AVG(t0.salarioMensual) as salarioMensual,
		SUM(sSimples) as sSimples, SUM(sDobles) as sDobles,
			CASE
		WHEN t2.fechaIngreso <= DATEFROMPARTS(YEAR(t3.fechaInicio), MONTH(t3.fechaInicio), 01) THEN 30
		ELSE 31 - DAY(fechaIngreso) END as diasReal, NULL, NULL
		FROM tPlanillaTemporal t0
		INNER JOIN tEmpleado t1 ON t0.codEmpleado = t1.codEmpleado
		INNER JOIN tContrato t2 ON t0.codEmpleado = t2.codEmpleado AND T2.ACTIVO=1
		INNER JOIN tPeriodo t3 ON t0.idPeriodo = t3.idPeriodo
		WHERE t0.idEmpresa = @codEmpresa AND t0.codEmpleado=@empleadoCodigo AND
		t3.fechaInicio >= DATEADD(YEAR, -1, @fechaCalculo) AND t2.fechaIngreso <= t3.fechaFin AND (YEAR(t3.fechaInicio)<= YEAR(@fechaCalculo) OR MONTH(t3.fechaInicio) <= MONTH(@fechaCalculo))
		AND t3.fechaInicio <= @fechaCalculo 
		GROUP BY t1.codEmpleado, t1.nombreEmpleado, t1.segundoNombre, t1.apellidoEmpleado, t1.segundoApellido, t1.apellidoCasada, YEAR(t3.fechaInicio) , MONTH(t3.fechaInicio), t2.fechaIngreso
	
	DELETE @salarios
	INSERT INTO @salarios
	SELECT año,mes,fechaIngreso,codEmpleado,nombreEmpleado,segundoNombre,apellidoEmpleado,segundoApellido,apellidoCasada,salarioMensual,sSimples,sDobles,diasReal,diasLiquidacion,devengado FROM @planillas
	UNION ALL
	SELECT año,mes,fechaIngreso,codEmpleado,nombreEmpleado,segundoNombre,apellidoEmpleado,segundoApellido,apellidoCasada,salarioMensual,sSimples,sDobles,diasReal,diasLiquidacion,devengado FROM @salariosTemporal WHERE año=(SELECT TOP 1 año FROM @planillas ORDER BY id DESC) and mes>(SELECT TOP 1 mes FROM @planillas ORDER BY id DESC)

DECLARE @dias180 INT = 180
DECLARE @diaMesCalculo INT = 0

IF( DAY(@fechaCalculoInicial) > 30 ) BEGIN SET @diaMesCalculo = 30 END ELSE BEGIN SET @diaMesCalculo= DAY(@fechaCalculoInicial)END
UPDATE @salarios SET diasReal = @diaMesCalculo, salarioMensual=(salarioMensual/30)*@diaMesCalculo WHERE mes= MONTH(@fechaCalculoInicial) AND año = YEAR(@fechaCalculoInicial)

DECLARE @codEmpleado int = 0
DECLARE @codEmpleadoActual int = 0
DECLARE @an int
DECLARE @mes int
DECLARE @diasAcumulado int = 0
DECLARE @diasReal int
DECLARE @diasLiquidacion int = 0
DECLARE @id INT = 0
DECLARE @promedioDevengado DECIMAL(10,2) = 0.00
DECLARE @promedioTotalDevengado DECIMAL(10,2) = 0.00

DECLARE @fechaAguinaldo INT
IF @fechaIngreso=YEAR(@fechaCalculoInicial) and  MONTH(@fechaCalculoInicial)<12
BEGIN
	SET @fechaAguinaldo=@fechaIngreso
END
ELSE
BEGIN
	SET @fechaAguinaldo=@anioAguinaldo+1
END

DECLARE c1 CURSOR 
	FOR SELECT id,[año], mes, codEmpleado, diasReal FROM @salarios ORDER BY codEmpleado ASC, [año] DESC, mes DESC
OPEN c1
FETCH c1 INTO @id, @an, @mes, @codEmpleado, @diasReal
while(@@fetch_status=0)
BEGIN
	
	IF (@dias180>0)
	BEGIN	
		IF (@dias180<=30 AND @dias180>0)
		BEGIN
			UPDATE @salarios SET diasReal=@dias180, salarioMensual=(salarioMensual/30)*@dias180, sSimples=(sSimples/30)*@dias180, sDobles=(sDobles/30)*@dias180 WHERE id=@id
			INSERT INTO tbonoAguinaldoLiqui
			SELECT 
				[año],
				T1.mes,
				T2.nombre,
				T1.codEmpleado,
				CASE
					WHEN ([año] = @anioBono AND T1.mes >= 7) OR ([año] = @anioBono + 1) THEN (T1.salarioMensual/30)*T1.diasReal 
					ELSE 0 END as Bono,
				CASE
					WHEN ([año] = @anioAguinaldo AND T1.mes >= 12) OR ([año] = @fechaAguinaldo) THEN (T1.salarioMensual/30)*T1.diasReal  
					ELSE 0 END as Aguinaldo
			FROM @salarios T1 INNER JOIN tMes T2 ON T1.mes=T2.mes
			WHERE T1.id=@id
			
			INSERT INTO tSalariosEmpleadoMasi
			SELECT codEmpleado, [año], t0.mes, t1.nombre, salarioMensual, sSimples, sDobles, diasReal as diasLiquidacion, (salarioMensual/30)*diasReal as devengado, ((salarioMensual + sSimples + sDobles)/30)*diasReal as totalDevengado FROM @salarios t0
			INNER JOIN tMes t1 ON t0.mes = t1.mes
			where id=@id			
		END
		ELSE IF (@dias180>30)
		BEGIN
			INSERT INTO tSalariosEmpleadoMasi	
			SELECT codEmpleado, [año], t0.mes, t1.nombre, salarioMensual, sSimples, sDobles, diasReal as diasLiquidacion,  (salarioMensual/30)*diasReal as devengado, ((salarioMensual + sSimples + sDobles)/30)*diasReal as totalDevengado FROM @salarios t0
			INNER JOIN tMes t1 ON t0.mes = t1.mes
			where id=@id
			
			
			INSERT INTO tbonoAguinaldoLiqui
			SELECT 
				[año],
				T1.mes,
				T2.nombre,
				T1.codEmpleado,
				CASE
					WHEN ([año] = @anioBono AND T1.mes >= 7) OR ([año] = @anioBono + 1) THEN (salarioMensual/30)*diasReal 
					ELSE 0 END as Bono,
				CASE
					WHEN ([año] = @anioAguinaldo AND T1.mes >= 12) OR ([año] = @fechaAguinaldo) THEN (salarioMensual/30)*diasReal 
					ELSE 0 END as Aguinaldo
			FROM @salarios T1 INNER JOIN tMes T2 ON T1.mes=T2.mes
			WHERE T1.id=@id

		END
		ELSE IF (@dias180=0)
		BEGIN
			INSERT INTO tSalariosEmpleadoMasi	
			SELECT codEmpleado, [año], t0.mes, t1.nombre, salarioMensual, sSimples, sDobles, diasReal as diasLiquidacion,  (salarioMensual/30)*diasReal as devengado, ((salarioMensual + sSimples + sDobles)/30)*diasReal as totalDevengado FROM @salarios t0
			INNER JOIN tMes t1 ON t0.mes = t1.mes
			where id=@id

			INSERT INTO tbonoAguinaldoLiqui
			SELECT 
				[año],
				T1.mes,
				T2.nombre,
				T1.codEmpleado,
				CASE
					WHEN ([año] = @anioBono AND T1.mes >= 7) OR ([año] = @anioBono + 1) THEN (salarioMensual/30)*diasReal 
					ELSE 0 END as Bono,
				CASE
					WHEN ([año] = @anioAguinaldo AND T1.mes >= 12) OR ([año] = @fechaAguinaldo) THEN (salarioMensual/30)*diasReal 
					ELSE 0 END as Aguinaldo
			FROM @salarios T1 INNER JOIN tMes T2 ON T1.mes=T2.mes
			WHERE T1.id=@id
		END		
		SET @dias180 = @dias180-@diasReal
	END
	ELSE
		BEGIN
			INSERT INTO tbonoAguinaldoLiqui
			SELECT 
				[año],
				T1.mes,
				T2.nombre,
				T1.codEmpleado,
				CASE
					WHEN ([año] = @anioBono AND T1.mes >= 7) OR ([año] = @anioBono + 1) THEN  (salarioMensual/30)*diasReal 
					ELSE 0 END as Bono,
				CASE
					WHEN ([año] = @anioAguinaldo AND T1.mes >= 12) OR ([año] = @fechaAguinaldo) THEN (salarioMensual/30)*diasReal 
					ELSE 0 END as Aguinaldo
			FROM @salarios T1 INNER JOIN tMes T2 ON T1.mes=T2.mes
			WHERE T1.id=@id
		END
FETCH c1 INTO @id, @an, @mes, @codEmpleado, @diasReal
END
CLOSE c1
DEALLOCATE c1

insert into tdescuentotemporalliqui
SELECT t1.codEmpleado, SUM(T1.montoDescuento) AS descuento
		FROM tDescuento T1  
		INNER JOIN tPeriodo T2 ON T1.idPeriodo = T2.idPeriodo
		WHERE T2.fechaInicio>@fechaCalculoInicial AND T1.codEmpleado=@empleadoCodigo and T1.idTipoDescuento <> 23
		GROUP BY T1.codEmpleado

FETCH C21 INTO @empleadoCodigo, @anioAguinaldo, @anioBono,@fechaIngreso
	END
CLOSE C21
DEALLOCATE C21


		--DECLARE @vJas nvarchar (MAX) =  '276'  ;

		--DECLARE @var NVARCHAR(MAX) = 'SELECT	
		--T1.codEmpleado,
		--t3.nombreComercial as empresa, 
		--T1.codigo+'' ''+T1.empleado as trabajador,
		--T1.centoCosto,
		--T1.nomPuesto,
		--T1.fechaIngreso,
		--T1.finContract,
		--T1.salarioOrdinario,
		--T1.bonifDecreto,
		--''Despido'' as motivoRetiro,
		--T1.periodoAguinaldo,
		--T1.periodoBono,
		--T1.diasIndemnizacion,
		--T1.diasAguinaldo,
		--T1.diasBono14,
		--T1.diasVacaPendiente,
		--T1.diasVacaPropo,
		--CAST((SUM(T4.devengado)/SUM(T4.diasLiquidacion))*30 )  AS  promedioDevengado,
		--CAST((SUM(T4.totalDevengado)/SUM(T4.diasLiquidacion))*30 AS DECIMAL(10,2)) AS promedioTotalDevengado
		--FROM tCabeceraEmpleadoMasi T1 
		--INNER JOIN tContrato T2 ON T1.codEmpleado=T2.codEmpleado AND T2.activo=1
		--INNER JOIN tCabeceraEmpresaMasi T3 ON T2.codEmpresa=T3.codEmpresa
		--INNER JOIN tSalariosEmpleadoMasi T4 ON T1.codEmpleado=T4.codEmpleado
		--WHERE T1.codEmpleado IN ('+ @vJas + ')
		--GROUP BY t3.nombreComercial,T1.codigo,T1.empleado,T1.centoCosto,T1.nomPuesto,T1.fechaIngreso,T1.finContract,T1.salarioOrdinario,
		--T1.bonifDecreto,T1.periodoAguinaldo,T1.periodoBono,T1.diasIndemnizacion,T1.diasAguinaldo,T1.diasBono14,T1.diasVacaPendiente,
		--T1.diasVacaPropo,T1.codEmpleado'

		--EXEC (@var)

--select SUM(T6.bono) AS bono ,SUM(T6.aguinaldo) as aguinaldo from tbonoAguinaldoLiqui T6 where codempleado=320


--EXEC [dbo].[spLiquiMasivo] 14,'2022-11-30'
