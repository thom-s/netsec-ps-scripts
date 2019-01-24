# Parameters
param(
    [string] $ComputerList = $(Join-Path -Path $PSScriptRoot -ChildPath "computers.txt"), # Path to the list of computers
    [string] $ReportPath = $(Join-Path -Path $PSScriptRoot -ChildPath "report.csv"),      # Path to the report to output
    [switch] $DeleteFolder = $false                                                       # Whether to delete MININT or not
)

# Constants
$ErrorActionPreference = 'Stop'
$Computers = Get-Content $ComputerList

# Initialise the report array, including the first line
$report = @()
$report += ,@("Hostname","Could Connect?", "Found MININT?", "Deleted MININT?")

# Loop through each computer
$Computers | ForEach-Object{
    
    # Initialise variables
    $could_connect = $null
    $found_minint = $null
    $deleted_minint = $null
    
    # Find C:\MININT
    Try{
        $minint_folder = Get-ChildItem -Force \\$_\c$ -ErrorAction Stop | Where-Object { $_.Name -eq "MININT"} # Try Get-Childitem remotely
        $could_connect = $true                                                                                 # If it succeeds, set $could_connect to $true
    }
    Catch {                                                                                                    # If it fails, we know we can't connect
        $could_connect = $false                                                                                # Set $could_connect to $false
    }
    
    if($minint_folder -eq $null -or $could_connect -eq $false){                                                # If we didn't find C:\MININT or couldn't connect
        $found_minint = $false                                                                                 # Set $found_minint to $false
    }
    else{                                                                                                      # If we found C:\MININT
        $found_minint = $true                                                                                  # Set $found_minint to $true
    }

    # Delete C:\MININT
    if($could_connect -and $DeleteFolder){     # If we could connect and the DeleteFolder parameter is set
        Try{
            Remove-Item \\$_\c$\MININT -Force  # Delete C:\MININT
            $deleted_minint = $true            # If it worked
        }
        Catch{
            $deleted_minint = $false           # If it failed
        }
    }
    else{
        $deleted_minint = $false
    }

    # Append report with data
    $report += ,@($_,$could_connect, $found_minint, $deleted_minint)
}

# Output CSV
Add-Content $ReportPath -Value "SEP=,"                     # Write out the first line
$report | % { $_ -join ","} | Out-File $ReportPath -Append # Write out the rest of the report
