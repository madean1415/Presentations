function  Get-ProductionProduct
{
    <#
    .Synopsis
        Query the Production.Product table in the AdventureWorks2014 database.
    .DESCRIPTION
        Query the Production.Product table in the AdventureWorks2014 database.
    .EXAMPLE
        Get-ProductionProduct;
    .OUTPUTS
        DataTable (as SQL TVP)
    .COMPONENT
        ResourceInventory module
    #>
    [CmdletBinding()]
    Param()
    Process
    {
        $fxnExceptionLog = "C:\Program Files\WindowsPowerShell\Modules\ResourceInventory\errors\Get-ProductionProduct\$((Get-Date).ToString("s").Replace(':','_')).log";
        try
        {
            $production = [DataTable]::new('Product','Production')
                [void]$production.Columns.Add('Color',[string]);
                [void]$production.Columns.Add('CriticalItems',[string]);
                [void]$production.Columns.Add('CriticalItemsCount',[int]);
                [void]$production.Columns.Add('CriticalItemsLength',[int]);
                [void]$production.Columns.Add('DaysToManufacture',[int]);
                [void]$production.Columns.Add('ListPrice',[decimal]);
                [void]$production.Columns.Add('Name',[string]);
                [void]$production.Columns.Add('ProductID',[int]);
                [void]$production.Columns.Add('ProductNumber',[string]);
                [void]$production.Columns.Add('ReorderPoint',[int]);
                [void]$production.Columns.Add('SellEndDate',[datetime]);
                [void]$production.Columns.Add('SellStartDate',[datetime]);
                [void]$production.Columns.Add('Style',[string]);
                [void]$production.Columns.Add('HashID',[string]);

            function Add-Item([Product]$product)
            {
                process
                {
                    $row = $production.NewRow();
                        $row.Color = $product.Color;
                        $row.CriticalItems = $product.CriticalItems;
                        $row.CriticalItemsCount = $product.CriticalItemsCount;
                        $row.CriticalItemsLength = $product.CriticalItemsLength;
                        $row.DaysToManufacture = $product.DaysToManufacture;
                        $row.ListPrice = $product.ListPrice;
                        $row.Name = $product.Name;
                        $row.ProductID = $product.ProductID;
                        $row.ProductNumber = $product.ProductNumber;
                        $row.ReorderPoint = $product.ReorderPoint;
                        $row.SellEndDate = $product.SellEndDate;
                        $row.SellStartDate = $product.SellStartDate;
                        $row.Style = $product.Style;
                        $row.HashID = $product.HashID;
                    $production.Rows.Add($row);
                }
            }

            $matchStuff = {param($x) process{ $x -match "(Black|BK|\bGrip Tape\b|adjust|(?<!Front\s)Derailleur)"} }

            [Server]$sourceServer = "MyServer";
            [Database]$sourceDatabase = $sourceServer.Databases.Item('AdventureWorks2014');
            $sourceQuery = Get-Content ".\Query-Production.Product.sql";
            $sourceSet = $sourceDatabase.ExecuteWithResults("$sourceQuery");

            foreach($i in $sourceSet.Tables[0])
            {
                $results = [Product]::new();

                $props = @($i.Color,$i.Name,$i.ProductNumber);
                $lamba = Get-MyStuff -Expression $matchStuff -item $props -ErrorVariable +err -ErrorAction SilentlyContinue;

                $x = [Dictionary[string,string]]::new();
                $x["SellEndDate"] = $i.SellEndDate;
                $x["SellStartDate"] = $i.SellStartDate;

                $times = [ArrayList]::new();
                foreach($k in $x.Keys)
                {
                    if($x[$k])
                    {
                        [void]$times.Add($results.ConvertToSQLDateTime($x[$k],$k));
                    }
                    else
                    {
                        [void]$times.Add($results.ConvertToSQLDateTime(0,$k));
                    }
                }

                $hashValue = @($i.Color,$i.DaysToManufacture,$i.ListPrice,$i.Name,$i.ProductID,$i.ProductNumber,$i.ReorderPoint,$times[0],$times[1],$i.Style);

                $results.Color = $i.Color;
                $results.CriticalItems = $lamba -join "^";
                $results.CriticalItemsCount = $lamba.Count;
                $results.CriticalItemsLength = $lamba.Length;
                $results.DaysToManufacture = $i.DaysToManufacture;
                $results.ListPrice = [decimal]::Round($i.ListPrice,2);
                $results.Name = $i.Name;
                $results.ProductID = $i.ProductID;
                $results.ProductNumber = $i.ProductNumber;
                $results.ReorderPoint = $i.ReorderPoint;
                $results.SellEndDate = $times[0];
                $results.SellStartDate = $times[1];
                $results.Style = $i.Style;
                $results.HashID = $results.NewHashID($hashValue-join"");
                Add-Item($results);
            }

            if($production.Rows.Count -gt 0)
            {
                Update-SQLTable("MyServer","MyDatabase",$production)
            }
        }
        catch
        {
            $PSItem *>> $fxnExceptionLog;
        }
    }
}