# printer-auth-report

Find network printers that don't require authentication to the configuration web interface.

**Requires PowerShell Core 6**

## How it works

First, the script will get all the printers from the servers in the file supplied by the optional `-PrintServerList` parameter through a WMI request.

It will then test if the configuration web interface requires authentication on each printer. Different printers having different configuration interfaces, we need to test them all. It does so by doing an unauthenticated web request on all web paths in the file supplied by the optional `-TestPathList` parameter. 

**The script expects each printers to return at least one `401 Unauthorized` HTTP return code to consider the printer as secured.** It will consider the printer to be unsecured if it receives any `200 OK` HTTP status codes or to be manually reviewed if it receives anything else.

After having scanned all printers, it will output the hostname, IP, whether the printer is reachable and whether it is secured as a CSV file to the path supplied by `-ReportPath`. 

## How to use

Simply download the script and run it from the PowerShell command line like so :

```PowerShell
./printer-auth-report.ps1 
  [-PrintServerList] <String> 
  [-TestPathList] <String>
  [-ReportPath] <String>
  [-UseHTTPS]
```

Here's an example :
```PowerShell
./printer-auth-report.ps1 -PrintServerList ./servers.txt -TestPathList ./testpath.txt
```

You will need the rights to do WMI requests on each print servers to run the script.

### Parameters

`-PrintServerList` : The list of print servers to get printers from. (Required)

`-TestPathList` : The list of web paths to be tested. (Required)

`-ReportPath` : The path of the CSV report to output. The default is `./report.csv` (Optional)

`-UseHTTPS` : You can supply this parameter to force the requests to be done over HTTPS instead of HTTP. (Optional)

### Text file examples

Here are some examples of what the text files needed could look like.

#### `-PrintServerList <String>`
```
printserv1
printserv2
```
#### `-TestPathList <String>`
```
login.html
config/index.html?content=security
webAccess/adminpanel.htm
```
