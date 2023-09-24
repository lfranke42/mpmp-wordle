main_loop:
  ldc %reg0 0x8002 ; address for reading the keyboard buffer
  ld %reg1 %reg0 ; load the current input buffer value to reg1
  ldc %reg0 0x8000 ; address for writing to the screen
  st %reg0 %reg1 ; write the current input buffer value to the screen
  nop
  jr main_loop