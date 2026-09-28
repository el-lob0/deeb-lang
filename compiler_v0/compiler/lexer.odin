package v0compiler

import "core:os"
import "core:fmt"
import "core:strings"


Token :: enum {
    CurlyBracketOpen,
    CurlyBracketClose,
    ParenthesisOpen,
    ParenthesisClose,
    DoubleQuoteOpen,
    DoubleQuoteClose,
    Identifier,
    Keyword,
    Type,
    Number,
    String,
}

DelimiterSwitch :: enum {
  Inside,
  Outside
}

Lexer :: struct {
    token: [dynamic]Token,
    value: [dynamic]string,
}

tokenize :: proc(field: string) -> (Token, string, int) {

    for char in field {
        
    }
    token := Token.Number

    return token, "1", 0
}


file_to_tokens :: proc(filepath: string) -> (Lexer, int, string) {
    file, error := os.read_entire_file_from_filename(filepath)
    defer delete(file, context.allocator)

    fields := strings.fields(string(file))

    lexer := Lexer {} 

    for field in fields {
        token, value, result := tokenize(field)
        if result == 1 {
          return lexer, 1, value
        }
        append_elem(&lexer.token, token)
        append_elem(&lexer.value, value)
    }

    return lexer, 0, fmt.tprintf("Tokenized file: %s", filepath)
}
