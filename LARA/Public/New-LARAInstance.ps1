function New-LARAInstance {
    <#
    .SYNOPSIS
        Creates a New LARA Instance
    .DESCRIPTION
        Create a instance for LARA. Here you will be able to Configure what have to be collected
    .PARAMETER Credential
        System.Management.Automation.PSCredential
        Specifies the credentials
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        Author: HpotsirhcH
		Date: 03.10.2021
		Version: 1.0
    #>

    #Region Paramblock ----------------------------------------------------------------------

    param (
        [Parameter()][System.Management.Automation.PSCredential]$Credential
    )

    #EndRegion


    #Region Initialisations -----------------------------------------------------------------
    $InstanceGUID = New-LARAInstanceGUID
    Write-Output "Create New LARA instance"
    Write-Output "INSTANCE GUID: $InstanceGUID"

    $LaraTempFolder = $LARAConfiguration.TempFolderPath + "\" + $InstanceGUID
    $LaraConfigFolder = $LARAConfiguration.TempFolderPath + "\" + $LARAConfiguration.ConfigFolder
    $LaraZipFolder = $LARAConfiguration.TempFolderPath+ "\" + $LARAConfiguration.ZipFolder
    Write-Output "Create Temp folder for Config and ZIP content: $LaraTempFolder"
    if (Test-Path -Path $LaraTempFolder) {
        Write-Output "Folder with same guid found. This one will eb deleted"
        Remove-Item -Path $LaraTempFolder -Force -Recurse
    }

    New-Item -Path $LaraTempFolder -ItemType Directory
    New-Item -Path $LaraConfigFolder -ItemType Directory
    New-Item -Path $LaraZipFolder -ItemType Directory

    #EndRegion


    #Region Execution -----------------------------------------------------------------------

    #EndRegion

}