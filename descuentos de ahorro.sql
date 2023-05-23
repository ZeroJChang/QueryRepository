USE PINULITO_NOMINA
SELECT T4.nombre AS empresa, T3.nombre as tienda, T1.empleado,T1.ahorro,T2.nombrePeriodo FROM TPLANILLA T1
INNER JOIN tPeriodo T2 ON T1.idPeriodo=T2.idPeriodo
INNER JOIN tDepartamento T3 ON T1.departamento=T3.codDepto
INNER JOIN tEmpresa T4 ON T1.idEmpresa=T4.codEmpresa
WHERE T1.IDEMPRESA BETWEEN 6 AND 16 AND T1.idPeriodo >=69
ORDER BY EMPLEADO

