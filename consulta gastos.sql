--TABLA GASTO TOTAL
DECLARE @GastoTotal as TABLE (noDoc int,tipoGasto nvarchar(64), descripcion nvarchar (128), monto decimal (10,2), estado nvarchar(64), serie nvarchar(15), numero int)

--TABLA RECIBOS
DECLARE @Recibos as TABLE (noDoc int,tipoGasto nvarchar(64), descripcion nvarchar (128), monto decimal (10,2), estado nvarchar(64),serie nvarchar(15), numero int)

--TABLA FACTURAS
DECLARE @Facturas as TABLE (noDoc int,tipoGasto nvarchar(64), descripcion nvarchar (128), monto decimal (10,2), estado nvarchar(64), serie nvarchar(15), numero int)

--TABLA RENTAS
DECLARE @Rentas as TABLE (noDoc int,tipoGasto nvarchar(64), descripcion nvarchar (128), monto decimal (10,2), estado nvarchar(64), serie nvarchar(15), numero int)

--TABLA VERDURA
DECLARE @Verduras as TABLE (noDoc int,tipoGasto nvarchar(64), descripcion nvarchar (128), monto decimal (10,2), estado nvarchar(64), serie nvarchar(15), numero int)

--TABLA ENERGIA ELECTICA
DECLARE @EnergiaElectrica as TABLE (noDoc int,tipoGasto nvarchar(64), descripcion nvarchar (128), monto decimal (10,2), estado nvarchar(64), serie nvarchar(15), numero int)

DECLARE @fechaInicio date='2023-01-01'
DECLARE @fechaFin date='2023-03-31'

SELECT
t3.nombre AS empresa,
t2.tda_nombre AS tienda,
t1.fechaCompra,
cantCebolla, precioCebolla,
cantLechuga, precioLechuga,
cantPimiento, precioPimiento,
cantRepollo, precioRepollo,
cantZanahoria, precioZanahoria,
cantOtros, precioOtros,
total
FROM tIngresoVerdura t1
inner join tTienda t2 on t1.empresa=t2.empresa and t1.tienda=t2.tienda
inner join tEmpresa t3 on t1.empresa=t2.empresa
WHERE  fechaCompra between @fechaInicio and @fechaFin

--INSERT INTO TABLE @RECIBOS
INSERT INTO @Recibos
SELECT 
idIngresoRecibo, 
'RECIBO' as tipo, 
T2.nombre, 
T1.monto,
'APLICADO' as estado,
'N/A' as serie,
idIngresoRecibo as numero
FROM tIngresoRecibo T1
INNER JOIN tTipoRecibo T2 ON T1.idTipoRecibo = T2.idTipoRecibo
WHERE fecha between @fechaInicio and @fechaFin AND t1.vigente = 1 AND T1.idTipoRecibo ! = 10

--INSERT INTO TABLE @Facturas
INSERT INTO @Facturas
SELECT 
T1.idCompra,
'FACTURA' as tipo,
(SELECT nombre FROM tCompra WHERE idCompra = t1.idCompra) as descripcion,
total,
'APLICADO' as estado,
T1.serie,
T1.numero
FROM tCompra T1
WHERE fechaFactura between @fechaInicio and @fechaFin AND vigente = 1

--INSERT INTO TABLE @Renta
INSERT INTO @Rentas
SELECT
idAbonoRenta,
'RENTA',
'RESERVA RENTA '+mesRenta,
monto,
'APLICADO',
'N/A' as serie,
idAbonoRenta as numero
FROM tAbonoRenta 
WHERE fecha between @fechaInicio and @fechaFin AND vigente = 1

--INSERT INTO TABLE @Verdura
INSERT INTO @Verduras
SELECT
idIngresoVerdura,
'RECIBO VERDURA' as tipo,
'COMPRA DE VERDURA SIN FACTURA',
total,
'APLICADO',
'N/A' as serie,
idIngresoVerdura as numero
FROM tIngresoVerdura 
WHERE  fechaCompra between @fechaInicio and @fechaFin


--INSERT INTO TABLE @EnergiaElectrica
INSERT INTO @EnergiaElectrica
SELECT 
idPagoElectricidad,
'PAGO ELECTRICIDAD',
'PAGO ENERGIA '+empresaElectrica,
montoPago,
'APLICADO',
'N/A' as serie,
idPagoElectricidad as numero
FROM tPagoElectricidad 
WHERE  fechaPago  between @fechaInicio and @fechaFin


--UNIFICAR 
INSERT INTO @GastoTotal
SELECT * FROM @Recibos

INSERT INTO @GastoTotal
SELECT * FROM @Facturas

INSERT INTO @GastoTotal
SELECT * FROM @Rentas

INSERT INTO @GastoTotal
SELECT * FROM @Verduras

INSERT INTO @GastoTotal
SELECT * FROM @EnergiaElectrica

SELECT * FROM @GastoTotal