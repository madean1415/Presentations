using namespace System.Collections;
using namespace System.Collections.Generic;
using namespace System.Data;
using namespace System.Data.SqlClient;
using namespace System.IO;
using namespace Microsoft.SqlServer.Management.Smo;

[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo");

# Use the full file path in these Get-ChildItem statements.

Get-ChildItem -Path ".\Modules\ResourceInventory\functions" | ForEach-Object -Process {
    . $PSItem.FullName
}

Get-ChildItem -Path ".\Modules\ResourceInventory\classes" | ForEach-Object -Process {
    . $PSItem.FullName
}