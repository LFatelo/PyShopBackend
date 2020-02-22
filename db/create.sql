IF NOT EXISTS 
    (SELECT name  
     FROM master.sys.server_principals
     WHERE name = 'formando')
BEGIN
    CREATE LOGIN formando WITH PASSWORD = 'Passw0rd', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
END
GO

IF NOT EXISTS (SELECT name 
                FROM [sys].[database_principals]
                WHERE [type] = 'S' AND name ='formando')
Begin
    CREATE USER formando
    FOR LOGIN formando
end

ALTER ROLE db_owner ADD MEMBER formando
GO

DROP DATABASE IF EXISTS WebDB;
GO

CREATE DATABASE WebDB;
GO

Use WebDB;
-- -----------------------------------------------------
-- Table WebDB.Internal_User
-- -----------------------------------------------------
DROP TABLE IF EXISTS Internal_User ;

if not exists (select * from sysobjects where name='Internal_User' and xtype='U')
    create table Internal_User (
        id          INT NOT NULL IDENTITY,
		username    VARCHAR(16) NOT NULL,
		password    VARBINARY(100) NOT NULL ,
		create_time DATETIME2 NULL DEFAULT GETDATE(),
		isactive    BINARY(1) NULL DEFAULT 1,

		PRIMARY KEY (id)
    )
go

	declare @CurrentUser sysname
    select @CurrentUser = user_name()
    execute sp_addextendedproperty 'MS_Description', 
   'Hashed password and salt',
   'user', @CurrentUser, 'table', 'Internal_User', 'column', 'password'

go
-- -----------------------------------------------------
-- Table WebDB.Product_Type
-- -----------------------------------------------------
DROP TABLE IF EXISTS Product_Type ;

if not exists (select * from sysobjects where name='Product_Type' and xtype='U')
	CREATE TABLE Product_Type (
		id			SMALLINT NOT NULL IDENTITY,
		name		VARCHAR(50) NOT NULL,
		description	VARCHAR(500) NOT NULL,
		updated_by	INT NOT NULL,
		last_updated_date DATETIME2 NULL DEFAULT GETDATE(),
		isactive	BINARY(1) NULL,

		PRIMARY KEY(id),
		CONSTRAINT name_UNIQUE UNIQUE (name ASC)
		)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Category name',
   'user', @CurrentUser, 'table', 'Product_Type', 'column', 'name'
go

-- -----------------------------------------------------
-- Table WebDB.Product
-- -----------------------------------------------------
DROP TABLE IF EXISTS Product ;

