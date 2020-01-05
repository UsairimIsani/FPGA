setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500/Div_F_1miao_0.5/Div_F_1miao/div_f_1miao.bit"
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500/Div_F_1miao_0.5/Div_F_1miao/Div_F_1miao.ipf"
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
