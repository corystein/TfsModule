function Get-TfsConfigServer() {
    <#
    .SYNOPSIS
    Get a Team Foundation Server (TFS) Configuration Server object
    .DESCRIPTION
    The TFS Configuration Server is used for basic authentication and represents
    a connection to the server that is running Team Foundation Server.
    .EXAMPLE
    Get-TfsConfigServer "<Url to TFS>"
    .EXAMPLE
    Get-TfsConfigServer "http://localhost:8080/tfs"
    .EXAMPLE
    gtfs "http://localhost:8080/tfs"
    .PARAMETER url
     The Url of the TFS server that you'd like to access
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$url
    )
    begin {
        Write-Verbose "Loading TFS OM Assemblies for 2015 (14.83.0)"
        Import-TFSAssemblies
    }
    process {
        $retVal = [Microsoft.TeamFoundation.Client.TfsConfigurationServerFactory]::GetConfigurationServer($url)
        [void]$retVal.Authenticate()
        if(!$retVal.HasAuthenticated)
        {
            Write-Host "Not Authenticated"
            Write-Output $null;
        } else {
            Write-Host "Authenticated"
            Write-Output $retVal;
        }
    }
    end {
        Write-Verbose "ConfigurationServer object created."
    }
} #end Function Get-TfsConfigServer