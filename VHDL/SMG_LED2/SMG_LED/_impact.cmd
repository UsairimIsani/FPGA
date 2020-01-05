loadProjectFile -file "D:\XC3S500\SMG_LED2\SMG_LED/SMG_LED.ipf"
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
setMode -bs
setMode -bs
setMode -bs
setMode -bs
Program -p 1 -defaultVersion 0 
setMode -bs
deleteDevice -position 1
