SELECT t0.empresa,t0.tienda,t2.nombreComercial,t2.tda_nombre,
CONVERT(DATE,t0.fechaHora) AS fecha,
SUM(T1.TOTAL) AS Venta,
ISNULL((SELECT SUM(monto) FROM tDeposito WHERE  empresa=t0.empresa AND tienda=t0.tienda  AND fechaVenta=CONVERT(DATE,t0.fechaHora) AND Anulado=0),0) AS Deposito,
ISNULL((SELECT SUM(TOTAL) FROM tCompra WHERE empresa=t0.empresa AND tienda=t0.tienda AND fechaFactura=CONVERT(DATE,t0.fechaHora) AND vigente=1),0) AS Compras,
ISNULL((select SUM(monto) from tIngresoRecibo where empresa=t0.empresa AND tienda=t0.tienda and fecha=CONVERT(DATE,t0.fechaHora) and vigente=1),0) AS Gastos,
ISNULL((SELECT SUM(total) FROM vwTransaccionCredomatic WHERE empresa=t0.empresa AND tienda=t0.tienda AND fecha=CONVERT(DATE,t0.fechaHora)),0)  AS Tarjeta,
ISNULL((SELECT SUM(monto) FROM tPagoPersonaExtra WHERE empresa=t0.empresa AND tienda=t0.tienda AND fechaBoleta=CONVERT(DATE,t0.fechaHora) AND vigente=1 AND autorizado=1),0)  AS PagoPersonaExtra,
ISNULL((SELECT sum(montoPago) FROM tPagoElectricidad WHERE empresa=t0.empresa AND tienda=t0.tienda AND fechaPago=CONVERT(DATE,t0.fechaHora) AND vigente=1),0)  AS PagoElecticidad,
ISNULL((SELECT SUM(monto) FROM tAbonoRenta WHERE empresa=t0.empresa AND tienda=t0.tienda AND fecha=CONVERT(DATE,t0.fechaHora) AND vigente=1 ),0)  AS rentaTienda,
ISNULL((SELECT SUM(total) FROM tIngresoVerdura WHERE empresa=t0.empresa AND tienda=t0.tienda AND fechaCompra=CONVERT(DATE,t0.fechaHora)  AND vigente=1 ),0) AS CompraVerdura
FROM tFactura t0
INNER JOIN tFacturaDetalle t1 ON t0.idFactura = t1.idFactura
INNER JOIN tTienda t2 ON t0.empresa = t2.empresa AND t0.tienda = t2.tienda
WHERE CONVERT(DATE,fechaHora) BETWEEN '2023-01-01' AND '2023-01-31'  and t0.empresa between 1 and 5 and anulada=0 and t2.tda_nombre !='PAN REYES'
group by t2.nombreComercial,t2.tda_nombre,t0.empresa,t0.tienda,CONVERT(DATE,t0.fechaHora)
order by t0.empresa,t0.tienda,CONVERT(DATE,t0.fechaHora)

