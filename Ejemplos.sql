--CREAR BASE DE DATOS
CREATE DATABASE BDTest01
GO
--ELIMINAR
--DROP DATABASE BDTest01

--CREAR ESQUEMA
CREATE SCHEMA Person;
GO
--DROP SCHEMA Person

--CREAR TABLE
CREATE TABLE Person.Perfil
(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	codigo VARCHAR(5) NOT NULL,
	descripcion VARCHAR(100) NOT NULL
)
GO

CREATE TABLE Person.Genero
(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	codigo VARCHAR(5) NOT NULL,
	descripcion VARCHAR(100) NOT NULL
)
go

CREATE TABLE Person.Nacionalidad
(
	id INT IDENTITY PRIMARY KEY NOT NULL,
	codigo VARCHAR(5) NOT NULL,
	descripcion VARCHAR(100) NOT NULL
)
go

--DROP TABLE Nacionalidad

CREATE TABLE Person.UsuarioBE
(
	id int IDENTITY PRIMARY KEY NOT NULL,
	codigo VARCHAR(5) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
	edad INT NULL DEFAULT 5,	
	correo VARCHAR (100) NULL DEFAULT '_@gmail', 
	idGenero INT NOT NULL,
	idNacionalidad INT NOT NULL ,
	idPerfil INT NOT NULL,
	CONSTRAINT fk_Genero FOREIGN KEY (idGenero) REFERENCES Person.Genero (id),    
	CONSTRAINT fk_Nacionalidad FOREIGN KEY (idNacionalidad) REFERENCES Person.Nacionalidad (id),    
	CONSTRAINT fk_Perfil FOREIGN KEY (idPerfil) REFERENCES Person.Perfil (id),    
)
GO

--MODIFICAR CAMPOS DE LA TABLA
ALTER TABLE Person.UsuarioBE ALTER COLUMN correo VARCHAR (50) NULL
ALTER TABLE [Person].[UsuarioBE] DROP CONSTRAINT [DF__UsuarioBE__edad__534D60F1]
ALTER TABLE Person.UsuarioBE ALTER COLUMN fechaRegistro DATETIME NOT NULL 
--AGREGAR CAMPOS DE LA TABLA
ALTER TABLE Person.UsuarioBE ADD direccion VARCHAR (100)  NULL
ALTER TABLE Person.UsuarioBE ADD fechaRegistro DATETIME DEFAULT GETDATE()
ALTER TABLE Person.UsuarioBE ADD estado BIT NOT NULL DEFAULT 0


INSERT INTO Person.Perfil VALUES ('ADM', 'ADMINISTRADOR')
INSERT INTO Person.Perfil VALUES ('TEC', 'TECNICO')
INSERT INTO Person.Perfil VALUES ('SOL', 'SOLICITANTE')

SELECT * FROM Person.Perfil WHERE id = 1 

IF EXISTS(SELECT 1 FROM Person.Perfil WHERE id = 1 )
BEGIN
	PRINT  'SI EXISTE'
END
ELSE
	PRINT  'NO EXISTE'



DECLARE @V_CONTADOR INT = 0;
DECLARE @V_TOTAL_REGISTRO INT = 0;
SELECT @V_TOTAL_REGISTRO = COUNT(ID) FROM Person.Perfil 

SELECT @V_TOTAL_REGISTRO

WHILE @V_CONTADOR < @V_TOTAL_REGISTRO
BEGIN

PRINT @V_CONTADOR

SET @V_CONTADOR = @V_CONTADOR + 1

END


SELECT * FROM   sys.tables
SELECT * FROM   sys.procedures
SELECT * FROM   sys.views

SELECT Schema_id('Person')

USE BDTest01
GO

IF OBJECT_ID('Person.Perfil') IS NULL --this object does exist in the sample database
BEGIN
    PRINT 'The specified object does not exist';
END
ELSE
BEGIN
    PRINT 'The specified object exists';
END;


  --WHERE  NAME = 'uspGetEmployeeManagers'  AND SCHEMA_ID = Schema_id('P2M')   AND type = 'P'


INSERT INTO Person.Perfil VALUES ('ADM', 'ADMINISTRADOR')
INSERT INTO Person.Perfil VALUES ('TEC', 'TECNICO')
INSERT INTO Person.Perfil VALUES ('SOL', 'SOLICITANTE')

