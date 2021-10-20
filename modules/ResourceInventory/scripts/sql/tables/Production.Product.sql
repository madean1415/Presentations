CREATE TABLE [Production].[Product](
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
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [History].[Product] )
)
GO

ALTER TABLE [Production].[Product] ADD  DEFAULT (sysutcdatetime()) FOR [RowModifiedDateTime]
GO

ALTER TABLE [Production].[Product] ADD  CONSTRAINT [DF_SysStart]  DEFAULT (sysutcdatetime()) FOR [SysStartTime]
GO

ALTER TABLE [Production].[Product] ADD  CONSTRAINT [DF_SysEnd]  DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) FOR [SysEndTime]
GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Production', @level1type=N'TABLE',@level1name=N'Product'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Contains the products sold or used in the manufacturing of sold products.' , @level0type=N'SCHEMA',@level0name=N'Production', @level1type=N'TABLE',@level1name=N'Product'
GO