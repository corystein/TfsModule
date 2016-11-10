#Write-Host "Loading TfsModule"
#Module location folder
$ModuleRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
#where to put TFS Client OM files
$omBinFolder = $("$ModuleRoot\bin\")
 
# TFS Object Model Assembly Names
$vsCommon = "Microsoft.VisualStudio.Services.Common"
$commonName = "Microsoft.TeamFoundation.Common"
$clientName = "Microsoft.TeamFoundation.Client"
$VCClientName = "Microsoft.TeamFoundation.VersionControl.Client"
$WITClientName = "Microsoft.TeamFoundation.WorkItemTracking.Client"
$BuildClientName = "Microsoft.TeamFoundation.Build.Client"
$BuildCommonName = "Microsoft.TeamFoundation.Build.Common"

function New-Folder() {
    <# .SYNOPSIS This function creates new folders .DESCRIPTION This function will create a new folder if required or return a reference to the folder that was requested to be created if it already exists. .EXAMPLE New-Folder "C:\Temp\MyNewFolder\" .PARAMETER folderPath String representation of the folder path requested #>
 
     [CmdLetBinding()]
     param(
         [parameter(Mandatory=$true, ValueFromPipeline=$true)]
         [string]$folderPath
     )
    begin {}
    process {
        if (!(Test-Path -Path $folderPath)){
            New-Item -ItemType directory -Path $folderPath
        } else {
            Get-Item -Path $folderPath
        }
    }
    end {}
} #end Function New-Directory

$Private = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private') -Filter *.ps1 -Recurse)
$Public = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter *.ps1 -Recurse)


foreach ($Script in $Public) {
    . $Script.FullName
    #Write-Host "Loading public function [$($Script.FullName)]..."
    Export-ModuleMember $Script.BaseName
}

foreach ($Script in $Private) {
    #Write-Host "Sourcing private files [$($Script.FullName)]..."
    . "$($Script.FullName)"
}

