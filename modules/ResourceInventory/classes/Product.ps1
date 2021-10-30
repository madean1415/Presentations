using namespace System.Collections;
using namespace System.Collections.Generic;

Enum SystemDateType
{
    SellEndDate = 0;
    SellStartDate = 1;
    AccountLockoutTime = 2;
    Created = 3;
    LastBadPasswordAttempt = 4;
    LastLogonDate = 5;
    Modified = 6;
    PasswordLastSet = 7;
    BadPasswordTime = 16;
    LastLogoff = 17;
    LastSuccessfulInteractiveLogonTime = 18;
    LockOutTime = 19;
}

Class Product
{
    hidden [string] $Color;
    hidden [string] $CriticalItems;
    hidden [int] $CriticalItemsCount;
    hidden [int] $CriticalItemsLength;
    hidden [int] $DaysToManufacture;
    hidden [decimal] $ListPrice;
    hidden [string] $Name;
    hidden [int] $ProductID
    hidden [string] $ProductNumber;
    hidden [int] $ReorderPoint;
    [datetime] $SellEndDate;
    [datetime] $SellStartDate;
    hidden [string] $Style;
    [string] $HashID;

    Product([System.Object]$table,[string]$expr)
    {
        $mu = $this.SetMatchedTerms($expr, @($table.Color,$table.Name,$table.ProductNumber));
        $this.Color = $table.Color;
        $this.CriticalItems = $mu -join "^";
        $this.CriticalItemsCount = $mu.Count; 
        $this.CriticalItemsLength= $mu.Length;
        $this.DaysToManufacture = $table.DaysToManufacture
        $this.ListPrice = [decimal]::Round($table.ListPrice,2);
        $this.Name = $table.Name;
        $this.ProductID = $table.ProductID;
        $this.ProductNumber = $table.ProductNumber;
        $this.ReorderPoint = $table.ReorderPoint;
        $this.Style = $table.Style;
    }

    [array] SetMatchedTerms($regex,$item)
    {
        $lamba = [List [string]]::new()
        $matchTerms = {param($x) process{ $x -match $regex} }       
        
        &$matchTerms $item |&{
            process
            {
                [void]$lamba.Add($_)
            }
        }
        return $lamba;
    }

    [datetime] ConvertToSQLDateTime([string]$value,[string]$key)
    {
        $convert = Switch($value)
        {
            0{'1900-01-01';break}
            {[SystemDateType]::$key.value__ -le 7 -and ([datetime]$_).Year -lt 1900}{'1900-01-01';break}
            {[SystemDateType]::$key.value__ -gt 7}{[datetime]::FromFileTime($_);break}
            default{$_}
        }
        return $convert;
    }

    [ArrayList] GetProductDates($entry)
    {
        $dateCollection = [ArrayList]::new();
        foreach($key in $entry.Keys)
        {
            if($entry[$key])
            {
                [void]$dateCollection.Add($this.ConvertToSQLDateTime($entry[$key],$key));
            }
            else
            {
                [void]$dateCollection.Add($this.ConvertToSQLDateTime(0,$key));
            }
        }
        return $dateCollection;
    }
}