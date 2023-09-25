main:
 ldc %reg0 0x02
 ldc %reg1 0x01
 tst %reg0 %reg1
 jzr main