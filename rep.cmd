
if_2 goto START
echo *** usage:  .rep metal needles , .rep cloth shirt etc ***
exit

START:
var repairstorage tail kit in my portal
var item1 0

if %1 = metal then {
    var item1 brush
    var item1action "rub my %2 with my %item1"
    var item2 oil
    var item2action "pour my %item2 on my %2"
} 
if %1 = cloth then {
    var item1 s needle
    var item1action "push my %2 with my %item1"
    var item2 slickstone
    var item2action "rub my %2 with my %item2"
}
if %1 = wood then {
    var item1 sandpaper
    var item1action "rub my %2 with my %item1"
    var item2 stain
    var item2action "apply my %item2 to my %2"
} 
if %item1 = 0 then {
    echo *** repair type not recognized ***
    exit
}

if contains(!"$righthand", "%1") then put stow right
if contains(!"$lefthand", "%1") then put stow left
pause 


DRIVER:
gosub GETTOOL %item1
gosub REPAIR %item1action
gosub PUTTOOL %item1
gosub GETTOOL %item2
gosub REPAIR %item2action
gosub PUTTOOL %item2
GOTO DRIVER


REPAIR:
pause 0.5
match ACTION ...wait
matchre RETURN Roundtime
matchre EXIT not damaged enough
put $1
matchwait

GETTOOL:
pause 0.5
if $righthand = $0 || $lefthand = $0 then return
match GETTOOL ...wait
match RETURN You get 
match RETURN You are already
match NOTOOL What were you
put get $0 from %repairstorage
matchwait

PUTTOOL:
pause 0.5
match PUTTOOL ...wait
#match PUTTOOL You reach towards
match RETURN You put your
put put my $0 in my %repairstorage
matchwait

NOTOOL:
echo *** Tool could not be found! ***
exit

EXIT:
gosub PUTTOOL %item1
echo *** All done ***
exit

RETURN:
return