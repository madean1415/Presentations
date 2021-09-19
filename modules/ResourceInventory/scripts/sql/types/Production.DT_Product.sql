CREATE TYPE [Production].[DT_Product] AS TABLE(
	[Color] [varchar](15) NULL,
	[CriticalItems] [varchar](500) NULL,
	[CriticalItemsCount] [int] NULL,
	[CriticalItemsLength] [int] NULL,
	[DaysToManufacture] [int] NULL,
	[ListPrice] [decimal](9, 4) NULL,
	[Name] [varchar](128) NULL,
	[ProductID] [int] NOT NULL,
	[ProductNumber] [varchar](25) NULL,
	[ReorderPoint] [int] NULL,
	[SellEndDate] [datetime2](0) NULL,
	[SellStartDate] [datetime2](0) NULL,
	[Style] [varchar](2) NULL,
	[HashID] [varchar](64) NULL
)
GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Production', @level1type=N'TYPE',@level1name=N'DT_Product'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'User-Defined Table Type used as a Table-Valued Parameter (TVP).' , @level0type=N'SCHEMA',@level0name=N'Production', @level1type=N'TYPE',@level1name=N'DT_Product'
GO


