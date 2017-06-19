FROM microsoft/windowsservercore:latest
MAINTAINER @csciborg
ENV NginxVersion 1.13.1
ENV WriteReverseProxyConfFromEnv=true \
    ReverseProxyListenPort=80 \
    ReverseProxyServerName=nginx
EXPOSE ${ReverseProxyListenPort}

SHELL ["powershell", "-command"]
RUN Invoke-WebRequest "http://nginx.org/download/nginx-$($env:NginxVersion).zip" -OutFile /nginx.zip; \
    Expand-Archive /nginx.zip /nginx ; \
    Remove-Item "/nginx/nginx-$($env:NginxVersion)/conf/*.conf" -Verbose;

WORKDIR /nginx/nginx-${NginxVersion}
COPY ./conf/* /nginx/nginx-${NginxVersion}/conf/

ENTRYPOINT .\conf\Generate-ReverseProxyConf.ps1;.\nginx.exe