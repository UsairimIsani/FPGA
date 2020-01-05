setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "D:/XC3S500/LCD_VGA/LCD_VGA/lcd_vga.bit"
Program -p 1 -defaultVersion 0 
saveProjectFile -file "D:/XC3S500/LCD_VGA/LCD_VGA/LCD_VGA.ipf"
setMode -bs
deleteDevice -position 1
