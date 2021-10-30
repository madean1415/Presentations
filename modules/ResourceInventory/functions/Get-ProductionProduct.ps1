using namespace System.Collections;
using namespace System.Collections.Generic;
using namespace System.Data;

Function  Get-ProductionProduct
{
    <#
        .Synopsis
            Query the source AdventureWorks2014 Production.Product table and 
            store the results in a separate table.
        .DESCRIPTION
            Get data from the AdventureWorks2014 Production.Product table, and 
            combine with keyword match criteria. Results are stored in a 
            destination Production.Product SQL data table.
        .EXAMPLE
            Get-ProductionProduct -Expression "(Black|BK|\bGrip Tape\b|adjust|(?<!Front\s)Derailleur)"
        .INPUTS
            System.String
        .OUTPUTS
            System.Object
        .COMPONENT
            ResourceInventory module
        .NOTES
            creator: Mark Dean
            created: 2021-09-18
            description: "Query the source AdventureWorks2014 Production.Product table and store the results in a separate table."
            example: 
                - 'Get-ProductionProduct -Expression "(Black|BK|\bGrip Tape\b|adjust|(?<!Front\s)Derailleur)"'
            version: v1.0
            class: CommandLineTool
            baseCommand: SQL query
            inputs:
                example_flag:
                    type: string
                    inputBinding:
                        position: 0
                        prefix: -regex
    #>
    [CmdletBinding()]
        Param
        (
            [Parameter(Mandatory=$true,
                       ValueFromPipeline=$true,
                       ValueFromPipelineByPropertyName=$true,
                       Position=1,
                       HelpMessage="Enter a string value to be interpreted as a regular expression.")]
            [ValidateNotNull()]
            [ValidateNotNullOrEmpty()]
            [string]$Expression
        )
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

            function Add-Product([Product]$product)
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

            $sourceSet = Get-SourceSQLData "MyServer" "AdventureWorks2019" "C:\Program Files\WindowsPowerShell\Modules\ResourceInventory\scripts\sql\queries\Query-Production.Product.sql";

            foreach($i in $sourceSet.Tables[0])
            {
                $results = [Product]::new($i,$Expression);

                $dates = [Dictionary[string,string]]::new();
                $dates["SellEndDate"] = $i.SellEndDate;
                $dates["SellStartDate"] = $i.SellStartDate;

                $dateCollection = $results.GetProductDates($dates);

                $results.SellEndDate = $dateCollection[0];
                $results.SellStartDate = $dateCollection[1];
                $hashValue = @($i.Color,$lamba.Count;,$i.DaysToManufacture,$i.ListPrice,$i.Name,$i.ProductID,$i.ProductNumber,$i.ReorderPoint,$dateCollection[0],$dateCollection[1],$i.Style);
                $results.HashID = $results.NewHashID($hashValue-join"");

                Add-Product($results);
            }

            if($production.Rows.Count -gt 0)
            {
                Update-SQLTable "MyServer" "MyDatabase" "Production.ManageProduct" $production;
            }
        }
        catch
        {
            $PSItem *>> $fxnExceptionLog;
            Write-Output ("Error`r`nSee {0} file." -f $fxnExceptionLog);
        }
    }
}