
# Thanks to [Boe Prox](https://social.technet.microsoft.com/profile/boe%20prox/)
function Test-UDPPort {
    Param(
        [Parameter(
            Mandatory = $True,
            Position = 0,
            ParameterSetName = '',
            ValueFromPipeline = $True)]
        [string]$ComputerName,

        [Parameter(
            Position = 1,
            Mandatory = $True,
            ParameterSetName = '')]
        [int]$Port,

        [Parameter(
            Mandatory = $False,
            ParameterSetName = '')]
        [int]$TimeOut = 1000
    )

    Begin {
        $ComputerName =  $ComputerName.ToUpper()
        $report = @();
        $temp = "" | Select-Object Server, Port, TypePort, Open, Notes
    }

    Process {
        $udpobject = new-Object system.Net.Sockets.Udpclient
        #Set a timeout on receiving message
        $udpobject.client.ReceiveTimeout = $TimeOut
        #Connect to remote machine's port
        Write-Verbose "Making UDP connection to remote server"
        $udpobject.Connect($ComputerName, $Port)
        #Sends a message to the host to which you have connected.
        Write-Verbose "Sending message to remote host"
        $a = new-object system.text.asciiencoding
        $byte = $a.GetBytes("$(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')")
        [void]$udpobject.Send($byte, $byte.length)
        #IPEndPoint object will allow us to read datagrams sent from any source.
        Write-Verbose "Creating remote endpoint"
        $remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any, 0)
        Try {
            #Blocks until a message returns on this socket from a remote host.
            Write-Verbose "Waiting for message return"
            $receivebytes = $udpobject.Receive([ref]$remoteendpoint)
            [string]$returndata = $a.GetString($receivebytes)
            If ($returndata) {
                Write-Verbose "Connection Successful"
                #Build report
                $temp.Server = $ComputerName
                $temp.Port = $Port
                $temp.TypePort = "UDP"
                $temp.Open = "True"
                $temp.Notes = $returndata
                $udpobject.close()
            }
        }
        Catch {
            If ($Error[0].ToString() -match "\bRespond after a period of time\b") {
                #Close connection
                $udpobject.Close()
                #Make sure that the host is online and not a false positive that it is open
                If (Test-Connection -ComputerName $ComputerName -Count 1 -quiet) {
                    Write-Verbose "Connection Open"
                    #Build report
                    $temp.Server = $ComputerName
                    $temp.Port = $Port
                    $temp.TypePort = "UDP"
                    $temp.Open = "True"
                    $temp.Notes = ""
                }
                Else {
                    <# It is possible that the host is not online or that the host is online,
                    but ICMP is blocked by a firewall and this port is actually open.  #>
                    Write-Verbose "Host maybe unavailable"
                    #Build report
                    $temp.Server = $ComputerName
                    $temp.Port = $Port
                    $temp.TypePort = "UDP"
                    $temp.Open = "False"
                    $temp.Notes = "Unable to verify if port is open or if host is unavailable."
                }
            }
            ElseIf ($Error[0].ToString() -match "forcibly closed by the remote host" ) {
                #Close connection
                $udpobject.Close()
                Write-Verbose "Connection Timeout"
                #Build report
                $temp.Server = $ComputerName
                $temp.Port = $Port
                $temp.TypePort = "UDP"
                $temp.Open = "False"
                $temp.Notes = "Connection to Port Timed Out"
            }
            Else {
                $udpobject.close()
            }
        }
        #Merge temp array with report
        $report += $temp
    }
    End {
        #Generate Report
        $report
    }
}
