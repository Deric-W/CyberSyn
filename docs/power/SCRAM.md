# SCRAM

Program which disables any linked building exceeding a heat threshold,
designed to prevent thorium reactors from overheating.

## Pseudocode

```
Number heatThreshold = 0.001
while (true) {
    for (Number index = 0; index < @links; index++) {
        Building linked = getlink(index)
        building.enabled = building.heat < heatThreshold
    }
}
```
