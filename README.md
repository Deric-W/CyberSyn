# CyberSyn

This repository contains a collection of programs written in the [Logic][logic]
programming language existing in the game of [Mindustry][mindustry].

## Building

Since the final Logic programs have to be generated ([on why this is necessary](#code))
the following tools are required to obtain them (assuming a POSIX system):

- [GNU m4][m4]
- [make][make]

Running `make all` will build all programs and place them in a `build` directory,
while running `make build/name-of-program.m4` will only build a specific program.

To remove all generated files run `make clean`.

## Structure

### Code

The code is contained in `.m4` files which actually contain instructions for the
[m4 macro processor][m4], making advanced use cases such as code reuse possible.

These files are organized into two directories: `src` and `include`.

#### Programs

Files which are intended to be evaluated by m4 to produce the actual Logic programs
are placed in the `src` directory (or one of its subdirectories) and can be built
according to the [instructions](#building).

These files may want to reuse existing code, which is explained in the following
section.

#### Libraries

Files which are not intended to be evaluated directly but rather to be included by
other programs are placed in the `include` directory.

To make sure programs are rebuilt when a file included by them (or directly or indirectly)
was changed the build system has to be notified of any dependencies between them.
Normally these dependencies represent reverse "is included by" relationships and
have to be recorded in the `Makefile` using the following templates.

To cause the program `src/program.m4` to be reevaluated every time `include/dependency.m4` changes:

```make
$(OUTPUT)/program.mlog: include/dependency.m4
```

To cause programs using the library `include/dependent.m4` to be reevaluated every time `include/dependency.m4` changes:

```make
include/dependent.m4: include/dependency.m4
    @touch $@
```

Please group any new rules by the program or dependent library to make identifying
the dependencies of a file easier.


### Documentation

To increase the comprehensibility of the code additional documentation may be
provided in the `docs` directory. 


[logic]: <https://mindustrygame.github.io/wiki/logic/0-introduction/>

[mindustry]: <https://github.com/Anuken/Mindustry>

[m4]: <https://en.wikipedia.org/wiki/M4_(computer_language)>

[make]: <https://en.wikipedia.org/wiki/Make_(software)>
