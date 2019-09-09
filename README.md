Generate A Room (Start with a square box of X by Y dimensions)
Store Room in a table with Dimensions
Display room (1 pixel = 1 ascii char) Need to use monospace font
Create a Game Table
Game Table has attributes for turn time, amounts of turns (enemy foreign key, player foreign key)
Create and Insert Enemies and Player

Player has one health. Goal is to defeat all enemies.
Since player moves first you must carefully choose where to move.
Spawn in 4-5 random enemies at random locations w/ random directions?

Timer/Turns displayed at top, goal is to clear as fast as possible.

Functions:

GameEngine
Menu()
	Start()
	Exit()
While (Ruby.time every 1 second)
	Move()
		MakePlayerMove()
			Collision?()
		MakeEnemy()
			Collision?()
	EndGame?()
		Won?()
			WinScreen()
			Start()/Menu()
		Lost?()
			LoseScreen()
			GameOver()/Restart()/EndGame()
		Continue
GameScreen()
				DrawMap()
				DrawCharacters()
	Input()
		Gets.strip().last()
End


Collisions:
Map should be handled as a giant hash filled with 0’s for empty or an Object.
Possible objects are walls, players, and enemies
If a player moves into a wall, they remain where they are.
If a player moves into an enemy, and that enemy has no more health, the player moves into the spot and the enemy is deleted.
If the enemy has more than one health, the player remains in the same spot and the enemies health is decreased.
If the enemy moves into a wall, their direction is changed according to type.
If the enemy moves into another enemy, they pause and wait a turn.
If the enemy moves into the player, the game is over.
Walls do not move ;)

Player:
@ = Player

Walls:
- : Top or Bottom Wall
| : Left or Right Wall

Enemies:
BlobL = ‘L’
Moves left until hits object, then right. Needs to know its direction
BlobU = ‘U’
Moves up until hits object, then down. Needs to know its direction
Gobby = ‘%’
Moves diagonally until it hits an object, then reflects diagonally. Needs to know its direction
Big Slime = ‘O’ to ‘o’ 
Moves every other turn towards the player (if diagonal choose a random value). Needs to know health 
Swirl =  ‘#’‘
Moves in a square shape. Needs to know direction, i.e. clockwise (Bool)
Controls:
‘S’,’R’ = start/restart
‘Quit’/’exit’/’Q’ = quit
‘H’ = left
‘J’ = down
‘K’ = up
‘L’ = left

Stretch Goals:
Add more levels
Create random terrain
Spawn enemies in random places
Add more types of enemies
Difficulty Settings
Start and End Screens
Endless mode (spawn more and more enemies over time)
Add color?
Find a way to sync BPM and start playing a song when game starts
Add a music file to the database that is played/restarted when game starts/ends
Character Designer: Pick your color and symbol
Character Class: Can move twice, Has extra health, Moves in L shape
Difficulty: Amount of Enemies, Size of Room, Time Per Turn

