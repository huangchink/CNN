##------------------Dont touch----------------------##
clear -all

# Config rules
config_rtlds -rule -enable -domain { LINT }
config_rtlds -rule -disable -domain { DFT AUTO_FORMAL }

# ivcad2020_constrain //
config_rtlds -rule  -disable -tag { IDN_NR_CKYW IDN_NR_SVKY NAM_NR_REPU MOD_NR_PGAT MOD_NO_IPRG FLP_NR_MXCS REG_NR_RWRC }
config_rtlds -rule -disable -category {NAMING}
config_rtlds -rule -disable -tag { INS_NR_INPR FLP_NO_ASRT OTP_NR_ASYA ASG_MS_RPAD ASG_NS_TRNB OPR_NR_UEOP OPR_NR_UREL OPR_NR_UCMP CAS_NR_UCIT INP_NO_USED} 
# ivcad2020_constrain //

##------------------Dont touch----------------------##

# import and elaborate design //
analyze -v2k ../src/top.v +incdir+../src+../include; ## modify your file name ## 
elaborate -bbox true -top top; ## modify your top module ##

# Setup clock and reset
clock clk; ## modify your clock name ##
reset rst; ## modify your reset name ##

# Extract checks
check_superlint -extract

