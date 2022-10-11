function Start-LARAInstance {
    <#
    .SYNOPSIS
        Start the LARA Instance
    .DESCRIPTION
        Start the instance for LARA. Now Everything will be collected
    .PARAMETER InstanceGUID
        System.String
        Specifies the InstanceGuid to Start
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
        [Parameter(Mandatory = $true)][string]$InstanceGUID
    )

    #EndRegion


    #Region Initialisations -----------------------------------------------------------------
    $LaraTempFolder = $env:TEMP + "\" + $InstanceGUID
    $LaraConfigFolder = $LaraTempFolder + "\Config"
    $LaraZipFolder = $LaraTempFolder + "\ZIPTemp"
    #EndRegion


    #Region Execution -----------------------------------------------------------------------
    if (Test-Path -Path $LaraTempFolder) {
        if (Test-Path -Path $LaraConfigFolder) {
            $LaraConfigFiles = Get-ChildItem -Path $LaraConfigFolder -Recurse -File
            if ($LaraConfigFiles.Count -eq 0) {
                throw [System.IO.FileNotFoundException] "No Lara Configuration file found"
            }
        }
        else {
            throw [System.IO.DirectoryNotFoundException] "No Lara Configuration folder found under: $LaraConfigFolder"
        }
    }
    else {
        throw [System.IO.DirectoryNotFoundException] "No Lara Instance folder found under: $LaraTempFolder"
    }
    #EndRegion

}