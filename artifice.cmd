debug 0
var loop augmenting loop
var burin copperwood burin
var fount thick fount
var rod imbuement rod
var base totem
var book artificing book
var default haversack
var enchantbag sch tote
var finished haversack

#### IMBUE STUFF
var cast_imbue YES
var imbue_prep 30
var cambrinth_total 50
var cambrinth_charge_amt 20
var cambrinth_item watersilk bag

#### BYOB or not
var heldbrazier YES

var booktypes book|tome
var congruence blue tome
var abolition white tome
var induction black tome
var rarefaction red tome
var permutation gold-hued tome
var antipode icy-blue tome
var ascension bone-white tome
var clarification copper-hued tome
var decay platinum-hued tome
var evolution fiery-red tome
var integration twilight-blue tome
var metamorphosis pitch-black tome
var nuture shadowy-black tome
var paradox ash-grey tome
var unity blood-red tome

var special 0
var final 0
var itemsleft %2
var chapter 1

action var page $1 when Page (\d+):\s+?a?n?(\s+)?%1
action math final add 1 when ^Then continue the process with the casting of an imbue spell|Once finished you sense an imbue spell will be required to continue enchanting.|^The.*?requires an application of an imbue spell to advance the enchanting process.
action var special SIGIL;var sigil $1 when ^You need another (?!primary|secondary)(\S+) .*sigil to continue the enchanting process
action var special MEDITATE when ^The traced sigil pattern blurs before your eyes, making it difficult to follow
action var special PUSH when ^You notice many of the scribed sigils are slowly merging back into
action var special FOCUS when ^The .* struggles to accept the sigil scribing

if_3 then {
    var sigil %3
    var final 1
    goto START2
} 
if_2 goto START
echo *** Usage .artifice "radiant trinket" 3
exit

START:
put stow left
put stow right
pause 1
put store default %enchantbag
if $righthand != "%book") then {
		GOSUB GETTOOL %book
	  }
	}
put turn my book to chapter %chapter
match START ...wait

if %heldbrazier = YES then {
    match NOBRAZIER What were you referring to?
    match FINDCHAPTER You get a
    put get my brazier from my %enchantbag
} else {
    match FINDCHAPTER You see nothing
    match NOBRAZIER I could not find
    put look brazier
}
matchwait

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

BRAZIER:
pause 0.5
match BRAZIER ...wait
match BRAZIER You glance down
match RETURN With a flick
put put my %base on brazier
matchwait

FOUNT:
pause 0.5
match FOUNT ...wait
match RETURN You slowly wave the fount over and around
put wave my %fount at %base on brazier
matchwait

IMBUE:
if "%cast_imbue" != "YES" then GOTO ROD_IMBUE

SPELL_IMBUE:
var charged_amount 0
evalmath amount_to_charge_now min(%cambrinth_total, %cambrinth_charge_amt)
matchre IMBUE ...wait|Sorry
match CAMBRINTH_CHARGE With calm movements
put prep imbue
matchwait

CAMBRINTH_CHARGE:
pause 0.5
match CAMBRINTH_CHARGE ...wait
match CAMBRINTH_CHARGE Sorry
match CAMBRINTH_TEST You harness
put charge %cambrinth_item %amount_to_charge_now
matchwait

CAMBRINTH_TEST:
math charged_amount add %amount_to_charge_now
evalmath remaining (%cambrinth_total - %charged_amount)
if %remaining > 0 then {
    evalmath amount_to_charge_now min(%remaining, %cambrinth_charge_amt)
    goto CAMBRINTH_CHARGE

}

CAMBRINTH_INVOKE:
pause 0.5
match CAMBRINTH_INVOKE ...wait
match CAMBRINTH_INVOKE Sorry
match IMBUE_CAST_CHECK Roundtime
put invoke my %cambrinth_item %cambrinth_total
matchwait

IMBUE_CAST_CHECK:
if $spelltime > 20 then {
    goto IMBUE_CAST 
}
else {
    pause 1
    GOTO IMBUE_CAST_CHECK
}

IMBUE_CAST:
pause 0.5
match IMBUE_CAST ...wait
match IMBUE_CAST Sorry
match RETURN You
put cast %base on brazier
matchwait

ROD_IMBUE:
pause 0.5
match IMBUE ...wait
match RETURN The spell is channeled through the fount hanging above
put wave my %rod at %base on brazier
matchwait

MAIN:
if $righthand != "%book") then {
		GOSUB GETTOOL %book
	  }
	}
gosub ACTION "study my %book" "You now feel ready"
gosub PUTTOOL %book
gosub GETTOOL %base
gosub BRAZIER
gosub GETTOOL %fount
gosub FOUNT
if "%cast_imbue" != "YES" then gosub GETTOOL %rod
gosub IMBUE
if "%cast_imbue" != "YES" then gosub PUTTOOL %rod

gosub SIGIL
START2:
gosub CRAFT
gosub PUTTOOL %burin
if "%cast_imbue" != "YES" then gosub GETTOOL %rod
gosub IMBUE
if "%cast_imbue" != "YES" then gosub PUTTOOL %rod
gosub ACTION "stow my %fount at my feet" "You put your"
gosub ACTION "get my %base" "You pick up"
gosub ACTION "put my %base in my %finished" "You put your"
math itemsleft subtract 1
if %itemsleft > 0 then {
    GOTO MAIN 
}
else 
{
     GOTO EXIT
}

SIGIL:
if $lefthand = %burin or $righthand = %burin then GOSUB PUTTOOL %burin
GOSUB GETTOOL %%sigil
GOSUB ACTION "turn my %%sigil to page 1" "You turn the (%booktypes)|You are already on"
GOSUB ACTION "read my %%sigil" "On this page you"
GOSUB ACTION "study my %%sigil" "You commit the sigil's design to memory"
GOSUB PUTTOOL %%sigil
GOSUB GETTOOL %burin
GOSUB ACTION "trace %base on brazier with %burin" "you trace its form"
GOSUB PUTTOOL %burin
var special 0
var sigil 0
return

CRAFT:
gosub GETTOOL %burin
if %final < 2 then {
    if %special = 0 then {
        GOSUB ACTION "scribe %base on braz with my %burin" "You lean in towards|You need another"
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
    return
}

PUSH:
pause 0.5
gosub PUTTOOL %burin
gosub GETTOOL %loop
gosub ACTION "push %base on brazier with my %loop" "You wave the loop"
gosub PUTTOOL %loop
gosub GETTOOL %burin
var special 0
return

MEDITATE:
pause 0.5
gosub ACTION "meditate %fount on brazier" "You lean in close to the fount"
var special 0
return

FOCUS:
pause 0.5
gosub ACTION "focus %base on brazier" "You adjust the brazier's intensity and"
var special 0
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
put get my $0 from my %enchantbag
matchwait

PUTTOOL:
pause 0.5
match PUTTOOL ...wait
match RETURN You put your
put put my $0 in my %enchantbag
matchwait

NOTOOL:
echo *** Tool could not be found! ***
exit

EXIT:
echo *** All done ***
if %heldbrazier = YES then put stow brazier
put store default %default
exit

RETURN:
return