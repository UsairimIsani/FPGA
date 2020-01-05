/*
www.21eda.net
sz21eda@126.com

NET "switch[0]"  LOC = "P16"  ;  SW1
NET "switch[1]"  LOC = "P17"  ;
NET "switch[2]"  LOC = "P21"  ;
NET "switch[3]"  LOC = "P22"  ;
NET "switch[4]"  LOC = "P23"  ;
NET "switch[5]"  LOC = "P24"  ;
NET "switch[6]"  LOC = "P26"  ;
NET "switch[7]"  LOC = "P27"  ;  SW8
*/
module bm_kg_led(
		switch,   //SW INPUT
		led       // LED OUTPUT
		);					    // 模块名led
		
input	[7:0] 	switch;		    //拨码开关
output	[7:0]	led;			//LED灯输出显示

assign led =	switch;			//把拨码开关的数据在LED灯上面显示

endmodule