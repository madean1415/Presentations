# The Resource Inventory Module

## Introduction

This module and manifest were created for a [Research Triangle PowerShell Users Group](https://www.meetup.com/Research-Triangle-PowerShell-Users-Group/) Five Minute Lightning demonstration. It gets source data from an **AdventureWorks2019** SQL database and transforms them using PowerShell objects and methods. This strategy is based on one that collects metadata from data systems across operational environments of a large enterprise.

## Scripting & performance considerations

As this module is meant for a demonstration, there may be script items or actions that are not optimized but exist as potential use cases. For example, the Product Class references the `SystemDateTime` enumerator, which is not fully used by the program. The enumerator and a class method exist to show how data systems having different base types for **datetime** properties—like those in Active Directory objects—can be transformed to meet destination standards. Furthermore, **try/catch exception handling** is not as robust as it would be in production code.

## The October 2021 demonstration

1. Syntax for a type extension for `System.Object` that creates the `NewHashID` method.
2. Include the type script file in the manifest.
3. Use the type extension in a cmdlet when calling the `Person` class.
4. Review the SQL results before and after subsequent source data updates.

## Remarks

### Manifest settings

Declare both `FunctionsToExport` and `CmdletsToExport` arrays using `= '*'`. Despite the best performance warnings, setting these with a wildcard reduced raised exceptions regarding missing module objects.

### Workflow impact

Type extensions might be a cause for PowerShell workflows failing to execute cmdlets and functions. This has not been evaluated, but observations suggest there might be causation for the raised exception.

### Type extension options

- Extend a specific custom class object rather than `System.Object`.

> The latter adds the extension to all `System.Objects` items in the module and so it needs to be scripted only once.
