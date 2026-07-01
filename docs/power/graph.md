# Graph

Utilities used to draw a power graph in parallel.

A power graph consists of a "main" processor, which manages a group of "worker"
processors to draw a graph (possibly in parallel) and a shared display and memory cells or banks.

## Macros

### `POWER_GRAPH_CONFIG(name, attribute, value)`

Configure an attribute with the specified value of a power graph configuration
with the specified name.

A list of available attributes is available under [Configuration Attributes](#configuration-attributes).

### `POWER_GRAPH_GET_CONFIG(name, attribute)`

Get the value associated with an attribute of a power graph configuration.

If the attribute is missing the result is empty.

### `powerGraphInit(currentVariable, config)`

Initialize a power graph based on its config and a variable used for tracking
the current index.

This will clear any data present in the power graph.

### `powerGraphSamplePoint(node, currentVariable, config)`

Add an additional data point to the power graph by sampling data from a power node,
incrementing the current index stored in `currentVariable`.

### `powerGraphStartPreparation(worker)`

Start the preparation of drawing the power graph on the processor passed as `worker`,
causing it to call [`graphPreparePartition`](../graphics/graphs.md#graphpreparepartitionname-number-cell-offset-resultvariable)
with its configured partition.

All partitions of the graph have to be prepared and their results merged
before the graph can be drawn.

### `powerGraphStartDraw(currentVariable, prepareState, worker)`

Start the drawing of the power graph on the processor passed as `worker`,
causing it to call [`graphDrawPartition`](../graphics/graphs.md#graphdrawpartitionname-number-current-preparestate-cell-offset-layout)
with its configured partition.

### `powerGraphStartFlush(worker)`

Start the flushing of the draw commands on the processor passed as `worker`.

The results of [`powerGraphBeginDraw`](#powergraphbegindrawcurrentvariable-config)
have to be flushed before any other workers flush their commands.

### `powerGraphTryWaitWorker(worker, pendingLabel)`

Wait for the processor passed as `worker` to finish processing its current command,
jumping to `pendingLabel` if it is not finished yet.

### `powerGraphResetWorker(worker)`

Reset the state of the processor passed as `worker`, canceling any pending commands.

### `powerGraphMergePreparationResults(partitionResult, worker, resultVariable)`

Wrapper around [`graphMergePreparationResults`](../graphics/graphs.md#graphmergepreparationresultspartitionresult1-partitionresult2-resultvariable)
which fetches the second preparation result from the processor passed as `worker`.

It is assumed the processors last command was `powerGraphStartPreparation`, which
finished before calling this function.

### `powerGraphPrepare(partition, config, resultVariable)`

Wrapper around [`graphPreparePartition`](../graphics/graphs.md#graphpreparepartitionname-number-cell-offset-resultvariable)
which performs it across all required memory cells configured in `config`.

### `powerGraphBeginDraw(currentVariable, config)`

Draw some initial graphics before the main power graph is drawn.

This function should only be called by one worker and before any other drawing functions.

### `powerGraphDraw(partition, currentVariable, prepareState, background, config)`

Draw a partition of the power graph, based on the current index and preparation results
passed in `currentVariable` and `prepareState`, respectively.

To remove any superfluous graphics they are painted over with the color passed in `background`.

### `powerGraphPrintStats(node)`

Print the power statistics of a power node, allowing them to be flushed to a message.

### `powerGraphWorkerInit()`

Prepare a worker prcessor for operation.

### `powerGraphWorkerTryProcessCmd(partition, display, background, config, pendingLabel)`

Check if the current worker processor received a command and execute it, jumping
to `pendingLabel` if no command was pending.

## Configuration Attributes

- `STORED_CELL`: memory cell for storing the statistics of the stored power

- `STORED_OFFSET`: offset in `STORED_CELL` to use

- `IN_CELL`: memory cell for storing the statistics of the produced power

- `IN_OFFSET`: offset in `IN_CELL` to use

- `OUT_CELL`: memory cell for storing the statistics of the consumed power

- `OUT_OFFSET`: offset in `OUT_CELL` to use

- `BAR_LAYOUT`: [layout](../graphics/layout.md) to use for the stored power bar

- `BAR_BORDER`: [border](../graphics/borders.md) to use for the stored power bar

- `GRAPH`: [graph](../graphics/graphs.md) to use for displaying the statistics

- `GRAPH_LAYOUT`: [layout](../graphics/layout.md) to use for `GRAPH`

- `GRAPH_BORDER`: [border](../graphics/borders.md) to use for `GRAPH`

### Predefined Configurations

- `POWER_GRAPH_LOGIC_DISPLAY`: Configuration with a logic display and 4 worker processors

- `POWER_GRAPH_LARGE_DISPLAY`: Configuration with a large logic display and 6 worker processors

## Examples

See [`graph-leader.m4`](../../templates/power/graph-leader.m4) and [`graph-worker.m4`](../../templates/power/graph-worker.m4).
