USE [EXAMEN_NET]
GO
CREATE SCHEMA Scripts
GO
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES 
			WHERE SPECIFIC_NAME = 'sp_Libros_SegunCategoriaSexoAutor' 
			AND SPECIFIC_SCHEMA = 'Scripts' AND Routine_Type ='PROCEDURE')
BEGIN
	DROP PROCEDURE [Scripts].[sp_Libros_SegunCategoriaSexoAutor]
END
GO
-- ===================================================================================================================
-- NAME           :   [Scripts].[sp_Libros_SegunCategoriaSexoAutor]
-- Author         :   <David Fernando Legendre Albites>
-- Create date    :   10/02/2023
-- BBDD           :   Desarrollo: <EXAMEN_NET> <Scripts>
-- BBDD           :   PreProducción: <EXAMEN_NET> <Scripts>
-- Description    :   <Procedimiento almacenado para devolver info de Libros segun el Id de categoria y sexo del autor>
-- PARAMETERS     :   <@IDCateg> ==> <Id Categoria a Buscar>				
--				  :	  <@Sexo> ==> <Sexo a filtrar>	
--				  :
-- TEST           :   [Scripts].[sp_Libros_SegunCategoriaSexoAutor] 2, 'M', 0  
-- ================================================================================================================================


CREATE PROCEDURE [Scripts].[sp_Libros_SegunCategoriaSexoAutor]
--<Parametros de entrada y de salida> <Tipo>
	@IDCateg int, 
	@Sexo varchar(1),
    @PO_OUT BIT OUT
AS
BEGIN

	SET NOCOUNT ON;   

    BEGIN TRY      
        BEGIN TRAN  

			IF(@IDCateg IS NOT NULL AND (@Sexo is null or @Sexo = ''))
			BEGIN
				SELECT cCodigoLibro AS 'Cód. Libro', cLibTitulo as 'Título de Libro',
					   CONCAT(cAutApellido, ' ', cAutNombres) as Autor,
					   (SELECT item from [Scripts].[fn_ObtenerAñoPublicacion](L.dLibFecPublicacion)) as 'Año Publicacion',
					   nNroPaginas as 'Nº Páginas'

				FROM LIBRO L WITH(NOLOCK)
					INNER JOIN AUTOR A WITH(NOLOCK) ON L.nIdAutor = A.nIdAutor
					Inner join CATEGORIA_LIBRO c WITH(NOLOCK) ON L.nIdCatLib = c.nIdCatLib
					Inner join EDITORIAL e WITH(NOLOCK) ON L.nIdEditorial = e.nIdEditorial
				WHERE L.nIdCatLib = @IDCateg 
				Order by cAutApellido asc, cAutNombres asc, cLibTitulo asc
			END
			ELSE IF(@Sexo IS NOT NULL and @IDCateg is not null)
			BEGIN
				SELECT cCodigoLibro AS 'Cód. Libro', cLibTitulo as 'Título de Libro',
					   CONCAT(cAutApellido, ' ', cAutNombres) as Autor,
					   (SELECT item from [Scripts].[fn_ObtenerAñoPublicacion](L.dLibFecPublicacion)) as 'Año Publicacion',
					   nNroPaginas as 'Nº Páginas'

				FROM LIBRO L WITH(NOLOCK)
					INNER JOIN AUTOR A WITH(NOLOCK) ON L.nIdAutor = A.nIdAutor
					Inner join CATEGORIA_LIBRO c WITH(NOLOCK) ON L.nIdCatLib = c.nIdCatLib
					Inner join EDITORIAL e WITH(NOLOCK) ON L.nIdEditorial = e.nIdEditorial
				WHERE L.nIdCatLib = @IDCateg AND A.cAutSexo = @Sexo
				Order by cAutApellido asc, cAutNombres asc, cLibTitulo asc
			END
			ELSE
			BEGIN
				SELECT cCodigoLibro AS 'Cód. Libro', cLibTitulo as 'Título de Libro',
					   CONCAT(cAutApellido, ' ', cAutNombres) as Autor,
					   (SELECT item from [Scripts].[fn_ObtenerAñoPublicacion](L.dLibFecPublicacion)) as 'Año Publicacion',
					   nNroPaginas as 'Nº Páginas'

				FROM LIBRO L WITH(NOLOCK)
					INNER JOIN AUTOR A WITH(NOLOCK) ON L.nIdAutor = A.nIdAutor
					Inner join CATEGORIA_LIBRO c WITH(NOLOCK) ON L.nIdCatLib = c.nIdCatLib
					Inner join EDITORIAL e WITH(NOLOCK) ON L.nIdEditorial = e.nIdEditorial
					Order by cAutApellido asc, cAutNombres asc, cLibTitulo asc
			END

		SET @PO_OUT = 1

        COMMIT
    END TRY    
    BEGIN CATCH    
        ROLLBACK  
        SET @PO_OUT = 0  
		DECLARE
				@ErMessage NVARCHAR(2048),
				@ErSeverity INT,
				@ErState INT
		SELECT
				@ErMessage = ERROR_MESSAGE(),
				@ErSeverity = ERROR_SEVERITY(),
				@ErState = ERROR_STATE()
		RAISERROR (@ErMessage, @ErSeverity, @ErState)  
    END CATCH 	
END

GO
-- Propiedad extendida de versionado del procedimiento
EXEC sys.sp_addextendedproperty 
		@name = N'Version', 
		@value = N'1' , 
		@level0type = N'SCHEMA', 
		@level0name = N'Scripts', 
		@level1type = N'PROCEDURE', 
		@level1name = N'sp_Libros_SegunCategoriaSexoAutor'
GO
--Propiedad extendida de descripcion del procedimiento
EXEC sys.sp_addextendedproperty 
		@name = N'MS_Description', 
		@value = N'Procedimiento almacenado para devolver info de Libros segun el Id de categoria y sexo del autor', 
		@level0type = N'SCHEMA', 
		@level0name = N'Scripts', 
		@level1type = N'PROCEDURE', 
		@level1name = N'sp_Libros_SegunCategoriaSexoAutor'
GO
-- Propiedad extendida de descripcion de los parametros del procedimiento
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Id Categoria a Buscar',
		@level0type = N'SCHEMA', 
		@level0name = N'Scripts', 
		@level1type = N'PROCEDURE', 
		@level1name = N'sp_Libros_SegunCategoriaSexoAutor',
		@level2type = N'PARAMETER', 
		@level2name = N'@IDCateg'
GO
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Sexo a filtrar',
		@level0type = N'SCHEMA', 
		@level0name = N'Scripts', 
		@level1type = N'PROCEDURE', 
		@level1name = N'sp_Libros_SegunCategoriaSexoAutor',
		@level2type = N'PARAMETER', 
		@level2name = N'@Sexo'
go