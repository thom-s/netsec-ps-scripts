# Parameters
param(
    [string] $ADGroup,                                                              # Path to the report to output
    [string] $ReportPath = $(Join-Path -Path $PSScriptRoot -ChildPath "report.csv") # Path to the report to output
)

$report = @()
$report += ,@("Name", "SamAccountName", "PasswordNeverExpires", "PasswordExpired", "PasswordLastSet")
$total_accounts = 0
$never_expires = 0

# Whether we're applying to one group or all of Active Directory
If(-not $ADGroup){
    $user_list = Get-ADUser -Filter * -Properties *
}
Else{
    $user_list = Get-ADGroupMember $ADGroup | Get-ADUser -Properties *
}


$user_list | Select Name, SamAccountName, PasswordNeverExpires, PasswordExpired, PasswordLastSet | ForEach-Object{
   
    $report += ,@("`"$($_.Name)`"", $_.SamAccountName, $_.PasswordNeverExpires, $_.PasswordExpired, $_.PasswordLastSet)

    $total_accounts += 1
    if($_.passwordNeverExpires -eq "true"){
        $never_expires += 1
    }


}


$report += ,@()
$report += ,@("Number of accounts",$total_accounts)
$report += ,@("Accounts never expiring",$never_expires)
$report += ,@("Percentage never expiring",$(($never_expires / $total_accounts) * 100 ))

Add-Content $ReportPath -Value "SEP=,"                     # Write out the first line
$report | % { $_ -join ","} | Out-File $ReportPath -Append # Write out the rest of the report
