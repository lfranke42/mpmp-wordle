init_game:
  ldc


;; handle user input and store results to memory (address 0x004 - 0x008)

get_user_input:
  ldc %reg0 0x00
  ld %reg1 %reg0 ; load the amount of chars parsed
  ldc %reg0 0x0005
  tst %reg1 %reg0
  jzr check_user_input ; if the amount of chars parsed is 5, check input
  ldc %reg0 0x8002 ; address for reading the keyboard buffer
  ld %reg5 %reg0 ; load the current input buffer value to reg5
  ldc %reg1 0x00
  tst %reg5 %reg1 ; test if the current input buffer value is 0
  jzr get_user_input ; if the current input buffer value is 0, wait for a new input
  ldc %reg0 0x8000 ; address for writing to the screen
  st %reg0 %reg5 ; write the current input buffer value to the screen
  jr store_user_input

store_user_input:
  ldc %reg1 0x003 ; base address for storing user input
  ldc %reg0 0x00 ; address for counting the number of characters
  ld %reg2 %reg0 ; load the number of characters
  inc %reg2 ; increment the number of characters
  st %reg0 %reg2 ; store new amount of characters
  add %reg3 %reg1 %reg2 ; calculate the address for storing the new character
  st %reg3 %reg5 ; store the new character
  ldc %reg5 0x00
  jr get_user_input

check_user_input:
  hlt