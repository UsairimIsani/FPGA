setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500/BianMa_8_3/BianMa_8_3/bianma_8_3.bit"
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500/BianMa_8_3/BianMa_8_3/BianMa_8_3.ipf"
setMode -bs
deleteDevice -position 1
loadProjectFile -file "D:\XC3S500\BianMa_8_3\BianMa_8_3/BianMa_8_3.ipf"
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
assignFile -p 1 -file "D:/XC3S500/BianMa_8_3/BianMa_8_3/bianma_8_3.bit"
Program -p 1 -defaultVersion 0 
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500/BianMa_8_3/BianMa_8_3/BianMa_8_3.ipf"
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
