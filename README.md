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
    * Default: `@()`
    * Example: `ReverseProxyLocationList="@('/==>http://home', '/hello==>http://hello', '/goodbye==>http://goodbye')"`
* **EnabledSitesPath**
    * This variable defines the location inside container where the server block configuraiton files will be stored and included from.
    * To load externally generated server block configuration files into the container, mount a volume and set this variable to mount destination.
    * Acceptable Values: A directory path existing inside container.
	* Default: `c:\nginx\enabled-sites`
	* Example: `docker run -d --mount type=volume,src=mynginxvol,dst=c:/mynginxconf -e EnabledSitesPath=c:\mynginxconf -P estenrye/nginx-windowsservercore`	
* **EnableNginxWebServer**
    * This variable allows to add a server block to serve content out of /html directory of nginx. This can be used to test basic nginx installation
	* Acceptable Values: `true` or `false`
    * Default: `true`
    * Example: `EnableNginxWebServer=true`