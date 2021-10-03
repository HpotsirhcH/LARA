function New-LARAInstanceGUID {
    <#
    .SYNOPSIS
        Will Return an LARA Instance Guid
    .DESCRIPTION
        Will Return an LARA Instance Guid
    .EXAMPLE
        PS C:\> New-LARAInstanceGUID
        Just Return an New Instance GUID
    .OUTPUTS
        System.String Lara Instance GUID
    .NOTES
        Author: HpotsirhcH
		Date: 03.10.2021
		Version: 1.0
    #>

    #Region Execution -----------------------------------------------------------------------

    [String]$GUID = (New-Guid).Guid.ToUpper()

    $GUID = $GUID.Replace("-","")

    $GUID = "Lara" + $GUID.Substring(4)

    Return $GUID
    #EndRegion

}