package v0compiler

import "core:os"
import "core:fmt"
import "core:strings"



Token :: enum {
    CurlyBracketOpen,
    CurlyBracketClose,
    SquareBracketOpen,
    SquareBracketClose,
    ParenthesisOpen,
    ParenthesisClose,
    DoubleQuoteOpen,
    DoubleQuoteClose,
    SingleQuoteOpen,
    SingleQuoteClose,
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
    Char,
    PlusOp,
    MinusOp,
    MultOp,
    DivOp,
    ModuloOp,
    AssignOp,
    EqualComparisonOp,
    NotEqualComparisonOp,
    OR_ComparisonOp,
    AND_ComparisonOp,
    NotPrefix,

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


is_keyword :: proc(field: string) -> (Token, string, int) {
    is_keyword := field == "run" || field == "loop" || field == "if" || field == "else" || field == "array" || field == "fn" || field == "enum" || field == "struct" 
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

    token := Token.Identifier

    return token, field, 0
}


tokenize :: proc (tokens: ^[dynamic]Token, values: ^[dynamic]string, file: string) -> (Error) {
    // switch on every char, accumulate into a string 
    // checks order: 
    // check for string or char delimiters
    // if inside string, or char, append until closing delimiter is met
    // if not: -> symbol -> double symbol -> keyword -> number
    // when its a whitespace without issues append token and continue

    buffer : [dynamic]u8

    in_single_quote := false
    char_count := 0
    in_double_quote := false

    escape := false

    for char in file {

        
        // ----------------------- CHAR AND STRING ---------------------
        if in_single_quote {
            char_count += 1
        }
        if char_count > 2 {
            return Error.ExpectedClosingSingleQuote
        }

        if in_double_quote {
            append_elem(&buffer, u8(char))
            continue
        }
        if in_single_quote && char != '\'' {
            append_elem(tokens, Token.Char)
            append_elem(values, fmt.tprintf("%c", char))
            continue
        }


        switch char {
        case '"': {
            if in_double_quote && !in_single_quote && char == '"' {

                append_elem(tokens, Token.DoubleQuoteClose)
                append_elem(values, "")

                append_elem(tokens, Token.String)
                append_elem(values, string(buffer[:]))

                in_double_quote = false
            }
            if !in_double_quote && !in_single_quote {
 
               append_elem(tokens, Token.DoubleQuoteOpen)
               append_elem(values, "")

               in_double_quote = true
            }
        }
        case '\'': {
            if !in_single_quote {
                in_single_quote = true
                append_elem(tokens, Token.SingleQuoteOpen)
                append_elem(values, "")
            }
            if in_single_quote {
                char_count = 0
                append_elem(tokens, Token.SingleQuoteClose)
                append_elem(values, "")
            }
        }
        // ------------------------ END CHAR AND STRING -------------------
        





        }
    }


    return Error.None
}



file_to_tokens :: proc(filepath: string) -> ([dynamic]Token, [dynamic]string, int, string) {
    tokens : [dynamic]Token
    values : [dynamic]string
 
    raw_file, read_error := os.read_entire_file_from_filename(filepath)
    if read_error {       
        return tokens, values, 1, fmt.tprintf("Error reading file: %s", filepath)
    }

    err := tokenize(&tokens, &values, string(raw_file))
    defer delete(raw_file, context.allocator)

    return tokens, values, 0, fmt.tprintf("Tokenized file: %s", filepath)
}
