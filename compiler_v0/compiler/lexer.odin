package v0compiler

import "core:os"
import "core:fmt"
import "core:strings"


// TODO: seperate non string fields into multiple fields if it contains multiple tokens (i.e. `y=x+a`, 5 different tokens without whitespaces)
// TODO: tokenize standalone operators/brackets

Token :: enum {
    CurlyBracketOpen,
    CurlyBracketClose,
    ParenthesisOpen,
    ParenthesisClose,
    DoubleQuoteOpen,
    DoubleQuoteClose,
    Identifier,
    KeywordIf,
    KeywordElse,
    KeywordRun,
    KeywordLoop,
    KeywordArray,
    KeywordFn,
    KeywordEnum,
    KeywordStruct,
    // these 
    TypeInt,
    TypeUnsigned,
    TypeFloat,
    // require explicit sizes: `int(64)` 
    Number,
    String,
    PlusOp,
    MinusOp,
    MultOp,
    DivOp,
    AssignOp,
    EqualComparisonOp,
    NotEqualComparisonOp,
    OR_ComparisonOp,
    AND_ComparisonOp,

    ReferenceOp,
    None,
}

StringState :: enum {
  Inside,
  Outside
}

Lexer :: struct {
    token: [dynamic]Token,
    value: [dynamic]string,
}

is_numerical :: proc(str: string) -> bool {
    is_numerical := true
    for char in str {
        if !((char >= '0' && char <= '9') || char == '.') {
            is_numerical = false
            break
        }
    }
    return is_numerical
}

is_type_with_size :: proc (field: string) -> (Token, string, bool) {

    index := 0 

    first_slice: [dynamic]u8
    for i in field {
        if i == '(' {
            break
        }
        append_elem(&first_slice, u8(i))
        index += 1
    }
 
    second_slice: [dynamic]u8
    for i := index; i<len(field); i+=1 {
        if field[i] == '(' {
            continue
        }
        if field[i] == ')' {
            break
        }
        append_elem(&second_slice, field[i])

        // need to check for a closing bracket
        if i == len(field)-1 {
            if field[i] != ')' {
                return Token.None, "", false
            }
        }
    }

    if !is_numerical(string(second_slice[:])) {
        return Token.None, "", false
    }

    switch string(first_slice[:]) {
    case "int": return Token.TypeInt, string(second_slice[:]), true 
    case "uint": return Token.TypeUnsigned, string(second_slice[:]), true
    case "float": return Token.TypeFloat, string(second_slice[:]), true 
    case: return Token.None, "", false
    }
} 


tokenize :: proc(field: string, string_state: StringState) -> (Token, string, int) {

  // WARN: field is whitespace seperated elements of the files.
  //       so i need to check for isolated operators as well as ones that are stuck to identifiers or keywords ot types 

    is_keyword := field == "run" || field == "loop" || field == "if" || field == "else" || field == "array" || field == "fn" || field == "enum" || field == "struct" 


    if is_numerical(field) {
      return Token.Number, field, 0
    }

    if string_state == StringState.Inside {
        return Token.String, field, 0
    }

    if is_keyword {
        switch field {
        case "run": return Token.KeywordRun, "", 0
        case "loop": return Token.KeywordLoop, "", 0
        case "if": return Token.KeywordIf, "", 0
        case "else": return Token.KeywordElse, "", 0
        case "array": return Token.KeywordArray, "", 0
        case "fn": return Token.KeywordFn, "", 0
        case "enum": return Token.KeywordEnum, "", 0
        case "struct": return Token.KeywordStruct, "", 0
        // case: return Token.Number, "Impossible", 1
        }
    }

    test_token, test_value, is_type := is_type_with_size(field)
    if is_type {
        return test_token, test_value, 0
    }

    token := Token.Identifier

    return token, field, 0
}

// NOTE: gotta add escaping bytes to strings

file_to_tokens :: proc(filepath: string) -> (Lexer, int, string) {
    file, error := os.read_entire_file_from_filename(filepath)
    defer delete(file, context.allocator)

    fields := strings.fields(string(file))

    lexer := Lexer {} 

    string_state := StringState.Outside

    for field in fields {
        
        if field == "\"" && string_state == StringState.Outside {
            string_state = StringState.Inside
            append_elem(&lexer.token, Token.DoubleQuoteOpen)
            append_elem(&lexer.value, field)
            continue
        } else if field == "\"" && string_state == StringState.Inside {
            string_state = StringState.Inside
            append_elem(&lexer.token, Token.DoubleQuoteOpen)
            append_elem(&lexer.value, field)
            continue
        }

        token, value, result := tokenize(field, string_state)
        
        if result == 1 {
          return lexer, 1, value
        }
        append_elem(&lexer.token, token)
        append_elem(&lexer.value, value)
    }

    return lexer, 0, fmt.tprintf("Tokenized file: %s", filepath)
}
