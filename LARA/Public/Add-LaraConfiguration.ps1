function Add-LaraConfiguration {
    <#
    .SYNOPSIS
        Add a New LARA LaraConfiguration
    .DESCRIPTION
        Add a Lara Configuration to an instance. Here you will be able to Configure what have to be collected

    .PARAMETER Command
        System.String
        Specifies the Command to Add to Configuration

    .PARAMETER InstanceGUID
        System.String
        Specifies the InstanceGUID

    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        Author: HpotsirhcH
		Date: 11.10.2022
		Version: 1.0
    #>

    #Region Paramblock ----------------------------------------------------------------------

    param (
        [Parameter(Mandatory=$true)][string]$InstanceGUID,
        [Parameter(Mandatory=$true)][ValidateSet("FolderCopy","FileCopy","EventLogPath")][string]$Command
    )

    #EndRegion


    #Region Initialisations -----------------------------------------------------------------
    $LaraTempFolder = $LARAConfiguration.TempFolderPath + "\" + $InstanceGUID
    $LaraConfigFolder = $LARAConfiguration.TempFolderPath + "\" + $LARAConfiguration.ConfigFolder
    $LaraZipFolder = $LARAConfiguration.TempFolderPath+ "\" + $LARAConfiguration.ZipFolder


    #Region Execution -----------------------------------------------------------------------

    #EndRegion

}