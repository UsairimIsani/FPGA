setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500E_Verilog/div_f_f/DIVF_F/div_f_f.bit"
Program -p 1 -defaultVersion 0 
assignFile -p 1 -file "D:/XC3S500E_Verilog/div_f_f/DIVF_F/div_f_f.bit"
Program -p 1 -defaultVersion 0 
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500E_Verilog/div_f_f/DIVF_F/DIVF_F.ipf"
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
