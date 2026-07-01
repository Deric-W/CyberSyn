# Small power graph

Power graph using the predefined [`POWER_GRAPH_LOGIC_DISPLAY`](./graph.md#predefined-configurations)
configuration.

In addition to a shared logic display a message is used to display the current
stats of the power network and a switch is available to reset the graph if necessary.

When building the main `.mlog` file it contains the code of the main processor,
which is also a worker.
The code of the remaining 3 workers is generated in files with `-workerN` appended
to their names.
