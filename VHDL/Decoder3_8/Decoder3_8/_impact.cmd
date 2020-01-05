setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500/Decoder3_8/Decoder3_8/decoder3_8.bit"
Program -p 1 -defaultVersion 0 
assignFile -p 1 -file "D:/XC3S500/Decoder3_8/Decoder3_8/decoder3_8.bit"
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500/Decoder3_8/Decoder3_8/Decoder3_8.ipf"
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
