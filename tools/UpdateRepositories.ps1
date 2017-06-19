param(
    [Parameter(Mandatory=$true)]
    [string]$version,
    [ValidateSet("none", "stable", "mainline")]
    [string]$alternateTag = "none"
    [switch]$isLatest = $false
)

$versionsToPush = @()

docker build -t "estenrye/nginx-windowsservercore:$version" ..
$versionsToPush += "estenrye/nginx-windowsservercore:$version"

if ($alternateTag -ne "none")
{
    docker tag "estenrye/nginx-windowsservercore:$version" "estenrye/nginx-windowsservercore:$alternateTag"
    $versionsToPush += "estenrye/nginx-windowsservercore:$alternateTag"
}

if ($isLatest)
{
    docker tag "estenrye/nginx-windowsservercore:latest" "estenrye/nginx-windowsservercore:latest"
    $versionsToPush += "estenrye/nginx-windowsservercore:latest"    
}

foreach($image in $versionsToPush)
{
    docker push $image
}