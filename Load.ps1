#build module script
[cmdletbinding()]
Param(
    [string]$ModuleName = "TfsModule"
    ,
    [switch]$Major
    ,
    [switch]$Minor
    ,
    [switch]$LoadModule
)

$F = $MyInvocation.InvocationName

$ModuleFileName = "$ModuleName.psm1"

#Write-Verbose -Message "$f - Modulename is $ModuleName at $PSScriptRoot"

#Write-Verbose -Message "$F - Starting build, getting files"

#region Remove Module if found
if (Get-Module -Name $ModuleName)
{
    Write-Verbose "$F - Removing $ModuleName module"
    Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
}
#endregion

Write-Output "Loading module [$ModuleName]..."
Import-Module ./$ModuleName -Force -Verbose -Scope Global
if ((Get-Module -Name $ModuleName) -ne $null) {
    Write-Host "Successfully loaded module [$ModuleName]" -ForegroundColor Green
}

Get-Module -Name $ModuleName 

$ModuleRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Write-Output "Module Root: $ModuleRoot"

Get-NuGet
Get-TfsAssembliesFromNuget -ModuleRoot $ModuleRoot
#Import-TFSAssemblies

#$configServer = Get-TfsConfigServer http://yourserver:8080/tfs