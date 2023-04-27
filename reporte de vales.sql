SELECT 
		T2.codDepto,
		T5.nombreEmpleado+' '+ISNULL(T5.segundoNombre,'')+' '+ISNULL(T5.apellidoEmpleado,'')+' '+ISNULL(T5.segundoApellido,'')+' '+ISNULL(T5.apellidoCasada,'') AS empleado,
		T6.nombre AS departamento,
		T1.motivo,
		T1.montoTotal,
		T3.tda_nombre AS tiendaDeCanje,
		t4.nombre AS empresaDeCanje,
		T1.fechaCanje		
		FROM tValeComida T1
		INNER JOIN PINULITO_NOMINA..TCONTRATO T2 ON T1.codEmpleado = T2.codEmpleado
		INNER JOIN tTienda T3 ON T1.empresaCanje=T3.EMPRESA and T1.tiendaCanje=T3.tienda
		INNER JOIN tEmpresa T4 on T1.empresaCanje=T4.empresa
		INNER JOIN PINULITO_NOMINA..tEmpleado T5 ON T1.codEmpleado=T5.codEmpleado
		INNER JOIN PINULITO_NOMINA..tDepartamento T6 ON T2.codDepto=T6.codDepto
		where CONVERT(nvarchar,T1.fechaCanje,23) between '2022-08-01' and '2022-08-31' and T2.codDepto in (12,538)
		order by T1.codEmpleado,T1.fechaCanje

