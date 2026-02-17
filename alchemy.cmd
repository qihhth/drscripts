#debug 10

#    deep-sea draught instructions - uses junliar stem
#    gill glop instructions - uses georin grass
#    landsickness potion instructions - uses aevaes leaves
#    scale moisturizer instructions - uses red flowers

var mortar large mortar
var sieve wirework sieve
var catalyst crushed seolarn
var pestle pestle
var bowl cauldron
var stick mixing stick

# Instructions should be 1 if using HE-style instructions, otherwise 0
var instructions 0
var book remedies book
#var book instructions

var default haversack
var craftbag alch kit
var finished haversack

# Set toolbet to 1 and toolbeltnoun to the toolbelt's noun if using one
# It will try to store anything that can be tied to the toolbelt there
# If you don't want this, you should manually set the beltlist variable rather
# than letting the script set it with a trigger.
var toolbelt 1
var toolbeltnoun toolbelt

###
# No edits past here
###

var special 0
var more 0
var itemsleft %1
var chapter 1
var done 0

eval noun replace("%2", " ", "|")  
eval noun element("%noun", -1)
eval nouningred replace("%3", " ", "|")
eval nouningred element("%nouningred", -1)
if %book = "instructions" then var book %noun instructions

action var page $1 when Page (\d+):\s+?((a?n?)|some)(\s+)?%2
action var more LIQUID; var liquid $1 when ^You need another splash of (water|alcohol|brewer's brine) to continue
action var more CATALYST when ^You need another catalyst material to continue crafting 
action var special SMELL when ^As you finish, the mixture begins to transition colors
action var special SMELL when takes on an odd hue
action var special SIEVE when ^Upon completion you see some particulate clouding up the mixture
action var special SIEVE when ^A thick froth coats
action var special TURN when ^Once finished you notice clumps of material forming on the edge of the
action var special TURN when ^Clumps of material stick to the sides
action var more HERB when ^You need another prepared herb to
action var done 1 when ^Applying the final touches
action var done 1 when ^Interesting thought really
action var done 1 when ^Try as you might, you just
#action var beltlist $1 when You think you can tie the following items\: ([\w\s,]+)\.
var beltlist cauldron, mortar, pestle, bowl, stick, sieve

# external -> mortar, internal -> bowl
if matchre("(salve|ointment|poultices|cream|balm|glop|moisturizer|unguent)", "%noun") then {
    var verb crush
    var container %mortar
    var implement %pestle
} else {
    var verb mix
    var container %bowl
    var implement %stick
}

if_3 goto START
echo *** Usage .alchemy 3 "blister cream" "dried georin" "dried nemoih"
echo *** .alchemy count "craft thing" "ingredient one" "ingredient two"
echo *** Most things only have one ingredient.
exit

START:
var firstingred %3
if_4 var secondingred %4
#GOTO CRAFT
put stow left
put stow right
pause 1
put store default %craftbag
if ($righthand != "%book") then {
    GOSUB GETTOOL %book
}
if %instructions = 1 then {
    goto MAIN
}
put turn my %book to chapter %chapter
match START ...wait

FINDCHAPTER:
pause 0.5
match FINDCHAPTER ...wait
match INCREMENTCHAPTER A good positive
match FOUND %2
put read my %book;yes
matchwait

INCREMENTCHAPTER:
math chapter add 1
GOTO NEXTCHAPTER

NEXTCHAPTER:
pause 0.5
match NEXTCHAPTER ...wait
match FINDCHAPTER You turn your book
match FINDCHAPTER The book is already
match NOTFOUND does not have a chapter
put turn my book to chapter %chapter
matchwait

NOTFOUND:
echo *** Error, %2 was not found in your instruction book. ***
exit

FOUND:
# Should already be on the correct chapter
pause 0.5
match FOUND ...wait
match MAIN You turn your book
match MAIN You are already on
put turn my book to page %page
matchwait


MAIN:
if $righthand != "%book") then {
		GOSUB GETTOOL %book
	  }
	}
