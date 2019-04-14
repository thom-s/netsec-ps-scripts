# password-expiration-report

This script will generate an audit report on accounts with passwords that never expire, password expiration dates and password last set dates. 

This script can be used to audit password policies and make sure they are applied properly. It can also be used to audit users in groups with special password policies in your organization, such as users used by specific softwares or Exchange mailboxes for example.

**This script is currently a WIP.**
   - Needs to be cleaned up
   - Needs more comments
   - Verbose will be added soon (currently the only output is the report)

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
