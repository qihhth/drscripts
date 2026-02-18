#
# Designed to work for bone carving mostly, not stone yet.
#

#debug 10
var rasp tapered rasp
var rifflers elongated rifflers
var bonesaw bone saw
var polish surface polish
var book carving book
var default haversack
var carvebag red case
var finished haversack
var base deer-bone stack

var special 0
var more 0
var itemsleft %1
var chapter 1
var codexchapter 0
var codexpage 0
var bonecount 0
var design 0
var stacksize 0
var done 0

eval noun replace("%2", " ", "|")  
eval noun element("%noun", -1)
#eval nouningred replace("%3", " ", "|")
#eval nouningred element("%nouningred", -1)

action var bonecount $1 when ^   \(\d\) a bleached bone stack \((\d+) pieces\)
action var page $1 when Page (\d+):\s+?((a?n?)|some)(\s+)?%2
action var more 1; var moreitem $1 $2 when ^You need another \w+ (\w+) \w+ (\w+)
action var special RIFFLERS when ^Upon completion you notice several rough, jagged
action var special RASP when determine it is no longer level.
action var special RASP when developed an uneven texture along its surface
action var special RASP when ^When you have finished working you determine the \w+ is uneven
action var special POLISH when ^Upon finishing you see some discolored areas
action var special CODEX when ^You must study a design in a design codex before proceeding to craft this.
action var codexchapter $1 when ^You turn your codex to chapter (\d+)
action var stacksize $1 when ^You count out (\d+) pieces of material

action var done 1 when ^Applying the final touches
action var done 1 when ^Interesting thought really
action var done 1 when ^Try as you might, you just

# stupid case sensitive humanoid designs
if_3 then {
    eval lowerdesign tolower(%3)
    var humanoids human|elf|dwarf|elothean|gor'tog|halfling|s'kra mur|rakash|prydaen|gnome|kaldar
    eval is_humanoid indexof("%humanoids", "%lowerdesign")
    if %is_humanoid > 0 then {
        if "%lowerdesign" = "s'kra mur" then {
            var design "S'Kra Mur"
        } else if "%lowerdesign" = "gor'tog" then {
            var design "Gor'Tog"
        }
        else {
            eval first toupper(substr(%lowerdesign, 0,1))
            eval rest substr(%lowerdesign, 1, )
            var design %first%rest
        }
    }
    else {
        var design %lowerdesign
    }
}  
if (%design = 0) then {
    var design viper
}
action var codexpage $1 when Page (\d+): %design
if_2 goto START
echo *** Usage .carve 3 "bone totem" "viper"
echo *** .carve count "craft thing" "design"
echo *** Some things don't need an entry from the design codex.
exit

START:
put stow left
put stow right
pause 1
put store default %carvebag
if ($righthand != "%book") then {
    GOSUB GETTOOL %book
}
put turn my book to chapter %chapter
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
if %bonecount = 0 then {
    if ($righthand != "%book") then {
        GOSUB GETTOOL %book
    }
    gosub ACTION "read my %book" "a bleached bone"
    gosub PUTTOOL %book
}
gosub CUT
if_3 then {
    gosub CODEX
}
if not matchre("$righthand $lefthand", "%book") then gosub GETTOOL %book
gosub ACTION "study my %book" "You now feel ready"
gosub PUTTOOL %book
gosub GETTOOL %bonesaw
gosub ACTION "carve my %base with my %bonesaw" "(^You saw|^Back and forth)"

CRAFT:
if %more != 0 then {
    GOSUB %more
    GOTO CRAFT
}
if %done != 0 then {
    GOSUB DONE
}
if %special = 0 then {
    GOSUB ACTION "carve %noun with %bonesaw" "Roundtime"
    GOTO CRAFT
}
else {
    GOSUB %special
    GOTO CRAFT
}

