SELECT T3.tda_nombre, T2.descripcion, SUM(t2.cantidad) as cantidad, SUM(t2.total) as monto 
FROM tFactura T1 
INNER JOIN tFacturaDetalle T2 ON T1.idFactura=T2.idFactura
INNER JOIN tTienda T3 ON T1.empresa=T3.empresa AND T1.tienda=T3.tienda
WHERE T1.empresa BETWEEN '00001' AND'00005'  AND year(fechaHora) >=2023 AND T2.descripcion LIKE '%verano%' and anulada=0 
group by T2.descripcion,T3.tda_nombre 
ORDER BY T2.descripcion