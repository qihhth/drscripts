action var goodbook 1 when book( of sigils)? back to the contents\.$|book( of sigils)? is already at the contents\.
var color none
var goodbook 0

if_1 goto VALIDATE
echo *** USAGE:  .sbook induction ***
exit


VALIDATE:
    if "%1" = "integration" then var color twilight-blue
    if "%1" = "rarefaction" then var color red
    if "%1" = "metamorphosis" then var color pitch-black
    if "%1" = "congruence" then var color blue
    if "%1" = "decay" then var color platinum-hued
    if "%1" = "clarification" then var color copper-hued
    if "%1" = "abolition" then var color white
    if "%1" = "nurture" then var color shadowy-black
    if "%1" = "antipode" then var color icy-blue
    if "%1" = "induction" then var color black
    if "%1" = "ascension" then var color bone-white
    if "%1" = "evolution" then var color fiery-red
    if "%1" = "permutation" then var color gold-hued
    if "%1" = "paradox" then var color ash-grey
    if "%1" = "unity" then var color blood-red

    if %color = "none" then {
        echo *** %1 is not a recognized sigil type.  Use the entire name of the sigil. ***
        exit 
    }
    if ("$righthandnoun" = "book") && ("$lefthandnoun" = "book") = 2 then {
        echo *** You are holding two books, put the one you don't want to change away then try again. ***
        exit
    }
    else if ("$righthandnoun" = "book") || ("$lefthandnoun" = "book") then {
        gosub ACTION "turn my book to contents" "."
        if %goodbook != 1 then {
            echo *** This is not the right kind of book, it needs ot be a sigil book. ***
            exit
        }

    }
    else {
        echo *** You need to be holding the book whose color you wish to change. ***
        exit
    }

CHANGE:
if ("$righthand" = "%color book") || ("$lefthandnoun" = "%color book") then {
    echo *** Correct color achieved! ***
    exit
}
else {
    gosub ACTION "rub my book" "Ripples dance across the surface"
}
GOTO CHANGE

ACTION:
pause 0.5
match ACTION ...wait
matchre RETURN $2
put $1
matchwait 

RETURN:
return