define(`jumpIfUnitIsInvalid',`dnl
jump $2 strictEqual $1 null
sensor tmp $1 @dead
jump $2 equal tmp true
sensor tmp $1 @controlled
jump $2 equal tmp @ctrlPlayer
jump $2 equal tmp @ctrlCommand')dnl
define(`jumpIfFlaggedUnitIsInvalid',`dnl
jumpIfUnitIsInvalid(`$1', `$3')
sensor tmp $1 @flag
jump $3 notEqual tmp $2')