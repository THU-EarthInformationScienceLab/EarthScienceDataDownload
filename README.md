# Earth Science Data Download
Some powershell/shell/python scripts I use to download or simply  process GIS/RS data

---
## 1. gscloud
  - Download mosaicked MODIS product published on gscloud (地理空间数据云)
  - Need browser cookie to download, e.g. copy it from Chrome DevTools to the script
  - there are always some false download result when you download from gscloud, and i dont know why.... users have to pick them out and re-download 
## 2. nasa earthdata
  ### Download-default.sh
  I made some tweaks on the downloading script nasa provides. Screen output is now saved into dl.log, and failed files are recorded into failed.txt.
  ### Download-aria2c.sh
  Using aria2c to download, which is much faster because of multithreading. Require aria2c installed. 
  - **usage:**
  - First replace the username in Download.sh with your nasa earthdata username
  - Get the links of files from nasa earthdata website. e.g. links.txt
  - Run the Script: ./Downloadxxx.sh <links.txt>
  - Check if there are failed files in failed.txt and re-download them
 
 ## TODO:
 - add failed files check in nasa earthdata aria2c download
    
