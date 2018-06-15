function Decode-SSRCode {
    param(
        [Parameter(Mandatory=$true)]
        [string]$String
    )

    BEGIN {
        $Real_String = $String.Replace("-","+").Replace("_","/").PadRight($String.Length + (4 - $($String.Length % 4)) % 4,"=")
    }

    PROCESS {
        $decode_string = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Real_String))
        $server = $decode_string -replace "\:.*"
        $port = $decode_string -replace "^.+?\:|\:.*"
        $protocol = $decode_string -replace "^.+?\:.+?\:|\:.*"
        $method = $decode_string -replace "^.+?\:(.+?\:){2}|\:.*"
        $obfs = $decode_string -replace "^.+?\:(.+?\:){3}|\:.*"
        
        $encoded_pwd_str = $decode_string -replace "^.+?\:(.+?\:){4}|\/\?.*"
        $encoded_pwd = $encoded_pwd_str.Replace("-","+").Replace("_","/").PadRight($encoded_pwd_str.Length + (4 - $($encoded_pwd_str.Length % 4)) % 4,"=")
        $password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encoded_pwd))

        $encoded_remark_str = $decode_string -replace "^.*remarks\=|\&group.*$"
        $encoded_remark = $encoded_remark_str.Replace("-","+").Replace("_","/").PadRight($encoded_remark_str.Length + (4 - $($encoded_remark_str.Length % 4)) % 4,"=")
        $remark = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encoded_remark))

        $encoded_group_str = $decode_string -replace "^.*group\="
        $encoded_group = $encoded_group_str.Replace("-","+").Replace("_","/").PadRight($encoded_group_str.Length + (4 - $($encoded_group_str.Length % 4)) % 4,"=")
        $group = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encoded_group))
    }

    END {
        $result = @"
        Server:`t`t$server
        Port:`t`t$port
        Password:`t$password
        Method:`t`t$method
        Protocol:`t$protocol
        OBFS:`t`t$obfs
        Remark:`t`t$remark
        Group:`t`t$group
"@
        Write-Host $result
    }
}
