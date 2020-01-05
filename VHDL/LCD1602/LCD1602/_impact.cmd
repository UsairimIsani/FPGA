loadProjectFile -file "D:\XC3S500\LCD1602\LCD1602/LCD1602.ipf"
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
Program -p 1 -defaultVersion 0 
assignFile -p 1 -file "D:/XC3S500/LCD128644466/lcd12864.bit"
Program -p 1 -defaultVersion 0 
Program -p 1 -defaultVersion 0 
assignFile -p 1 -file "D:/XC3S500/12864/LCD12864/lcd12864.bit"
Program -p 1 -defaultVersion 0 
assignFile -p 1 -file "D:/XC3S500/1286444/LCD12864/lcd12864.bit"
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500/LCD1602/LCD1602/LCD1602.ipf"
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
