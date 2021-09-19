using namespace System.Data;
using namespace Microsoft.SqlServer.Management.Smo;

[void][reflection.assembly]::LoadWithPartialName("Microsoft.Sqlserver.Smo");

[Server]$sourceServer = 'MyServer';

Enum DNISchema
{
    dbo = 1
    informationSchema  = 2
    sys = 3
}

Enum DNIDatabase
{
    master = 1
    model = 2
    msdb = 3
    tempdb = 4
}

Class InvenTable
{
    [string]$DatabaseName;
    [int]$NbrTables;
    [decimal]$Quotient;
    [string]$ServerName;

    InvenTable($q0,$q1,$q2)
    {
        [int]$d = $q2.Count;
        [int]$n = ($q2|Where-Object{$_.HasCompressedPartitions -eq $true}).Count;

        $this.DatabaseName = $q0;
        $this.ServerName = $q1;
        $this.NbrTables = $d;
        $this.Quotient = switch($d)
        {
            0{0.00}
            Default{$n/$d}
        }
    }
}

$compressedTables = [DataTable]::new("CompressedTables","Inventory");
    [void]$compressedTables.Columns.Add("DatabaseName",[string]);
    [void]$compressedTables.Columns.Add("NbrTables",[int]);
    [void]$compressedTables.Columns.Add("Quotient",[decimal]);
    [void]$compressedTables.Columns.Add("ServerName",[string]);

    function Add-Item($item)
    {
        process
        {
            $row = $compressedTables.NewRow();
                $row.DatabaseName = $item.DatabaseName;
                $row.NbrTables = $item.NbrTables;
                $row.Quotient = $item.Quotient;
                $row.ServerName = $item.ServerName;
            $compressedTables.Rows.Add($row);
        }
    }

<#
Measure-Command{
$x = $sourceServer.Databases.Where({$_.Name -notin [DNIDatabase].GetEnumValues() -and $_.Tables.Schema -notin [DNISchema].GetEnumValues()})|Select-Object @{l="DatabaseName";e={$_.Name}},@{l="ServerName";e={$_.Parent.Name}},Tables;
foreach($i in $x)
{
    Add-Item([InvenTable]::new($i.DatabaseName,$i.ServerName,$i.Tables))
}
}
#>

Measure-Command{
$sourceServer.Databases.Where({$_.Name -notin [DNIDatabase].GetEnumValues() -and $_.Tables.Schema -notin [DNISchema].GetEnumValues()})|Select-Object @{l="DatabaseName";e={$_.Name}},@{l="ServerName";e={$_.Parent.Name}},Tables|%{
        Add-Item([InvenTable]::new($_.DatabaseName,$_.ServerName,$_.Tables))
}
}

return $compressedTables;

foreach($i in $compressedTables)
{
    if($i.NbrTables -gt 0)
    {
        Write-Output("{0} of {1} inventoried tables in {2}.{3} are compressed." -f $i.Quotient.ToString('P'),$i.NbrTables,$i.ServerName,$i.DatabaseName);
    }
    else
    {
        Write-Output("No inventoried tables in {0}.{1}." -f $i.ServerName,$i.DatabaseName);
    }
}