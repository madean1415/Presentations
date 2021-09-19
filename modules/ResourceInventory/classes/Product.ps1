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