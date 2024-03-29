

--Antes de ejecutar esta query, debemos elegir arriba a la izquierda la base de datos donde hayamos creado las 
--tablas para los precios de las casas, si ejecutamos esto en master(lo que aparece por defaut en el desplegable 
--creara el store procedure en la base de datos master y no funcionara)


CREATE PROC PA_COC_VIVIENDAS_MONTEVERDE

AS 

--indicamos donde va a insertar la informacion limpia
INSERT INTO [Precios_casas].[dbo].[Viviendas_Monteverde_limpio]


--realizamos la consulta que nos data como resultado la info que queremos insertar en la tabla de informacion limpia
--verificando que no ingrese informacion duplucada

SELECT TOP 1000 CONVERT(DATE, A.[Fecha]) as Fecha
      ,A.[Modelo]
      ,CONVERT(INT,REPLACE(REPLACE(REPLACE(A.[Precio], ' (*) contado',''), '$',''), '.','')) as Precio
FROM [Precios_casas].[dbo].[Viviendas_Monteverde_crudo] A
LEFT JOIN [Precios_casas].[dbo].[Viviendas_Monteverde_limpio] B
	on CONVERT(DATE, A.[Fecha]) = B.fecha
	and A.modelo = B.modelo
	and CONVERT(INT,REPLACE(REPLACE(REPLACE(A.[Precio], ' (*) contado',''), '$',''), '.','')) = B.Precio
 WHERE B.fecha is null

 --Borramos la informacion cruda ya insertada en la tabla limpia para que no ocupe especio 
 --(esta tabla solo se llena cuando trataremos los datos, una vez tratados e insertados la info se borra y debe quedar vacia)
 DELETE FROM [Precios_casas].[dbo].[Viviendas_Monteverde_crudo]

 