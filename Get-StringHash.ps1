function Get-StringHash {
    param (
        [string]$ClearString,
        [ValidateSet("SHA1", "SHA256", "SHA384", "SHA512", "MD5")]
        [string]$HashAlgorithm = "SHA256"
    )

    BEGIN {
        if ( [string]::IsNullOrEmpty($ClearString) ) {
            Write-Warning -Message "Invalid input."
            break
        }
    }

    PROCESS {
        $hasher = [System.Security.Cryptography.HashAlgorithm]::Create($HashAlgorithm)
        $hash = $hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ClearString))

        $hashString = [System.BitConverter]::ToString($hash)
        $output = $hashString -replace "-", ""
    }

    END {
        Write-Output $output
    }
}