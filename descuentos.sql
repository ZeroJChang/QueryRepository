select * from tDescuento where codEmpleado =26 and idPeriodo=59

		SELECT * FROM tPlanilla WHERE codEmpleado=26 AND idPeriodo=59

		select t2.nombreEmpleado+' '+ISNULL(t2.segundoNombre,'')+' '+ISNULL(t2.apellidoEmpleado,'')+' '+ISNULL(t2.segundoApellido,'')+' '+ISNULL(t2.apellidoCasada,'') as empleado,
				t1.montoDescuento, 		 
				t4.nombrePeriodo,
				t1.comentario,
				t3.nombreEmpleado+' '+ISNULL(t3.apellidoEmpleado,'') AS creadoPor
		from tDescuento t1 
		inner join tEmpleado t2 on t1.codEmpleado=t2.codEmpleado
		inner join tEmpleado t3 on t1.creadoPor=t3.codEmpleado
		inner join tPeriodo t4 on t1.idPeriodo=t4.idPeriodo
		where t1.idPeriodo in(55,56,57,58,59,60,61,62,63,64,65,66,67,68,69) and t1.vigente=0 order by t1.idPeriodo