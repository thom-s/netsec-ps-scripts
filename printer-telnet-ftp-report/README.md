# printer-telnet-ftp-report

Find network printers that have telnet or FTP services enabled. These services should normally be turned off unless they're required, to prevent unauthorized access to the printers.

**Use the `-Verbose` parameter for verbose output**

## How it works

First, the script will get all the printers from the servers in the file supplied by the optional `-PrintServerList` parameter through a WMI request.

It will then test if the printers have Telnet or FTP enabled and generate a CSV report.

## How to use

Simply download the script and run it from the PowerShell command line like so :

```PowerShell
./printer-telnet-ftp-report.ps1 
  [-PrintServerList] <String> 
  [-ReportPath] <String>
```

Here's an example :
```PowerShell
./printer-telnet-ftp-report.ps1 -PrintServerList ./servers.txt
```

You will need the rights to do WMI requests on each print servers to run the script.

### Parameters

`-PrintServerList` : The list of print servers to get printers from. (Required)

`-ReportPath` : The path of the CSV report to output. The default is `./report.csv` (Optional)

### Text file examples

Here are some examples of what the text files needed could look like.

#### `-PrintServerList <String>`
```
printserv1
printserv2
```

### Report example

Here's an example of what the CSV report will look like :

```
Server,Hostname,IP,Reachable?,Telnet Enabled?,FTP Enabled?
printserv1,printer_1,10.0.0.2,TRUE,TRUE,TRUE
printserv2,printer_2,10.0.0.3,FALSE,FALSE,FALSE
```
