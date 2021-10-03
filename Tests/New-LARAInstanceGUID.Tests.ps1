BeforeDiscovery {

    $RepositoryPath = Split-Path -Path $PSScriptRoot
    $ModulePath = "$RepositoryPath\LARA"
    $ModuleManifest = "$ModulePath\LARA.psd1"

    Import-Module $ModuleManifest -Force

}

InModuleScope PSHVITSM {
    Describe "New-LARAInstanceGUID" {
        BeforeAll {
            $InstanceGUID = New-LARAInstanceGUID
        }

        It "Test Length of Instance GUID" {
            $InstanceGUID.Length | Should -Be 32
        }

        It "Instance GUID starts with LARA" {
            $InstanceGUID.Substring(0,4) | Should -BeExactly "LARA"
        }

        It "Instance GUID contains only upper case" {
            $InstanceGUID | Should -Not -MatchExactly '[a-z]'
        }

        It "Instance GUID contains only valid chars" {
            $InstanceGUID | Should -MatchExactly '[0-9A-Z]{32}'
        }
    }
}