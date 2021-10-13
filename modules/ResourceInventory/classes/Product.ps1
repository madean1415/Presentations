Class Product
{
    [string] $Color;
    [string] $CriticalItems;
    [int] $CriticalItemsCount;
    [int] $CriticalItemsLength;
    [int] $DaysToManufacture;
    [decimal] $ListPrice;
    [string] $Name;
    [int] $ProductID
    [string] $ProductNumber;
    [int] $ReorderPoint;
    [datetime] $SellEndDate;
    [datetime] $SellStartDate;
    [string] $Style;
    [string] $HashID;

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
}