function Start-LARAInstance {
    <#
    .SYNOPSIS
        Start the LARA Instance
    .DESCRIPTION
        Start the instance for LARA. Now Everything will be collected
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
        [Parameter()][string]$InstanceGUID
    )

    #EndRegion


    #Region Initialisations -----------------------------------------------------------------
    $LaraTempFolder = $env:TEMP + "\" + $InstanceGUID
    $LaraConfigFolder = $LaraTempFolder + "\Config"
    $LaraZipFolder = $LaraTempFolder + "\ZIPTemp"
    #EndRegion


    #Region Execution -----------------------------------------------------------------------

    #EndRegion

}