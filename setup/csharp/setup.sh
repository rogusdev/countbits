# https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-3.1

# https://www.michaelcrump.net/part12-aspnetcore/
export DOTNET_CLI_TELEMETRY_OPTOUT=true

# https://github.com/dotnet/sdk/issues/3828
# export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
export DOTNET_NOLOGO=true
# https://docs.microsoft.com/en-us/nuget/reference/cli-reference/cli-ref-environment-variables
export NUGET_XMLDOC_MODE=skip

echo dotnet $(dotnet --version)
