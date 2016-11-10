function Global:Get-TfsAssembliesFromNuget(){
    <# 
    .SYNOPSIS This function gets all of the TFS Object Model assemblies from nuget 
    .DESCRIPTION This function gets all of the TFS Object Model assemblies from nuget and then creates a bin folder of all of the net45 assemblies so that they can be referenced easily and loaded as necessary 
    #>
    [CmdletBinding()]
    param(
        [string]$ModuleRoot
    )
 
    begin{}
    process{
        #clear out bin folder
        $targetOMbinFolder = New-Folder $omBinFolder
        Remove-Item $targetOMbinFolder -Force -Recurse
        $targetOMbinFolder = New-Folder $omBinFolder
        $targetOMFolder = New-Folder $("$ModuleRoot\bin\")
 
        #$ModuleRootBin = New-Folder "$ModuleRoot\bin"

        #get all of the TFS 2015 Object Model packages from nuget
        Write-Output "Installing Tfs via nuget..."
        nuget install "Microsoft.TeamFoundationServer.Client" -OutputDirectory $targetOMFolder -ExcludeVersion -NonInteractive
        nuget install "Microsoft.TeamFoundationServer.ExtendedClient" -OutputDirectory $targetOMFolder -ExcludeVersion -NonInteractive
        nuget install "Microsoft.VisualStudio.Services.Client" -OutputDirectory $targetOMFolder -ExcludeVersion -NonInteractive
        nuget install "Microsoft.VisualStudio.Services.InteractiveClient" -OutputDirectory $targetOMFolder -ExcludeVersion -NonInteractive
        Write-Output "Completed install"

        #Copy all of the required .dlls out of the nuget folder structure 
        #to a bin folder so we can reference them easily and they are co-located
        #so that they can find each other as necessary when loading
        $allDlls = Get-ChildItem -Path $("$ModuleRoot\bin\") -Recurse -File -Filter "*.dll"
 
        # Create list of all the required .dlls
        #exclude portable dlls
        $requiredDlls = $allDlls | ? {$_.PSPath.Contains("portable") -ne $true } 
        #exclude resource dlls
        $requiredDlls = $requiredDlls | ? {$_.PSPath.Contains("resources") -ne $true } 
        #include net45, native, and Microsoft.ServiceBus.dll
        $requiredDlls = $requiredDlls | ? { ($_.PSPath.Contains("net45") -eq $true) -or ($_.PSPath.Contains("native") -eq $true) -or ($_.PSPath.Contains("Microsoft.ServiceBus") -eq $true) }
        #copy them all to a bin folder
        $requiredDlls | % { Copy-Item -Path $_.Fullname -Destination $targetOMBinFolder}
    }
    end{}
}