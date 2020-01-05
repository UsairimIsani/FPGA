setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
setMode -bs
deleteDevice -position 14
deleteDevice -position 13
deleteDevice -position 12
deleteDevice -position 11
deleteDevice -position 10
deleteDevice -position 9
deleteDevice -position 8
deleteDevice -position 7
deleteDevice -position 6
deleteDevice -position 5
deleteDevice -position 4
deleteDevice -position 3
deleteDevice -position 2
deleteDevice -position 1
setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500E_Verilog/UART/UART/uart.bit"
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500E_Verilog/UART/UART/UART.ipf"
setMode -bs
deleteDevice -position 1
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
setMode -bs
