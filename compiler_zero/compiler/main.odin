package v0compiler

import "core:fmt"





main :: proc() {
    test_file := "test.fih"

    tokens, values, err, msg := file_to_tokens(test_file)

    if err != Error.None {
        #partial switch err {
            case Error.UnexpectedToken: {
                fmt.println("[ERROR]: Unexpected token, ", msg)
                return
            }
            case Error.ExpectedClosingSingleQuote: {
                fmt.println("[ERROR]: Expected closing `'`, ", msg)
                return
            }
            case Error.ExpectedClosingDoubleQuote: {
                fmt.println("[ERROR]: Expected closing `\"`, ", msg)
                return
            }
        }
    }

    fmt.println("[INFO]: ", msg)
}

