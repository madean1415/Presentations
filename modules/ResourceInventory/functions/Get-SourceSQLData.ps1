using namespace Microsoft.SqlServer.Management.Smo;

function Get-SourceSQLData
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $SourceServer,
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1,
            HelpMessage = "SQL database name where query executes.")]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $SourceDatabase,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2,
            HelpMessage = "Full path of SQL script file.")]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $ScriptFile
    )
    Begin
    {
        [void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo");
    }
    Process
    {
        [Server]$server = $SourceServer;
        [Database]$database = $server.Databases.Item($SourceDatabase);
        return $database.ExecuteWithResults("$(Get-Content $ScriptFile)");
    }
}