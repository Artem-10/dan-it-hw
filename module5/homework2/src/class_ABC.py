class alphabet:
    def __init__(self, lang, letter):
     self.letter = letter
     self.lang = lang
    def print(self):
        print(self.letter)

    def letters_num(self):
      return len(self.letter)


class EngAlphabet(alphabet):
        _letters_num = 26
        def __init__(self):
            super().__init__('En', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')
        def is_en_letter(self, letter):
            return letter in self.letter
        def letter_num(self):
            return EngAlphabet._letters_num

        @staticmethod
        def example():
            return "The quick brown fox jumps over the lazy dog."


english_alphabet = EngAlphabet()
english_alphabet.print()
print(english_alphabet.letters_num())
print(english_alphabet.is_en_letter('щ'))
