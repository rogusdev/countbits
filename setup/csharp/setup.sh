curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list' 

sudo apt-get update
sudo apt-get install -yq dotnet-sdk-2.1.4

# https://www.michaelcrump.net/part12-aspnetcore/
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# https://github.com/dotnet/cli/issues/6815
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
