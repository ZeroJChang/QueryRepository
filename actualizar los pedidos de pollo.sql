DECLARE @empresa nvarchar(5)
DECLARE @tienda nvarchar(5)
DECLARE @fecha date
DECLARE @origen nvarchar(6)
DECLARE @serie nvarchar(3)
DECLARE @idvehiculo nvarchar(7)
DECLARE @piloto nvarchar(32)
DECLARE @despachador nvarchar(32)
DECLARE @idenvio int
DECLARE @fechaEnvio date = '2023-02-09'
DECLARE @ptv1 int
DECLARE @ptv2 int
DECLARE @ptv3 int
DECLARE @ptv4 int
DECLARE @ptv5 int
DECLARE @ptv6 int
DECLARE @ptv7 int
DECLARE @ptv8 int
DECLARE @ptv9 int
DECLARE @ptv10 int
DECLARE @ptv11 int
DECLARE @ptv12 int
DECLARE @ptv13 int
DECLARE @ptv15 int
DECLARE @p010171 int
DECLARE C21 CURSOR
	FOR SELECT empresa,tienda FROM tRutasEnvio  WHERE Serie is null and fecha=@fechaEnvio
	--SELECT empresa,tienda,fecha,origen,Serie,IdVehiculo,Piloto,Despachador,idenvio FROM logtRutasEnvio WHERE fecha ='2023-01-12' and serie='ag2'
OPEN C21
FETCH C21 INTO @empresa, @tienda
	--, @fecha,@origen,@serie,@idvehiculo,@piloto,@despachador,@idenvio
	while(@@fetch_status=0)
	BEGIN
	set @origen = (SELECT top 1 origen FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @serie = (SELECT top 1 Serie FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @idvehiculo = (SELECT top 1 IdVehiculo FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @piloto = (SELECT top 1 Piloto FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @despachador = (SELECT top 1 Despachador FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @idenvio = (SELECT top 1 idenvio FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv1 = (SELECT top 1 [PTV-001] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv2 = (SELECT top 1 [PTV-002] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv3 = (SELECT top 1 [PTV-003] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv4 = (SELECT top 1 [PTV-004] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv5 = (SELECT top 1 [PTV-005] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv6 = (SELECT top 1 [PTV-006] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv7 = (SELECT top 1 [PTV-007] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv8 = (SELECT top 1 [PTV-008] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv9 = (SELECT top 1 [PTV-009] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv10 = (SELECT top 1 [PTV-010] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv11 = (SELECT top 1 [PTV-011] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv12 = (SELECT top 1 [PTV-012] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv13 = (SELECT top 1 [PTV-013] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @ptv15 = (SELECT top 1 [PTV-015] FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	set @p010171 = (SELECT top 1 P010171 FROM logtRutasEnvio WHERE fecha =@fechaEnvio and serie='ag2' and empresa=@empresa and tienda=@tienda order by fecha desc)
	if @origen <> ''
	begin 
		UPDATE tRutasEnvio SET Origen=@origen,Serie=@serie,IdVehiculo=@idvehiculo,Piloto=@piloto,Despachador=@despachador,idenvio=@idenvio,[PTV-001]=@ptv1
		,[PTV-002]=@ptv2,[PTV-003]=@ptv3,[PTV-004]=@ptv4,[PTV-005]=@ptv5,[PTV-006]=@ptv6,[PTV-007]=@ptv7,[PTV-008]=@ptv8,[PTV-009]=@ptv9,[PTV-010]=@ptv10,[PTV-011]=@ptv11
		,[PTV-012]=@ptv12,[PTV-013]=@ptv13,[PTV-015]=@ptv15 WHERE empresa=@empresa AND tienda=@tienda AND fecha=@fechaEnvio
	end

	--select @empresa, @tienda, @fecha,@origen,@serie,@idvehiculo,@piloto,@despachador,@idenvio
FETCH C21 INTO @empresa, @tienda
	--, @fecha,@origen,@serie,@idvehiculo,@piloto,@despachador,@idenvio
	END
CLOSE C21
DEALLOCATE C21

--SELECT empresa,tienda,fecha FROM tRutasEnvio  WHERE Serie is null and fecha='2023-01-12' 

