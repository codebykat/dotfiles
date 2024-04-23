function oblique -d "Get an oblique strategy"
	echo -n '💁🏻 '
	set -l lines (echo "Abandon desire
Abandon normal instructions
Accept advice
Adding on
A line has two sides
Allow an easement (an easement is the abandonment of a stricture)
Always give yourself credit for having more than personality
Always the first steps 🚶
Ask people to work against their better judgement
Ask your body
Assemble some of the elements in a group and treat the group
A very small object — Its centre
Balance the consistency principle with the inconsistency principle ⚖️
Be dirty
Be extravagant 💎
Be less critical
Be less critical more often
Breathe more deeply
Bridges -build -burn 🔥
Cascades
Change instrument roles
Change ambiguities to specifics
Change nothing and continue consistently
Change specifics to ambiguities
Children -speaking -singing
Cluster analysis
Consider different fading systems
Consult other sources -promising -unpromising
Consider transitions
Convert a melodic element into a rhythmic element
Courage!
Cut a vital connection ✂️
Decorate, decorate ✨
Destroy nothing; Destroy the most important thing 🔥
Discard an axiom
Disciplined self-indulgence
Discover your formulas and abandon them
Display your talent
Distort time
Do nothing for as long as possible
Don't avoid what is easy
Don't break the silence 🙊
Don't stress one thing more than another
Do something boring
Do something sudden, destructive and unpredictable 🔨
Do the last thing first
Do the washing up ✨
Do the words need changing?
Do we need holes? 🕳️
Emphasize differences
Emphasize the flaws
Faced with a choice, do both
Feed the recording back out of the medium
Fill every beat with something
Find a safe part and use it as an anchor ⚓
From nothing to more than nothing 📈
Get your neck massaged
Ghost echoes 👻
Give the game away ♟️
Give way to your worst impulse
Go outside. Shut the door. 🚪
Go slowly all the way round the outside
Go to an extreme, come part way back
How would someone else do it?
How would you have done it?
Idiot glee (?)
Imagine the piece as a set of disconnected events
Infinitesimal gradations
Intentions -nobility of -humility of -credibility of
In total darkness, or in a very large room, very quietly
Into the impossible 🚀
Is it finished?
Is the intonation correct? 👂
Is something missing?
Is the style right?
It is simply a matter of work
It is quite possible (after all)
Just carry on 💪
Left channel, right channel, centre channel
Listen to the quiet voice
Look at the order in which you do things
Lost in useless territory
Lowest common denominator
Magnify the most difficult details 🔍
Make a blank valuable by putting it in an exquisite frame 🎨
Make an exhaustive list of everything you might do and do the last thing on the list
Make it more sensual 🦵
Make what's perfect more human 🤖
Mechanicalise something idiosyncratic 🤖
Move towards the unimportant
Mute and continue 🔇
Not building a wall; making a brick 🧱
Once the search has begun, something will be found
Only a part, not the whole
Only one element of each kind
(Organic) machinery
Overtly resist change
Pae White's non-blank graphic metacard
Pay attention to distractions
Put in earplugs 🎧
Question the heroic 🦸
Remember quiet evenings
Remove a restriction
Remove the middle, extend the edges
Repetition is a form of change
Retrace your steps 👣
Revaluation (a warm feeling)
Reverse
Short circuit (example; a man eating peas with the idea that they will improve his virility shovels them straight into his lap)
Simple Subtraction
Slow preparation, fast execution
State the problem as clearly as possible
Take a break 🌴
Take away the elements in order of apparent non-importance
Take away the important parts
Tape your mouth 🙊
The inconsistency principle
The most easily forgotten thing is the most important
The tape is now the music
Think -inside the work -outside the work
Think of the radio 📻
Tidy up 🧹
Trust in the you of now
Try faking it
🙃 uʍop ǝpısdn ʇı uɹnʇ
Twist the spine
Use an old idea
Use an unacceptable colour
Use clichés
Use fewer notes
Use filters
Use something nearby as a model
Use 'unqualified' people
Use your own ideas 💡
Voice your suspicions 🗣️
Water 💦
What are the sections sections of? Imagine a caterpillar moving 🐛
What context would look right?
What is the simplest solution?
What is the reality of the situation?
What mistakes did you make last time?
What to increase? What to reduce? What to maintain?
What were you really thinking about just now?
What wouldn't you do?
What would your closest friend do?
When is it for?
Where is the edge?
Which parts can be grouped?
Work at a different speed
Would anyone want it?
You are an engineer
You can only make one dot at a time
Your mistake was a hidden intention" | string collect)

	set -x strategy (echo -e -n $lines | awk 'BEGIN{srand()}{rand()*NR<1&&l=$0}END{print l}')
	if test "$TERM_PROGRAM" = "iTerm.app"
		iterm2_set_user_var currentStrategy $strategy
	end

	echo $strategy
end
