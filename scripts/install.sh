#! /bin/bash -e
set -x
cd $HELM_PLUGIN_DIR
echo "Installing helm-opa..."

osName=$(uname -s)
osArchitecture=$(uname -m)

if [[ $osArchitecture == *'aarch'* || $osArchitecture == *'arm'* ]]; then
    osArchitecture='arm64'
fi

if [[ $osName == "Linux" ]]; then
  osName='linux'
fi

if [[ $osArchitecture == 'x86_64' ]]; then
  osArchitecture='amd64'
fi

DOWNLOAD_URL=$(curl --silent "https://api.github.com/repos/shift/helm-opa/releases/latest" | grep -m 1 -o "browser_download_url.*\-${osName}-${osArchitecture}.tar.gz")

DOWNLOAD_URL=${DOWNLOAD_URL//\"}
DOWNLOAD_URL=${DOWNLOAD_URL/browser_download_url: /}

echo $DOWNLOAD_URL
OUTPUT_BASENAME=helm-opa
OUTPUT_BASENAME_WITH_POSTFIX=$OUTPUT_BASENAME.tar.gz

if [ "$DOWNLOAD_URL" = "" ]
then
    echo "Unsupported OS / architecture: ${osName}"
    exit 1
fi

if [ -n $(command -v curl) ]
then
    curl -L $DOWNLOAD_URL -o $OUTPUT_BASENAME_WITH_POSTFIX
else
    echo "Need curl"
    exit -1
fi

rm -rf bin && mkdir bin && tar xfv $OUTPUT_BASENAME_WITH_POSTFIX > /dev/null && rm -f $OUTPUT_BASENAME_WITH_POSTFIX

echo "helm-opa is installed."
echo
echo "Happy testing..."
