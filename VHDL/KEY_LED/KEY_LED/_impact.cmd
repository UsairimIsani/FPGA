loadProjectFile -file "D:\XC3S500\KEY_LED\KEY_LED/KEY_LED.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -acecf
setMode -acempm
setMode -pff
setMode -spi
setMode -bs
setMode -bs
setMode -spi
setMode -spi
setMode -pff
setSubmode -pffserial
setMode -pff
setMode -spi
setMode -pff
setMode -pff
setMode -spi
setMode -spi
setMode -bs
setMode -bs
setMode -spi
setMode -spi
setMode -bs
setMode -bs
setMode -spi
setMode -spi
setMode -pff
setMode -pff
setMode -spi
setMode -spi
setMode -bs
setMode -bs
setMode -pff
setMode -pff
setMode -pff
setMode -pff
setCurrentDesign -version 0
setMode -pff
setCurrentDeviceChain -index 0
setSubmode -pffparallel
setAttribute -configdevice -attr spiSelected -value "TRUE"
deletePromDevice -position 1
addPromDevice -p 1 -size 1024 -name 8M
setCurrentDeviceChain -index 0
setMode -bs
setMode -bs
setCable -port auto
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:\XC3S500\KEY_LED\KEY_LED/KEY_LED.ipf"
saveProjectFile -file "D:/XC3S500/KEY_LED/KEY_LED/KEY_LED.ipf"
setMode -bs
deleteDevice -position 1
setMode -pff
setMode -pff
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
deleteDevice -position 1
setMode -acecf
setMode -acempm
setMode -pff
deletePromDevice -position 1
setCurrentDesign -version 0
setCurrentDeviceChain -index 0
deleteDevice -position 1
setCurrentDeviceChain -index 0
deleteDesign -version 0
setCurrentDesign -version -1
setMode -pff
setMode -pff
setSubmode -pffparallel
setAttribute -configdevice -attr spiSelected -value "TRUE"
setMode -pff
setMode -pff
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
setMode -spi
setMode -bs
