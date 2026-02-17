debug 1

# this is still WIP Sorry friend

#    deep-sea draught instructions - uses junliar stem
#    gill glop instructions - uses georin grass
#    landsickness potion instructions - uses aevaes leaves
#    scale moisturizer instructions - uses red flowers

var scissors steel scissors
var yardstick electrum yardstick
var slickstone small slickstone
var awl iron awl
var pins straight pins
var material burlap cloth
var thread cotton thread
var needles sewing needles
#var bowl 
#var stick 

# Instructions should be 1 if using HE-style instructions, otherwise 0
var instructions 0
var book tailoring book
#var book instructions

var default haversack
var craftbag tailor kit
var finished haversack

# Set toolbet to 1 and toolbeltnoun to the toolbelt's noun if using one
# It will try to store anything that can be tied to the toolbelt there
# If you don't want this, you should manually set the beltlist variable rather
# than letting the script set it with a trigger.
var toolbelt 0
#var toolbeltnoun toolbelt

###
# No edits past here
###

var special 0
var more 0
var itemsleft %1
var chapter 1
var chaptertype 0
var crafttype 0
var done 0

eval noun replace("%2", " ", "|")  
eval noun element("%noun", -1)
#eval nouningred replace("%3", " ", "|")
#eval nouningred element("%nouningred", -1)
if %book = "instructions" then var book %noun instructions

action var page $1 when Page (\d+):\s+?((a?n?)|some)(\s+)?%2
#action var more LIQUID; var liquid $1 when ^You need another splash of (water|alcohol|brewer's brine) to continue
action var more ASSEMBLE; var assemblewith "small padding" when ^You need another finished small cloth padding
action var more ASSEMBLE; var assemblewith "large padding" when ^You need another finished large cloth padding
action var more ASSEMBLE; var assemblewith "shield handle" when ^You need another finished leather shield handle
action var more ASSEMBLE; var assemblewith "long cord" when ^You need another finished long leather cord
action var special PUTFEET when ^You carefully cut off the excess material and set it at your feet.
action var special YARDSTICK when dimensions appear to have shifted and could benefit from some remeasuring
action var special SLICKSTONE when deep crease develops along
action var special SLICKSTONE when wrinkles from all the handling and could use
action var special PINS when ^The fabric keeps folding back and could use some pins to keep it straight.
action var special PINS when ^The leather keeps bending apart and could use some pins to keep it together.
action var special PINS when ^Two layers of the fabric won't cooperate and could use some pins to align them.
action var special AWL when One leather piece is too thick for the needle to penetrate
action var special AWL when A critical section of leather needs holes punched
action var more RETHREAD when The last of your thread is used up
action var done 1 when ^You cannot figure out how to do that
action var done 1 when ^not damaged enough to
action var done 1 when ^Applying the final touches, you complete working
action var beltlist $1 when You think you can tie the following items\: ([\w\s,]+)\.
action var chaptertype cloth when ^You turn your book to chapter \d{1,}, entitled "(Cloth|Knitted)
action var chaptertype leather when ^You turn your book to chapter \d{1,}, entitled "Leather
#var beltlist cauldron, mortar, pestle, bowl, stick, sieve

# external -> mortar, internal -> bowl
#if matchre("(salve|ointment|poultices|cream|balm|glop|moisturizer|unguent)", "%noun") then {
#    var verb crush
#    var container %mortar
#    var implement %pestle
#} else {
#    var verb mix
#    var container %bowl
#    var implement %stick
#}

if_3 then {
  eval crafttype tolower(%3)
  if matchre("(cloth|leather)" = "%crafttype") then goto START
  else echo *** Valid options for argument 3 are cloth and leather.  You input %3
  exit
}

if_2 goto START
echo *** Usage .sew 3 "cloth pants" "cloth"
echo *** .sew count "craft thing" "leather or cloth"
echo *** Some things have the same name in both the leather and the cloth sections so we sometimes need to indicate which it is.  If your thing is not one of those, you don't need the third argument.
exit

