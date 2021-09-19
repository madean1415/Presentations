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

            function AddItem([Product]$item)
            {
                $row = $production.NewRow();
                    $row.Color = $item.Color;
                    $row.CriticalItems = $item.CriticalItems;
                    $row.CriticalItemsCount = $item.CriticalItemsCount;
                    $row.CriticalItemsLength = $item.CriticalItemsLength;
                    $row.DaysToManufacture = $item.DaysToManufacture;
                    $row.ListPrice = $item.ListPrice;
                    $row.Name = $item.Name;
                    $row.ProductID = $item.ProductID;
                    $row.ProductNumber = $item.ProductNumber;
                    $row.ReorderPoint = $item.ReorderPoint;
                    $row.SellEndDate = $item.SellEndDate;
                    $row.SellStartDate = $item.SellStartDate;
                    $row.Style = $row.Style;
                    $row.HashID = $item.HashID;
                $production.Rows.Add($row);
            }

            $matchStuff = {param($x) $x -match "(Black|BK|\bGrip Tape\b|adjust|(?<!Front\s)Derailleur)"}

            function GetMyStuff
            {
                [CmdletBinding()]
                Param(
                [Scriptblock] $Expression,
                [Array] $item
                )

                $results = [List [string]]::new()
                &$Expression $item | ForEach-Object{[void]$results.Add($_)}
                $results;
            }

            [Server]$sourceServer = "MyServer";
            [Database]$sourceDatabase = $sourceServer.Databases.Item('AdventureWorks2014');
            $sourceQuery = Get-Content ".\Query-Production.Product.sql";
            $sourceSet = $sourceDatabase.ExecuteWithResults("$sourceQuery");

            foreach($i in $sourceSet.Tables[0])
            {
                $results = [Product]::new();

                $props = @($i.Color,$i.Name,$i.ProductNumber);
                $lamba = GetMyStuff -Expression $matchStuff -item $props -ErrorVariable +err -ErrorAction SilentlyContinue;

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
                AddItem($results);
            }

            if($production.Rows.Count -gt 0)
            {
                [Server]$targetServer = "MyServer";
                [Database]$targetDatabase = $targetServer.Databases.Item("MyDatabase");

                $targetConnection = [SQLConnection]::new("Server=$($targetServer.Name); Database=$($targetDatabase.Name); Integrated Security=true");
                $targetConnection.Open();
                    $manageTargetTable = [SqlCommand]::new("Production.ManageProduct",$targetConnection);
                    $manageTargetTable.CommandType = [CommandType]::StoredProcedure;
                    $manageTargetTable.Parameters.Add([SqlParameter]::new("@dt",[SQLDbType].Structured)).Value = $production;
                    [void]$manageTargetTable.ExecuteNonQuery();
                $targetConnection.Close();
            }
        }
        catch
        {
            $PSItem *>> $fxnExceptionLog;
        }
    }
}