INSERT INTO Person.Genero VALUES ('M', 'MASCULINO')
INSERT INTO Person.Genero VALUES ('F', 'FEMENINO')

INSERT INTO Person.Nacionalidad VALUES ('PE', 'PERU')
INSERT INTO Person.Nacionalidad VALUES ('MX', 'MEXICO')
INSERT INTO Person.Nacionalidad VALUES ('US', 'ESTADO UNIDOS')
INSERT INTO Person.Nacionalidad VALUES ('CL', 'COLOMBIA')
INSERT INTO Person.Nacionalidad VALUES ('BR', 'BRASIL')

SELECT * FROM Person.Perfil
SELECT * FROM Person.Genero
SELECT * FROM Person.Nacionalidad

DECLARE @V_CODIGO VARCHAR(5) = '00005'
DECLARE @V_NOMBRE VARCHAR(100) = 'ALBERTO'
DECLARE @V_APELLIDO VARCHAR(100) = 'MENDEZ'
DECLARE @V_EDAD INT = 28
DECLARE @V_CORREO VARCHAR(100) = 'alberto@gmail.com'
DECLARE @V_IDGENERO INT = 2
DECLARE @V_IDNACIONALIDAD INT = 1
DECLARE @V_IDPERFIL INT = 3
DECLARE @V_DIRECCION VARCHAR(100) = 'AV. ESPAÑA 1356'

--INSERT INTO Person.UsuarioBE (codigo, nombre, apellido, idGenero, idNacionalidad, idPerfil, direccion) VALUES (@V_CODIGO, @V_NOMBRE,@V_APELLIDO, @V_IDGENERO, @V_IDNACIONALIDAD, @V_IDPERFIL, @V_DIRECCION)

--SELECT * FROM Person.UsuarioBE

--UPDATE Person.UsuarioBE SET fechaRegistro = GETDATE() WHERE fechaRegistro IS NULL


UPDATE	PERSON.UsuarioBE SET 
		codigo = @V_CODIGO, 
		nombre = @V_NOMBRE, 
		apellido = @V_APELLIDO, 
		edad = @V_EDAD, 
		correo =  @V_CORREO , 
		idGenero = @V_IDGENERO, 
		idNacionalidad = @V_IDNACIONALIDAD, 
		idPerfil = @V_IDPERFIL   
WHERE id = 5

SELECT CONVERT(VARCHAR, fechaRegistro, 105) AS NUEVA_FECHA, * FROM Person.UsuarioBE



--DELETE FROM Person.UsuarioBE WHERE id = 6

SELECT CONVERT(VARCHAR, fechaRegistro, 105) AS NUEVA_FECHA, * FROM Person.UsuarioBE WHERE id = 2

--DELETE FROM Person.UsuarioBE WHERE idGenero = 2


SELECT  U.codigo, U.nombre, U.apellido, U.edad, U.correo,  G.codigo + ' - ' + G.descripcion AS GENERO, N.codigo + ' - ' + N.descripcion AS NACIONALIDAD, P.codigo + ' - ' + P.descripcion AS PERFIL
FROM	Person.UsuarioBE U WITH(NOLOCK)
		INNER JOIN Person.Genero G WITH(NOLOCK) ON U.idGenero = G.id
		INNER JOIN Person.Nacionalidad N WITH(NOLOCK) ON U.idNacionalidad = N.id
		INNER JOIN Person.Perfil P WITH(NOLOCK) ON U.idPerfil = P.id
WHERE	P.codigo = 'ADM'


SELECT * FROM Person.UsuarioBE
SELECT * FROM Person.UsuarioBE_Historico
[Person].[uspInsertUsuarioBE] '00010', 'CINTYA', 'BENITES', '30', 'cintya@gmail.com', 2, 3, 3, 'Suarez 189', 0  

--- SESSION II
-- CREACION DE STORED PROCEDURE

USE [BDTest01]
GO
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES 
			WHERE SPECIFIC_NAME = 'uspInsertUsuarioBE' AND SPECIFIC_SCHEMA = 'Person' AND Routine_Type ='PROCEDURE')
BEGIN
	DROP PROCEDURE Person.uspInsertUsuarioBE
