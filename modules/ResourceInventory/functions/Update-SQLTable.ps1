function Update-SQLTable
{
    <#
    .NOTES
        Pass parameter values as a DataTable object.
        Objects are reference variables in PowerShell by default.
    #>
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $serverName,

        [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=1)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $databaseName,

        [Parameter(Mandatory=$true,
            HelpMessage="Object must reference a DataTable object.",
            Position=2)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.Data.DataTable]$object
    )
    process
    {
        [Server]$targetServer = "$($serverName)";
        [Database]$targetDatabase = $targetServer.Databases.Item("$($databaseName)");

        $targetConnection = [SQLConnection]::new("Server=$($targetServer.Name); Database=$($targetDatabase.Name); Integrated Security=true");
            $targetConnection.Open();
                $manageTargetTable = [SqlCommand]::new("Production.ManageProduct",$targetConnection);
                $manageTargetTable.CommandType = [CommandType]::StoredProcedure;
                $manageTargetTable.Parameters.Add([SqlParameter]::new("@dt",[SQLDbType].Structured)).Value = $object;
                [void]$manageTargetTable.ExecuteNonQuery();
            $targetConnection.Close();
    }
}