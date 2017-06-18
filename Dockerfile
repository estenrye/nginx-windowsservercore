FROM microsoft/windowsservercore:latest
MAINTAINER @csciborg
ENV NginxVersion 1.12.0
#ENV WriteReverseProxyConfFromEnv true
#ENV ReverseProxyListenPort 80
#ENV ReverseProxyServerName nginx
#ENV ReverseProxyLocationList "@('/hello==>http://localhost:9090/hello', '/goodbye==>http://localhost:9091/goodbye')"
EXPOSE 80

SHELL ["powershell", "-command"]
RUN Invoke-WebRequest "http://nginx.org/download/nginx-$($env:NginxVersion).zip" -OutFile /nginx.zip; \
    Expand-Archive /nginx.zip /nginx ; \
    Remove-Item "/nginx/nginx-$($env:NginxVersion)/conf/*.conf" -Verbose;

WORKDIR /nginx/nginx-${NginxVersion}
COPY ./conf/* /nginx/nginx-${NginxVersion}/conf/

ENTRYPOINT .\conf\Generate-ReverseProxyConf.ps1;.\nginx.exe