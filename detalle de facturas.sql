SELECT T2.descripcion, SUM(t2.cantidad) as cantidad, SUM(t2.total) as monto 
FROM tFactura T1 INNER JOIN tFacturaDetalle T2 ON T1.idFactura=T2.idFactura
WHERE T1.empresa BETWEEN '00001' AND'00005'  AND CONVERT(DATE,fechaHora) BETWEEN '2023-04-10' AND'2023-04-16' AND T2.descripcion LIKE '%barba%' and anulada=0 
group by T2.descripcion 
ORDER BY T2.descripcion