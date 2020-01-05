setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
setMode -bs
setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500/LED_TEST/LED_TEST/led_water.bit"
Program -p 1 -defaultVersion 0 
setCable -port lpt1
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