if not exists (select * from sysobjects where name='Product' and xtype='U')
	CREATE TABLE Product (
    id                INT NOT NULL IDENTITY(100001,1),
    product_type_id   SMALLINT NOT NULL,
    description       VARCHAR(4000) NULL,
    price             DECIMAL(18,2) NOT NULL,
    sku               VARCHAR(50) NOT NULL,
    product_image     VARCHAR(300) NULL UNIQUE,
    updated_by        INT NOT NULL,
    last_updated_date DATETIME2 NOT NULL DEFAULT GETDATE(),
    isactive          BIT NULL DEFAULT 1,
    weight            DECIMAL(10,2) NULL ,
    dimensions        VARCHAR(50) NULL ,

    PRIMARY KEY (id),

    CONSTRAINT fk_Product_Product_Type1
        FOREIGN KEY (product_type_id)
        REFERENCES Product_Type (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE INDEX fk_Product_Product_Type1_idx ON Product (product_type_id ASC);

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Weight in grams',
   'user', @CurrentUser, 'table', 'Product', 'column', 'weight'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'HEIGHT, WIDTH, DEPTH separated by ‘/‘ and measured in ‘mm’',
   'user', @CurrentUser, 'table', 'Product', 'column', 'dimensions'
go

-- -----------------------------------------------------
-- Table WebDB.Client
-- -----------------------------------------------------

DROP TABLE IF EXISTS Client ;

if not exists (select * from sysobjects where name='Client' and xtype='U')
	CREATE TABLE Client(
		id			INT NOT NULL IDENTITY(10001,1),
		email		VARCHAR(50) NOT NULL,
		password	VARBINARY(100) NOT NULL,
		firstname	VARCHAR(50) NOT NULL,
		surname		VARCHAR(50) NOT NULL,
		phone		VARCHAR(21) NULL,
		create_time	DATETIME2 NOT NULL DEFAULT GETDATE(),
		fault_count TINYINT NOT NULL DEFAULT 0,
		isactive	BIT NULL DEFAULT 1,
		address		VARCHAR(200) NOT NULL,
		postcode	VARCHAR(7) NOT NULL,
		country		VARCHAR(50) NOT NULL,
		birthday	DATE NULL,
		fiscal_num	VARCHAR(12) NOT NULL,

		PRIMARY KEY(id),
		CONSTRAINT username_UNIQUE UNIQUE (email ASC),
		CONSTRAINT fiscal_num_UNIQUE UNIQUE (fiscal_num ASC),
		CONSTRAINT phone_UNIQUE UNIQUE (phone ASC)
		)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Hashed password and salt',
   'user', @CurrentUser, 'table', 'Client', 'column', 'password'
go

-- -----------------------------------------------------
-- Table WebDB.Order
-- -----------------------------------------------------
DROP TABLE IF EXISTS [Order] ;

if not exists (select * from sysobjects where name='[Order]' and xtype='U')
	CREATE TABLE [Order] (
		id				INT NOT NULL IDENTITY(100001,1),
		client_id		INT NOT NULL,
		order_date		DATETIME2 NULL,
		delivery_addr	VARCHAR(200) NOT NULL,
		shipping_costs	DECIMAL(18,2) NOT NULL DEFAULT 0,
		payment_type	CHAR(2) NOT NULL DEFAULT 'OC',
		payment_id		VARCHAR(100) NULL,
		payment_field1	VARCHAR(100) NULL,
		payment_field2	VARCHAR(100) NULL,
		payment_field3	VARCHAR(100) NULL,
		status			CHAR(2) NOT NULL DEFAULT 'IP',
		modified_date	DATETIME2 NOT NULL DEFAULT GETDATE(),
		status_reason	VARCHAR(512) NULL,

		PRIMARY KEY(id),
        CONSTRAINT id
        FOREIGN KEY (client_id)
        REFERENCES Client (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE INDEX id_idx ON [Order] (client_id ASC);

go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Filled with CURDATE (can’t be NULL)\n',
   'user', @CurrentUser, 'table', 'Order', 'column', 'order_date'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'One of: \nOC - Online Credit Card (Visa, MasterCard only)\nOP - Online PayPal\nDM - Deferred Payment: Money Order\nDC - Deferred Payment: Cheque',
   'user', @CurrentUser, 'table', 'Order', 'column', 'payment_type'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'For credit cards, is the credit card number\nFor PayPal, is the account number\nFor cheques is the cheque number\nFor Money Order, is the money order number',
   'user', @CurrentUser, 'table', 'Order', 'column', 'payment_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'IP - InProgress (aka, ’Shopping Cart’)\nPR - Processing\nPE - Pending\nOH - OnHold\nCA - Cancelled\nCO - Complete\nRE - Refunded',
   'user', @CurrentUser, 'table', 'Order', 'column', 'status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Status modification date (default: CURDATE, cant be NULL)',
   'user', @CurrentUser, 'table', 'Order', 'column', 'modified_date'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Description of last status change',
   'user', @CurrentUser, 'table', 'Order', 'column', 'status_reason'
go

-- -----------------------------------------------------
-- Table WebDB.Order_Item
-- -----------------------------------------------------
DROP TABLE IF EXISTS WebDB.Order_Item ;

if not exists (select * from sysobjects where name='Order_Item' and xtype='U')
	CREATE TABLE Order_Item (
		id				INT NOT NULL IDENTITY,
		order_id		INT NOT NULL,
		product_id		INT NOT NULL,
		tax_amount		DECIMAL(18,2) NULL DEFAULT 0,
		tax_description	VARCHAR(255) NULL,
		physical_item_id INT NULL,
		date_added		DATETIME2 NOT NULL,

   PRIMARY KEY (id)
   ,
    CONSTRAINT uq_order_produtct_ids_idx UNIQUE (order_id ASC, product_id ASC),
    CONSTRAINT fk_Order_items_Order1
        FOREIGN KEY (order_id)
        REFERENCES [Order] (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Order_items_Product1
        FOREIGN KEY (product_id)
        REFERENCES Product (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE INDEX fk_Order_items_Order1_idx ON Order_Item (order_id ASC);
CREATE INDEX fk_Order_items_Product1_idx ON Order_Item (product_id ASC);
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Por omissão e por simplicidade, 23% do preço do produto',
   'user', @CurrentUser, 'table', 'Order_item', 'column', 'tax_amount'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Por omissão e simplicidade, ‘IVA/VAT’',
   'user', @CurrentUser, 'table', 'Order_item', 'column', 'tax_description'
go

-- -----------------------------------------------------
-- Table WebDB.Logs
-- -----------------------------------------------------
DROP TABLE IF EXISTS WebDB.Logs ;

if not exists (select * from sysobjects where name='Logs' and xtype='U')
	CREATE TABLE Logs (
		id			INT NOT NULL IDENTITY,
		client_id	INT NOT NULL,
		login_date	DATETIME2 NOT NULL DEFAULT GETDATE(),
		status		CHAR(1) NOT NULL,


		PRIMARY KEY(id),
        CONSTRAINT fk_Logs_Client1
        FOREIGN KEY (client_id)
        REFERENCES Client (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE INDEX id_idx ON Logs (client_id ASC);

go

-- -----------------------------------------------------
-- Table WebDB.Campaign
-- -----------------------------------------------------
DROP TABLE IF EXISTS WebDB.Campaign;

if not exists (select * from sysobjects where name='Campaign' and xtype='U')
	CREATE TABLE Campaign (
		id			INT NOT NULL IDENTITY,
		title		VARCHAR(100) NOT NULL,
		start_date	DATETIME2 NOT NULL DEFAULT GetDate(),
		end_date	DATETIME2 NULL,

		PRIMARY KEY(id)
);
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ex: \"Holidays deals\"',
   'user', @CurrentUser, 'table', 'Campaign', 'column', 'title'
go

-- -----------------------------------------------------
-- Table WebDB.Promotion
-- -----------------------------------------------------
DROP TABLE IF EXISTS WebDB.Promotion ;

if not exists (select * from sysobjects where name='Promotion' and xtype='U')
	CREATE TABLE Promotion (
		id				INT NOT NULL IDENTITY,
		campaign_id		INT NOT NULL,
		product_id		INT NOT NULL,
		promotion_area	TINYINT NOT NULL DEFAULT 1,
		title			VARCHAR(100) NOT NULL,
		
		PRIMARY KEY(id),
		CONSTRAINT fk_Promotion_Product1
        FOREIGN KEY (product_id)
			REFERENCES Product (id)
			ON DELETE NO ACTION
			ON UPDATE CASCADE,
		CONSTRAINT fk_Promotion_Campaign1
			FOREIGN KEY (campaign_id)
			REFERENCES Campaign (id)
			ON DELETE NO ACTION
			ON UPDATE CASCADE
);

CREATE INDEX id_idx ON Promotion (product_id ASC);
CREATE INDEX fk_Promotion_Campaign1_idx ON Promotion (campaign_id ASC);
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Item promotion title. Ex: \"Now, 50% lower\"',
   'user', @CurrentUser, 'table', 'Promotion', 'column', 'title'
go

-- -----------------------------------------------------
-- Table WebDB.Recomm
-- -----------------------------------------------------
DROP TABLE IF EXISTS WebDB.Recomm ;

if not exists (select * from sysobjects where name='Recomm' and xtype='U')
	CREATE TABLE Recomm (
		id				INT NOT NULL IDENTITY,
		start_date		DATETIME2 NOT NULL,
		end_date		DATETIME2 NULL,
		product_id		INT NOT NULL,
		client_id		INT NOT NULL,

		
		PRIMARY KEY(id),
		CONSTRAINT id0
			FOREIGN KEY (product_id)
			REFERENCES Product (id)
			ON DELETE NO ACTION
			ON UPDATE NO ACTION,
		CONSTRAINT fk_Recomm_Client1
			FOREIGN KEY (client_id)
			REFERENCES Client (id)
			ON DELETE NO ACTION
			ON UPDATE NO ACTION
) ;

CREATE INDEX id_idx ON Recomm (product_id ASC);
CREATE INDEX fk_Recomm_Client1_idx ON Recomm (client_id ASC);
go

-- -----------------------------------------------------
-- Table WebDB.Physical_Item
-- -----------------------------------------------------
DROP TABLE IF EXISTS WebDB.Physical_Item ;

if not exists (select * from sysobjects where name='Physical_Item' and xtype='U')
	CREATE TABLE Physical_Item (
		id				INT NOT NULL IDENTITY(100001,1),
		external_id		VARCHAR(60) NULL,
		date_added		DATETIME2 NOT NULL DEFAULT GetDate(),
		status			CHAR(1) NOT NULL,
		product_id		INT NOT NULL,

		
		PRIMARY KEY(id),
		CONSTRAINT fk_Physical_Item_Product1
			FOREIGN KEY (product_id)
			REFERENCES Product (id)
			ON DELETE NO ACTION
			ON UPDATE NO ACTION
);

CREATE INDEX fk_Physical_Item_Product1_idx ON Physical_Item (product_id ASC);
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Na maioria dos casos é um número de série do fabricante',
   'user', @CurrentUser, 'table', 'Physical_Item', 'column', 'external_id'
go

-- -----------------------------------------------------
-- Table WebDB.Product_Attr
-- -----------------------------------------------------
DROP TABLE IF EXISTS WebDB.Product_Attr ;

if not exists (select * from sysobjects where name='Product_Attr' and xtype='U')
	CREATE TABLE Product_Attr (
		product_type_id  SMALLINT NOT NULL,
		name             VARCHAR(50) NOT NULL,
		description      VARCHAR(500) NULL,
		type			 VARCHAR(1) NOT NULL CHECK (type IN('D', 'N', 'S')),
	   
		PRIMARY KEY (product_type_id, name),
		CONSTRAINT fk_Product_Attr_Product_Type1
			FOREIGN KEY (product_type_id)
			REFERENCES Product_Type (id)
			ON DELETE NO ACTION
			ON UPDATE NO ACTION
			
	);

CREATE INDEX fk_Product_Attr_Product_Type_idx ON Product_Attr (product_type_id ASC);
go

-- -----------------------------------------------------
-- Table WebDB.Product_Attr_Value
-- -----------------------------------------------------
DROP TABLE IF EXISTS WebDB.Product_Attr_Value ;

if not exists (select * from sysobjects where name='Product_Attr_Value' and xtype='U')
	CREATE TABLE Product_Attr_Value (
		product_id		INT NOT NULL,
		product_type_id	SMALLINT NOT NULL,
		attr_name		VARCHAR(50) NOT NULL,
		numeric_val		DECIMAL(18,4) NULL,
		string_val		VARCHAR(4000) NULL,
		date_val		DATE NULL,
		modified_date	DATETIME2 NOT NULL DEFAULT GetDate(),

	   
	   PRIMARY KEY (product_id, product_type_id, attr_name),
	   CONSTRAINT fk_Product_Attr_Value_Product1
			FOREIGN KEY (product_id)
			REFERENCES Product (id)
			ON DELETE NO ACTION
			ON UPDATE NO ACTION,
		CONSTRAINT fk_Product_Attr_Value_Product_Attr1
			FOREIGN KEY (product_type_id , attr_name)
			REFERENCES Product_Attr (product_type_id , name)
			ON DELETE NO ACTION
			ON UPDATE NO ACTION
	);
CREATE INDEX fk_Product_Attr_Value_Product1_idx ON Product_Attr_Value (product_id ASC);
CREATE INDEX fk_Product_Attr_Value_Product_Attr1_idx ON Product_Attr_Value (product_type_id ASC, attr_name ASC);
go

-- -----------------------------------------------------
-- Table WebDB.Author
-- -----------------------------------------------------
DROP TABLE IF EXISTS WebDB.Author ;

if not exists (select * from sysobjects where name='Author' and xtype='U')
	CREATE TABLE Author (
		id			SMALLINT NOT NULL IDENTITY,
		name		VARCHAR(100) NOT NULL,
		fullname	VARCHAR(100),
		birthdate	DATE,
		description	VARCHAR(500),
		date_added	DATETIME2 NOT NULL DEFAULT GetDate(),

		PRIMARY KEY(id)
);
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Authors literary/pseudo name, for which he is known',
   'user', @CurrentUser, 'table', 'Author', 'column', 'name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Authors real full name',
   'user', @CurrentUser, 'table', 'Author', 'column', 'fullname'
go


DROP TABLE IF EXISTS WebDB.Stock;
go

if not exists (select * from sysobjects where name='Stock' and xtype='U')
	CREATE TABLE Stock (
		id			SMALLINT NOT NULL IDENTITY,
		id_product	INT NOT NULL,
		product_type_id INT NOT NULL,
		stock		INT NOT NULL,

		PRIMARY KEY(id),
		CONSTRAINT fk_Stock_Product1
			FOREIGN KEY (id_product)
			REFERENCES Product (id)
			ON DELETE NO ACTION
			ON UPDATE NO ACTION
);
go



-- -----------------------------------------------------
--
-- CREATE METAMODEL (via DML)
--
-- -----------------------------------------------------

INSERT INTO Product_Type
    (name, description, updated_by)
VALUES 
    ('book', 'All kinds of books (paperback, hardcover, eBook, etc.)', 0),
    ('electronic', 'All kinds of gadgets and electronic devices', 0);

DECLARE @book_prod_type SMALLINT;
DECLARE @elec_prod_type SMALLINT;

SELECT @book_prod_type = id FROM Product_Type WHERE name = 'book';
SELECT @elec_prod_type = id FROM Product_Type WHERE name = 'electronic';


INSERT INTO Product_Attr 
    (product_type_id, name, description, type)
VALUES 
    (@book_prod_type, 'title', 'Book title', 'S'),
    (@book_prod_type, 'author1_id', 'Book author(s)', 'N'),
    (@book_prod_type, 'author2_id', 'Book author(s)', 'N'),
    (@book_prod_type, 'author3_id', 'Book author(s)', 'N'),
    (@book_prod_type, 'literary_genre1', 'Literary genre 1 (eg, "Programming", "Python", etc.)', 'S'),
    (@book_prod_type, 'literary_genre2', 'Literary genre 2', 'S'),
    (@book_prod_type, 'literary_genre3', 'Literary genre 3', 'S'),
    (@book_prod_type, 'publishing_company', 'Name says it all', 'S'),
    (@book_prod_type, 'publication_date', 'Date of publication', 'D'),
    (@book_prod_type, 'edition_num', 'Edition number', 'N'),
    (@book_prod_type, 'isbn10', 'ISBN 10', 'S'),
    (@book_prod_type, 'isbn13', 'ISBN 13', 'S'),
    (@book_prod_type, 'book_format', 'Should be one of: paperback, hard cover, PDF, eBook', 'S'),
    (@book_prod_type, 'num_pages', 'Number of pages', 'N'),
    (@book_prod_type, 'language', 'Main language it was written on', 'S'),

    (@elec_prod_type, 'name', 'Product marketing designation', 'S'),
    (@elec_prod_type, 'model', 'Example:  MacBook Air 13, TP-Link TL-WA901ND, WD 2TB NAS Red Label, Raspberry PI 3', 'S'),
    (@elec_prod_type, 'release_date', 'Name says it all', 'D'),
    (@elec_prod_type, 'technical_specifications', 'All the other tecnhical characteristics of the product', 'S');

go
-- ---------------------------------------------------------
-- Table WebDB.DEBUG
-- 
-- The following table is used only for debugging purposes
-- ---------------------------------------------------------
DROP TABLE IF EXISTS DEBUG

if not exists (select * from sysobjects where name='DEBUG' and xtype='U')
	CREATE TABLE DEBUG (
		data	VARCHAR(5000),
		moment DATETIME2 DEFAULT GetDate()
);
go
-- -----------------------------------------------------
-- Trigger WebDB.BeforeNewClient
-- -----------------------------------------------------
DROP TRIGGER IF EXISTS BeforeNewClient;
go

CREATE TRIGGER BeforeNewClient
ON Client
INSTEAD OF INSERT, UPDATE
AS
BEGIN
	DECLARE @count int
	SELECT @count = COUNT(*) FROM deleted

	DECLARE @phone VARCHAR(20)
	DECLARE @password VARBINARY(100)
	DECLARE @fault_count int
	DECLARE @email VARCHAR(50)
	IF (@count = 0)
	BEGIN
		SELECT @phone = phone FROM inserted
		SELECT @password = password FROM inserted
		SELECT @fault_count = fault_count FROM inserted
		SELECT @email = email from inserted
	END
	ELSE
	BEGIN
		SELECT @phone = phone FROM deleted
		SELECT @password = password FROM deleted
		SELECT @fault_count = fault_count FROM deleted
		SELECT @email = email FROM deleted
	END

	IF (LEN(@phone) < 6 AND @phone LIKE '%[^0-9]%') 
	BEGIN
		RAISERROR('Invalid phone number',16, 1)
		RETURN
	END

	IF (@fault_count < 0)
	BEGIN
		RAISERROR('Fault error',16,1)
		RETURN
	END

	IF (@email NOT LIKE '%_@__%.__%')
	BEGIN
		RAISERROR('Invalid email address',16,1)
		RETURN
	END

	IF (@count = 0)
	BEGIN
		INSERT INTO Client
		SELECT email,password,firstname,surname,phone,create_time,fault_count,isactive,address,postcode,country,birthday,fiscal_num
		FROM inserted
	END
	ELSE
	BEGIN
		UPDATE Client
		SET email = NEW.email,
		password = NEW.password,
		firstname = NEW.firstname,
		surname = NEW.surname, 
		phone = NEW.phone,
		fault_count = NEW.fault_count,
		isactive = NEW.isactive,
		address = NEW.address,
		postcode = NEW.postcode,
		country = NEW.country,
		birthday = NEW.birthday,
		fiscal_num = NEW.fiscal_num
		
		FROM inserted NEW
		WHERE NEW.id = Client.id

	END
END
GO

-- -----------------------------------------------------
-- Trigger WebDB.BeforeNewProduct
-- -----------------------------------------------------
DROP TRIGGER IF EXISTS BeforeNewProduct
go


CREATE TRIGGER BeforeNewProduct
ON Product 
INSTEAD OF INSERT, UPDATE
AS
BEGIN

	DECLARE @count int
	SELECT @count = COUNT(*) FROM deleted
	
	IF (@count = 0)
	BEGIN
		INSERT into Product
		SELECT product_type_id, description, price, sku, product_image, updated_by, last_updated_date, isactive, weight, dimensions
		FROM inserted
	END
	ELSE
	BEGIN 
		UPDATE Product
		SET product_type_id = NEW.product_type_id,
			description = NEW.description,
			price = NEW.price,
			sku = NEW.sku,
			product_image = NEW.product_image,
			updated_by = NEW.updated_by,
			last_updated_date = GETDATE(),
			isactive = NEW.isactive,
			weight = NEW.weight,
			dimensions = NEW.dimensions
		FROM inserted NEW
		WHERE NEW.id = Product.id
	END
	declare @Product_image varchar(255)
	SELECT @Product_image = product_image FROM inserted 
	IF (@Product_image IS NULL)
	BEGIN
		Update Product
		SET product_image =  IDENT_CURRENT('Product')
		WHERE product_image IS NULL
	END
END
GO


-- -----------------------------------------------------
-- Trigger WebDB.BeforeNewCampaign
-- -----------------------------------------------------
DROP TRIGGER IF EXISTS BeforeNewCampaign
go

CREATE TRIGGER BeforeNewCampaign
ON Campaign 
INSTEAD OF INSERT, UPDATE
AS
BEGIN

	DECLARE @start_date DATETIME2
	DECLARE @end_date DATETIME2
	DECLARE @end_date2 DATETIME2
	DECLARE @count int

	SELECT @count = COUNT(*) FROM deleted
	IF (@count = 0)
	BEGIN
		SELECT @start_date = start_date FROM inserted
		SELECT @end_date = end_date FROM inserted
	END 
	ELSE
	BEGIN
		SELECT @start_date = start_date FROM deleted
		SELECT @end_date = end_date FROM deleted
	END

	IF (@end_date < @start_date OR @end_date IS NULL)
	BEGIN
		RAISERROR('Invalid end date', 16, 45000);
		RETURN
	END

	SELECT TOP 1 @end_date2 = C.end_date
    FROM Campaign AS C
    ORDER BY C.end_date DESC

	IF (@end_date2 IS NOT NULL AND @start_date < @end_date2)
	BEGIN
		RAISERROR('Error: invalid dates; previous campaign still going on', 16, 45000)
		RETURN
	END

	IF(@count=0)
	BEGIN
		INSERT into Campaign 
		SELECT title, start_date, end_date
		FROM inserted
	END
	ELSE
	BEGIN
		UPDATE Campaign 
		SET title = NEW.title,
		start_date = NEW.start_date,
		end_date = NEW.end_date
		FROM inserted NEW
		WHERE NEW.id = Campaign.id
	END
END
GO


-- -----------------------------------------------------
-- Trigger WebDB.BeforeNewProductAttrValue
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS BeforeNewProductAttrValue
GO

CREATE TRIGGER BeforeNewProductAttrValue
ON Product_Attr_Value
INSTEAD OF INSERT, UPDATE 
AS
BEGIN
	DECLARE @attr_type VARCHAR(1) -- CHECK (type IN('D', 'N', 'S'))
	DECLARE @string_val VARCHAR(4000)
	DECLARE @numeric_val DECIMAL(18,2)
	DECLARE @date_val DATE
	DECLARE @product_type_id SMALLINT
	DECLARE @attr_name VARCHAR(50)
	DECLARE @count INT

	SELECT @count = COUNT(*) FROM deleted

	IF(@count = 0)
	BEGIN
		SELECT @string_val = string_val FROM inserted
		SELECT @numeric_val = numeric_val FROM inserted
		SELECT @date_val = date_val FROM inserted
		SELECT @product_type_id = product_type_id FROM inserted
		SELECT @attr_name = attr_name FROM inserted
	END
	ELSE
		BEGIN
		SELECT @string_val = string_val FROM deleted
		SELECT @numeric_val = numeric_val FROM deleted
		SELECT @date_val = date_val FROM deleted
		SELECT @product_type_id = product_type_id FROM deleted
		SELECT @attr_name = attr_name FROM deleted
	END
	IF NOT ((@string_val IS NOT NULL AND @numeric_val IS NULL AND @date_val IS NULL) OR (@string_val IS NULL AND @numeric_val IS NOT NULL AND @date_val IS NULL) OR (@string_val IS NULL AND @numeric_val IS NULL AND @date_val IS NOT NULL) OR (@string_val IS NULL AND @numeric_val IS NULL AND @date_val IS NULL))
	BEGIN
		RAISERROR ('Use only one of string_val, numeric_val or date_val', 16, 1)
		RETURN
	END

	SELECT @attr_type = type 
	FROM Product_Attr
	WHERE product_type_id = @product_type_id
	AND name = @attr_name

	If(@attr_type IS NULL)
	BEGIN
		RAISERROR('Unknown product attribute', 16, 1)
	END

	 IF (@attr_type = 'S' AND (@numeric_val IS NOT NULL OR @date_val IS NOT NULL))  
    OR (@attr_type = 'N' AND (@string_val IS NOT NULL OR @date_val IS NOT NULL))
    OR (@attr_type = 'D' AND (@string_val IS NOT NULL OR @numeric_val IS NOT NULL))
	BEGIN
		RAISERROR('Invalid attribute type', 16, 1)
	END

	IF (@count = 0)
	BEGIN
		INSERT INTO Product_Attr_Value
		SELECT product_id, product_type_id, attr_name, numeric_val, string_val, date_val, modified_date
		FROM inserted

		UPDATE Product_Attr_Value
		SET modified_date = GETDATE()
		FROM inserted NEW
		WHERE NEW.product_id = Product_Attr_Value.product_id
	END
	ELSE
	BEGIN
		UPDATE Product_Attr_Value
		SET product_type_id = NEW.product_type_id,
			attr_name = NEW.attr_name,
			numeric_val = NEW.numeric_val,
			string_val = NEW.string_val,
			date_val = NEW.date_val,
			modified_date = GETDATE()
		FROM inserted NEW
		WHERE NEW.product_id = Product_Attr_Value.product_id
	END

END
GO

DROP TRIGGER IF EXISTS BeforeUpdateOrder
GO

CREATE TRIGGER BeforeUpdateOrder
ON [Order]
INSTEAD OF UPDATE
AS
BEGIN
	UPDATE [Order]
	SET client_id = NEW.client_id,
	order_date = NEW.order_date,
	delivery_addr = NEW.delivery_addr,
	shipping_costs = NEW.shipping_costs,
	payment_type = NEW.payment_type,
	payment_id = NEW.payment_id,
	payment_field1 = NEW.payment_field1,
	payment_field2 = NEW.payment_field2,
	payment_field3 = NEW.payment_field3,
	status = NEW.status,
	modified_date = GETDATE(),
	status_reason = NEW.status_reason
	FROM inserted NEW
	WHERE NEW.id = [Order].id
END
GO


--
--
--ADICIONAR RESTO DOS TRIGGERS
--
--
-- -----------------------------------------------------
-- Procedure WebDB.GetLoginInfo
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS GetUserLoginInfo
go

CREATE PROCEDURE GetUserLoginInfo @email VARCHAR(50)
AS
    SELECT id, password, firstname, surname, isactive, fault_count
      FROM Client
     WHERE Client.email = @email;
GO

-- -----------------------------------------------------
-- Procedure WebDB.GetCommonLoginInfo
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS GetCommonLoginInfo
go

CREATE PROCEDURE GetCommonLoginInfo @client_id INT
AS
    -- ------------------------------------------------------------
    -- *** EM FALTA: Concluir este procedimento (se for relevante)
    -- ------------------------------------------------------------
GO

-- -----------------------------------------------------
-- Procedure WebDB.GetCurrentPrommotion
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS GetCurrentCampaign
GO

CREATE PROCEDURE GetCurrentCampaign
AS
    DECLARE @campaign_id INT;
    DECLARE @campaign_title VARCHAR(100);
    SET @campaign_title = NULL;

    SELECT @campaign_id = id, @campaign_title = title
      FROM Campaign 
     WHERE GETDATE() BETWEEN start_date AND end_date;

    IF @campaign_title IS NULL
	BEGIN
        SET @campaign_title = '<span><strong>Seasonal</strong> <span class="invert">deals</span>';
    END

    SELECT @campaign_title;

    SELECT A.product_id, A.promotion_area, A.title, 
           B.description, B.price, B.product_image
      FROM Promotion AS A
           INNER JOIN Product B
                   ON B.id = product_id
     WHERE A.campaign_id = campaign_id; 
GO

-- -----------------------------------------------------
-- Procedure WebDB.UpdateLoginStatus
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS UpdateLoginStatus 
GO

CREATE PROCEDURE UpdateLoginStatus 
    @client_id   INT, 
    @isactive    BIT, 
    @fault_count TINYINT
AS 

    UPDATE Client 
       SET Client.isactive = @isactive, Client.fault_count = @fault_count
     WHERE id = @client_id;
GO

DROP PROCEDURE IF EXISTS ValidateISBN10
GO

CREATE PROCEDURE ValidateISBN10(@isbn10 VARCHAR(20))
AS
BEGIN
	DECLARE @i SMALLINT;
	SET @i = 1;

	DECLARE @t SMALLINT;
	SET @t = 0;

	DECLARE @s SMALLINT;
	SET @s = 0;

	SET @isbn10 = REPLACE(@isbn10, '-', '');
	SET @isbn10 = REPLACE(@isbn10, ' ', '');
	SET @isbn10 = REPLACE(@isbn10, '_', '');

	IF (LEN(@isbn10) != 10 OR @isbn10 LIKE '%[^0-9]%')
	BEGIN
		RAISERROR('Invalid ISBN',16,1)
		RETURN
	END

	--WHILE @i < 10
		--SET @t = @t + SUBSTRING(@isbn10, @i, 1);
		--SET @s = @s + @t;
		--SET @i = @i + 1;
	---END

	--SET @s = @s + (@t + IF(SUBSTRING(@isbn10, 10, 1) CHECK (typeIN ('x', 'X'), 10, SUBSTRING(@isbn10, 10, 1)));

END
GO

DROP PROCEDURE IF EXISTS ValidateISBN13
GO

CREATE PROCEDURE ValidateISBN13(@isbn13 VARCHAR(20))
AS
BEGIN
	DECLARE @i SMALLINT;
	SET @i = 1;

	DECLARE @t SMALLINT;
	SET @t = 0;

	DECLARE @s SMALLINT;
	SET @s = 0;

	SET @isbn13 = REPLACE(@isbn13, '-', '');
	SET @isbn13 = REPLACE(@isbn13, ' ', '');
	SET @isbn13 = REPLACE(@isbn13, '_', '');

	IF (LEN(@isbn13) != 13 OR @isbn13 LIKE '%[^0-9]%')
	BEGIN
		RAISERROR('Invalid ISBN',16,1)
		RETURN
	END

	--WHILE @i < 10
		--SET @t = @t + SUBSTRING(@isbn10, @i, 1);
		--SET @s = @s + @t;
		--SET @i = @i + 1;
	---END

	--SET @s = @s + (@t + IF(SUBSTRING(@isbn10, 10, 1) CHECK (typeIN ('x', 'X'), 10, SUBSTRING(@isbn10, 10, 1)));

END
GO
-- -----------------------------------------------------
-- Procedure WebDB.AddBook
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS AddBook
GO

CREATE PROCEDURE AddBook
    @prod_type_id        SMALLINT,
    @price_              DECIMAL(18,2),  -- NOT NULL
    @sku_                VARCHAR(50),    -- NOT NULL
    @prod_img            VARCHAR(300),   -- UNIQUE
    @updatedby           INT,            -- NOT NULL
    @weight_             DECIMAL(10,2),  -- NOT NULL COMMENT 'Weight in grams'
    @dims                VARCHAR(50),    -- NOT NULL
    @desc_               VARCHAR(4000),
    @title               VARCHAR(200),   -- NOT NULL
    @author1_id          SMALLINT,       -- NOT NULL
    @author2_id          SMALLINT,
    @author3_id          SMALLINT,
    @literary_genre1     VARCHAR(50),   -- NOT NULL
    @literary_genre2     VARCHAR(50),
    @literary_genre3     VARCHAR(50),
    @publishing_company  VARCHAR(100),
    @publishing_date     DATE,
    @edition_num         TINYINT,       -- DEFAULT 1
    @isbn10              VARCHAR(20),   -- NOT NULL
    @isbn13              VARCHAR(23),   -- NOT NULL
    @book_format         VARCHAR(5),   -- NOT NULL
    @num_pages           INT,           -- NOT NULL
    @language            VARCHAR(50),   -- DEFAULT 'English'
	@stock				 INT,

    @prod_id             INT OUTPUT
AS

    IF (@author1_id IS NULL AND @author2_id IS NULL AND @author3_id IS NULL)
	BEGIN
      RAISERROR('No authors IDs were given', 16, 45000)
    END

   EXEC ValidateISBN10 @isbn10
    -- -------------------------------------------------
    -- **** EM FALTA: Implementar procedimento ValidateISBN13
    -- -------------------------------------------------
    EXEC ValidateISBN13 @isbn13

    --BEGIN TRANSACTION;

    INSERT INTO Product (
        product_type_id,
        price,
        sku,
        product_image,
        updated_by,
        weight,
        dimensions,
        description
    ) VALUES (
        @prod_type_id,
        @price_,
        @sku_,
        @prod_img,
        @updatedby,
        @weight_,
        @dims,
        @desc_
    );
	

    SET @prod_id = @@IDENTITY

    INSERT INTO Product_Attr_Value
        (product_id, product_type_id, attr_name, string_val)
    VALUES
        (@prod_id, @prod_type_id, 'title', @title),
        (@prod_id, @prod_type_id, 'literary_genre1', @literary_genre1),
        (@prod_id, @prod_type_id, 'literary_genre2', @literary_genre2),
        (@prod_id, @prod_type_id, 'literary_genre3', @literary_genre3),
        (@prod_id, @prod_type_id, 'publishing_company', @publishing_company),
        (@prod_id, @prod_type_id, 'isbn10', @isbn10),
        (@prod_id, @prod_type_id, 'isbn13', @isbn13),
        (@prod_id, @prod_type_id, 'book_format', @book_format),
        (@prod_id, @prod_type_id, 'language', @language);        


    INSERT INTO Product_Attr_Value
        (product_id, product_type_id, attr_name, numeric_val)
    VALUES
        (@prod_id, @prod_type_id, 'edition_num', @edition_num),
        (@prod_id, @prod_type_id, 'num_pages', @num_pages);

    INSERT INTO Product_Attr_Value
        (product_id, product_type_id, attr_name, date_val)
    VALUES
        (@prod_id, @prod_type_id, 'publication_date', @publishing_date);

	INSERT INTO Stock
		(id_product, product_type_id, stock)
	VALUES
		(@prod_id, @prod_type_id, @stock)
    --COMMIT;
GO
-- -----------------------------------------------------
-- Procedure WebDB.AddElectronic
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS AddElectronic
GO

CREATE PROCEDURE AddElectronic(
	@prod_type_id      SMALLINT,
    @price_            DECIMAL(18,2),  -- NOT NULL
    @sku_              VARCHAR(50),    -- NOT NULL
    @updatedby         INT,            -- NOT NULL
    @weight_           DECIMAL(10,2),  -- NOT NULL COMMENT 'Weight in grams'
    @dims              VARCHAR(50),    -- NOT NULL
    @desc_             VARCHAR(4000),
    @name              VARCHAR(200),   -- NOT NULL
    @model             VARCHAR(200),
    @technical_specifications VARCHAR(4000),
    @release_date      DATETIME2,
	@stock			   INT,

    @prod_id    INT	  = NULL  OUTPUT
)
AS

BEGIN
	INSERT INTO Product (
		product_type_id,
		price,
		sku,
		updated_by,
		weight,
		dimensions,
		description
	) VALUES (
		@prod_type_id,
		@price_,
		@sku_,
		@updatedby,
		@weight_,
		@dims,
		@desc_
	);

	SET @prod_id = @@IDENTITY
	INSERT INTO Product_Attr_Value
		(product_id, product_type_id, attr_name, string_val)
	VALUES
		(@prod_id, @prod_type_id, 'name', @name),
		(@prod_id, @prod_type_id, 'model', @model),
		(@prod_id, @prod_type_id, 'technical_specifications', @technical_specifications);

	INSERT INTO Product_Attr_Value
		(product_id, product_type_id, attr_name, date_val)
	VALUES
		(@prod_id, @prod_type_id, 'release_date', @release_date);
		INSERT INTO Stock
		(id_product, product_type_id, stock)
	VALUES
		(@prod_id, @prod_type_id, @stock)
END
GO

-- -----------------------------------------------------
-- Procedure WebDB.GetProduct
-- Returns two result sets:
-- 1. The first RS has only one row with all common attributes. 
--    Each attribute is a column from the WebDB.Product table  
-- 2. The second RS has one row per attribute. Each attribute is 
--    taken from the WebDB.Product_Attr_Value table
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS GetProduct
GO

CREATE PROCEDURE GetProduct(
	@prod_id	INT = NULL
)
AS
BEGIN
	SELECT pt.name AS 'Product',
		p.description,
		price,
		sku,
		product_image,
		weight,
		dimensions
	FROM Product p
		INNER JOIN Product_Type pt ON product_type_id = pt.id
	WHERE p.id = @prod_id;

	SELECT PAV.attr_name as 'name',
		COALESCE(PAV.string_val, CAST(PAV.numeric_val AS VARCHAR), CAST(PAV.date_val AS VARCHAR)) AS 'value',
		PA.type AS 'type'
	FROM Product_Attr_Value AS PAV
		INNER JOIN Product_Attr AS PA
		ON PAV.product_type_id = PA.product_type_id
		AND PAV.attr_name = PA.name
	WHERE PAV.product_id = @prod_id;
END
GO

-- -----------------------------------------------------
-- Procedure WebDB.GetProduct2
-- Returns all product attributes as rows
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS GetProduct2
GO

CREATE PROCEDURE GetProduct2(
	@prod_id	INT = NULL
)
AS
BEGIN

	(SELECT 'product' AS 'name',
		pt.name AS 'value',
		'S' AS 'type'
	FROM Product
		INNER JOIN Product_Type pt
				ON product_type_id = pt.id
	WHERE Product.id = @prod_id)

	UNION ALL


	(SELECT 'description',
			TRIM(description),
			'S'
	FROM	Product
	WHERE	id = @prod_id)

	UNION ALL

	(SELECT 'price',
			CAST(price AS varchar),
			'N'
	FROM	Product
	WHERE	id = @prod_id)

	UNION ALL

	(SELECT 'sku',
			sku,
			'S'
	FROM	Product
	WHERE	id = @prod_id)

	UNION ALL

	(SELECT 'product_image',
			product_image,
			'S'
	FROM	Product
	WHERE	id = @prod_id)

	UNION ALL

	(SELECT 'weight',
			CAST(weight AS varchar),
			'N'
	FROM	Product
	WHERE	id = @prod_id)

	UNION ALL

	

	(SELECT PAV.attr_name,
			COALESCE(PAV.string_val, CAST(PAV.numeric_val AS VARCHAR), CAST(PAV.date_val AS VARCHAR)),
			PA.type
	FROM	Product_Attr_Value AS PAV
		INNER JOIN Product_Attr AS PA
				ON PAV.product_type_id = PA.product_type_id
			   AND PAV.attr_name = PA.name
	WHERE PAV.product_id = @prod_id);
END
GO

DROP PROCEDURE IF EXISTS AddClient
GO

CREATE PROCEDURE AddClient(
	@email		       VARCHAR(50),
    @password          VARCHAR(100),  -- NOT NULL
    @firstname         VARCHAR(50),    -- NOT NULL
    @surname           VARCHAR(50),            -- NOT NULL
    @phone             VARCHAR(21),  -- NOT NULL COMMENT 'Weight in grams'
    @address           VARCHAR(200),
    @postcode		   VARCHAR(7),
    @country		   VARCHAR(50),
	@birthday		   DATETIME,
	@fiscal_num		   VARCHAR(12),

    @prod_id    INT	= NULL   OUTPUT
)
AS
BEGIN
	DECLARE @create_time DATETIME2 = GETDATE()
	DECLARE @isactive BIT = 1
	DECLARE @NewPassword VARBINARY(100)

	IF (LEN(@password) < 6 AND NOT (@password LIKE '%[0-9]%' AND @password LIKE '%[A-Z]%' AND @password LIKE '%[a-z]%' AND(@password LIKE '%!%' OR @password LIKE '%#%' OR @password LIKE '%?%' OR @password LIKE '%[%]%')))  
	BEGIN
		RAISERROR('Invalid password',16, 1)
		RETURN
	END
	SET @NewPassword = HASHBYTES('SHA2_256', @password)

	INSERT INTO Client(
		email,
		password,
		firstname,
		surname,
		phone,
		create_time,
		isactive,
		address,
		postcode,
		country,
		birthday,
		fiscal_num
	) VALUES (
		@email,
		@NewPassword,
		@firstname,
		@surname,
		@phone,
		@create_time,
		@isactive,
		@address,
		@postcode,
		@country,
		@birthday,
		@fiscal_num
	);

	SET @prod_id = @@IDENTITY
END

GO

DROP PROCEDURE IF EXISTS AddAuthor
GO

CREATE PROCEDURE AddAuthor (
	@name			VARCHAR(100),
	@fullname		VARCHAR(100),
	@birthdate		DATE,
	@description	VARCHAR(500),

	@prod_id 		INT	= NULL	OUTPUT
)

AS

BEGIN
	INSERT INTO Author(
		name,
		fullname,
		birthdate,
		description,
		date_added
	) VALUES (
		@name,
		@fullname,
		@birthdate,
		@description,
		GETDATE()
	);

	SET @prod_id = @@IDENTITY

END
GO

DROP PROCEDURE IF EXISTS AddOrder 
GO

CREATE PROCEDURE AddOrder (
	@client_id			INT,
	@delivery_addr		VARCHAR(200),
	@shipping_costs		DECIMAL(18,2),
	@payment_type		CHAR(2),
	@payment_id			VARCHAR(100),
	@payment_field1		VARCHAR(100),
	@payment_field2		VARCHAR(100),
	@payment_field3		VARCHAR(100),
	@status				CHAR(2),
	@status_reason		VARCHAR(512)

)

AS
BEGIN
	INSERT INTO [Order](
		client_id,
		order_date,
		delivery_addr,
		shipping_costs,
		payment_type,
		payment_id,
		payment_field1,
		payment_field2,
		payment_field3,
		status,
		modified_date,
		status_reason
	) VALUES (
		@client_id,
		GETDATE(),
		@delivery_addr,
		@shipping_costs,
		@payment_type,
		@payment_id,
		@payment_field1,
		@payment_field2,
		@payment_field3,
		@status,
		GETDATE(),
		@status_reason
	)
END
GO

DROP PROCEDURE IF EXISTS AddOrder_Item
GO

CREATE PROCEDURE AddOrder_Item(
	@order_id			INT,
	@product_id			INT,
	@tax_amount			DECIMAL(18,2),
	@tax_description	VARCHAR(255),
	@physical_item_id	INT

)

AS
BEGIN
	INSERT INTO Order_Item (
		order_id,
		product_id,
		tax_amount,
		tax_description,
		physical_item_id,
		date_added
	) VALUES (
		@order_id,
		@product_id,
		@tax_amount,
		@tax_description,
		@physical_item_id,
		GETDATE()
	)
END
GO