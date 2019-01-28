# printer-auth-report

Find network printers that don't require authentication to the configuration web interface.

## How it works

First, the script will get all the printers from the servers in the file supplied by the optional `-PrintServerList` parameter through a WMI request.

It will then test if the configuration web interface requires authentication on each printer. Different printers having different configuration interfaces, we need to test them all. It does so by doing an unauthenticated web request on all web paths in the file supplied by the optional `-TestPathList` parameter. 

**The script expects each printers to return at least one `401 Unauthorized` HTTP return code to consider the printer as secured.** It will consider the printer to be unsecured if it receives any `200 OK` HTTP return codes or unreachable if it doesn't receive anything.

After having scanned all printers, it will output the hostname, IP, whether the printer is reachable and whether it is secured as a CSV file to the path supplied by `-ReportPath`. 

## How to use

Simply download the script and run it from the PowerShell command line like so :

```PowerShell
PS C:\scripts\netsec-ps-scripts\printer-auth-report> ./printer-auth-report.ps1
```

You will need the rights to do WMI requests on each print servers to run the script.

### Parameters

`-PrintServerList` : 

`-ReportPath` : 

`-TestPathList` : If this parameter is not supplied, the default file will be `servers.txt` in the root path of the script.

`-UseHTTPS` : By default, the requests are done over HTTP. You can supply this parameter to force the requests to be done over HTTPS.
