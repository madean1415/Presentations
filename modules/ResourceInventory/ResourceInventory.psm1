using namespace System.Collections;
using namespace System.Collections.Generic;
using namespace System.Data;
using namespace System.Data.SqlClient;
using namespace System.IO;
using namespace Microsoft.SqlServer.Management.Smo;

[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo");

Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules\ResourceInventory\functions" | ForEach-Object -Process {
    . $PSItem.FullName;
}
Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules\ResourceInventory\classes"|Select-Object -ExpandProperty FullName|&{process{. $PSItem;}}
