using namespace Microsoft.SqlServer.Management.Smo;
using namespace System.Data;
using namespace System.Data.SqlClient;

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
        [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $ServerName,

        [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=1)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DatabaseName,

        [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                HelpMessage="SchemaName.ProcedureName",
                Position=2)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^\w+\.\w+$")]
        [string] $StoredProcedure,

        [Parameter(Mandatory=$true,
            HelpMessage="Object must reference a DataTable object.",
            Position=3)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.Data.DataTable] $Object
    )
    Begin
    {
        [void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo");
    }
    Process
    {
        [Server]$server = $ServerName;
        [Database]$database = $server.Databases.Item($DatabaseName);

        $targetConnection = [SQLConnection]::new("Server=$($server.Name); Database=$($database.Name); Integrated Security=true");
            $targetConnection.Open();
                $manageTargetTable = [SqlCommand]::new("$($StoredProcedure)",$targetConnection);
                $manageTargetTable.CommandType = [CommandType]::StoredProcedure;
                $manageTargetTable.Parameters.Add([SqlParameter]::new("@dt",[SQLDbType].Structured)).Value = $Object;
                [void]$manageTargetTable.ExecuteNonQuery();
            $targetConnection.Close();
    }
}