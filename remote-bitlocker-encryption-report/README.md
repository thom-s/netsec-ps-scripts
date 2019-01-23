# remote-bitlocker-encryption-report
This PowerShell script takes a list of PC as input, gets their BitLocker encryption type remotely, and outputs the list as a CSV file to help mitigate against CVE-2018-12038.

## Prevent CVE-2018-12038 vulnerability

Description of CVE-2018-12038 from NIST :
>An issue was discovered on Samsung 840 EVO and 850 EVO devices (only in "ATA high" mode, not vulnerable in "TCG" or "ATA max" mode), Samsung T3 and T5 portable drives, and Crucial MX100, MX200 and MX300 devices. Absence of a cryptographic link between the password and the Disk Encryption Key allows attackers with privileged access to SSD firmware full access to encrypted data.

[More here ...](https://nvd.nist.gov/vuln/detail/CVE-2018-12037)

Along with applying patches on SSD firmware, [CERT advises not to use hardware BitLocker encryption.](https://kb.cert.org/vuls/id/395981/)

This script helps network administrators mitigate this vulnerability by generating a CSV report listing computers and their BitLocker encryption method, which can be used to identify workstations that need to have their encryption type changed. Network administrators can then manually change this encryption type or [remotely through GPO](https://blogs.technet.microsoft.com/dubaisec/2016/03/04/bitlocker-aes-xts-new-encryption-type/).


This script does this by taking a text file list of PCs as input, getting their BitLocker encryption type using the [manage-bde](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/manage-bde) command remotely and outputing a list of PC and encryption types as a CSV file. 
