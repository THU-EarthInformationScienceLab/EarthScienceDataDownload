# http://www.gscloud.cn/sources/download/334/MODLT1D.20011231.CN.LTN.V2/bj?csrftoken=NclV9CNz3nLvocADEV5zNivgrsGoCtAL&gscloud_session=kw6g55xfsxfh29r0vylthbhl3ebxtwzd&utoken="ut:z2qFpCkf-plmrige-8i-RkmG"
$BaseRequestUrl = 'http://www.gscloud.cn/sources/download/dataid/bj'
$Cookie1 = New-Object System.Net.Cookie('csrftoken', 'NclV9CNz3nLvocADEV5zNivgrsGoCtAL', '/', 'www.gscloud.cn')
$Cookie2 = New-Object System.Net.Cookie('gscloud_session', 'kw6g55xfsxfh29r0vylthbhl3ebxtwzd', '/', 'www.gscloud.cn')
$Cookie3 = New-Object System.Net.Cookie('utoken', '"ut:4mox_eI4SZ4DAXKhaPTgTgmZ"', '/', 'www.gscloud.cn')
$CookieContainer = New-Object System.Net.CookieContainer
$CookieContainer.Add($Cookie1)
$CookieContainer.Add($Cookie2)
$CookieContainer.Add($Cookie3)

# User Definition
$DataIdList = '341/MYDLT1D.yyyyMMdd.CN.LTD.V2', '341/MYDLT1D.yyyyMMdd.CN.LTN.V2','334/MODLT1D.yyyyMMdd.CN.LTD.V2', '334/MODLT1D.yyyyMMdd.CN.LTN.V2'
$OutDir='D:\Storage\gscloud\'


# start and end date both included
[DateTime]$StartDate = '2002-07-08'
[DateTime]$EndDate = '2002-07-09'
For ($presentDate = $StartDate; $presentDate -le $EndDate; $presentDate = $presentDate.AddDays(1) ) {
    $presentDateStr = $presentDate.ToString('yyyyMMdd')
    Foreach ($dataId in $DataIdList) {
        $dataId = $dataId.Replace('yyyyMMdd', $presentDateStr)
        #Write-Host $dataId
        $requestUrl = $BaseRequestUrl.Replace('dataid', $dataId)
        $request = [System.Net.HttpWebRequest]::Create($requesturl)
        $request.CookieContainer = $CookieContainer
        $response = $request.GetResponse()
        $absoluteUri = $response.ResponseUri.AbsoluteUri
        # Don't forget to close $response or the following requests will time out
        $response.Close()
        #Write-Host $absoluteUri
        $outFile=$OutDir+$dataId+'.tif'
        (New-Object System.Net.WebClient).DownloadFile($absoluteUri, $outFile)
        Write-Host $outFile
        #Write-Host "------"

    }
}

####################Test
$downloadToPath = "c:\somewhere\on\disk\file.zip"
$remoteFileLocation = "http://somewhere/on/the/internet"
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie('utoken', '"ut:oWp30wqg5nOzYwbQt2YwyAxc"', '/', 'www.gscloud.cn')
$session.Cookies.Add($cookie);
Invoke-WebRequest $remoteFileLocation -WebSession $session -TimeoutSec 900 -OutFile $downloadToPath
http://www.gscloud.cn/sources/download/341/MYDLT1D.20020708.CN.LTN.V2/bj