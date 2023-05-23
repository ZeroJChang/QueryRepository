SELECT * FROM tPagoPersonaExtra WHERE codEmpleado='pe0275' AND fechaBoleta='2023-04-04'
SELECT * FROM tMarcaje WHERE alias ='pe0275' AND fecha='2023-04-03'
SELECT * FROM tPagoPersonaExtraDetalle WHERE idPagoPersonaExtra=34742

UPDATE tPagoPersonaExtra SET autorizado=1 WHERE codEmpleado='pe0275' AND fechaBoleta='2023-04-04'


--http://sistema.grupopinulito.com:81/POS/services/personaExtra/generaBoletaPago.php?aliasCodigo=pe0275&idMarcaje =394216
--http://sistema.grupopinulito.com:81/POS/services/formatPagoPE.php?id=34742



