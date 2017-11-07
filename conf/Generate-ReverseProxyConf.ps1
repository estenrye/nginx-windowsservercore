param(
    [switch]$WriteConf = [bool]::Parse($env:WriteReverseProxyConfFromEnv),
    [int]$ListenPort = [int]::Parse($env:ReverseProxyListenPort),
    [string]$ServerName = $env:ReverseProxyServerName,
    [string[]]$LocationList = (iex "$env:ReverseProxyLocationList"),
	[string]$EnabledSitesPath = $env:EnabledSitesPath
)

Write-Host "Generate-ReverseProxyConf.ps1 Started"
Write-Host "WriteConf: $WriteConf"
Write-Host "ListenPort: $ListenPort"
Write-Host "ServerName: $ServerName"
Write-Host "LocationList:"

function Generate-Locations
{
    param([string[]]$locations)
    $result = ''

    foreach($location in $locations)
    {
		$rewrite = $false
		$offset = 3
        Write-Host "`t$location"
        $index = $location.IndexOf('==>')
		if ($index -eq -1)
		{
			$rewrite = $true
			$index = $location.IndexOf('==R=>')
			$offset = 5
		}
        $route = $location.Substring(0, $index)
        $server =$location.Substring($index+$offset)

        $result += "    location $route {`n"
		if ($rewrite)
        {
			$result += "      rewrite $route(.*) /$1  break;`n"
		}
        $result += "      proxy_pass      $server;`n"
        $result += "    }`n"
    }
    return $result
}

function ReplaceConfigTarget
{
    param(
        [Parameter(Mandatory=$true)]
        [string]$InputFile,
        [Parameter(Mandatory=$true)]
        [string]$OutputFile,
        [string]$TargetLineToReplace,
        [string]$Content
    )
    # Code Snippet modified from: https://stackoverflow.com/questions/35293655/powershell-out-file-force-end-of-line-character
    # Note that IO.StreamWriter will use process's current working directory,
    #  not PS's. So safer to specify full paths
    $inStream =  [System.IO.StreamReader] $InputFile
    $outStream = new-object System.IO.StreamWriter $OutputFile, [text.encoding]::ASCII
    $outStream.NewLine = "`n"

    while (-not $inStream.endofstream) {
        $line = $instream.Readline()

        if (-not $line.Trim().Equals($TargetLineToReplace))
        {
            $outStream.WriteLine($line)
        }
        else 
        {
            foreach($line in $Content)
            {
                $outStream.WriteLine($line)
            }
        }
    }
    $inStream.close()
    $outStream.close()
}

if ($WriteConf -and ($LocationList.Length -gt 0))
{
    $locationConfig = Generate-Locations -locations $LocationList
    $virtualServerConf = "  server { 
    listen       $ListenPort;
    server_name  $ServerName;
    access_log   logs/$ServerName.reverseproxy.access.log  main;
    resolver 127.0.0.11 ipv6=off;

$locationConfig
  }
" 
    Set-Content -Path "$($env:EnabledSitesPath)\$ServerName.virtualserver.conf" -Value $virtualServerConf
}

$nginxConfDir = "c:/nginx/nginx-$($env:NginxVersion)/conf"
$proxyDefaultsFile="$nginxConfDir/proxy.conf"

$config = "  include $proxyDefaultsFile;
  include $(($EnabledSitesPath).Replace("\", "/"))/*.conf;

"

ReplaceConfigTarget `
        -InputFile "$PSScriptRoot\nginx.conf" `
        -OutputFile "$PSScriptRoot\nginx.conf.1" `
        -TargetLineToReplace '###_SERVER_REPLACEMENT_TARGET_###' `
        -Content $config
    
Remove-Item "$PSScriptRoot\nginx.conf"
mv "$PSScriptRoot\nginx.conf.1" "$PSScriptRoot\nginx.conf"
