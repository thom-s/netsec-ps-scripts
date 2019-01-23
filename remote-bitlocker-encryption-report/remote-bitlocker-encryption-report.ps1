# Parameters
$computers = Get-Content "computers.txt" # The list of computers, one computer name (hostname) per line
$reportfile = "report.csv"               # File name of the report

# Initialise the report array, including the first line
$report = @()
$report += ,@("Hostname","Encryption Method")

# Get the encryption type for each PC
$computers | ForEach-Object{                                                                        # Loop through each computer
  $bitlocker_status = manage-bde -status -computername $_ | Where {$_ -match "Encryption Method:"}  # Run manage-bde remotely and match the "Encryption Method" line
    $bitlocker_status = $bitlocker_status.Replace("Encryption Method:","").Trim()                   # Remove "Encryption Method:" header from the line
    $report += , @($_,$bitlocker_status)                                                            # Add the PC and Bitlocker encryption type to the report 
}

# Create the CSV report
Add-Content .\$reportfile -Value "SEP=,"                     # Write out the first line
$report | % { $_ -join ","} | Out-File .\$reportfile -Append # Write out the rest of the report
