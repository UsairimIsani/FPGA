setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500/PS_2_A/PS2/ps2.bit"
Program -p 1 -defaultVersion 0 
setMode -bs
deleteDevice -position 1
setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500/PS_2_A/PS2/ps2.bit"
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500/PS_2_A/PS2/PS2.ipf"
setMode -bs
deleteDevice -position 1
