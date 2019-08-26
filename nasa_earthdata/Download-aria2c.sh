#!/bin/sh

GREP_OPTIONS=''

links=$1
cookiejar=$(mktemp cookies.XXXXXXXXXX)
netrc=$(mktemp netrc.XXXXXXXXXX)
chmod 0600 "$cookiejar" "$netrc"

function finish() {
    rm -rf "$cookiejar" "$netrc"
}

prompt_credentials() {
    echo "Enter your Earthdata Login or other provider supplied credentials"
    read -p "Username (your_username): " username
    username=${username:-your_username}
    read -s -p "Password: " password
    echo "machine urs.earthdata.nasa.gov login $username password $password" >>$netrc
    echo
}

exit_with_error() {
    echo
    echo "Unable to Retrieve Data"
    echo
    echo $1
    echo
    echo "https://e4ftl01.cr.usgs.gov//ASTER_B/ASTT/ASTGTM.003/2000.03.01/ASTGTMV003_N11E028.zip"
    echo
    exit 1
}

detect_app_approval() {
    approved=$(curl -s -b "$cookiejar" -c "$cookiejar" -L --max-redirs 2 --netrc-file "$netrc" https://e4ftl01.cr.usgs.gov//ASTER_B/ASTT/ASTGTM.003/2000.03.01/ASTGTMV003_N11E028.zip -w %{http_code} | tail -1)
    if [ "$approved" -ne "302" ]; then
        # User didn't approve the app. Direct users to approve the app in URS
        exit_with_error "Please ensure that you have authorized the remote application by visiting the link below "
    fi
}

setup_auth_curl() {
    # Firstly, check if it require URS authentication
    status=$(curl -s -z "$(date)" -w %{http_code} https://e4ftl01.cr.usgs.gov//ASTER_B/ASTT/ASTGTM.003/2000.03.01/ASTGTMV003_N11E028.zip | tail -1)
    if [[ "$status" -ne "200" && "$status" -ne "304" ]]; then
        # URS authentication is required. Now further check if the application/remote service is approved.
        detect_app_approval
    fi
}

setup_auth_wget() {
    # The safest way to auth via curl is netrc. Note: there's no checking or feedback
    # if login is unsuccessful
    touch ~/.netrc
    chmod 0600 ~/.netrc
    credentials=$(grep 'machine urs.earthdata.nasa.gov' ~/.netrc)
    if [ -z "$credentials" ]; then
        cat "$netrc" >>~/.netrc
    fi
}

fetch_urls() {
    if command -v aria2c >/dev/null 2>&1; then
        setup_auth_curl
        aria2c -i "$links" --no-netrc false --netrc-path="$netrc" --load-cookies="$cookiejar" --save-cookies="$cookiejar" || echo "Command failed with error. Please retrieve the data manually."
    else
        exit_with_error "Error: Could not find a command-line downloader.  Please install curl or wget"
    fi
}

# always execute finish function if receives EXIT signal
trap finish EXIT

# calling function
prompt_credentials

fetch_urls 2>&1 | tee dl.log
