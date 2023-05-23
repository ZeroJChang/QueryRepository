DECLARE @tabla as nvarchar(256)

/* RECORDAR QUE SI SE LE HACE ALTER A LA TABLA HAY QUE MODIFICAR MANUALMENTE 
   LA TABLA DE LOG y EL TRIGGER DE LOG */

SET @tabla = 'tVacacionDetalle'; --Nombre de la tabla



/* AQUI EMPIEZA GENERACION DE TABLA Y SCRIPT DE LOGS */

DECLARE @COLUMN_NAME nvarchar(128),
		@DATA_TYPE nvarchar(128),
		@CHARACTER_MAXIMUM_LENGTH int,
		@NUMERIC_PRECISION tinyint, 
		@NUMERIC_SCALE smallint,
		@txtTextos nvarchar(32),
		@txtNumeros nvarchar(32),
		@campos varchar(MAX)

DECLARE @sql as nvarchar(MAX)
SET @sql = 'CREATE TABLE log' + @tabla + '(idLog int primary key identity(1,1), fechaHoraLog datetime default getdate(), usuarioLog nvarchar(128) default SYSTEM_USER	';
SET @campos = '';

DECLARE esquema CURSOR  LOCAL FOR
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE 
FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tabla

OPEN esquema
FETCH esquema INTO @COLUMN_NAME, @DATA_TYPE, @CHARACTER_MAXIMUM_LENGTH, @NUMERIC_PRECISION, @NUMERIC_SCALE

WHILE (@@FETCH_STATUS = 0 )
BEGIN 
	IF (@CHARACTER_MAXIMUM_LENGTH < 0) SET @txtTextos =  '(MAX)'
	ELSE SET @txtTextos =  '(' + CAST(@CHARACTER_MAXIMUM_LENGTH as nvarchar) + ')'

	IF (@NUMERIC_SCALE = 0) SET @txtNumeros = '';
	ELSE SET @txtNumeros = '(' + CAST(@NUMERIC_PRECISION as nvarchar) + ', ' + CAST(@NUMERIC_SCALE as nvarchar) + ')'
	
	SET @sql = @sql + ', [' + @COLUMN_NAME + '] ' + @DATA_TYPE + ISNULL(@txtTextos, '') + ISNULL(@txtNumeros,'')
	SET @campos = @campos + ', [' + @COLUMN_NAME+']'
	

	FETCH esquema INTO @COLUMN_NAME, @DATA_TYPE, @CHARACTER_MAXIMUM_LENGTH, @NUMERIC_PRECISION, @NUMERIC_SCALE

END

CLOSE esquema
DEALLOCATE esquema

SET @sql = @sql + '); '

EXEC (@sql);

SET @sql = 'CREATE OR ALTER TRIGGER trgLog' + @tabla + ' ON ' + @tabla + ' AFTER UPDATE, DELETE AS INSERT INTO log' + @tabla + ' (usuarioLog'
SET @sql = @sql + @campos + ')  SELECT SYSTEM_USER' + @campos + ' FROM deleted;'

EXEC (@sql);

