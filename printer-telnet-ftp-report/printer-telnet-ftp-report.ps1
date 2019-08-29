param(
    [Parameter(Mandatory=$True)] [string] $PrintServerList, # Path to the list of print servers
    [string] $ReportPath = $(Join-Path -Path $PSScriptRoot -ChildPath "report.csv")       # Path to the report to output
)

# Pull list of printers from print servers supplied by -PrintServerList
$printers = @()
Try{
    Get-Content $PrintServerList | ForEach-Object{
        $server = $_
        Get-CimInstance -ClassName Win32_Printer -ComputerName $server | ForEach-Object{
            $printers += , @($_.Name, $($_.PortName).Replace('..','.'), $server) # Some IPs have two dots for some reason, I use a .Replace() for that (ex: 10..10.10.10)
        }
    }
}
Catch{
    Write-Error $_
}

# Create report
$report = @()
$report += ,@("Server","Hostname","IP", "Reachable?", "Telnet Enabled?", "FTP enabled?")


# Loop through all printers
$printers | Foreach-Object{

    # Set initial variables
    $printer_name, $printer_ip, $printer_server = $_

    # Reset 
    $printer_reachable = $null
    $printer_telnet = $null
    $printer_ftp = $null

    # Ping Test
    If(Test-Connection -ComputerName $printer_ip -Quiet -Count 1 -InformationAction Ignore){
        
        $printer_reachable = $true


        # Test Telnet connectivity     
        $telnet_test = Test-NetConnection -ComputerName $printer_ip -Port 23

        If($telnet_test.TcpTestSucceeded){
            $printer_telnet = $true
        }
        Else{
            If($telnet_test.PingSucceeded){
                
                $printer_telnet = $false   
            }
            Else{
                
                $printer_telnet = $false
            }
        }

        # Test FTP connectivity
        Try
        {
            $client = New-Object System.Net.Sockets.TcpClient($printer_ip, 21)
            $client.Close()
            $printer_ftp = $true
        }
        Catch
        {
            $printer_ftp = $false
        }
    }
    Else{
        # If printer is unreachable, set all to false
        $printer_reachable = $false
        $printer_telnet = $false
        $printer_ftp = $false
    }

    # Append report
    $report += ,@($printer_server,$printer_name,$printer_ip,$printer_reachable,$printer_telnet, $printer_ftp)
    Write-Verbose -Verbose -Message "Scanned $printer_name at $printer_ip on $printer_server"

}

Add-Content $ReportPath -Value "SEP=,"                     # Write out the first line
$report | % { $_ -join ","} | Out-File $ReportPath -Append # Write out the rest of the report
Write-Verbose -Verbose -Message "Reported created to $ReportPath !"
