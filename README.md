# nginx-windowsservercore
This repository holds my docker file and scripts to build a windows server core container image with the official Win32 nginx binaries.

## Environment Variables:
* **NginxVersion**
    * This variable defines the version of Nginx to download and extract at build time.
    * Example: `NginxVersion=1.13.1`
* **WriteReverseProxyConfFromEnv**
    * This variable defines whether the container will generate the location config from environment settings at runtime.
    * Acceptable Values: `true` or `false`
    * Default: `true`
    * Example: `WriteReverseProxyConfFromEnv=true`
* **ReverseProxyListenPort**
    * This variable defines what port nginx will listen on at build time for traffic when generating location config from environment settings.
    * Acceptable Values: An integer between `1` and `65535`
    * Default: `80`
    * Example: `ReverseProxyListenPort=80`
* **ReverseProxyServerName**
    * This variable is a space separated list of domains to provide the server config when generating config from environment settings at runtime.
    * Acceptable Values: A space separated list of strings.
    * Default: `nginx`
    * Example: `ReverseProxyServerName="nginx nginx.local"`
* **ReverseProxyLocationList**
    * Acceptable Values: A powershell array of strings representing proxy locations of the format *location==>targetLocation*
    * Default: No Default Value Defined.
    * Example: `ReverseProxyLocationList="@('/==>http://home', '/hello==>http://hello', '/goodbye==>http://goodbye')"`