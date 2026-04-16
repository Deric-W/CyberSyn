# Export

Program for controling a group of launch pads and their inputs.

After linking the processor to all launch pads and their unloaders
they can be enabled or disabled by using a switch, with their item
selection being taken from a sorter.

The status of the group is visualized by an illuminator.

## Pseudocode

```mlog
Building switch = switch1
Building itemSelect = sorter1
Building enableStatus = illuminator
Number enabledColor = pack(0, 255, 0, 255)
Number disabledColor = pack(255, 0, 0, 255)

# initialize to null to force update on first iteration
bool lastEnabled = null
Item lastItem = null
while (true) {
    bool enabled = switch.enabled
    Item item = itemSelect.config
    if (enabled === lastEnabled && item === lastItem) {
        # reduces delay when receiving new user input
        continue
    }

    for (Number index = 0; index < @links; index++) {
        Building building = getlink(index)
        if (building === switch || building === itemSelect || building === enableStatus) {
            continue
        }
        building.enabled = enabled
        building.condig = item
    }

    # update status at the end to signal that the changes are applied
    enabledStatus.color = enabled ? enabledColor : disabledColor
    enabledStatus.enabled = enabled
    lastEnabled = enabled
    lastItem = item
}
```
