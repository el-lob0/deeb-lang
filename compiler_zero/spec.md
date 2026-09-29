# Syntax

## Main block

```c
run {
    // main program
    // no input, can return an int (error code)
}
```
And comments*

## Generic types

```
uint(size)
int(size)
float(size)

string
char
bool
```

* Variables:
```c
num: uint(8) // declaration
num: uint(8): 5 // const declaration
num: uint(8) = 10 // mutable declaration
num = 1 // assign (impossible on undeclared)

```

## Structs & enums

```c 
struct Person {
    age: int,
    name: string.
}

person: Person = {age: 18, name: "name"}

person.age
```
```c 
enum Nationality {
    French,
    NotFrench,
}

if n == Nationality.French {}
```
<br />

P.S. The syntax here will change in the v1 compiler to: 
```c
type TypeName: enum {
    // ...
}
type TypeName: struct {
    // ...
}
type TypeName: int
```


## Functions
```c
fn func_name(param: type): return_type {
    return 0
}
```

## Loop

```c

loop (int(8): i = 0) < n {

}

loop (bool: on = true) == false {

}
```



# Not yet designed

## Memory

```c
variable: type = value @(expression)
realloc(variable, newsize_expression)
// expression that equals the size
```

## Arrays 
```c
// not dynamic until v1
items: (i32)list[9]
update_len(items, new_len) 


items: (string)list[9]
grow_list(items, 3) // list[9] -> list[12] 
update_value(items, index, value, new_size) // need to specify a new memory size 

```

# Memory management

## Functions 

```c

num: i32 = 5 

// reference syntax is to be thunk about
fn use_as_reference(n: &i32): i32 {
    n = 6 // illegal
    a: i32 = n + 1 // read-only allowed

    return a // destroyed
}

fn move_and_return(n: i32): i32 {
    n = 6 // legal
    return n
}
```
P.S. Copying functionality needs to be from v0

## Scope

All variables and values are destroyed at end of scope. 
Only "global" data allowed are structs and enums.


