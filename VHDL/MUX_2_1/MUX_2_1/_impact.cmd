setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500/MUX_2_1/MUX_2_1/mux_2_1.bit"
Program -p 1 -defaultVersion 0 
setMode -bs
deleteDevice -position 1
setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500/MUX_2_1/MUX_2_1/mux_2_1.bit"
Verify -p 1 
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500/MUX_2_1/MUX_2_1/MUX_2_1.ipf"
setMode -bs
deleteDevice -position 1
