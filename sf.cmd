#script debug 10
pause 1
var startroom 1
if_1 var startroom %1
var next_room %startroom

if $season != "winter" && $season != "summer" && $season != "spring" && $season != "fall" then put time
pause 1

GOTO AUTOMOVE

PERCROOM:
pause 0.5
match PERCROOM ...wait
match PERCROOM You clear your mind and begin searching the area for
match PERCROOM You scour the area looking for hints of sigil lore patterned upon the ground.
match PERCROOM Left and right you crane your head to observe the intricacies of your surroundings.
match PERCROOM Back and forth you walk through the area while taking note of its more unique aspects.
match PERCROOM You close your eyes and turn to a random direction.  Quickly opening them, you hunt for previously-hidden details in the area.
match PERCROOM Eddies in the water catch your eye.  You get closer to study them in more detail.
match PERCROOM Whorls of dust upon the ground catch your eye.  You get closer to study them in more detail.
match PERCROOM The ceiling holds your interest and you wander about scanning it for sigil clues.
match PERCROOM The sky holds your interest and you wander about scanning it for sigil clues.
match AUTOMOVE You recall having already identified
match AUTOMOVE Having recently been searched, this area contains no traces of sigils.
match AUTOMOVE You wisely decide against that, not wishing to disturb the sanctity of this place.
match AUTOMOVE This is not an appropriate place for that.
put perceive sigil
matchwait

AUTOMOVE:
put #GOTO %next_room
var attempt 1
pause 3
AUTOMOVE1:
if %attempt > 4 then GOTO FAILED
if "$scriptlist" != "sf" then {
    pause 5
    math attempt add 1
    goto AUTOMOVE1
}
else {
    math next_room add 1
}
GOTO PERCROOM

FAILED:
echo *** Movement failed, exiting. ***
exit