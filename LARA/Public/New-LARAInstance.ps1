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
    #EndRegion


    #Region Execution -----------------------------------------------------------------------

    #EndRegion

}