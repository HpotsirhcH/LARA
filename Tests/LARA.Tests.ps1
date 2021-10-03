BeforeAll {
    # get Current Path Needed to Check  of all Pester functions
    $TestPath = $PSScriptRoot

    # Configuration
    # get default from static property
    $configuration = [PesterConfiguration]::Default
    # assing properties & discover via intellisense
    $configuration.Run.Path = $TestPath
    $configuration.Should.ErrorAction = 'Continue'

    $RepositoryPath = Split-Path -Path $TestPath
    $ModulePath = "$RepositoryPath\LARA"
    # $ModuleScript = "$ModulePath\LARA.psm1"
    $ModuleManifest = "$ModulePath\LARA.psd1"
    $ManifestHash = Invoke-Expression (Get-Content $ModuleManifest -Raw)
    $ExFunctions = $ManifestHash.FunctionsToExport

    if ($ExFunctions -eq "*") {
        $isWildCardFunctionsToExport = $true
    }
    else {
        $isWildCardFunctionsToExport = $false

        # All functions that are supposed to get exported (Files in Public folder)
        $FunctionFiles = Get-ChildItem "$ModulePath\Public" -Filter *.ps1 | Select-Object -ExpandProperty BaseName

        $FunctionNames = @()
        foreach ($item in $FunctionFiles) {
            $FunctionNames += $item
        }
    }
}

# test the module manifest - exports the right functions, processes the right formats, and is generally correct
Describe "Manifest" {

    It "has a valid manifest" {
        {
            $null = Test-ModuleManifest -Path $ModuleManifest -ErrorAction Stop -WarningAction SilentlyContinue
        } | Should -Not -Throw
    }

    It "has a valid root module" {
        $ManifestHash.RootModule | Should -Be "LARA.psm1"
    }

    It "has a valid Description" {
        $ManifestHash.Description | Should -Not -BeNullOrEmpty
    }

    It "has a valid guid" {
        $ManifestHash.Guid | Should -Match '[0-9A-Fa-f]{8}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{12}'
    }

    It "has a valid copyright" {
        $ManifestHash.CopyRight | Should -Not -BeNullOrEmpty
    }

    Context "exports all public functions" {
        It "Export function is wildcard" -Skip:$(-not $isWildCardFunctionsToExport){
            $ExFunctions | Should -be "*"
        }

        It "exports <FunctionNames>" -TestCases $FunctionNames -Skip:$isWildCardFunctionsToExport{
            Param($FunctionNames)
            $ExFunctions -contains $FunctionNames | Should -Be $true
        }
    }
}



