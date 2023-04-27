--SELECT T1.aliasCodigo AS CODIGO,
--		T1.nombreEmpleado+' '+ISNULL(T1.segundoNombre,'')+' '+ISNULL(T1.apellidoEmpleado,'')+' '+ISNULL(T1.segundoApellido,'')+' '+ISNULL(T1.apellidoCasada,'') AS EMPLEADO,
--		CASE
--			WHEN T2.activo=1
--			THEN 'ACTIVO'
--			ELSE 'INACTIVO'
--		END AS ESTADO,
--		CASE	
--			WHEN T2.finContract IS NULL OR T2.finContract='1900-01-01'
--			THEN NULL
--			ELSE CONVERT(nvarchar, T2.finContract,103)
--		END AS FECHAFINDECONTRATO,
--		T3.nombre AS TIENDA
--	FROM tEmpleado T1 
--	INNER JOIN tContrato T2 ON T1.noContract=T2.noContract 
--	INNER JOIN tDepartamento T3 ON T2.codDepto=T3.codDepto
--	INNER JOIN tEmpresa T4 ON T2.codEmpresa=T4.codEmpresa
--	WHERE T2.codEmpresa BETWEEN 1 AND 5
--	ORDER BY T1.codEmpleado


SELECT  T1.codigoPersonaExtra AS CODIGO,
		T1.primerNombre+' '+ISNULL(T1.segundoNombre,'')+' '+ISNULL(T1.primerApellido,'')+' '+ISNULL(T1.segundoApellido,'') AS EMPLEADO,
		CASE
			WHEN T1.vigente=1
			THEN 'ACTIVO'
			ELSE 'INACTIVO'
		END ESTADO,
		CASE
			WHEN T3.tda_nombre IS NULL
			THEN 'NINGUNA ASIGNADA'
			ELSE T3.tda_nombre
		END AS TIENDA
	FROM tPersonaExtra T1
	left JOIN PINULITO_PDV..tAsignacionTienda T2 ON T2.codEmpleado='999'+RIGHT(T1.codigoPersonaExtra, LEN(T1.codigoPersonaExtra) - 2) and T2.vigente=1
	LEFT JOIN PINULITO_PDV..tTienda T3 ON T2.empresa=T3.empresa AND T2.tienda=T3.tienda





