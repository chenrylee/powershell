
[cmdletbinding()]

    param(
        [Parameter(Mandatory=$true)]
        [string]$Keywords
    )

    Begin {
        $songlist=@()
    }

    PROCESS {
        $songs = ((Invoke-WebRequest "http://api.imjad.cn/cloudmusic/?type=search&search_type=1&s=$Keywords").content | ConvertFrom-Json).result.songs
        foreach ($song in $songs) {
            $songProp = New-Object -TypeName psobject -Property (
                @{
                    ID="";
                    Name="";
                    Artist="";
                    Album="";
                    Duration=""
                }
            )
            $id = $song.ID;
            $name = $song.Name;
            $Artist = $song.ar.Name;
            $Album = $song.al.Name;
            $dt = [timespan]::FromSeconds([int]$($song.dt)/1000)
            $Duration = "{0:mm\:ss}" -f $dt
            $songProp.ID = $id;
            $songProp.Name = $name;
            $songProp.Artist = $Artist;
            $songProp.Album = $Album;
            $songProp.Duration = $Duration


            $songlist += $songProp

            Remove-Variable songprop 
        }
    }

    END{
        $songlist | Select-Object ID,Name,Duration,Artist,Album | Format-Table -AutoSize
        Remove-Variable songlist
    }
