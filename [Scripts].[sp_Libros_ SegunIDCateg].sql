USE [EXAMEN_NET]

GO
CREATE SCHEMA Scripts
GO
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES 
			WHERE SPECIFIC_NAME = 'sp_Libros_SegunIDCateg' AND SPECIFIC_SCHEMA = 'Scripts' AND Routine_Type ='PROCEDURE')
BEGIN
	DROP PROCEDURE [Scripts].[sp_Libros_SegunIDCateg]
END
GO
-- ===================================================================================================================
-- NAME           :   [Scripts].[sp_Libros_SegunIDCateg]
-- Author         :   <David Fernando Legendre Albites>
-- Create date    :   10/02/2023
-- BBDD           :   Desarrollo: <EXAMEN_NET> <Scripts>
-- BBDD           :   PreProducción: <EXAMEN_NET> <Scripts>
-- Description    :   <Procedimiento almacenado para devolver info de Libros filtrado por IDCategoria>
-- PARAMETERS     :   <@IDCategoria> ==> <Id Categoria a Buscar>				
--				  :	  
-- TEST           :   [Scripts].[sp_Libros_SegunIDCateg] 1, 0 
-- ================================================================================================================================


CREATE PROCEDURE [Scripts].[sp_Libros_SegunIDCateg]
--<Parametros de entrada y de salida> <Tipo>
	@IDCategoria INT,  
    @PO_OUT BIT OUT
AS
BEGIN

	SET NOCOUNT ON;   

    BEGIN TRY      
        BEGIN TRAN  
			IF(@IDCategoria IS NULL)
			BEGIN 
				SELECT distinct cCatLibDescripcion AS Categoria,
						cEditDescripcion as Editorial,
						A.cAutSexo as Genero,
						cCodigoLibro as 'Cód. Libro',
						cLibTitulo as 'Título de Libro',
						CONCAT(cAutApellido, ' ', cAutNombres) as Autor,
						(SELECT item FROM [Scripts].[fn_ObtenerAñoPublicacion](L.dLibFecPublicacion)) as 'Año Publicacion',
						nNroPaginas AS 'Nº Páginas'

				FROM LIBRO	L WITH(NOLOCK)

						INNER JOIN CATEGORIA_LIBRO CL WITH(NOLOCK) ON L.nIdCatLib = CL.nIdCatLib
						INNER JOIN EDITORIAL E WITH(NOLOCK) ON L.nIdEditorial = E.nIdEditorial
						INNER JOIN AUTOR A WITH(NOLOCK) ON L.nIdAutor = A.nIdAutor
			END
			ELSE
			BEGIN 
				SELECT distinct cCatLibDescripcion AS Categoria,
						cEditDescripcion as Editorial,
						A.cAutSexo as Genero,
						cCodigoLibro as 'Cód. Libro',
						cLibTitulo as 'Título de Libro',
						CONCAT(cAutApellido, ' ', cAutNombres) as Autor,
						(SELECT item FROM [Scripts].[fn_ObtenerAñoPublicacion](L.dLibFecPublicacion)) as 'Año Publicacion',
						nNroPaginas AS 'Nº Páginas'

				FROM LIBRO	L WITH(NOLOCK)

						INNER JOIN CATEGORIA_LIBRO CL WITH(NOLOCK) ON L.nIdCatLib = CL.nIdCatLib
						INNER JOIN EDITORIAL E WITH(NOLOCK) ON L.nIdEditorial = E.nIdEditorial
						INNER JOIN AUTOR A WITH(NOLOCK) ON L.nIdAutor = A.nIdAutor
				Where l.nIdCatLib = @IDCategoria
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
		@level1name = N'sp_Libros_SegunIDCateg'
GO
--Propiedad extendida de descripcion del procedimiento
EXEC sys.sp_addextendedproperty 
		@name = N'MS_Description', 
		@value = N'Descripcion', 
		@level0type = N'SCHEMA', 
		@level0name = N'Scripts', 
		@level1type = N'PROCEDURE', 
		@level1name = N'sp_Libros_SegunIDCateg'
GO
-- Propiedad extendida de descripcion de los parametros del procedimiento
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Descripcion',
		@level0type = N'SCHEMA', 
		@level0name = N'Scripts', 
		@level1type = N'PROCEDURE', 
		@level1name = N'sp_Libros_SegunIDCateg',
		@level2type = N'PARAMETER', 
		@level2name = N'@IDCategoria'
GO