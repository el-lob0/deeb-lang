
### (wip)

# Design


---


## Syntax (Grammar)

main block <br />
```c
run {
    const string name = "your_name";
    print(hello_world(name, 0));
}
```
<br />

```c
// comment

/*
comment block
*/

```
<br />

loops <br />
```rs

loop (i32: i = 0) < n {

}

loop (bool: on) == false {

}
```

<br />

functions <br />
```c
fn hello_world(name: string, count: int): () {
    return l
}
```
<br />

lists <br />
```c
// dynamic by default
list l = []
list_add(l, "a")
// etc...
```
<br />

struct <br />
```c 
struct Person {
    age: int,
    name: string.
}

person: Person = {age: 18, name: "name"}

a = person.age

```
<br />

enum <br />
```c
enum Nationality {
    French,
    NotFrench,
}

if n == Nationality::French {}

```
<br />

maps <br />
```c
// each field is a list (dynamic array)
map People {
    age: int,
    name: string,
}

people: People // initialized each list as empty

people.age = some_list

list_add(people.age, 18)

```
<br />

other types <br />
```sh
u32, u64, i32, i63

string

id // index

```
<br />

errors and return types <br />
```c 
// to define a constant (something like a global enum) that can be returned from any functions

#return_type FileIO_Error

fn write_file(): () {
    // ...
    if !error {
        return
    } else {
        return FileIO_Error
    }
}
// ps. all the return types are like a single big enum that belongs to the entire package or file (tbd)

```
<br />

boolean operations <br />
```c 
// joining bools in comparisions

if x; > 1 | < 0 { }

// normal bools 

if x > 10 {}
```

## Memory Management

- Mutable values are moved, pointers are only for immutable values (Cloning/copying is possible).
- All values are freed at the end of their scope.
- You can create, modify and access global data through maps, and indexes/handles.

## Standard Library

- Input/output operations  
- Math and string utilities  
- File and system tools  
- Hashmaps
- FFI
- Vulkan interface
