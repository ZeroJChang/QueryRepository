USE grupopinulito
SELECT empresa,tienda FROM tRutasEnvio  WHERE Serie is null and fecha='2023-03-06'

SELECT T1.empresa,T1.tienda, T1.IdVehiculo as PLACA, T2.direccion AS DIRECCION, T2.tda_nombre AS TIENDA, ISNULL(T2.latitudGps,'') AS altitud, ISNULL(T2.altitudGps,'') as longitud FROM tRutasEnvio T1 INNER JOIN PINULITO_PDV..tTienda T2 ON T1.empresa=T2.empresa AND T1.tienda=T2.tienda WHERE T1.fecha='2023-03-07' and T2.inactiva=0 AND T1.idenvio IS NOT NULL ORDER BY IdVehiculo

SELECT * FROM tRutasEnvio WHERE empresa+'-'+tienda IN (SELECT T1.empresa+'-'+T1.tienda FROM tRutasEnvio T1 INNER JOIN PINULITO_PDV..tTienda T2 ON T1.empresa=T2.empresa AND T1.tienda=T2.tienda WHERE T1.fecha='2023-03-07' and T2.inactiva=0 AND T1.IdVehiculo IS NULL) AND fecha='2023-03-07'

SELECT * FROM logtRutasEnvio WHERE empresa ='00001' AND tienda='00012' AND fecha='2023-03-07'
SELECT * FROM tRutasEnvio WHERE empresa ='00001' AND tienda='00012' AND fecha='2023-03-07'


USE PINULITO_PDV
select * from tTienda
SELECT idTienda, tda_nombre as tienda, direccion, inactiva FROM PINULITO_PDV..TTIENDA WHERE empresa='00020'

SELECT t1.cardCode,T2.CardName, t1.itemCode,precioAutorizado, (SELECT top 1 Dscription FROM DB_22_CORPORACION..INV1 WHERE ITEMCODE=t1.itemCode COLLATE DATABASE_DEFAULT GROUP BY Dscription ) AS descripcion
	FROM TPRECIOPROVEEDORBODEGA  t1 
	INNER JOIN DB_22_CORPORACION..OCRD T2 ON T1.cardCode=t2.CardCode COLLATE DATABASE_DEFAULT

	delete tSolicitudDetalleBodega WHERE IDDETALLE=519

	SELECT * FROM PINULITO_NOMINA..tEmpleado where aliasCodigo='AP2817'

	USE PINULITO_NOMINA
	SET LANGUAGE ESPAÑOL;
SELECT T0.nombreEmpleado+' '+T0.segundoNombre+' '+T0.apellidoEmpleado+' '+T0.segundoApellido AS nombre
		,DATENAME(month,T0.fechaNac) AS mes
		,T1.codEmpresa
		,day(t0.fechaNac) AS dia
		,T2.nombre AS empresa
		,T3.nombre AS departamento
		,T1.nomPuesto AS puesto
        ,CONVERT(nvarchar,T1.fechaIngreso,103) AS fechaIngreso
		,T5.nombreEmpleado+' '+T5.segundoNombre+' '+T5.apellidoEmpleado+' '+T5.segundoApellido AS nombreSupervisor
		FROM tEmpleado T0
		INNER JOIN tContrato T1 ON T0.noContract = T1.noContract
		INNER JOIN tEmpresa T2 ON T1.codEmpresa = T2.codEmpresa
		INNER JOIN tDepartamento T3 ON T1.codDepto =T3.codDepto	
		LEFT JOIN tResponsableCentroCosto t4 on T1.codDepto=t4.codDepto and t4.vigente=1
		LEFT JOIN tEmpleado T5 ON t4.codEmpleado=T5.codEmpleado	
        WHERE MONTH(T0.fechaNac)=3 AND T1.codEmpresa=8 AND T1.activo = 1
	order by day(T0.fechaNac)
		

	SELECT t2.idSolicitud, concat(nombreEmpleado,' ', apellidoEmpleado) as solicitante,
	   CONVERT(nvarchar, fechaRegistro,103) as fecha_Solicitud,
	   	   t2.vigencia,
	   t2.situacion,
	   t2.comentario,
	   t2.autoriza,
	   t2.revisado,
	   case WHEN '3634' = 3634
	       THEN 1
	       ELSE 0
	   END AS firma,
       CASE WHEN '$usuarioActual' = 49
           THEN 1
           ELSE 0
       END AS autorizador,    
	       as usuario
FROM PINULITO_NOMINA..TEMPLEADO T1 
INNER JOIN tSolicitudBodega t2 ON t2.usuario = T1.codEmpleado
ORDER BY fechaRegistro ASC
	
	