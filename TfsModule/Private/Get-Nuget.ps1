function Global:Get-Nuget(){
    <# .SYNOPSIS This function gets Nuget.exe from the web .DESCRIPTION This function gets nuget.exe from the web and stores it somewhere relative to the module folder location #>
    [CmdLetBinding()]
    param()
 
    begin{}
    process
    {
        #where to get Nuget.exe from
        $sourceNugetExe = "http://nuget.org/nuget.exe"
 
        #where to save Nuget.exe too
        $targetNugetFolder = New-Folder $("$ModuleRoot\Nuget")
        #$targetNugetFolder = $("$ModuleRoot\Nuget")
        $targetNugetExe = $("$ModuleRoot\Nuget\nuget.exe")
 
        try
        {
            # check if we have gotten nuget before
            #$nugetExe = Get-Item -Path $targetNugetFolder -Filter "nuget.exe"
            $nugetExe = $targetNugetFolder.GetFiles() | ? {$_.Name -eq "nuget.exe"}
            if ($nugetExe -eq $null) {
                #Get Nuget from a well known location on the web
                Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
            }
        }
        catch [Exception]
        {
            echo $_.Exception | format-list -force
        }
 
        #set an alias so we can use nuget syntactically the way we normally would
        Set-Alias nuget $targetNugetExe -Scope Global | Out-Null
    }
    end{}
}