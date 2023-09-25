
def parse_file():
    parsed_words = []

    word_count = 0
    with open("resources/valid-wordle-words.txt", "r") as f:
        for word in f:
            word_count += 1
            if word_count % 4 == 0:
                parsed_words.append(word.rstrip("\n"))

    print("Parsed " + str(len(parsed_words)) + " words")
    return parsed_words


def generate_hex_file(word_list):
    with open("build/ram.hex", "w") as f:
        f.write("v3.0 hex words plain\n")

        # Leave first few lines empty
        for i in range(0, 150):
            for j in range(0, 16):
                f.write("0000")
                if j != 15:
                    f.write(" ")
            f.write("\n")

        # Write words to RAM
        line_end = 0
        for word in word_list:
            for i in range(0, len(word)):
                ascii_val = ord(word[i])
                f.write("00" + hex(ascii_val)[2:] + " ")

            for i in range(0, 3):
                f.write("0000 ")

            line_end += 1

            if line_end % 2 == 0:
                f.write("\n")

        if (len(word_list) % 2) != 0:
            for i in range(0, 8):
                f.write("0000 ")


if __name__ == "__main__":
    words = parse_file()
    generate_hex_file(words)
