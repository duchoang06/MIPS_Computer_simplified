transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/system.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/REG.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/ALU.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/control.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/ALU_control.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/Exception_Handle.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/Sign_Extend.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/EPC.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/LCD_Controller.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/LCD_TEST.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/LCD_Selector.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/system_INTERFACE.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/IMEM.v}
vlog -vlog01compat -work work +incdir+D:/Study\ in\ BK/HK172/Computer\ Architecture/Lab/Assignment/Ass\ 2/MIPS_Computer_simplified {D:/Study in BK/HK172/Computer Architecture/Lab/Assignment/Ass 2/MIPS_Computer_simplified/DMEM.v}