gosub ACTION "study my %book" "You now feel ready|The delicate nature"
if %instructions = 1 then {
    gosub ACTION "study my %book" "You now feel ready"
}
gosub PUTTOOL %book
gosub GETTOOL %container
gosub ACTION "get my %firstingred" "You get"
gosub ACTION "put my %firstingred in my %container" "You put your|place only that many inside"
if not matchre("($righthand|$lefthand)", "Empty") then {
    gosub ACTION "stow my %firstingred" "You put your"
}
gosub GETTOOL %implement
if %verb = "crush" then {
    gosub ACTION "%verb my %nouningred in my %container with my %implement" "with your pestle"
}
else {
    gosub ACTION "%verb %container with %implement" "Roundtime"
}



CRAFT:
if %more != 0 then {
    GOSUB %more
    GOTO CRAFT
}
if %done != 0 then {
    GOSUB DONE
}
if %special = 0 then {
    if %verb = "crush" then {
        GOSUB ACTION "%verb %noun in my %container with my %implement" "with your pestle"
    }
    else {
        gosub ACTION "%verb %container with %implement" "Roundtime"
    }
    GOTO CRAFT
}
else {
    GOSUB %special
    GOTO CRAFT
}

LIQUID:
pause 0.5
gosub PUTTOOL %implement
gosub GETTOOL %liquid
gosub ACTION "put my %liquid in my %container" "You toss the"
if matchre("$righthand $lefthand", %liquid) then {
    gosub PUTTOOL %liquid
}
gosub GETTOOL %implement
var more 0
return

CATALYST:
pause 0.5
gosub PUTTOOL %implement
gosub GETTOOL %catalyst
gosub ACTION "put my %catalyst in my %container" "You vigorously rub the"
if ("$lefthand" != "Empty") then gosub PUTTOOL %catalyst
gosub GETTOOL %implement
var more 0
return

HERB:
pause 0.5
gosub PUTTOOL %implement
gosub ACTION "get my %secondingred from my %default" "You get"
gosub ACTION "put my %secondingred in my %container" "You vigorously rub the"
if ("$lefthand" != "Empty") then gosub ACTION "put my %secondingred in my %default" "You put your"
gosub GETTOOL %implement
var more 0
return

SMELL:
pause 0.5
gosub ACTION "smell my %noun in my %container" "You sniff the"
var special 0
return

SIEVE:
pause 0.5
gosub PUTTOOL %implement
gosub GETTOOL %sieve
gosub ACTION "push %noun in %container with %sieve" "Roundtime"
gosub PUTTOOL %sieve
gosub GETTOOL %implement
var special 0
return

TURN:
pause 0.5
gosub ACTION "turn my %container" "You spin your"
var special 0
return

DONE:
pause 0.5
gosub PUTTOOL %implement
gosub ACTION "get my %noun from my %container" "You get"
gosub ACTION "put my %noun in my %default" "You put"
math itemsleft subtract 1
if %itemsleft > 0 then {
    var done 0
    GOTO MAIN 
}
else 
{
    gosub PUTTOOL %container
    GOTO EXIT
}


ACTION:
pause 0.5
match ACTION ...wait
matchre RETURN $2
put $1
matchwait

GETTOOL:
var temp $0
GETOOL2:
pause 0.5
if $righthand = $0 || $lefthand = $0 then return
match GETOOL2 ...wait
match RETURN You get 
match RETURN You are already
match RETURN You untie
match NOTOOL What were you
match NOTOOL Untie what
if %toolbelt = 1 then {
    eval putnoun replace("$0", " ", "|")  
    eval putnoun element("%putnoun", -1)
    if matchre("(%beltlist)", "%putnoun") then {
        put untie my %temp on my %toolbeltnoun
    }
    else {
        put get my %temp in my %craftbag
    }
}
else {
    put get my %temp in my %craftbag
}
matchwait

PUTTOOL:
var temp $0
PUTTOOL2:
pause 0.5
match PUTTOOL2 ...wait
match RETURN You put your
match RETURN You attach
if %toolbelt = 1 then {
    eval putnoun replace("$0", " ", "|")  
    eval putnoun element("%putnoun", -1)
    if matchre("(%beltlist)", "%putnoun") then {
        put tie my %temp to my %toolbeltnoun
    }
    else {
        put put my %temp in my %craftbag
    }
}
else {
    put put my %temp in my %craftbag
}
matchwait

NOTOOL:
echo *** Tool could not be found! ***
echo *** Get the tool out then type YES to continue. ***
echo *** Type SHAKE to exit. ***
match EXIT What do you want to shake
match RETURN A good positive
matchwait


EXIT:
echo *** All done ***
put store default %default
exit

RETURN:
return