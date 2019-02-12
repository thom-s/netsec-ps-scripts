# Parameters
param(
    [string] $ComputerList = $(Join-Path -Path $PSScriptRoot -ChildPath "computers.txt"), # Path to the list of computers
    [string] $ReportPath = $(Join-Path -Path $PSScriptRoot -ChildPath "report.csv")       # Path to the report to output
)

# Constants
$Computers = Get-Content $ComputerList

# Initialise the report array, including the first line
$report = @()
$report += ,@("Hostname","Encryption Method")

# Get the encryption type for each PC
$Computers | ForEach-Object{# Loop through each computer
    $computer = $_
    Write-Verbose -Verbose -Message "Connecting to $computer ..."
    Try{                                                                  
        $bitlocker_status = manage-bde -status -computername $computer | Where {$_ -match "Encryption Method:"}  # Run manage-bde remotely and match the "Encryption Method" line
        $bitlocker_status = $bitlocker_status.Replace("Encryption Method:","").Trim()                            # Remove "Encryption Method:" header from the line
        $report += , @($computer,$bitlocker_status)                                                              # Add the PC and Bitlocker encryption type to the report
        Write-Verbose -Verbose -Message "Done with $($computer)."
    }
    Catch{                                           # If the computer is not reachable
        $report += , @($computer,"UNREACHABLE")      # Output UNREACHABLE to the report
        Write-Verbose -Verbose -Message "Couldn't connect to $computer"
    }                                                             
}

# Create the CSV report
Add-Content $ReportPath -Value "SEP=,"                     # Write out the first line
$report | % { $_ -join ","} | Out-File $ReportPath -Append # Write out the rest of the report
