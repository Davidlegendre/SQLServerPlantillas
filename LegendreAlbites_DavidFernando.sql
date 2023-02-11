--David Legendre Scripts
USE EXAMEN_NET
GO
CREATE SCHEMA Scripts
GO

--1. Crear función para obtener el año de publicación del libro
CREATE FUNCTION Scripts.fn_ObtenerAñoPublicacion(@Fecha Datetime)
RETURNS @tmp TABLE (
	i int identity(1, 1),
	item varchar(100)
)
AS
BEGIN
	DECLARE @YEAR INT = YEAR(CONVERT(DATE, @Fecha))
	INSERT INTO @tmp(item) VALUES(@YEAR)
	RETURN
END
GO

--2. Crear un índice no cluster de la tabla Autor cuando se filtra por Apellidos y Nombre
CREATE NONCLUSTERED INDEX ix_Autor_ApellidosNombre
ON AUTOR(cAutApellido, cAutNombres)
GO

--3. Crear un índice no cluster de la tabla Libro cuando se filtra por Código de Libro
CREATE NONCLUSTERED INDEX ix_Libro_CodigoLibro
ON LIBRO(cCodigoLibro)
GO

--4. Crear una Vista donde obtener esta información
/*
cCodigoLibro
cLibTitulo
cCatLibDescripcion
cAutorD (Apellidos y Nombres)
cAutSexoD
cEditDescripcionD
cEditPaisD
nNroPaginas

*/

CREATE VIEW Scripts.View_Informations
AS

	SELECT cCodigoLibro, cLibTitulo, cCatLibDescripcion, 
	CONCAT(cAutApellido, ' ', cAutNombres) AS cAutorD,
	cAutSexo AS cAutSexoD, cEditDescripcion AS CEditDescriptionD,
	cEditPais AS cEditPaisD, nNroPaginas
	FROM LIBRO L WITH(NOLOCK)
	INNER JOIN CATEGORIA_LIBRO CL ON CL.nIdCatLib = L.nIdCatLib
	INNER JOIN AUTOR A ON A.nIdAutor = L.nIdAutor
	INNER JOIN EDITORIAL E ON E.nIdEditorial = L.nIdEditorial

GO