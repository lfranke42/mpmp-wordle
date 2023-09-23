  ldc %reg0 0x01
  tst %reg0 %reg1
  jzr 0x03
  ldc %reg1 0x07
  add %reg1 %reg0 %reg1
