SELECT t5.idPOS, T3.nombreEmpleado+' '+T3.apellidoEmpleado AS SUPERVISOR ,
T2.nombreEmpleado+' '+T2.apellidoEmpleado AS SUBADMINISTRADOR 
FROM tSubAdministrador T1 
INNER JOIN tEmpleado T2 ON T1.codEmpleado=T2.codEmpleado 
INNER JOIN tEmpleado T3 ON T1.codSupervisor=T3.codEmpleado
inner join tResponsableCentroCosto t4 on t1.codSupervisor=t4.codEmpleado and t4.vigente=1
inner join tDepartamento t5 on t4.codDepto=t5.codDepto and t5.vigencia=1
WHERE t1.VIGENTE=1 ORDER BY SUPERVISOR


SELECT * FROM PINULITO_PDV..tAdministradores ORDER BY SUPERVISOR