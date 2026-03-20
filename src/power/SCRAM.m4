include(`control-flow.m4')dnl
set heatThreshold 0.0001

controlLoop:
LINKLOOP(`index', `reactor', `dnl
sensor tmp reactor @heat
op lessThan tmp tmp heatThreshold
control enabled reactor tmp _ _ _')
jump controlLoop always _ _