USE [Base_de_datos]
GO
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES 
			WHERE SPECIFIC_NAME = 'Nombre_de_Procedimiento' AND SPECIFIC_SCHEMA = 'Esquema' AND Routine_Type ='PROCEDURE')
BEGIN
	DROP PROCEDURE Person.uspDeleteListUsuarioBE
END
GO
-- ===================================================================================================================
-- NAME           :   [Esquema].[Nombre_de_Procedimiento]
-- Author         :   <Nombre completo>
-- Create date    :   09/02/2023
-- BBDD           :   Desarrollo: <Base_de_datos> <Esquema>
-- BBDD           :   PreProducción: <Base_de_datos> <Esquema>
-- Description    :   <Descripcion>
-- PARAMETERS     :   <Parametro> ==> <Descripcion>				
--				  :	  
-- TEST           :   [Esquema].[Nombre_de_Procedimiento] Valor,Valor,..  
-- ================================================================================================================================


CREATE PROCEDURE [Esquema].[Nombre_de_Procedimiento]
--<Parametros de entrada y de salida> <Tipo>
	@PI_LISTID VARCHAR(MAX),  
    @PO_OUT BIT OUT
AS
BEGIN

	SET NOCOUNT ON;   --<-- Siempre va

    BEGIN TRY      
        BEGIN TRAN  

		--SELECT * FROM Person.UsuarioBE WHERE id IN (38,40,52)
		--SELECT * FROM Person.UsuarioBE WHERE id IN (SELECT item FROM [dbo].[fnSplit]('38,40,52', ','))
		
		DELETE Person.UsuarioBE WHERE id IN (SELECT item FROM [dbo].[fnSplit](@PI_LISTID, ','))		--<-- Query
		SET @PO_OUT = 1

        COMMIT
    END TRY    
    BEGIN CATCH    --> Siempre va todo esto
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
		@level0name = N'Esquema', 
		@level1type = N'PROCEDURE', 
		@level1name = N'Nombre_de_Procedimiento'
GO
--Propiedad extendida de descripcion del procedimiento
EXEC sys.sp_addextendedproperty 
		@name = N'MS_Description', 
		@value = N'Descripcion', 
		@level0type = N'SCHEMA', 
		@level0name = N'Esquema', 
		@level1type = N'PROCEDURE', 
		@level1name = N'Nombre_de_Procedimiento'
GO
-- Propiedad extendida de descripcion de los parametros del procedimiento
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Descripcion',
		@level0type = N'SCHEMA', 
		@level0name = N'Esquema', 
		@level1type = N'PROCEDURE', 
		@level1name = N'Nombre_de_Procedimiento',
		@level2type = N'PARAMETER', 
		@level2name = N'Parametros' --....
GO