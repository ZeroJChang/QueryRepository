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