END
GO
-- ===================================================================================================================
-- NAME           :   [Person].[uspInsertUsuarioBE]
-- Author         :   Carlos Augusto Ñaño Velasquez
-- Create date    :   09/02/2023
-- Modify Autor   : 
-- Modify date    :   09/02/2023
-- BBDD           :   Desarrollo: <BDTest01> <Person>
-- BBDD           :   PreProducción: <BDTest01> <Person>
-- Description    :   Insertar Usuario
-- PARAMETERS     :  					
--				  :	  @PI_CODIGO ==>  Codigo de Usuario
--				  :	  @PI_NOMBRE ==>  Nombre de Usuario
--				  :	  @PI_APELLIDO ==>  Apellido de Usuario
--				  :	  @PI_EDAD ==>  Edad de Usuario
--				  :	  @PI_CORREO ==>  Correo de Usuario
--				  :	  @PI_IDGENERO ==>  Id Genero de Usuario
--				  :	  @PI_IDNACIONALIDAD ==>  Id Nacionalidad de Usuario
--				  :	  @PI_IDPERFIL ==>  Id Perfil de Usuario
--				  :	  @PI_DIRECCION ==>  Direccion Usuario
-- TEST           :   [Person].[uspInsertUsuarioBE] '00010', 'FABIOLA', 'CASTILLO', '28', 'fabiola@gmail.com', 2, 4, 2, 'AV. LOS LAURELES 123', 0  
-- ================================================================================================================================


CREATE PROCEDURE [Person].[uspInsertUsuarioBE]
	@PI_CODIGO VARCHAR(5),
	@PI_NOMBRE VARCHAR(100),
    @PI_APELLIDO VARCHAR(100),
	@PI_EDAD INT,
	@PI_CORREO VARCHAR(100),
	@PI_IDGENERO INT,
	@PI_IDNACIONALIDAD INT,
	@PI_IDPERFIL INT,
	@PI_DIRECCION VARCHAR(100),	
	@PO_OUT BIT OUT
AS
BEGIN
   
   SET NOCOUNT ON;    

    BEGIN TRY      
        BEGIN TRAN  

			INSERT INTO UsuarioBE (codigo, nombre, apellido, edad, correo, idGenero, idNacionalidad, idPerfil, direccion, fechaRegistro, estado)
			VALUES (@PI_CODIGO, @PI_NOMBRE,@PI_APELLIDO, @PI_EDAD, @PI_CORREO, @PI_IDGENERO, @PI_IDNACIONALIDAD, @PI_IDPERFIL, @PI_DIRECCION, GETDATE(), 0)
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
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE'
GO
--Propiedad extendida de descripcion del procedimiento
EXEC sys.sp_addextendedproperty 
		@name = N'MS_Description', 
		@value = N'Insertar Usuario', 
		@level0type = N'SCHEMA', 
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE'
GO
-- Propiedad extendida de descripcion de los parametros del procedimiento
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Codigo de Usuario',
		@level0type = N'SCHEMA', 
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE',
		@level2type = N'PARAMETER', 
		@level2name = N'@PI_CODIGO'
GO
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Nombre de Usuario',
		@level0type = N'SCHEMA', 
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE',
		@level2type = N'PARAMETER', 
		@level2name = N'@PI_NOMBRE'
GO
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Apellido de Usuario',
		@level0type = N'SCHEMA', 
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE',
		@level2type = N'PARAMETER', 
		@level2name = N'@PI_APELLIDO'
GO
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Edad de Usuario',
		@level0type = N'SCHEMA', 
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE',
		@level2type = N'PARAMETER', 
		@level2name = N'@PI_EDAD'
GO
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Correo de Usuario',
		@level0type = N'SCHEMA', 
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE',
		@level2type = N'PARAMETER', 
		@level2name = N'@PI_CORREO'
GO
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Id Genero de Usuario',
		@level0type = N'SCHEMA', 
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE',
		@level2type = N'PARAMETER', 
		@level2name = N'@PI_IDGENERO'
GO
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Id Nacionalidad de Usuario',
		@level0type = N'SCHEMA', 
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE',
		@level2type = N'PARAMETER', 
		@level2name = N'@PI_IDNACIONALIDAD'
GO
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Id Perfil de Usuario',
		@level0type = N'SCHEMA', 
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE',
		@level2type = N'PARAMETER', 
		@level2name = N'@PI_IDPERFIL'
