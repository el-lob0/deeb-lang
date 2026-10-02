package v0compiler

import "core:fmt"




main :: proc() {
    test_file := "test.fih"

    tokens, values, err, msg := file_to_tokens(test_file)

    for i := 0;i<len(tokens); i+= 1 {
        if values[i] == "" {
            fmt.println("Token: ", tokens[i])
            continue
        } 
        fmt.println("Token: ", tokens[i], ": ", values[i])
    }

}



