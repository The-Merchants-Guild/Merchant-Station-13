## Low Pop Cultist Documentation by Fantii644

[Changes have been made to the Cultist gamemode in order to fit it into our current Low Pop Format. Should we ever gain a lot more of users, it'll be important to rebalance it back to normal, this documentation is made to explain each change in detail for other coders.]

* **code/__DEFINES/cult.dm**

[Line 13 : MAX_BLOODCHARGE]
It refers to the number of spells one Cultist can have on themselves thank to the spell rune, it is normally **4** but I lowered it down to **3**

[Line 18 : CULT_ASCENDENT]
Originally **0.4**, it means the ration of cultist per total crewmembers needed (here, 40%) in order to activate the event where all Cultists get the red halo, I lowered it to **0.3** so that the normal crew can notice cult sooner and take action instead of being wiped too soon

[Line 22 : IRON_TO_CONSTRUCT_SHELL_CONVERSION]
Number of Iron needed to craft Shell Conversion, originally **50**, I figured it would be better to lower it to **25** since in Low Pop, you get less materials unless you go on your way for it.


* **code/modules/antagonists/cult/blood_magic.dm**

[Line 446 : L.Paralyze]
It's the number of seconds the Stun spell will paralyse someone, originally **16**, I found it to be an absurd number. Making it **6** instead will still give a good chance to cuff the victim

[Line 453 : C.silent]
Now it's the number of seconds the Stun spell will mute someone, originally **6**, I lowered it to **3**. However keep in mind that you need to **DOUBLE** that number for the real amount of seconds someone gets muted, meaning that right now it mutes you for 6 seconds, enough for a cultist to remove your headset

[Line 533 : C.silent]
Same as above, but it now affects the Shackle spell. Muting duration lowered from **5** to **2**. (Meaning 4 seconds total, remember, it's doubled)

[Line 780 : temp] 
Now we're into the Blood Rites spell, I turned the temp value from **30** to **60** in order to double the amount of blood acquired. In low pop we'd hardly get a lot of blood spilled

[Line 782 : temp]
Now it gets a bit funky, but the formula shown alters the amount of blood collected, I lowered the divider **800** to **400** in order to double the blood taken in a same fashion as Line 780

[Lines 797 to 844]
This one is a bit special, while not a mechanical change per-se, it's big enough that I should note what I did.
Basically instead of writing the cost down on the uses of Blood Rites (Example : "Blood Beam (500)") I put in the defines stated in (code/__DEFINES/cult.dm__), that way, if we were to change the defines for adjustment, it'll make the final result more clean and making more edits will not be needed. The rest of the lines are removing the backspaces.

* **code/modules/antagonists/cult/runes.dm**

[Lines 480 and 482 : cultist_desc and req_cultists]
The Final Rune needed to win the game, I changed the number of cultists needed to activate it from **9** to **4** (In exchange, I put in a nerf to that rune that will be explained in the later lines), and changing the description in the process

[Line 488 : scribe_delay]
Here comes the nerf to the Final Rune, now it takes **50%** more time to create the rune so that the cultists cannot speedrun a victory without being noticed (unless they really go out on their way)

[Lines 652 and 654 : cultist_desc and req_cultists]
Like the previous rune, I lowered this one rune (Summon Cultist) from needing **2** Cultists to only **1**. Description also changed accordingly. All the runes that requires more than 1 Cultist to operate aside from the Conversion rune will be changed that way.

[Lines 703 and 708 : cultist_desc and req_cultists]
As above, this rune is Boil Blood. Amount of Cultists needed to activate it lowered from **3** to **2**. Description also changed accordingly.

[Line 896 : req_cultists]
As above, this rune is Apocalypse. Amount of Cultists needed to activate it lowered from **3** to **2**. The description didn't need any change as it doesn't mention the amount of Cultists needed