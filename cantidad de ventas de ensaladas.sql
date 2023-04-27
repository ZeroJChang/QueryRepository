 USE DB_22_CORPORACION
-- USE [DB_22_DELPUEBLO]
-- USE [DB_22_KEYSSA]
-- USE [DB_22_PICONCITO]
-- USE [DB_22_POPULARES]

 

Declare @FechaIni    Date
Declare @FechaFin   Date 

 

Set @FechaIni = '2022-10-01'
Set @Fechafin = '2023-03-31' 

Create table Temp_Ensaladas (
    Mes            Nvarchar(10),
    Tienda        Nvarchar(15),
    NomTienda    Nvarchar(75),
    Codigo        Nvarchar(15),
    NomCodigo    Nvarchar(120),
    Cantidad    Decimal(12,2)
)

 

insert into Temp_Ensaladas (Mes, Tienda, NomTienda, Codigo, NomCodigo, Cantidad)
select Month(T1.DocDate), T1.CardCode, T1.CardName, T2.ItemCode, T2.Dscription, 
    Case
        When T2.ItemCode = 'PT0009' then sum(T2.Quantity)
        When T2.ItemCode in ('PT0045','PT0003','PT0005','PT0087') then 3
        When T2.ItemCode in ('PT0001','PT0002','PT0048','PT0093','PT0096') then 1                
        When T2.ItemCode in ('PT0004','PT0097','PT0100','PT0101','PT0102','PT0104') then 2
        When T2.ItemCode in ('PT0060','PT0061','PT0063','PT0079','PT0103') then 1
        when T2.ItemCode in ('PT0065','PT0066','PT0067','PT0084','PT0105') then 1
        When T2.ItemCode in ('PT0069','PT0070','PT0074','PT0086') then 1
        When T2.ItemCode in ('PT0071','PT0072','PT0085','PT0090','PT0091','PT0094') then 4
        When T2.ItemCode = 'PT0078' then 5
        When T2.ItemCode = 'PT0106' then 6        
    End 
    from OINV T1 inner join INV1 T2 on T1.DocEntry = T2.DocEntry
    where T1.DocDate between @FechaIni and @Fechafin and T1.CANCELED = 'N' -- and T2.ItemCode in ('PT0001','PT0002') 
    Group by T1.DocDate, T1.CardCode, T1.CardName, T2.ItemCode, T2.Dscription
    Order by T1.CardCode

 

--select month(T1.DocDate) Mes, T1.CardCode, T1.CardName, T2.ItemCode, T2.Dscription, sum(T2.Quantity) as Cantidad
--    from OINV T1 inner join INV1 T2 on T1.DocEntry = T2.DocEntry
--    where T1.DocDate between @FechaIni and @Fechafin and T2.ItemCode in ('PT0009','PT0045') and T1.CANCELED = 'N'
--    Group by T1.DocDate, T1.CardCode, T1.CardName, T2.ItemCode, T2.Dscription
--    Order by T1. DocDate, T1.CardCode

 

-- select Mes, Tienda, NomTienda, Codigo, NomCodigo, sum(Cantidad) Cantidad
select Mes, Tienda, NomTienda, sum(Cantidad) Cantidad
    from Temp_Ensaladas
    where Cantidad <> 0 
--    Group by Mes, Tienda, NomTienda, Codigo, NomCodigo
    Group by Mes, Tienda, NomTienda
    order by Mes, Tienda

 

Drop table Temp_Ensaladas