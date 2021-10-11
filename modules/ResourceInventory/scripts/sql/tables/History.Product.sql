CREATE TABLE [History].[Product](
	[Color] [varchar](15) NULL,
	[CriticalItems] [varchar](500) NULL,
	[CriticalItemsCount] [int] NULL,
	[CriticalItemsLength] [int] NULL,
	[DaysToManufacture] [int] NULL,
	[ListPrice] [decimal](9, 2) NULL,
	[Name] [varchar](128) NULL,
	[ProductID] [int] NOT NULL,
	[ProductNumber] [varchar](25) NULL,
	[ReorderPoint] [int] NULL,
	[SellEndDate] [datetime2](0) NULL,
	[SellStartDate] [datetime2](0) NULL,
	[Style] [varchar](2) NULL,
	[RowModifiedDateTime] [datetime2](0) NULL,
	[HashID] [varchar](64) NULL,
	[SysStartTime] [datetime2](7) NOT NULL,
	[SysEndTime] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'History', @level1type=N'TABLE',@level1name=N'Product'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'History table for the temporal table, Production.Product.' , @level0type=N'SCHEMA',@level0name=N'History', @level1type=N'TABLE',@level1name=N'Product'
GO

EXEC sys.sp_addextendedproperty @name=N'See_Also', @value=N'https://docs.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables?view=sql-server-ver15' , @level0type=N'SCHEMA',@level0name=N'History', @level1type=N'TABLE',@level1name=N'Product'
GO
