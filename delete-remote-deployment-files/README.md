# delete-remote-deployment-files

This script will look for files that were not deleted properly during Windows images deployments from MDT and delete them.

**Use the `-Verbose` parameter for verbose output**

## Possible security issue with MDT deployments

The MDT deployment process creates the `C:\MININT` folder during the Windows imaging process which contains an `unattend.xml` file. This file can contain the following passwords:
* An [AdministratorPassword](https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-useraccounts-administratorpassword) element.
* A [Password](https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-useraccounts-localaccounts-localaccount-password) element which specifies the password for a [LocalAccount](https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-useraccounts-localaccounts-localaccount) to be created. 
* A [Password](https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-password) element for the [AutoLogon](https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon) account. 

The [PlainText](https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-password-plaintext) element (which applies to all elements mentionned above) can be set to `true` or `false`. But even if it is set to `false`, the password is not actually encrypted. It is simply encoded as a Base64 string which can easily be decoded.

Normally, this folder should be deleted at the end of the imaging process. In reality, many system administrators have reported certain deployments failing to delete this folder. 

This script attempts to remediate this issue by scanning a list of hosts for the `C:\MININT` folder and deleting it if you wish. It will then generate a CSV report.

## How to use

Simply run the script with administrator credentials.

```PowerShell
./delete-remote-deployment-files.ps1
    [-ComputerList] <String>
    [-ReportPath] <String>
    [-DeleteFolder]
```

### Parameters
All the following parameters are optional.

`-ComputerList` : Path of the list of computers to scan. Defaults to `computers.txt` in the script's folder.

`-ReportPath` : Path where to output the report. Defaults to `report.csv` in the script's folder.

`-DeleteFolder` : Use this flag to delete `C:\MININT`. By default it will not be deleted.
