SELECT T4.nombre AS empresa,
		T3.tda_nombre as tienda,
		CONVERT(nvarchar, T1.fechaFactura,103) AS fechaFactura,
		T1.serie,
		T1.numero,
		T2. itemName,
		T2.price,
		T2.quantity,
		t2.price*T2.quantity as totalLinea,
		t1.total as TotalFactura
	FROM tCompra T1 
	INNER JOIN tCompraDetalle T2 ON T1.idCompra=T2.idCompra
	INNER JOIN tTienda T3 ON T1.empresa=T3.empresa AND T1.tienda=T3.tienda
	INNER JOIN tEmpresa T4 ON T1.empresa = T4.empresa
	WHERE T1.fechaFactura BETWEEN '2022-09-01' AND '2022-10-31' AND T1.vigente=1
