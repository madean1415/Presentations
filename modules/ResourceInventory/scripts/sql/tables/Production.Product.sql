CREATE TABLE  Production.Product (
	 Color   varchar (15) NULL,
	 CriticalItems   varchar (500) NULL,
	 CriticalItemsCount   int  NULL,
	 CriticalItemsLength   int  NULL,
	 DaysToManufacture   int  NULL,
	 ListPrice   decimal (9, 2) NULL,
	 Name   varchar (128) NULL,
	 ProductID   int  NOT NULL Primary Key,
	 ProductNumber   varchar (25) NULL,
	 ReorderPoint   int  NULL,
	 SellEndDate   datetime2 (0) NULL,
	 SellStartDate   datetime2 (0) NULL,
	 Style   varchar (2) NULL,
	 RowModifiedDateTime   datetime2 (0) NULL,
	 HashID   varchar (64) NULL)
GO

ALTER TABLE  Production . Product  ADD  DEFAULT (sysutcdatetime()) FOR  RowModifiedDateTime 
GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Production', @level1type=N'TABLE',@level1name=N'Product'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Contains the products sold or used in the manufacturing of sold products.' , @level0type=N'SCHEMA',@level0name=N'Production', @level1type=N'TABLE',@level1name=N'Product'
GO
