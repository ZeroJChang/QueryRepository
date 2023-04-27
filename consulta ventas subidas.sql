WITH recursive_hijos AS (
  SELECT idProyecto, idPadre, descripcion, esTarea, situacion, estatus
  FROM tProyecto
  WHERE idProyecto = 4
  UNION ALL
  SELECT t.idProyecto, t.idPadre, t.descripcion, t.esTarea, t.situacion, t.estatus
  FROM tProyecto t
  INNER JOIN recursive_hijos rh ON t.idPadre = rh.idProyecto
)
SELECT *
FROM recursive_hijos
WHERE idProyecto <> 4;


SELECT *, CONVERT(varchar, fechaSiguiente, 103) as fechaS  FROM tAnexoRespuesta where idAnexo=$idAnexo and empresa = $empresa and tienda = $tienda
SELECT * FROM TPROYE



WITH recursive_hijos AS (
  SELECT idAnexo, idPadre, nombre, permiteResp, recurrente, vigente
  FROM tanexo
  WHERE idAnexo = 1
  UNION ALL
  SELECT t.idAnexo, t.idPadre, t.nombre, t.permiteResp, t.recurrente, t.vigente
  FROM tanexo t
  INNER JOIN recursive_hijos rh ON t.idPadre = rh.idAnexo
)
SELECT *
FROM recursive_hijos
WHERE idAnexo <> 1;