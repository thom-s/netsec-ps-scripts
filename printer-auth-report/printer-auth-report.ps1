# Parameters
param(
    [Parameter(Mandatory=$True)] [string] $PrintServerList, # Path to the list of print servers
    [Parameter(Mandatory=$True)] [string] $TestPathList,   # Path 
    [string] $ReportPath = $(Join-Path -Path $PSScriptRoot -ChildPath "report.csv"),       # Path to the report to output
    [switch] $UseHTTPS = $false
)

# Constants
$PrintServers = Get-Content $PrintServerList
$TestPaths = Get-Content $TestPathList
If($UseHTTPS){
    $Protocol = "https"
}
Else{
    $Protocol = "http"
}

# Initialise the report array, including the first line
$report = @()
$report += ,@("Hostname","IP", "Reachable?", "Requires authentication?")

# Get list of printers

$printers = @()
$PrintServers | ForEach-Object{
    $server = $_
    Get-WMIObject -Class Win32_Printer -ComputerName $server | ForEach-Object{
        $printers += , @($_.Name, $_.PortName, $server)
    }
}

# Test all printers
$printers | Foreach-Object{
    
    $printer_name = $($_[0])
    $printer_ip = $($_[1])
    $printer_server = $($_[2])
    $printer_reachable = $null
    $printer_secured = $null
    $return_codes = @()

    Write-Output "`n=== Testing $printer_name at $printer_ip ===`n"

    If(Test-Connection -Computername $printer_ip -Count 1 -Quiet){
        Write-Output "Reached $printer_name at $printer_ip"
        $printer_reachable = $true

        # Test all web paths
        $TestPaths | ForEach-Object{

            $query_url = "$($Protocol)://$printer_ip/$_"
            Write-Output "Testing $printer_name at $query_url"

            try {
                $response = Invoke-WebRequest -URI $query_url -SkipCertificateCheck
                $status_code = [int]$r.StatusCode
            }
            catch {
                $status_code = [int]$_.Exception.Response.StatusCode
            }

            $return_codes += , $status_code 
            Write-Output "$query_url returned HTTP $status_code"
    
        }
        
        If($return_codes.Contains(401)){
            $printer_secured = 'Secure'
        }
        Elseif($return_codes.Contains(200)){
            $printer_secured = 'Unsecured'
        }
        Else{
            $printer_secured = 'Needs Manual Review'
        }

    }
    Else{
        Write-Output "Couldn't reach $printer_name at $printer_ip"
        $printer_reachable = $false
        $printer_secured = 'Unreachable'
    }

    $report += ,@($printer_server, $printer_name,$printer_ip, $printer_reachable, $printer_secured)
}

Write-Output "`n=== Generating CSV report to $ReportPath ===`n"
# Create the CSV report
Add-Content $ReportPath -Value "SEP=,"                     # Write out the first line
$report | % { $_ -join ","} | Out-File $ReportPath -Append # Write out the rest of the report
Write-Output "Done!"