GO
EXEC sys.sp_addextendedproperty
		@name = N'MS_Description',
		@value = N'Direccion de Usuario',
		@level0type = N'SCHEMA', 
		@level0name = N'Person', 
		@level1type = N'PROCEDURE', 
		@level1name = N'uspInsertUsuarioBE',
		@level2type = N'PARAMETER', 
		@level2name = N'@PI_DIRECCION'
GO

--PRUEBA CON NOCOUNT ON/OFF

exec TestNoCountON
ALTER PROCEDURE TestNoCountON
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @intFlag INT
	SET @intFlag = 1

	WHILE (@intFlag <=100)
	BEGIN
		SELECT	* 
		FROM	[Person].[UsuarioBE] where id = @intFlag
		
		SET @intFlag = @intFlag+1
	END
END
GO 

exec TestNoCountOFF
ALTER PROCEDURE TestNoCountOFF
AS
BEGIN
	
	SET NOCOUNT OFF;

	DECLARE @intFlag INT
	SET @intFlag = 1

	WHILE (@intFlag <=100)
	BEGIN
		SELECT	* 
		FROM	[Person].[UsuarioBE] --where id = @intFlag	
		
		SET @intFlag = @intFlag+1
	END
END
GO 

-- CREAR FUNCION
SELECT * FROM [dbo].[fnSplit]('10,20,30,40,50', ',')

CREATE FUNCTION [dbo].[fnSplit](@entrada varchar(max), @caracter varchar(5))
RETURNS @tmp TABLE (
	i int identity(1, 1),
	item varchar(100)
)
AS

BEGIN
	DECLARE @pos int
	DECLARE @tam int
	DECLARE @item varchar(64)
	DECLARE @longtotal int
	DECLARE @longItem int
	
	SET	@longtotal = len(@entrada)
	SET	@pos = 1;
	SET	@tam = 1;

	WHILE not (@pos > @longtotal)
	BEGIN
		SET @item = substring(@entrada, @pos, @tam)

		IF (right(@item,1) = @caracter)
		BEGIN
			IF(len(@item)>1)
			BEGIN
				SET @longItem = len(@item) - 1
				IF (@caracter = ' ')
				BEGIN
					SET @longItem = len(@item)
				END
				INSERT INTO @tmp(item) VALUES (left(@item, @longItem))
			END
			SET @pos = @pos + @tam
			SET @tam = 1
		END
		ELSE
		BEGIN
			IF (@pos + @tam > @longtotal)
			BEGIN
				INSERT INTO @tmp(item) values (left(@item, len(@item)))
				SET @pos = @pos + @tam
				SET @tam = 1
			END
			ELSE
			BEGIN
				SET @tam = @tam + 1
			END
		END
	END
    RETURN
END

GO


CREATE FUNCTION [Person].[fnSplitList](@entrada varchar(max), @caracter varchar(5))
RETURNS @tmp TABLE (
	i int identity(1, 1),
	item varchar(100)
)
AS

BEGIN
	DECLARE @pos int
	DECLARE @tam int
	DECLARE @item varchar(64)
	DECLARE @longtotal int
	DECLARE @longItem int
	
	SET	@longtotal = len(@entrada)
	SET	@pos = 1;
	SET	@tam = 1;

	WHILE not (@pos > @longtotal)
	BEGIN
		SET @item = substring(@entrada, @pos, @tam)

		IF (right(@item,1) = @caracter)
		BEGIN
			IF(len(@item)>1)
			BEGIN
				SET @longItem = len(@item) - 1
				IF (@caracter = ' ')
				BEGIN
					SET @longItem = len(@item)
				END
				INSERT INTO @tmp(item) VALUES (left(@item, @longItem))
			END
			SET @pos = @pos + @tam
			SET @tam = 1
		END
		ELSE
		BEGIN
			IF (@pos + @tam > @longtotal)
			BEGIN
				INSERT INTO @tmp(item) values (left(@item, len(@item)))
				SET @pos = @pos + @tam
				SET @tam = 1
			END
			ELSE
			BEGIN
				SET @tam = @tam + 1
			END
		END
	END
    RETURN
END

GO

--------------------------------------------------------------------------------------------------------------
-- CREAR VISTA

USE BDTest01  
GO  

