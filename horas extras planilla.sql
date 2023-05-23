



select T2.aliasCodigo from tContrato T1 INNER JOIN tEmpleado T2 ON T1.codEmpleado=T2.codEmpleado where codDepto IN (SELECT codDepto FROM tDepartamento WHERE nombre IN( 'ALOTENANGO','CIUDAD VIEJA','JOCOTENANGO','SANTA MARIA DE JESUS','SAN MIGUEL DUEÑAS','SAN PEDRO LAS HUERTAS','SAN ANTONIO AGUAS CALIENTES'))
SELECT * FROM tHoraExtra  WHERE codEmpleado IN (select codEmpleado from tContrato where codDepto IN (SELECT codDepto FROM tDepartamento WHERE nombre IN( 'ALOTENANGO','CIUDAD VIEJA','JOCOTENANGO','SANTA MARIA DE JESUS','SAN MIGUEL DUEÑAS','SAN PEDRO LAS HUERTAS','SAN ANTONIO AGUAS CALIENTES')) AND activo=1) AND idPeriodo IN (67,68)

