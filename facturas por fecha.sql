SELECT t3.nombre as empresa, T2.tda_nombre as tienda,convert(date,fechaHora) AS fecha, T1.nit,T1.nombre as cliente,t1.uuidFactura, T1.total as totalFactura, T4.descripcion,T4.cantidad,T4.precio, T4.cantidad*T4.precio AS totalLinea
	FROM tFactura T1 
	INNER JOIN tTienda T2 ON T1.empresa=t2.empresa and t1.tienda=t2.tienda 
	INNER JOIN tEmpresa t3 on t1.empresa=t3.empresa
	INNER JOIN tFacturaDetalle T4 ON T1.idFactura=T4.idFactura
	WHERE CONVERT(DATE,T1.fechaHora) between '2023-01-11' and '2023-01-15' and anulada=0 and T1.empresa between 1 and 5