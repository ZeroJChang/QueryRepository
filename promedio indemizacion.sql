--SELECT * FROM tLiquidacionAConfirmar WHERE codEmpleado=266
--SELECT (SUM(devengado)/6)/6 FROM tSalariosEmpleadoMasi WHERE codEmpleado=266
SELECT 
		
	 T1.codigo, T1.empleado,CAST(((SUM(T2.devengado)/SUM(T2.diasLiquidacion))*30)/6 AS DECIMAL(10,2) )  AS  promedioDevengado,
		CAST((SUM(T2.totalDevengado)/SUM(T2.diasLiquidacion))*30 AS DECIMAL(10,2) )  AS promedioSalario,T1.diasIndemnizacion 
	FROM tCabeceraEmpleadoMasi T1 
	INNER JOIN tSalariosEmpleadoMasi T2 ON T1.codEmpleado=T2.codEmpleado 
	INNER JOIN tLiquidacionAConfirmar T3 ON T1.codEmpleado=T3.codEmpleado	
	WHERE T3.codEmpresa=8 GROUP BY T1.diasIndemnizacion,T1.codEmpleado, T1.codigo, T1.empleado,T1.diasIndemnizacion







	
