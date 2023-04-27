USE PINULITO_DIVIDENDOS
--UPDATE tMovimientoBancario SET conciliado=0 where documento='12191510'
--SELECT * FROM tMovimientoBancario T1 INNER JOIN PINULITO_PDV..tDeposito T2 ON T1.idBanco=T2.idBanco AND T1.documento=T2.noBoleta AND T2.estado IN ('NO CONCILIADO') AND T1.monto=T2.monto WHERE T1.conciliado=1 AND T2.Anulado=0 AND T1.fecha>'2023-02-01'
SELECT * FROM tMovimientoBancario where documento='14460323'


use PINULITO_PDV
--SELECT * FROM facAnuluraSap
select * from tdeposito where noboleta='14460323'
--UPDATE tDeposito SET Anulado=1 WHERE idDeposito=516306
