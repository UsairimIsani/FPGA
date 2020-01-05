setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500E_Verilog/one_second/div_f/div_f.bit"
Verify -p 1 
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500E_Verilog/one_second/div_f/div_f.ipf"
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
