# The Resource Inventory Module

## Introduction

This module and manifest were created for a [Research Triangle PowerShell Users Group](https://www.meetup.com/Research-Triangle-PowerShell-Users-Group/) Five Minute Lightning demonstration. It gets source data from an **AdventureWorks** SQL database and transforms them using PowerShell objects and methods. This strategy is modified from one for the collection of metadata from data systems across multiple operational environments in a large enterprise.

## Development environments

- **Powershell**: `PSVersion, 5.1.14409.1018; PSEdition, Desktop; PSCompatibleVersions, {1.0, 2.0, 3.0, 4.0...}`
- **SQL Server**: `Microsoft SQL Server 2016`, `Microsoft SQL Server 2019`

## Scripting & performance considerations

Scripting, items, or actions may exist to demonstrate use cases during the demonstration. For example, the `Product` class references the `SystemDateTime` _enumerator_ class. The enumerator and a class method are provided to show how datetime elements with differing base types—like those found in Active Directory objects—can be transformed to meet destination standards. Lastly, **try/catch exception handling** is not as robust as it would be in production code.

### The October 2021 demonstration

1. Syntax for a type extension for `System.Object` that creates the `NewHashID` method.
2. Include the type script file in the manifest.
3. Use the type extension in a cmdlet when calling the `Product` class.
4. Review the SQL results before and after subsequent source data updates.

#### Manifest settings

Declare both `FunctionsToExport` and `CmdletsToExport` arrays using `= '*'`. Despite the best performance warnings, setting these with a wildcard reduced raised exceptions regarding missing module objects.

>The full file path may need to be specified in `Get-ChildItem -Path` in the **module file** if an exception is raised on `Import-Module ResourceInventory -Force`

#### PowerShell workflow impact

Type extensions might be a cause for PowerShell workflows failing to execute cmdlets and functions. This has not been evaluated, but observations suggest there might be causation for the raised exception.

#### Type extension option

Adding a type extension to `System.Objects` applies it to all Object items in the module, and so it needs to be scripted only once. This is similar to creating a static member on a class. It may be possilbe to extend one or more types for custom classes, like Product. However, this has not been tested as of this README release.
