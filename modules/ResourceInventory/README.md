# The Resource Inventory Module

## Introduction

This module and manifest were created for a [Research Triangle PowerShell Users Group](https://www.meetup.com/Research-Triangle-PowerShell-Users-Group/) Five Minute Lightning demonstration. It gets source data from an **AdventureWorks** SQL database and transforms them using PowerShell objects and methods. This strategy is modified from one for the collection of metadata from data systems across multiple operational environments in a large enterprise.

## Development environments

- **Powershell**: `PSVersion, 5.1.14409.1018; PSEdition, Desktop; PSCompatibleVersions, {1.0, 2.0, 3.0, 4.0...}`
- **SQL Server**: `Microsoft SQL Server 2016` 

## Scripting & performance considerations

Scripting, items, or actions may exist to demonstrate use cases during the demonstration. For example, the `Product` class references the `SystemDateTime` enumerator, which is not used fully by the program. The enumerator and a class method are provided to show how elements with differing datetime-like properties—like Active Directory objects—can be transformed to meet destination standards. Lastly, **try/catch exception handling** is not as robust as it would be in production code.

### The October 2021 demonstration

1. Syntax for a type extension for `System.Object` that creates the `NewHashID` method.
2. Include the type script file in the manifest.
3. Use the type extension in a cmdlet when calling the `Person` class.
4. Review the SQL results before and after subsequent source data updates.

#### Manifest settings

Declare both `FunctionsToExport` and `CmdletsToExport` arrays using `= '*'`. Despite the best performance warnings, setting these with a wildcard reduced raised exceptions regarding missing module objects.

#### PowerShell workflow impact

Type extensions might be a cause for PowerShell workflows failing to execute cmdlets and functions. This has not been evaluated, but observations suggest there might be causation for the raised exception.

#### Type extension option

- _Not tested or demonstrated_: Extend a specific custom class object rather than `System.Object`.

> Adding a type extension to `System.Objects` applies it to all Object items in the module, and so it needs to be scripted only once.
