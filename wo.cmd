if_5 GOTO ASK
echo *** usage:  .wo master hard tailor "knitted sweater" 4
exit

ASK:
pause 0.05
match ASK ...wait
match ASK Sorry, you may
match GONE To whom are
match TEST You seem to recall
matchre DONE this is an order for\s?(a|an|some|a pair of)? %4. I need %5
put ask %1 for %2 %3 work
matchwait

GONE:
echo *** Master walked off. ***
exit

TEST:
if %found = 1 then GOTO DONE
goto ASK


DONE:
echo *** Got the right workorder, yay.***
exit