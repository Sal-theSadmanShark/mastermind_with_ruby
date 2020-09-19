# mastermind_with_ruby
a command line version of mastermind
made by salim sadman

<pre>
Thoughts:

This the longest code i've written so far . It contains 3 files of more than 100 lines of code . I took an object oriented approach . The aim was the decrease dependencies among files and ease up the debugging process . The end product was easier to debug and it was a lot cleaner than my other projects . I used a modified version of Donald Knuth's five-guess algorith for the bot . I took my time while writing this and it took me well over a week to finish it properly


Code description:

made 3 files named core, players and main.

core.rb
	has the `Core` class -
	 keeep track secret code / color sequence
	 has the compare method to show the similarities of each guess
	 has the input converter to convert human and bot inputs 
	 keep track of turns rounds and player points
	 has no external dependencies
players.rb
	has the `Players` parent class -
	 takes and filters player inputs according to player id
	 takes and filters player secret code input according to player id
	has the `Human` child class - 
	 takes the human inputs with gets and verifies them
	has the `Bot` child class-
	 bot only works with  integers
	 this has external dependencies (the similarities between guess and secret code)
	 makes a random guess for setting the secret code
	 uses the stored similarities value to calculate guess between turns -
	 	1. make a set S conatining values from 1111 to 6666
	 	2. play 1234 as the initial guess in the first turn
	 	3. check for whites(correct num wrong position) and colors(correct number and position)
	 	4. remove all the elements from S , which wouldn't score the same num of whites and colors if compared to 	the last guess . (1234 if this is the 2nd turn)
	 	5. use the first element of  modified S as the new guess
	 	6. if the guess hasn't matched , repeat step 4. until it does
Main.rb
	has no classes
	maintains the control flow of the game
	makes objects according to player inputs
	maintains the bot dependencies
	checks for game end
</pre>