CREATE VIEW Person.InfoUsuario
AS  
	SELECT  U.codigo, U.nombre, U.apellido, U.edad, U.correo,  G.codigo + ' - ' + G.descripcion AS genero, N.codigo + ' - ' + N.descripcion AS nacionalidad, P.codigo + ' - ' + P.descripcion AS perfil,
			U.direccion, U.fechaRegistro
	FROM	Person.UsuarioBE U WITH(NOLOCK)
			INNER JOIN Person.Genero G WITH(NOLOCK) ON U.idGenero = G.id
			INNER JOIN Person.Nacionalidad N WITH(NOLOCK) ON U.idNacionalidad = N.id
			INNER JOIN Person.Perfil P WITH(NOLOCK) ON U.idPerfil = P.id
	WHERE	U.estado = 1

GO 
 
 SELECT * FROM Person.UsuarioBE WHERE estado = 0

 --UPDATE Person.UsuarioBE SET estado = 1 WHERE id IN (2,4,5, 37)


-- Query the view  
SELECT	*
FROM	Person.InfoUsuario  

--Triggers

--DROP TABLE Person.UsuarioBE_Historico
CREATE TABLE Person.UsuarioBE_Historico
(
	id int IDENTITY PRIMARY KEY NOT NULL,
	idUsuarioBE INT NOT NULL,
    nombreServidor VARCHAR(100) NOT NULL,
    nombrePrograma VARCHAR(100) NOT NULL,
	usuario VARCHAR(50) NOT NULL,	
	fechaRegistro DATETIME NOT NULL	
)
GO

CREATE TABLE Person.UsuarioBE_Delete_Historico
(
	id int IDENTITY PRIMARY KEY NOT NULL,
	idUsuarioBE INT NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	apellido VARCHAR(100) NOT NULL,
    nombreServidor VARCHAR(100) NOT NULL,
    nombrePrograma VARCHAR(100) NOT NULL,
	usuario VARCHAR(50) NOT NULL,	
	fechaRegistro DATETIME NOT NULL	
)
GO

CREATE TABLE Person.UsuarioBE_Update_Historico
(
	id int IDENTITY PRIMARY KEY NOT NULL,
	idUsuarioBE INT NOT NULL,
	nombre_old VARCHAR(100) NOT NULL,
	nombre_new VARCHAR(100) NOT NULL,
	apellido_old VARCHAR(100) NOT NULL,	
	apellido_new VARCHAR(100) NOT NULL,
    nombreServidor VARCHAR(100) NOT NULL,
    nombrePrograma VARCHAR(100) NOT NULL,
	usuario VARCHAR(50) NOT NULL,	
	fechaRegistro DATETIME NOT NULL	
)
GO


SELECT * FROM Person.UsuarioBE
SELECT * FROM Person.UsuarioBE_Historico
SELECT * FROM Person.UsuarioBE_Delete_Historico
SELECT * FROM Person.UsuarioBE_Update_Historico
EXEC [Person].[uspInsertUsuarioBE] '00009', 'FABIOLA', 'VELASQUEZ', '35', 'fabiola@gmail.com', 2, 1, 2, 'AV. America norte 566', 0

--UPDATE Person.UsuarioBE SET nombre = 'JOSE_TEST' , apellido = 'RODRIGUES_TEST' WHERE id = 2

SELECT c.session_id,
    c.net_transport,
    c.encrypt_option,
    c.auth_scheme,
    s.host_name,
    s.program_name,
    s.client_interface_name,
    s.login_name,
    s.nt_domain,
    s.nt_user_name,
    s.original_login_name,
    c.connect_time,
    s.login_time
FROM sys.dm_exec_connections AS c
INNER JOIN sys.dm_exec_sessions AS s
    ON c.session_id = s.session_id
WHERE c.session_id = @@SPID;

USE BDTest01
GO

