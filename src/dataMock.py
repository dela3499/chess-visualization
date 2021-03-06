import random
import numpy
import json

def saturate (x, minimum, maximum):
	if x < minimum:
		return minimum
	elif x > maximum:
		return maximum
	else:
		return x

def pointsTaken ():	
	aggressiveness = random.choice([0,5])
	piecesToLose = random.choice([0] * 10 + [1,3] * aggressiveness)
	return piecesToLose

# Bar Chart - distribution of games with different levels of material

def getData (nGames):
	"Return arbitrary distribution of material for N games, for each move"
	"Return list of games, where elements show total number of points on the board "

	# Simulate the number pieces in gameplay
	games = [simulateGame() for x in range(nGames)]
	# Find length of longest game
	longestGameLength = max([len(game["nWhitePoints"]) for game in games])
	
	# Initialize data structure to hold all the distributions
	moveDists = [[0]*79 for move in range(longestGameLength)]
	nPointsByGame = []

	# Iterate through each move of each game, and increment counters
	for game in games:
		
		# Prepare the point counters (the points for black and white will be summed shortly)
		nPoints = zip(game["nWhitePoints"],game["nBlackPoints"])
		nPointsTotal = []
		
		# Iterate through game, finding the total number of points on the board after each move, and incrementing counter
		for move, points in enumerate(nPoints):
			totalPoints = points[0] + points[1]
			nPointsTotal.append(totalPoints)
			moveDists[move][totalPoints] += 1

		# Add game to list of games (each games is just a list of nPieces after each move)
		nPointsByGame.append(nPointsTotal)

	return {"moveDists": moveDists, "nPointsByGame": nPointsByGame}

def simulateGame ():
	"""Return a list of integers representing 
	the amount of material on the board for each player"""

	# Randomly set length of game
	gameLength = random.randint(20,40)
	
	# Randomly assign winner
	gameWinner = random.choice(["white","black","draw"])

	# Set up the board 
	nWhitePoints = [39]
	nBlackPoints = [39]

	# Play game by randomly taking pieces
	for move in range(gameLength-1):
		w = nWhitePoints[move] # current number of pieces
		b = nBlackPoints[move]
		nWhitePoints.append(w - pointsTaken())
		nBlackPoints.append(b - pointsTaken())

	return {"nWhitePoints": nWhitePoints, "nBlackPoints": nBlackPoints}

nGames = 100

def mockupDistribution (nGames): 
	x = getData (nGames)
	with open('data.json', 'w') as outfile:
		json.dump(x,outfile) 

mockupDistribution(nGames)