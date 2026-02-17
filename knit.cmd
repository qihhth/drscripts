debug 0
var needles knitting needles
var book tailoring book
var default haversack
var craftbag sch tote
var finished haversack
var yarn wool yarn

var special 0
var final 0
var itemsleft %2
var chapter 1

action var page $1 when Page (\d+):\s+?(a|an|some)?(\s+)?%1
action var special CAST when The garment is nearly complete and now must be cast 
action var special TURN when Now the needles must be turned|Some ribbing should be added
action var special PUSH when Next the needles must be pushed|ready to be pushed


if_2 goto START
echo *** Usage .knit "blanket" 3
exit

START:
put stow left
put stow right
pause 1
put store default %craftbag
if $righthand != "%book") then {
		GOSUB GETTOOL %book
	  }
	}
put turn my book to chapter %chapter

FINDCHAPTER:
pause 0.5
match FINDCHAPTER ...wait
match INCREMENTCHAPTER A good positive
match FOUND %1
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
echo *** Error, %1 was not found in your instruction book. ***
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
gosub ACTION "study my %book" "You now feel ready"
gosub PUTTOOL %book
gosub GETTOOL %yarn
gosub GETTOOL %needles
gosub ACTION "knit my yarn with my nee" "a slip knot"
if $righthand = %yarn || $lefthand = %yarn then gosub PUTTOOL %yarn
gosub CRAFT
START2:
gosub PUTTOOL %needles
gosub ACTION "put my %1 in my %finished" "You put your"
math itemsleft subtract 1
if %itemsleft > 0 then {
    GOTO MAIN 
}
else 
{
     GOTO EXIT
}

CASTON:
pause 0.5
match CASTON ...wait
match RETURN a slip-knot
match MOREYARN You need a larger amount of material to continue crafting.
put knit my %yarn with my %needles
matchwait
return

MOREYARN:
pause 0.5
gosub PUTTOOL %needles
gosub GETTOOL %yarn
put combine %yarn
return


CRAFT:
if %final = 0 then {
    if %special = 0 then {
        GOSUB ACTION "knit my %needles" "Roundtime"
        GOTO CRAFT
    }
    else {
        GOSUB %special
        GOTO CRAFT
    }
}
else {
      
    var final 0
    return
}

PUSH:
pause 0.5
gosub ACTION "push my %needles" "Roundtime"
if %special != CAST then var special 0  
return

TURN:
pause 0.5
gosub ACTION "turn my %needles" "Roundtime"
if %special != CAST then var special 0  
return

CAST:
pause 0.5
gosub ACTION "cast my %needles" "Applying the final touches"
var special 0
var final 1
return

ACTION:
pause 0.5
match ACTION ...wait
matchre RETURN $2
put $1
matchwait

GETTOOL:
pause 0.5
if $righthand = $0 || $lefthand = $0 then return
match GETTOOL ...wait
match RETURN You get 
match RETURN You are already
match NOTOOL What were you
put get my $0 from my %craftbag
matchwait

PUTTOOL:
pause 0.5
match PUTTOOL ...wait
match RETURN You put your
put put my $0 in my %craftbag
matchwait

NOTOOL:
echo *** Tool could not be found! ***
exit

EXIT:
echo *** All done ***
put store default %default
exit

RETURN:
return