ALTER TRIGGER [Person].[Trigger_UsuarioBE_Historico] 
ON Person.UsuarioBE
AFTER INSERT, DELETE, UPDATE  
AS  
BEGIN
	SET NOCOUNT ON;
	DECLARE @V_HOST_NAME VARCHAR(100)
	DECLARE @V_PROGRAM_NAME VARCHAR(100)
	DECLARE @V_LOGIN_NAME VARCHAR(100)

	SELECT @V_HOST_NAME = s.host_name,
		   @V_PROGRAM_NAME = s.program_name,
		   @V_LOGIN_NAME = s.login_name  
	FROM sys.dm_exec_connections AS c
	INNER JOIN sys.dm_exec_sessions AS s
		ON c.session_id = s.session_id
	WHERE c.session_id = @@SPID;


	DECLARE @INSERTED INT
	DECLARE @DELETED INT
	
	SELECT  @INSERTED=count(*) FROM inserted
	SELECT  @DELETED=count(*) FROM deleted
	
	IF @INSERTED>0 AND @DELETED = 0   --INSERT
	BEGIN    
		INSERT INTO Person.UsuarioBE_Historico (idUsuarioBE, nombreServidor, nombrePrograma, usuario, fechaRegistro)
		SELECT c.id,
			@V_HOST_NAME,
			@V_PROGRAM_NAME,
			@V_LOGIN_NAME,
			GETDATE()
		from inserted c WITH(NOLOCK)	
	END

	IF @INSERTED = 0 AND @DELETED > 0   --DELETE
	BEGIN
		INSERT INTO Person.UsuarioBE_Delete_Historico (idUsuarioBE, nombre, apellido, nombreServidor, nombrePrograma, usuario, fechaRegistro)
		SELECT c.id,
			c.nombre,
			c.apellido,
			@V_HOST_NAME,
			@V_PROGRAM_NAME,
			@V_LOGIN_NAME,
			GETDATE()
		from deleted c WITH(NOLOCK)	
	END
	if @INSERTED>0  and @DELETED>0 --UPDATED
	BEGIN
			
	INSERT INTO Person.UsuarioBE_Update_Historico (idUsuarioBE, nombre_old, nombre_new, apellido_old, apellido_new, nombreServidor, nombrePrograma, usuario, fechaRegistro)
	SELECT c.id,
			c.nombre,
			i.nombre,
			c.apellido,
			i.apellido,
			@V_HOST_NAME,
			@V_PROGRAM_NAME,
			@V_LOGIN_NAME,
			GETDATE()
	from	deleted c  WITH(NOLOCK)	
			INNER JOIN inserted I WITH(NOLOCK)	ON c.id = I.id
		
	END	
END
GO


SELECT * FROM Person.UsuarioBE
SELECT * FROM Person.UsuarioBE_Historico
[Person].[uspInsertUsuarioBE] '00009', 'RODOLFO', 'MANNUCCI', '25', 'rodolfo@gmail.com', 1, 2, 3, 'Pizarro 120', 0  

/*
ALTER TRIGGER [dbo].[CLIENTES_MODIFICACION]
   ON  [dbo].[CLIENTES]
   FOR INSERT,DELETE,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @INSERTED INT
	DECLARE @DELETED INT
	DECLARE @NEMPRESA VARCHAR(5)
	
	select  @inserted=count(*) from inserted
	select  @deleted=count(*) from deleted
	if @inserted>0  and @deleted=0 --INSERT
	begin    
		INSERT INTO CLIENTES_ACT(NCLIENTE,FACTUALIZACION,BORRADO,NEMPRESA)
		SELECT NCLIENTE,GETDATE(),0,LEFT(NCLIENTE,5)
		FROM INSERTED I
		    
	end
	if @inserted=0  and @deleted>0 --DELETED
	begin			
		UPDATE CLIENTES_ACT SET BORRADO=1,FACTUALIZACION=GETDATE()
		FROM DELETED D WHERE D.NCLIENTE=CLIENTES_ACT.NCLIENTE
		
	end
	if @inserted>0  and @deleted>0 --UPDATED
	BEGIN			
		UPDATE CLIENTES_ACT SET FACTUALIZACION=GETDATE()
		FROM INSERTED D WHERE D.NCLIENTE=CLIENTES_ACT.NCLIENTE
		
	END	
END

*/


--CREAR INDEX

--La tabla Person.UsuarioBE es una tabla agrupada porque tiene una clave principal id.
SELECT	* FROM	Person.UsuarioBE

SELECT	* 
FROM	Person.UsuarioBE
WHERE	id = 5

--Cómo crear índices en SQL Server con la instrucción CREATE INDEX
--A) Uso de la instrucción CREATE INDEX de SQL Server para crear un índice no agrupado para un ejemplo de columna
SELECT	id, codigo
FROM	Person.UsuarioBE
WHERE	codigo = '00006'

--Si vemos el plan de ejecución estimado, verás que el optimizador de consultas escanea el índice agrupado para encontrar la fila.
--Esto se debe a que la tabla Person.UsuarioBE no tiene un índice para la columna de la codigo.

