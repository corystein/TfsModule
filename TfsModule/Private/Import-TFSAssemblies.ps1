function Global:Import-TFSAssemblies() {
    <# .SYNOPSIS This function imports TFS Object Model assemblies into the PowerShell session .DESCRIPTION After the TFS 2015 Object Model has been retrieved from Nuget using Get-TfsAssembliesFromNuget function, this function will import the necessary (given current functions) assemblies into the PowerShell session #>
    [CmdLetBinding()]
    param()
 
    begin{}
    process
    {
        $omBinFolder = $("$ModuleRoot\bin\");
        $targetOMbinFolder = New-Folder $omBinFolder;
 
        try {
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $vsCommon + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $commonName + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $clientName + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $VCClientName + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $WITClientName + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $BuildClientName + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $BuildCommonName + ".dll")
        } 
        catch {
            $_.Exception.LoaderExceptions | % { $_.Message }
        }
     }
     end{}
}