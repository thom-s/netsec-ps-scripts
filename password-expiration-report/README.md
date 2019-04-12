# password-expiration-report

This script will generate an audit report on accounts with passwords that never expire, password expiration dates and password last set dates. 

This script is currently a WIP.

## How to use

Simply run the script with admin credentials.

```PowerShell
./password-expiration-report.ps1
   [-ADGroup] <String>
   [-ReportPath] <String>
```

### Parameters
All the following parameters are optional.

`-ADGroup` : The AD group you want to run the report on. Defaults to all of Active Directory. (Optional)

`-ReportPath` : Path where to output the report. Defaults to `report.csv` in the script's folder. (Optional)
