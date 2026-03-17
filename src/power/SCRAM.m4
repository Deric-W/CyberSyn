set heatThreshold 0.0001

controlLoop:
set index 0
reactorLoop:
jump controlLoop greaterThanEq index @links
getlink reactor index
sensor tmp reactor @heat
op lessThan tmp tmp heatThreshold
control enabled reactor tmp _ _ _
op add index index 1
jump reactorLoop always _ _