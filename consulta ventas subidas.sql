SELECT SUM(DocTotal)/1.12 FROM OINV WHERE 
DocDate = '2023-01-10' AND
CArdCode COLLATE DATABASE_DEFAULT in (
    SELECT clienteSAP FROM PINULITO_PDV..tTienda
) AND CANCELED = 'N'

 

 

SELECT * FROM OINV WHERE 
DocDate = '2023-01-13' AND
CArdCode COLLATE DATABASE_DEFAULT in (
    SELECT clienteSAP FROM PINULITO_PDV..tTienda
) AND CANCELED = 'N'

 

 

SELECT t0.total, t2.DocTotal, t0.total - t2.DocTotal ,* FROM PINULITO_PDV..tFacturacionInfile t0
LEFT OUTER JOIN PINULITO_PDV..tTienda t1 ON t0.empresa = t1.empresa AND t0.tienda = t1.tienda
LEFT OUTER JOIN OINV t2 ON t1.clienteSAP COLLATE DATABASE_DEFAULT = t2.CardCode AND t0.fecha = t2.DocDate
WHERE t0.empresa = '00003' AND t0.fecha = '2023-01-10'  AND (( t2.CANCELED = 'N' AND ABS(t0.total - t2.DocTotal) != 0) OR t2.DocNum is null)

SELECT DocEntry,  ItemCode, Dscription, SUM(Quantity) as cantidad, SUM(Price), TaxCode, AcctCode FROM INV1 WHERE DocEntry in (
    SELECT DocEntry FROM OINV WHERE 
DocDate = '2023-01-10' AND --AcctCode != '4110101' AND
CArdCode COLLATE DATABASE_DEFAULT in (
    SELECT clienteSAP FROM PINULITO_PDV..tTienda
) AND Canceled = 'N'
) 
GROUP BY ItemCode, Dscription, TaxCode, AcctCode, DocEntry
ORDER BY SUM(Price)