RIFFLERS:
pause 0.5
gosub PUTTOOL %bonesaw
gosub GETTOOL %rifflers
gosub ACTION "rub my %noun with %rifflers" "(^You remove|^You pull out)"
gosub PUTTOOL %rifflers
gosub GETTOOL %bonesaw
var special 0
return

RASP:
pause 0.5
gosub PUTTOOL %bonesaw
gosub GETTOOL %rasp
gosub ACTION "rub my %noun with my %rasp" "(You scrape away|^You file down)"
gosub PUTTOOL %rasp
gosub GETTOOL %bonesaw
var special 0
return

POLISH:
pause 0.5
gosub PUTTOOL %bonesaw
gosub GETTOOL %polish
gosub ACTION "apply my polish to %noun" "Roundtime"
gosub PUTTOOL %polish
gosub GETTOOL %bonesaw
var special 0
return

MORE:
pause 0.5
gosub PUTTOOL %bonesaw
gosub ACTION "get my %moreitem from my %default" "You get"
gosub ACTION "assemble my %moreitem with my %noun" "You place the"
gosub GETTOOL %bonesaw
var more 0
var moreitem 0
return

DONE:
pause 0.5
gosub PUTTOOL %bonesaw
gosub ACTION "put my %noun in my %default" "You put"
math itemsleft subtract 1
if %itemsleft > 0 then {
    var done 0
    GOTO MAIN 
}
else 
{
    gosub PUTTOOL %mortar
    GOTO EXIT
}

CODEX:
if matchre("$righthand $lefthand", "%bonesaw") then {
    var hadsaw 1
}
else {
    var hadsaw 0
}
GOSUB PUTTOOL %bonesaw
gosub GETTOOL codex
if (%codexpage = 0) then {
    var codexchapter 0
    gosub CODEXFIND
}
gosub ACTION "turn my codex to chapter %codexchapter" "(^You turn your|^The codex is)"
gosub ACTION "turn my codex to page %codexpage" "(^You turn your|^The codex is)"
gosub ACTION "study my codex" "You study the codex"
gosub PUTTOOL codex
if %hadsaw = 1 then { 
    gosub GETTOOL %bonesaw
    var hadsaw 0
}
gosub RETURN


CUT:
gosub ACTION "get my %base" "(^You get|^You are already)"
put count my %base
pause 0.5
if %stacksize = %bonecount then {
    RETURN 
}
else if %stacksize < %bonecount then {
    gosub TOOSMALL
}
else {
    gosub ACTION "mark my stack at %bonecount" "You count out"
}
gosub GETTOOL %bonesaw
gosub ACTION "cut stack with saw" "You carefully cut"
gosub PUTTOOL %bonesaw
gosub ACTION "put my other %base in my %default" "You put your"
gosub ACTION "get stack" "You pick up the stack"
gosub ACTION "swap" "You move a"
return

TOOSMALL:
echo *** Stack is too small.  Go acquire a bigger one, place it in your right hand with your left empty, and input YES to continue.***
echo (Remember You can combine small stacks to make bigger ones.)
waitfor A good positive
gosub RETURN


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
put get my $0 from my %carvebag
matchwait

PUTTOOL:
pause 0.5
if matchre("$righthand $lefthand", $0) then {
    match PUTTOOL ...wait
    match RETURN You put your
    put put my $0 in my %carvebag
    matchwait
}
else {
    return
}

NOTOOL:
echo *** Tool could not be found! ***
exit

CODEXFIND:
math codexchapter add 1
matchre CODEXREAD (^You turn|^The codex is)
match CODEXFIND ...wait 
match NOTFOUND codex does not have
put turn my codex to chapter %codexchapter
matchwait

CODEXREAD:
match RETURN %design
match CODEXFIND A good positive
put read my codex;yes
matchwait 

CODEXNOTFOUND:
echo *** The codex doesn't have a page for %design ***

EXIT:
echo *** All done ***
put store default %default
exit

RETURN:
return