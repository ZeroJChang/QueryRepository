select t1.iddeposito,t2.tda_nombre,t1.noboleta, t1.fechaVenta, t1.fechaBoleta,t1.monto, 
	ISNULL(DATEDIFF(DAY, t1.fechaVenta, t1.fechaBoleta),0) AS Dias_De_Diferencia
	from tDeposito t1 
	inner join tTienda t2 on t1.empresa=t2.empresa and t1.tienda=t2.tienda
	where CONVERT(date, t1.fechaVenta)between'2023-04-03'and'2023-04-09' AND Anulado=0 and estado !='rechazado' and t2.division = 'LUZ REYES' ORDER BY Dias_De_Diferencia desc 