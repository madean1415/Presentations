CREATE PROCEDURE [Production].[ManageProduct]
    @dt Production.DT_Product READONLY
AS
UPDATE tt
SET tt.Color = st.Color
,tt.CriticalItems = st.CriticalItems
,tt.CriticalItemsCount = st.CriticalItemsCount
,tt.CriticalItemsLength = st.CriticalItemsLength
,tt.DaysToManufacture = st.DaysToManufacture
,tt.ListPrice = st.ListPrice
,tt.Name = st.Name
,tt.ProductID = st.ProductID
,tt.ProductNumber = st.ProductNumber
,tt.ReorderPoint = st.ReorderPoint
,tt.SellEndDate = st.SellEndDate
,tt.SellStartDate = st.SellStartDate
,tt.Style = st.Style
,tt.RowModifiedDateTime = SYSUTCDATETIME()
,tt.HashID = st.HashID
FROM Production.Product As tt
INNER JOIN @dt As st
ON st.ProductID = tt.ProductID AND (st.HashID != tt.HashID OR tt.HashID IS NULL)

INSERT INTO Production.Product(Color,CriticalItems,CriticalItemsCount,CriticalItemsLength,DaysToManufacture,ListPrice,Name,ProductID,ProductNumber,ReorderPoint,SellEndDate,SellStartDate,Style,HashID)
SELECT st.Color,st.CriticalItems,st.CriticalItemsCount,st.CriticalItemsLength,st.DaysToManufacture,st.ListPrice,st.Name,st.ProductID,st.ProductNumber,st.ReorderPoint,st.SellEndDate,st.SellStartDate,st.Style,st.HashID
FROM @dt As st
LEFT OUTER JOIN Production.Product As tt
ON tt.ProductID = st.ProductID
WHERE tt.ProductID IS NULL;

DELETE tt FROM Production.Product As tt
LEFT OUTER JOIN @dt As st
ON st.ProductID = tt.ProductID
WHERE st.ProductID IS NULL;

RETURN 0 

GO

EXEC sys.sp_addextendedproperty @name=N'Creator', @value=N'Mark Dean' , @level0type=N'SCHEMA',@level0name=N'Production', @level1type=N'PROCEDURE',@level1name=N'ManageProduct'
GO

EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Manages the data content of the Production.Product table with source data passed in using the TVP Production.DT_Product.' , @level0type=N'SCHEMA',@level0name=N'Production', @level1type=N'PROCEDURE',@level1name=N'ManageProduct'
GO