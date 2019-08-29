# netsec-ps-scripts
Collection of PowerShell network security scripts for system administrators.

All scripts were tested in PowerShell 5.1 on Windows 10 unless specified. Please let me know if you encounter any issues on other systems.

**Please read the README file in each folder before running any scripts.**

## Scripts
#### [delete-remote-deployment-files](delete-remote-deployment-files)
* Find and delete leftover deployment files with potential passwords.

#### [password-expiration-report](password-expiration-report)
* Audit accounts that never expire, password expiration dates and password last set dates.

#### [printer-auth-report](printer-auth-report)
* Find network printers that don't require authentication to the admin web interface.


#### [printer-telnet-ftp-report](printer-telnet-ftp-report)
* Find network printers that have telnet or FTP enabled.

#### [remote-bitlocker-encryption-report](remote-bitlocker-encryption-report)
* Bitlocker hardware encryption vulnerability mitigation. (CVE-2018-12038)

## Contribution

Contributions are welcomed! Simply do a pull request and it will be reviewed.

If you're creating a new script, create a folder and respect the current naming convention.

**Please submit any features or ideas you would like to see implemented as an issue! Feedback is always welcomed.**
