function Get-MyStuff
{
    [CmdletBinding()]
    Param(
    [Scriptblock] $Expression,
    [Array] $item
    )
    process
    {
        $results = [List [string]]::new()
        &$Expression $item |&{
            process
            {
                [void]$results.Add($_)
                return $results;
            }
        }
    }
}