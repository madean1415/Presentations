using namespace System.Collections;
using namespace System.Collections.Generic;
using namespace System.Data;
using namespace System.Data.SqlClient;
using namespace System.IO;
using namespace Microsoft.SqlServer.Management.Smo;

Get-ChildItem -Path ".\Modules\ResourceInventory\functions" | ForEach-Object -Process {
    . $PSItem.FullName
}

[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo");
