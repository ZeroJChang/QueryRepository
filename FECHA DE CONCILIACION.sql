select t1.iddeposito,t2.tda_nombre, t1.fechaCrea, t1.noboleta,
	ISNULL(DATEDIFF(SECOND, t1.fechaCrea, t1.fechaHoraConciliacion),0) / 86400 AS Días,
	ISNULL(DATEDIFF(SECOND, t1.fechaCrea, t1.fechaHoraConciliacion),0) % 86400 / 3600 AS Horas,
	ISNULL(DATEDIFF(SECOND, t1.fechaCrea, t1.fechaHoraConciliacion),0) % 3600 / 60 AS Minutos,
	ISNULL(DATEDIFF(SECOND, t1.fechaCrea, t1.fechaHoraConciliacion),0) % 60 AS Segundos
	from tDeposito t1 
	inner join tTienda t2 on t1.empresa=t2.empresa and t1.tienda=t2.tienda
	where CONVERT(date, t1.fechaCrea)between'2023-03-27'and'2023-04-02' AND Anulado=0  AND t1.creadoPor != t1.usuarioConciliacion