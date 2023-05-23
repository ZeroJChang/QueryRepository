SELECT T3.nombre AS empresa, T2.tda_nombre as tienda, T1.fechaFactura, T1.fechaPago, T1.montoPago FROM PINULITO_PDV..tPagoElectricidad T1
INNER JOIN tTienda T2 ON T1.empresa =T2.empresa  AND T1.tienda=T2.tienda
INNER JOIN tEmpresa T3 ON T1.empresa = T3.empresa
where T1.empresa='00003' AND T1.tienda='00049'