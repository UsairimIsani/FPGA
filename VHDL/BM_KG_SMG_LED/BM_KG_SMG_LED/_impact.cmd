loadProjectFile -file "D:\XC3S500\BM_KG_SMG_LED\BM_KG_SMG_LED/BM_KG_SMG_LED.ipf"
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
assignFile -p 1 -file "D:/XC3S500/BM_KG_SMG_LED/BM_KG_SMG_LED/bm_kg_smg_led.bit"
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500/BM_KG_SMG_LED/BM_KG_SMG_LED/BM_KG_SMG_LED.ipf"
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
