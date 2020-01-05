loadProjectFile -file "D:\XC3S500\UART\UART/UART.ipf"
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
saveProjectFile -file "D:/XC3S500/UART/UART/UART.ipf"
setMode -bs
deleteDevice -position 1
