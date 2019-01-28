# Parameters
param(
    [string] $PrintServerList = $(Join-Path -Path $PSScriptRoot -ChildPath "servers.txt"), # Path to the list of print servers
    [string] $ReportPath = $(Join-Path -Path $PSScriptRoot -ChildPath "report.csv"),       # Path to the report to output
    [string] $TestPathList = $(Join-Path -Path $PSScriptRoot -ChildPath "testpath.txt"),    # Path 
    [switch] $UseHTTPS = $false
)

# Constants
$PrintServers = Get-Content $PrintServerList
$TestPaths = Get-Content $TestPathList

# Initialise the report array, including the first line
$report = @()
$report += ,@("Hostname","IP", "Reachable?", "Requires authentication?")

# Get list of printers
$printers = @()
$PrintServers | ForEach-Object{
    Get-WMIObject -Class Win32_Printer -ComputerName $_ | ForEach-Object{
        $printers += , @($_.Name, $_.PortName)
    }
}

# Test all printers
$printers | Foreach-Object{
    
    $printer_name = $($_[1])
    $printer_ip = $($_[1])
    $printer_reachable = $null
    $printer_secured = $null
    $return_codes = @()

    If(Test-Connection -Computername $client -BufferSize 16 -Count 1 -Quiet){
        
        $printer_reachable = $true

        # Test all web paths
        $TestPaths | ForEach-Object{
        
            If($UseHTTPS){
                $request = [system.Net.WebRequest]::Create("http://$printer_ip/$_")
            }
            Else{
                $request = [system.Net.WebRequest]::Create("http://$printer_ip/$_")
            }
            Try{
                $response = $request.GetResponse()
            }
            Catch [System.Net.WebException]{
                $response = $_.Exception.Response
            }
        
            if($return_codes -notcontains $response.StatusCode){
                $return_codes += , $response.StatusCode
            }
    
        }
        
        If($return_codes.Contains('401')){
            $printer_secured = $true
        }
        Elif($return_codes.Contains('200')){
            $printer_secured = $false
        }

    }
    Else{
        $printer_reachable = $false
    }


    $report += ,@($printer_name,$printer_ip, $printer_reachable, $printer_secured)
}

# Create the CSV report
Add-Content $ReportPath -Value "SEP=,"                     # Write out the first line
$report | % { $_ -join ","} | Out-File $ReportPath -Append # Write out the rest of the report
