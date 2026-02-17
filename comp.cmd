#pause 3
if_2 then {
	var first %1
	var second %2
}
else {
	var first "Dwarven"
	var second "Angiswaerd"
}

action var music 0 when ^You finish playing.*on your.*\.$

var music 0
var play nocturne
var stop "Angiswaerd"
var comp field guide
var instrument silver txistu
var charts Rat|Croff Pothanit|Heggarangi Frog|Brocket Deer|Scavenger Goblin|Wild Boar|Silver Leucro|Grass Eel|Striped Badger|Blood Dryad|Equine|Blood Nyad|Glutinous Lipopod|Kelpie|Trollkin|Boggle|Cougar|Dwarven|Elothean|Elven|Gnome|Gor'Tog|Halfling|Human|Kaldar|Prydaen|Rakash|S'Kra Mur|Boobrie|Snow Goblin|Thunder Ram|Copperhead Viper|Malodorous Bucca|Dusk Ogre|Young Ogre|Bison|Rock Troll|Sun Vulture|Fire Maiden|Moss Mey|Prereni|Vela'tohr Bloodvine|Peccary|Blue-belly Crocodile|Kashika Serpent|River Caiman|Sluagh|Wood Troll|Gidii|Black Goblin|Granite Gargoyle|Rhoat Moda|River Sprite|Bawdy Swain|Swamp Troll|Heggarangi Boar|Warcat|Blacktip Shark|Piranha|Lanky Grey Lach|Ape|Merrows|Selkie|Geni|Trekhalo|Giant|Bobcat|Snowbeast|Arzumos|Caracal|Firecat|Gryphon|Seordmaor|Bull|Mammoth|Hawk|Armadillo|Shark|La'heke|Angiswaerd|Toad|Elsralael|Celpeze|Spider|Silverfish|Crab|Westanuryn|Dolomar|Warklin|Wasp|Dryad|Fendryad|Sprite|Alfar|Frostweaver|Spriggan|Gremlin|Cyclops|Atik'et|S'lai|Adan'f|Kra'hei|Faenrae|Bear|Barghest|Shalswar|Dyrachis|Poloh'izh|Korograth|Larva|Bizar|Pivuh|Vulture|Unyn|Moruryn|Moth|Kartais|Colepexy|Vykathi|Wyvern|Elpalzi|Xala'shar|
counter set 0
var used 

SETUP:
	if $righthand then {
	 if $righthand != "%comp") then {
		put stow right
	  }
	}
	if $righthand != "%comp" and $lefthand != "%comp" then {
		put get my %comp
		pause
	}
	if $lefthand then {
	 if $lefthand != "%instrument") then {
		put stow left
	  }
	}
	if $lefthand != "%instrument" and $righthand!= "%instrument" then {
		put get my %instrument
		pause
	}	
	put open my %comp
	pause

FINDFIRST:
	eval chart element("%charts", %c)
	if toupper(%chart) = toupper(%first) then {
		var first %c
		counter set 0
		GOTO FINDSECOND
	}
	if %chart = %stop then {
		echo *** Could not find chart "%first" in textbook!
		exit
	}
	counter add 1
	GOTO FINDFIRST

FINDSECOND:
	eval chart element("%charts", %c)
	if toupper(%chart) = toupper(%second) then {		
		if %c < %first then {
			var second %first
			var first %c
		}
		else {
			var second %c
		}
		counter set %first
		evalmath total ((%second - %first)+1)
		GOTO TURNTO
	}
	if %chart = %stop then {
		echo *** Could not find chart "%second" in textbook!
		exit
	}
	counter add 1
	GOTO FINDSECOND
	
TURNTO:
	if contains("%used", "%c") then GOTO INCREMENT
	eval chart element("%charts", %c)
	if contains("%chart", " ") then {
		if not contains("Heggarangi boar|Blood Nyad|Blood Dryad|River Caiman|River Sprite|Fire Sprite", "%chart") then {
			eval chart substring("%chart", 0, indexof("%chart", " ")
		}
	}
	put turn my %comp to %chart
	match STUDY You turn to
	match TURNTO ...wait
	matchwait

INCREMENT:
	if $Empathy.LearningRate = 34 then goto DONE
	counter add 1
	if %c > %second then goto RESTART
	GOTO TURNTO
	
CATCH:
	var used %used|%c
	echo %used
	GOTO INCREMENT
	
RESTART:
    counter set %first
	eval check count("%used", "|")	
	if %check = %total then {
		goto NOMORE
	}
	GOTO TURNTO
	
STUDY:
        if %music = 0 then gosub MUSIC
	put study my %comp
	match STUDY ...wait
	match INCREMENT You begin
	match INCREMENT You continue
	match CATCH moment of clarity
	match INCREMENT You attempt to
	match CATCH Why do you need
	matchwait

MUSIC:  
        var music 1
        pause 0.2
        match MUSIC ...wait
        match MUSIC Sorry,
        match RETURN You begin
        match RETURN You struggle
        match RETURN You fumble
        put play %play
        matchwait

RETURN:
        return

DONE:
echo *** Scholarship locked, yay. ***
exit

NOMORE:
echo *** All designated pages completed. ***
exit