--Para mejorar la velocidad de esta consulta, puedes crear un nuevo índice llamado ix_UsuarioBE_codigo para la columna del codigo:
-- NONCLUSTERED opcional
CREATE NONCLUSTERED INDEX ix_UsuarioBE_codigo
ON Person.UsuarioBE(codigo);

--Ahora, si vuelves a ver el plan de ejecución estimado de la consulta anterior, 
--encontrarás que el optimizador de consultas utiliza el índice no agrupado ix_UsuarioBE_codigo:

---------------------------------------------------------------------------------------------------------
--B) Uso de la declaración CREATE INDEX de SQL Server para crear un índice no agrupado para el ejemplo de varias columnas

--La siguiente declaración encuentra al cliente cuyo apellido es MENDEZ y el nombre es ALBERTO:

SELECT	id, nombre, apellido
FROM	Person.UsuarioBE
WHERE	apellido = 'MENDEZ' AND nombre = 'ALBERTO' 

--El optimizador de consultas escanea el índice agrupado para localizar al cliente.

--Para acelerar la recuperación de datos, puedes crear un índice no agrupado que incluya las columnas apellido y nombre:

CREATE INDEX ix_UsuarioBE_apellido_nombre
ON Person.UsuarioBE(apellido, nombre);

-- Ahora, el optimizador de consultas usa el índice ix_UsuarioBE_apellido_nombre para encontrar al cliente.

-- Cuando creas un índice no agrupado que consta de varias columnas,
-- el orden de las columnas en el índice es muy importante. 
-- Debes colocar las columnas que utiliza con frecuencia para consultar datos al principio de la lista de columnas.

-- Por ejemplo, la siguiente declaración busca clientes cuyo apellido es MENDEZ. 
-- Debido a que apellido es la columna más a la izquierda en el índice, 
-- el optimizador de consultas puede aprovechar el índice y usa el método de búsqueda de índice para buscar:

SELECT	id, nombre, apellido
FROM	Person.UsuarioBE
WHERE	apellido = 'MENDEZ'

--La siguiente declaración encuentra clientes cuyo nombre es ALBERTO. 
--También aprovecha el índice ix_UsuarioBE_apellido_nombre. Pero necesita escanear todo el índice para buscar, 
--lo cual es más lento que la búsqueda de índice.

SELECT	id, nombre, apellido
FROM	Person.UsuarioBE
WHERE	nombre = 'ALBERTO' 

--==================================================================================================
-- Cómo crear los índices únicos de SQL Server con CREATE UNIQUE INDEX

SELECT	id, correo
FROM	Person.UsuarioBE
WHERE	correo = 'jean@gmail.com' 

--update Person.UsuarioBE set correo = LOWER(nombre)  + '@gmail.com'  where id IN (1,2)

-- El optimizador de consultas tiene que escanear todo el índice agrupado para encontrar la fila.
-- Para acelerar la recuperación de la consulta, puedes agregar un índice no agrupado a la columna de correo.
-- Sin embargo, suponiendo que cada Usuario tendrá un correo electrónico único, puedes crear un índice único para la columna de correo.
-- Debido a que la tabla Person.UsuarioBE ya tiene datos, primero debes verificar los valores duplicados en la columna de correo:

SELECT
    correo,
    COUNT(correo)
FROM
    Person.UsuarioBE
GROUP BY
    correo
HAVING
    COUNT(correo) > 1;

-- La consulta devuelve un conjunto de registros vacíos. Significa que no hay valores duplicados en la columna de correo.
-- Por lo tanto, puedes ir a crear un índice único para la columna de correo electrónico de la tabla Person.UsuarioBE:

CREATE UNIQUE INDEX ix_UsuarioBE_correo
ON Person.UsuarioBE(correo);

--=======================================================================================
--Cómo definir un índice agrupado en una tabla SQL Server con CREATE CLUSTERED INDEX

CREATE TABLE parts(
    part_id   INT NOT NULL,
    part_name VARCHAR(100)
);

INSERT INTO
    parts(part_id, part_name)
VALUES
    (1,'Estrada Web Group'),
    (2,'EWG'),
    (3,'Handlebar Grip'),
    (4,'Shock Absorber'),
    (5,'Fork');

SELECT * FROM parts

SELECT
    part_id,
    part_name
FROM
    parts
WHERE
    part_id = 5;


CREATE CLUSTERED INDEX ix_parts_part_id
ON parts(part_id);

	