START:
# var firstingred %3
# if_4 var secondingred %4
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
match CHECKFOUND %2
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

CHECKFOUND:
if_3 then {
  if ("%crafttype" != "%chaptertype") then GOTO INCREMENTCHAPTER
}
FOUND:
# Should already be on the correct chapter
pause 0.5
match FOUND ...wait
match MAIN You turn your book
match MAIN You are already on
put turn my book to page %page
matchwait


MAIN:
if ($righthand != "%book") then {
		GOSUB GETTOOL %book
}
gosub ACTION "study my %book" "You now feel ready|The delicate nature"
if %instructions = 1 then {
    gosub ACTION "study my %book" "You now feel ready"
}
gosub PUTTOOL %book
#gosub GETTOOL %container
gosub ACTION "get my %material" "You get"
gosub GETTOOL %scissors
gosub ACTION "cut my %material with my %scissors" "You"
gosub PUTTOOL %scissors


CRAFT:
if %more != 0 then {
    GOSUB %more
    GOTO CRAFT
}
if %done != 0 then {
    GOSUB DONE
}
if %special = 0 then {
    if not matchre("($righthand|$lefthand)", "needles") then {
      GOSUB GETTOOL %needles
    }
    gosub ACTION "push my %noun with my %needles" "Roundtime"
    GOTO CRAFT
}
else {
    GOSUB %special
    GOTO CRAFT
}

PUTFEET:
pause 0.5
var special 0
match PUTFEET ...wait
matchre RETURN You put your
matchre NOFIT ^The %material
put stow %material
matchwait

NOFIT:
pause 0.5
gosub ACTION "put my %material in my %default" "You put your"
return

YARDSTICK:
pause 0.5
gosub PUTTOOL %needles
gosub ACTION "get my %yardstick" "You get"
gosub ACTION "measure my %noun with my %yardstick" "Roundtime"
gosub ACTION "put my %yardstick in my %default" "You put"
gosub GETTOOL %scissors
gosub ACTION "cut my %noun with my %scissors" "Roundtime"
gosub PUTTOOL %scissors
if (%more = 0) then gosub GETTOOL %needles
var special 0
return

PINS:
pause 0.5
gosub PUTTOOL %needles
gosub GETTOOL %pins
gosub ACTION "poke my %noun with my %pins" "Roundtime"
if ("$lefthand" != "Empty") then gosub PUTTOOL %pins
if (%more = 0) then gosub GETTOOL %needles
var special 0
return

AWL:
pause 0.5
gosub PUTTOOL %needles
gosub GETTOOL %awl
gosub ACTION "poke my %noun with my %awl" "Roundtime"
gosub PUTTOOL %awl
if (%more = 0) then gosub GETTOOL %needles
var special 0
return

SLICKSTONE:
pause 0.5
gosub PUTTOOL %needles
gosub GETTOOL %slickstone
gosub ACTION "rub my %noun with my %slickstone" "Roundtime"
gosub PUTTOOL %slickstone
if (%more = 0) then gosub GETTOOL %needles
var special 0
return


ASSEMBLE:
if matchre("$righthand $lefthand", %needles) then {
  gosub PUTTOOL %needles
}
gosub GETTOOL %assemblewith
gosub ACTION "assemble my %noun with my %assemblewith" "You place"
gosub GETTOOL %needles
var more 0
return

RETHREAD:
gosub ACTION "put my %noun in my %finished" "You put"
gosub GETTOOL %needles
gosub ACTION GETTOOL %thread
gosub ACTION "put my %thread on my %needles" "You carefully"
gosub ACTION "get my %noun from my %finished" "You get"
var more 0
return

DONE:
pause 0.5
gosub PUTTOOL %needles
#gosub ACTION "get my %noun from my %container" "You get"
gosub ACTION "put my %noun in my %default" "You put"
math itemsleft subtract 1
if %itemsleft > 0 then {
    var done 0
    GOTO MAIN 
}
GOTO EXIT

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