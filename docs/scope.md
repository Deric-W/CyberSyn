# Scope

Utilities for improving modularity by defining macro scopes.

## Macros

### `SCOPED_DEFINE(name, definition)`

Define a macro, making sure its definition is undone when the current scope ends.

### `BEGIN_SCOPE`

Begin a new scope.

The new scope will contain all definitions from any enclosing scopes, unless
they are shadowed by definitions decleared in the current scope.

### `END_SCOPE`

End the current scope.

### `SCOPE_DEPTH`

The current number of nested scopes.

### `DEFINITIONS_IN_SCOPE`

The number of definitions in the current scope.

### `TOTAL_DEFINITIONS`

The number of definitions in the current and any enclosing scopes.

### `IDENTIFIER(name)`

Register an identifier, which will be defined as a macro expanding to
an unique name within the current scope.

### `LABEL(name)`

Register a named label in the current scope, defining it as a macro which
expands to a unique name across all scopes.

When defining labels in macros they will be duplicated when the same macro is
invoked several times. This macro prevents that by replacing them with unique
identifiers.
