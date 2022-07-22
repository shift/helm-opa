#! /bin/bash -e
set -x
cd $HELM_PLUGIN_DIR
echo "Installing helm-opa..."

osName=$(uname -s)
osArchitecture=$(uname -m)

if [[ $osArchitecture == *'aarch'* || $osArchitecture == *'arm'* ]]; then
    osArchitecture='arm64'
fi

DOWNLOAD_URL=$(curl --silent "https://api.github.com/repos/shift/helm-opa/releases/latest" | grep -o "browser_download_url.*\_${osName}_${osArchitecture}.zip")

DOWNLOAD_URL=${DOWNLOAD_URL//\"}
DOWNLOAD_URL=${DOWNLOAD_URL/browser_download_url: /}

echo $DOWNLOAD_URL
OUTPUT_BASENAME=helm-opa
OUTPUT_BASENAME_WITH_POSTFIX=$OUTPUT_BASENAME.zip

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

rm -rf bin && mkdir bin && unzip $OUTPUT_BASENAME_WITH_POSTFIX -d bin > /dev/null && rm -f $OUTPUT_BASENAME_WITH_POSTFIX

echo "helm-opa is installed."
echo
echo "Happy testing..."
