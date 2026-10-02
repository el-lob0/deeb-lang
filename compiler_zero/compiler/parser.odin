package v0compiler


StatementType :: enum {
    TypeDeclaration,
    FunctionDeclaration,
    RunDeclaration
}

Statement :: struct {
    type: StatementType,
}



parse_tokenstream :: proc(source_id: string, tokens: ^[dynamic]Token, values: ^[dynamic]string) -> (Error, [dynamic]Statement) {

    statements : [dynamic]Statement

    /* 



     */

    return Error.None, statements
}


















