# http://www.gscloud.cn/sources/download/334/MODLT1D.20011231.CN.LTN.V2/bj?csrftoken=NclV9CNz3nLvocADEV5zNivgrsGoCtAL&gscloud_session=kw6g55xfsxfh29r0vylthbhl3ebxtwzd&utoken="ut:z2qFpCkf-plmrige-8i-RkmG"
$BaseRequestUrl = 'http://www.gscloud.cn/sources/download/dataid'
$Cookie1 = New-Object System.Net.Cookie('csrftoken', '45p7mQVb9nEQrFtnTPzIsvHKvcWiccj0', '/', 'www.gscloud.cn')
$Cookie2 = New-Object System.Net.Cookie('gscloud_session', 'owkte2295xk6u3wv5dbrtccp2fjwzrjd', '/', 'www.gscloud.cn')
$Cookie3 = New-Object System.Net.Cookie('utoken', '"ut:m2rSis0IEyvV0QBhsnmHBlX8"', '/', 'www.gscloud.cn')
$CookieContainer = New-Object System.Net.CookieContainer
$CookieContainer.Add($Cookie1)
$CookieContainer.Add($Cookie2)
$CookieContainer.Add($Cookie3)

# Data Path
# 逐月MYD昼和夜平均值
# '340/MYDLT1M.yyyyMMdd.CN.LTN.AVG.V2/bj','340/MYDLT1M.yyyyMMdd.CN.LTD.AVG.V2/bj'
# 逐月MOD昼和夜平均值
# '336/MODLT1M.yyyyMMdd.CN.LTN.AVG.V2/bj','336/MODLT1M.yyyyMMdd.CN.LTD.AVG.V2/bj'
# 逐日昼和夜MOD MYD 
# '341/MYDLT1D.yyyyMMdd.CN.LTN.V2','334/MODLT1D.yyyyMMdd.CN.LTD.V2', '334/MODLT1D.yyyyMMdd.CN.LTN.V2'

# Create a folder for each data product, for example a '340' folder for '340/MYDLT1M.yyyyMMdd.CN.LTN.AVG.V2/bj'
$OutDir = 'E:\'
$dataFilterList = ('2000-04-01', '2000-09-01', '336/MODLT1M.yyyyMMdd.CN.LTN.AVG.V2/bj'), ('2000-04-01', '2000-09-01', '336/MODLT1M.yyyyMMdd.CN.LTD.AVG.V2/bj')
$dataIdList = @()

function buildDataListMonthly {
    param($dataFilter)
    $subdataIdList = @()
    # start and end date both included
    [DateTime]$StartDate = $dataFilter[0]
    [DateTime]$EndDate = $dataFilter[1]
    $dataId = $dataFilter[2]
    For ($presentDate = $StartDate; $presentDate -le $EndDate; $presentDate = $presentDate.AddMonths(1) ) {
        $presentDateStr = $presentDate.ToString('yyyyMMdd')
        $tmpdataId = $dataId.Replace('yyyyMMdd', $presentDateStr)
        $subdataIdList += $tmpdataId
    }
    return $subdataIdList
}

function downloadDataList {
    param($dataIdList)
    Foreach ($dataId in $dataIdList) {
        #Write-Host $dataId
        $requestUrl = $BaseRequestUrl.Replace('dataid', $dataId)
        $request = [System.Net.HttpWebRequest]::Create($requesturl)
        $request.CookieContainer = $CookieContainer
        try {
            $response = $request.GetResponse()
            $absoluteUri = $response.ResponseUri.AbsoluteUri
            # Don't forget to close $response or the following requests will time out
            $response.Close()
            # $absoluteUri
            #You have to manually create all parent directoryies of outfile it they don't exist 
            $outFile = $OutDir + $dataId + '.tif'
            # Patch for monthly file
            $outFile = $OutFile.Replace('/bj', '')
            (New-Object System.Net.WebClient).DownloadFile($absoluteUri, $outFile)
            $outFile
            $hereString = $outFile + "," + $absoluteUri
            $hereString | Out-File -Filepath $OutDir'downloadlist.csv' -Append
        }
        catch [Net.WebException] {
            $_.Exception.ToString() | Out-File -Filepath $OutDir'errorlog.txt' -Append
            $hereString = $outFile + "," + $absoluteUri
            $hereString | Out-File -Filepath $OutDir'failedlist.csv' -Append
        }
    }
}

# to use the functions above
foreach ($dataFilter in $dataFilterList) {
    $tmpList = buildDataListMonthly $dataFilter 
    $dataIdList += $tmpList
}

downloadDataList $dataIdList

##In most cases you cannot download all files without error... use this:
##get all tif filenames recursively into an array, this result has the same path pattern as $dataIdList above,
##can be directly dealt with downloadDataList function
# $dataidList = gci -recurse -Filter "*.tif*" -Name
# $dataidList = $dataidList | ForEach-Object { $_.Replace(".tif","/bj") }

#################### Another download Method, much slower
$downloadToPath = "E:\somewhere\on\disk\file.zip"
$remoteFileLocation = "http://somewhere/on/the/internet"
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie('utoken', '"ut:oWp30wqg5nOzYwbQt2YwyAxc"', '/', 'www.gscloud.cn')
$session.Cookies.Add($cookie);
Invoke-WebRequest $remoteFileLocation -WebSession $session -TimeoutSec 900 -OutFile $downloadToPath
http://www.gscloud.cn/sources/download/341/MYDLT1D.20020708.CN.LTN.V2/bj
