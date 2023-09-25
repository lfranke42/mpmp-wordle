init_game:
  ldc %reg0 0x0100 ; base adress of the word to guess

  ;; store the word to guess to adress 0x0100 - 0x0104
  ldc %reg1 0x72
  st %reg0 %reg1
  inc %reg0
  ldc %reg1 0x6F
  st %reg0 %reg1
  inc %reg0
  ldc %reg1 0x63
  st %reg0 %reg1
  inc %reg0
  ldc %reg1 0x6B
  st %reg0 %reg1
  inc %reg0
  ldc %reg1 0x79
  st %reg0 %reg1

display_title:
  ldc %reg0 0x8000 ; address for writing to the screen

  ;; WORDLE
  ldc %reg1 0x57
  st %reg0 %reg1
  ldc %reg1 0x4F
  st %reg0 %reg1
  ldc %reg1 0x52
  st %reg0 %reg1
  ldc %reg1 0x44
  st %reg0 %reg1
  ldc %reg1 0x4C
  st %reg0 %reg1
  ldc %reg1 0x45
  st %reg0 %reg1

  ;; -
  ldc %reg1 0x20
  st %reg0 %reg1
  ldc %reg1 0x2D
  st %reg0 %reg1
  ldc %reg1 0x20
  st %reg0 %reg1

  ;; Enter
  ldc %reg1 0x45
  st %reg0 %reg1
  ldc %reg1 0x6E
  st %reg0 %reg1
  ldc %reg1 0x74
  st %reg0 %reg1
  ldc %reg1 0x65
  st %reg0 %reg1
  ldc %reg1 0x72
  st %reg0 %reg1
  ldc %reg1 0x20
  st %reg0 %reg1

  ;; your
  ldc %reg1 0x79
  st %reg0 %reg1
  ldc %reg1 0x6F
  st %reg0 %reg1
  ldc %reg1 0x75
  st %reg0 %reg1
  ldc %reg1 0x72
  st %reg0 %reg1
  ldc %reg1 0x20
  st %reg0 %reg1

  ;; guess:
  ldc %reg1 0x67
  st %reg0 %reg1
  ldc %reg1 0x75
  st %reg0 %reg1
  ldc %reg1 0x65
  st %reg0 %reg1
  ldc %reg1 0x73
  st %reg0 %reg1
  st %reg0 %reg1
  ldc %reg1 0x3A
  st %reg0 %reg1

  ;; new line
  ldc %reg1 0x0A
  st %reg0 %reg1

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
  ldc %reg1 0x003 ; base address for storing user input (-1 because of the inc instruction)
  ldc %reg0 0x00 ; address for counting the number of characters
  ld %reg2 %reg0 ; load the number of characters
  inc %reg2 ; increment the number of characters
  st %reg0 %reg2 ; store new amount of characters
  add %reg3 %reg1 %reg2 ; calculate the address for storing the new character
  st %reg3 %reg5 ; store the new character
  ldc %reg5 0x00
  jr get_user_input

check_user_input:
  ;; Print newline to terminal
  ldc %reg0 0x8000
  ldc %reg1 0x0A
  st %reg0 %reg1

  ;; Check if the user input is correct
  ldc %reg0 0x0100 ; base adress of the word to guess
  ldc %reg1 0x004 ; base adress of the user input
  ldc %reg4 0x00 ; counter for the loop
  ldc %reg7 0x00 ; counter for correctly guessed characters

  jr check_character

check_character:
  ;; Check characters
  ld %reg2 %reg0 ; load correct character
  ld %reg3 %reg1 ; load user input character

  ;; Mask the stored characters so that only the lower 7 bits are compared
  ldc %reg5 0x007F
  and %reg3 %reg3 %reg5

  inc %reg0 ; increment the correct character address
  inc %reg1 ; increment the user input character address
  inc %reg4 ; increment the loop counter

  tst %reg2 %reg3 ; test if the characters are equal
  jzr correct_guess ; if the characters are equal, jump to correct_guess
  jr wrong_guess ; if the characters are not equal, jump to wrong_guess

wrong_guess:
  ldc %reg5 0x58
  ldc %reg6 0x8000
  st %reg6 %reg5 ; print "X" character
  jr check_character_end

correct_guess:
  ldc %reg5 0x2B
  ldc %reg6 0x8000
  st %reg6 %reg5 ; print "+" character
  inc %reg7 ; increment the correct guess counter
  jr check_character_end

check_character_end:
  ldc %reg5 0x05 ; max loop iterations / word length
  tst %reg7 %reg5 ; all characters guessed correctly?
  jzr win_game ; if all characters are guessed correctly, jump to win_game
  ldc %reg7 0x00 ; reset the correct guess counter for next round

  tst %reg4 %reg5 ; test if the loop counter is equal to the max loop iterations
  jnzr check_character ; if the loop counter is not equal to 5 check next character

win_game:
  ;; Print newline to terminal
  ldc %reg0 0x8000
  ldc %reg1 0x0A
  st %reg0 %reg1

  ;; Print "You win!" to terminal
  ;; You
  ldc %reg0 0x8000
  ldc %reg1 0x59
  st %reg0 %reg1
  ldc %reg1 0x6F
  st %reg0 %reg1
  ldc %reg1 0x75
  st %reg0 %reg1
  ldc %reg1 0x20
  st %reg0 %reg1

  ;; win!
  ldc %reg1 0x77
  st %reg0 %reg1
  ldc %reg1 0x69
  st %reg0 %reg1
  ldc %reg1 0x6E
  st %reg0 %reg1
  ldc %reg1 0x21
  st %reg0 %reg1

