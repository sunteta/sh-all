# 常用的SH 一键命令合集

**一键清空 docker 日志脚本**
这个脚本会先停止所有正在运行的 Docker 容器，然后清空每个容器的日志文件，最后再启动所有容器。请注意，在执行此脚本之前，请确保已备份并保存了您需要的日志记录。
```
bash <(curl -sL https://raw.githubusercontent.com/sunteta/sh-all/main/docker-clean-logs.sh)
```



**不停止容器，清除日志脚本**
这个脚本会遍历所有 Docker 容器的 ID，然后清空每个容器的日志文件。请注意，此脚本不会停止容器，因此您可以在不影响正在运行的容器的情况下清除它们的日志。但是，请注意，清除容器的日志文件可能会影响容器的性能，因此最好在必要时使用此脚本。
```
bash <(curl -sL https://raw.githubusercontent.com/sunteta/sh-all/main/docker-clean-logs-nostop.sh)
```
