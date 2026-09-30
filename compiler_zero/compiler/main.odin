package v0compiler

import "core:fmt"




main :: proc() {
    test_file := "test.fih"

    tokens, values, err, msg := file_to_tokens(test_file)

    for i := 0;i<len(tokens); i+= 1 {
        fmt.printfln("Token: ", tokens[i], "/  Value: ", values[i])
    }

}



