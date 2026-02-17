debug 0
var tongs muracite tongs
var bellows leather bellows 
var hammer ball-peen hammer
var shovel curved shovel
var ingot brass-alloy ingot

var default haversack
var craftbag forging kit
var finished haversack
var special 0
var final 0
var additional 0
var itemsleft %3
var chapter 1
var toolbelt 1
var toolbeltnoun black toolbelt
var instructions 0

action var page $1 when Page (\d+):\s+?(a|an|some)(\s+)?%2
action var final 1 when now appears ready for cooling in the slack tub
action var special TONGS when could use some straight|would benefit from some soft
action var special BELLOWS when is unable to consume its fuel|^As you finish working the fire dims and produces
action var special SHOVEL when fire dies down and (needs|appears)
action var additional $1 $3 when ^You need another finished (long|short) (wooden|leather) (cord|pole)
action var beltlist $1 when You think you can tie the following items\: ([\w\s,]+)\.

eval noun replace("%2", " ", "|")  
eval noun element("%noun", -1)
if_3 then {
    if %instructions = 1 then { 
        var book %noun instructions 
        GOTO START
    }
    else {
        eval discipline tolower(%1)
        var found 0
        if contains("blacksmithing", %discipline) then {
            var discipline blacksmithing
            var book %discipline book
            GOTO START
        }
        if contains("weaponsmithing", %discipline) then {
            var discipline weaponsmithing
            var book %discipline book
            GOTO START
        }
        if contains("armorsmithing", %discipline) then {
            var discipline armorsmithing
            var book %discipline book
            GOTO START
        }
    } 
}
echo *** Usage .forge blacksmith "green hammer" 2
exit

START:
pause 0.5
if %toolbelt = 1 then put study my %toolbeltnoun
var book_name %2
var item_name %noun
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
put turn my book to chapter %chapter

FINDCHAPTER:
pause 0.5
match FINDCHAPTER ...wait
match INCREMENTCHAPTER A good positive
match FOUND %book_name
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
echo *** Error, %book_name was not found in your instruction book. ***
exit

FOUND:
# Should already be on the correct chapter
pause 0.5
match FOUND ...wait
match MAIN You turn your book
match MAIN You are already on
put turn my book to page %page
matchwait

ANVIL:
pause 0.5
match ANVIL ...wait
match RETURN You put your ingot on the
put put my %ingot on anvil
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
gosub GETTOOL %ingot
gosub ANVIL
gosub GETTOOL %hammer
gosub GETTOOL %tongs
gosub POUND ingot
gosub CRAFT
gosub PUTTOOL %hammer
gosub PUTTOOL %tongs
gosub TUB 
gosub ACTION "put my %item_name in my %finished" "You put your"
if "$lefthandnoun" = "oil" then GOSUB ACTION "stow oil" "You put"
math itemsleft subtract 1
if %itemsleft > 0 then {
    GOTO MAIN 
}
else 
{
     GOTO EXIT
}


CRAFT:
if %final < 1 then {
    if %special = 0 then {
        GOSUB POUND %item_name
        GOTO CRAFT
    }
    else {
        GOSUB %special
        GOTO CRAFT
    }
}
else {
    var special 0
    var final 0
    var additional 0
    return
}

POUND:
    pause 0.5
    match POUND ...wait
    match POUND Sorry, 
    match RETURN Roundtime
    put pound $0 with my %hammer
    matchwait

TONGS:
pause 0.5
gosub ACTION "turn %item_name on anvil with my %tongs" "Roundtime"
var special 0
return

BELLOWS:
pause 0.5
gosub PUTTOOL %tongs
gosub GETTOOL %bellows
pause 0.5
gosub ACTION "push my %bellows" "Roundtime"
gosub PUTTOOL %bellows
gosub GETTOOL %tongs
pause 0.5
var special 0
return

SHOVEL:
pause 0.5
gosub PUTTOOL %tongs
gosub GETTOOL %shovel
pause 0.5
gosub ACTION "push fuel with my %shovel" "Roundtime"
gosub PUTTOOL %shovel
gosub GETTOOL %tongs
pause 0.5
var special 0
return

TUB:
gosub ACTION "push tub" "Roundtime"
gosub ACTION "get %item_name" "You get.*unfinished"
if %additional != 0 then {
    gosub GETTOOL %additional
    gosub ACTION "assemble my %item_name with my %additional" "You"
}
gosub ACTION "get my oil" "You get"
gosub ACTION "pour oil on my %item_name" "Applying the final"
return


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