using namespace System.Collections;

Class DimDate
{
    [string] $Month;
    [int] $RandomNbr;
    [int] $Year;

    [string]GetMonthName($p1)
    {
        return (Get-Culture).DateTimeFormat.GetMonthName($p1)
    }

    [ArrayList]GetYearList([int]$LowerYear,[int]$UpperYear,[int]$minimum,[int]$maximum)
    {
        $results = [ArrayList]::new();
        for ($i = $LowerYear; $i -le $UpperYear; $i++)
        {
            for ($j = 1; $j -le 12; $j++)
            {
                $x = [DimDate]::new();
                $x.Month = $x.GetMonthName($j);
                $x.RandomNbr = Get-Random -Minimum $minimum -Maximum $maximum;
                $x.Year = $i;
                [void]$results.Add($x);
            }
        }
        return $results;
    }
}