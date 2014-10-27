So, I defined some of the data that I'll need, but I still have some work to do. 
I've defined the data for the primary view, and for the point view. Now it's time to define the data required for each axis. 

For the X-axis view, I'll be showing some data for a single game. The number of pieces after each move, and the difference in the number of pieces between the players. 

I haven't really thought much about what should happen when hovering on a axis view. I suppose hovering on an x-axis view should show a point view. There should be a translucent vertical line on the display, and you should be able to hover over each line to see the relevant point value. 

Then, for a y-axis view, I guess it should just show some numeric data relevant to the histogram bar being hovered over. Also, it might be good to show two distributions: one for total points, and one for difference in points. Perhaps the distribution of advantages should be in a subset plot in the corner of the main plot. 
Given this design, what's next? 
I'll need to define the data for each one. 

So, for the X-axis view, I'll be displaying the number of pieces for each game, and the difference in pieces. 

At this point, it's also worth noting that pieces aren't a good measure of advantage. It's rather the total value of the pieces. Since each piece has a value, and the queen is worth more than a pawn, it's worth taking these points into consideration, rather than the pieces themselves. 

In any case, this is the data that's needed (representing a single game: 
{
	nPointsWhite: [],
	nPointsBlack: []
}

For the y-axis view, the following data will be required: 

{
	nGamesWithPoints: {nPoints: nGames} <- key=nPoints (e.g. 23), value = nGames (e.g. 25 games have 23 points at this move)
	nGamesWithAdvantage: {nPointsAdvantage: nGames} <- key=number of points advantage, value = number of games with that advantage at some move number
}

These two data structures should make it easy to bin things in other ways. The default here is to have a one-point bin, but I'll include a slider or something so larger bins can be accessed easily.

Having defined the data required for each graphic, a few questions are in the air. 
First, how will this data be generated? More specifically, what data will be precomputed, and what data will be computed as the program runs? I'd like to limit the loading time of the page, but the plots need to operate smoothly. I'll have to see how much computation can be done live while still maintaining smooth graphics. 

Ideally, I'd precompute nothing. This would mean I'd only have to load a small amount of data, then use it to generate everything else on the fly. 

Given the amount of data, however, I suspect there are parts of the system that will need to be precomputed. I suppose this issue will only become relevant later on, once the real data has entered the pipeline. 

---
For now, I need to implement each of the small visualizations. I suppose I'll start with the distribution plot. The structure of this application is interesting, and might be well-suited by noFlo (rather than React), since I really have separate graphs which should recompute as their data changes. Since I know React, I'll probably stick with it for now though. 

What needs to happen next? 

I need to create a simple dataset with my desired properties, then plot it with D3.js. At the very start, I'll make the graph work with only a single dataset, then I'll make sure it can handle transitions well (between two datasets.)Over the course of this hour, I'll try to do the following: 
1. Specify the types and ranges of data input to the Y-Axis chart. 
2. Find d3.js example with the right form
3. Make up some data of the right form
4. Try to put new data into the example chart

So, to start off, I determined that the data inputs to the Y-Axis chart is: 

For the y-axis view, the following data will be required: 
{
	nGamesWithPoints: {nPoints: nGames},
	nGamesWithAdvantage: {nPointsAdvantage: nGames}
}

This data has the following properties. 

nGamesWithPoints: 
key=nPoints (e.g. 23), value = nGames (e.g. 25 games have 23 points at this move)

Since there are 39 points for each player, there will be 78 total points possible in any given game. In fact, this will be a common key because every game starts with 78 points. 

The number associated with each key may be as high as T, the total number of games under consideration. 

So, there are up to 78 (positive) integer keys, with value up to (positive)integer N.

nGamesWithAdvantage: 
key=number of points advantage, value = number of games with that advantage at some move number

It's a bit more difficult to define the range of advantages. As a worst case, one player could have all their pieces but the king, and the other player could have all their pieces. In this case, the advantage would be +39 (if white had the advantage). Since I need to refer to both positive and negative advantages, and no advantage, there could be up to 79 keys, each with an associated value with max value T.

This will help to define the axes as well. 

The x and y axes will be: 
x: npoints  [78,0] 
y: percent games [0,100]

I may want to change the point scale to refer to percentage of pieces. 

# D3 example 

Having defined the form of the data, it's time to find an example to work with. I just need a bar chart, as far as I can tell. 

[This](http://alignedleft.com/tutorials/d3/making-a-bar-chart) is a good example. 
[This](http://tonygarcia.me/slides/d3chartintro/#example10) Is much more impressive, actually. 

[This](http://bl.ocks.org/Caged/6476579) is good for adding tooltips.# I'm trying to mock up the data for the distribution chart. What should I use? 

I don't quite know what data structure to use. 

My confusion arose from my desire to include all the moves in a single data structure. That's not quite right. I'll be displaying one chart for a given move number. So, I'd choose, say, move 21, and all games that were at least 21 moves long would be included in the analysis. Then I'd check all the games and increment a counter for each number of points. 

I'm still a bit confused now. I think it's possible to put together a nice algorithm which creates all the distributions in one go, without having to traverse games more than once. 

First, I'll take a game. On the first move, it should have a total of 78 points (I'll deal with the advantage counter later.). 

I'll have a list called moveDists which will be as long as the longest game. The first element of this list will hold the distribution of points for all games' first moves. I'm iterating by game, rather than by move (and repeatedly calling up different games). So, I'll iterate through the first game in the following way. 

- Move 1, Game had 78 points. 
  Get moveDists, edit first element, lookup or create key corresponding to 78, increment value for this key. 

I'll need to work out a few kinks in the algorithm. First, should I initialize the moveDists list with a length equal to the number of moves in the longest game? Should I add keys corresponding to every point value up to 78? I think both of these things make for nicer looking code, so I'll create the full data structure to start. In this hour, I'll try to use the data I generated in Python to create a D3.js bar chart. I found a good example of a bar chart, so I'll try to change out the data and see if I can get the example to work. 

example: http://tonygarcia.me/slides/d3chartintro/#example10

My four subproblems for the hour include the following: 
1. Identify what needs to be changed in the D3 example to suit my needs
2. Read the presentation on the visualization
3. Attempt to alter one part of the visualization
4. Attempt a static version of the plot

---
Changes:
 d3.csv -> d3.json

Primary questions: 
How do I get data into the visualization?
How do I make elements interactive?
How do I style the chart? 

---
1. Set dimensions of SVG
I'll want to make my charts responsive, but to start, I'll just hardcode some values here. 

2. Create SVG element
In this case, you'll need to select a tag (the example uses the body tag), then add a child SVG element, then you actually set attributes like dimensions.

3. Load data
The has three parts: getting a particular file, making any necessary changes to dataset, then creating the chart when the data is ready. 

---
The first problem I'll need to solve is getting my data into the proper format. 
Right now, I have a JSON file with a data structure of this form:

file: [moveDist]
moveDist: [nGames]
nPoints: Int
nGames: Int

In words, I have a list where each element corresponds to a move in a game. So, the first element shows the distribution of point across the first move of all games. 

The chart will only ever show the distribution for a single move, so the first thing I'll need to do is just take the first element of my array and use that. 
I think I've got the data in the right format now, but I've still got some debugging to do. 

For the next hour, I'll try: 
1. Debug and read docs
2. Style the chart
3. Try to make chart dynamic
4. Finish making chart dynamic

---
Right now, there seems to be a bug where D3 is trying to map over an object, but this can only be done with lists. I can try to iterate differently, or, more appropriate, I suspect - I can change the data representation. It probably should be a list in any case. Originally, I'd intended to make a sort of sparse array, but, since I initialized all the keys, there really wasn't much point in doing that. 

---
I have changed the data to use a list, rather than a dictionary, but I have yet to produce the right format. I'm now producing a single list of values. I'd like to represent key-value pairs of (nPoints, nGames). Right now, the list I've produced shows nPoints, as the index in the list. So, it looks like I'll need to either output a different list in Python or do a bit of preprocessing in Javascript. Which should I do? I'll try a bit of preprocessing first. I'm still debugging my code. The d3.json call seems to be giving me some trouble. 

Though it's listed with an optional second parameter, it doesn't seem to be working. 
In looking at the source, it seems that there's only a call for 2 parameters.

---
I've just gotten the data to work. I suspect that d3 handles data best as a list of objects, each with some associated properties. The object should contain, for instance, it's labels and coordinates. 

In any case, now that I've got some data showing, what's my next step? 

What are the next problems? 
1. Fix x labels - there are far too many
2. Add axis labels
3. Change fonts to raleway or open sans
4. Fix position and size of bar labels
5. Add control for bin size
6. Make chart square
7. Change color to blue-black

There are lots of problems to work on. One potential course of action is to use D3's histogram-displaying functionality. Let me come up with three types of things to change here. 

1. Interactivity - moves & bin sizes
2. Style - fonts, colors, transitions, layout, lines
3. Content - axes, labels, tooltips

The first thing I'll do is get the interactivity working. The most important feature to implement is the interactive playing through each move. 

It might also be cool to try to create a smoother, curve-fitted version of the distribution which can be overlaid on the bars. 

What needs to happen to implement the move-selector? 
The first thing is to add a slider. I think D3 provides a slider, so I'll try it out. Once I can show a slider's output, I'll need to reanimate the graphic with new data. This will be the main challenge. I'm getting progressively more uncomfortable with D3.js and the verbosity required to express my graphics. I think I'll solve this issue with the interactivity, but then I'll consider rewriting the project in Elm. 

Unexpectedly, and (so far) inexplicably, I can only access event data if I define a callback within the event call. I cannot call a handler. I suspect this is due to some error in the implementation of the D3 slider. It seems to be working alright for now, but I'll switch it to Jquery at some point. 

This code is becoming intolerably ugly. I'd really like to redo this stuff in Elm, but I'm very wary of its typesystem, and by how feature-poor it is. I think I should write a post about how I would design a system to visualize data. I think that I should reread what Bret Victor has to say about the matter. I'm finding myself very frustrated by the way I'm having to write things. 

---
In any case, I've got a working slider now. I should be able to use the value it outputs to select the index of the move distribution I want to show. 
Having setup the slider to work, I'll need to prepare the dataset to function properly. Or, more accurately, prepare the render function to display only the part of the dataset specified by the slider.I'd like to see if Elm can ease my pain. I'll try to reimplement the same graphic there, and perhaps even make it nicer. 

So, here's the hour plan:
1. Try to build a bar chart
2. Discuss the design issues for an Elm-based data visualization
3. Continue trying to build basic bar chart
4. Try to base visualization on user input somehow. 


---
One of the first things to do is set up the position of each bar. It's not so straightforward to define the position of each bar without iteration. So, I suspect I'll have to use recursion. 

To recurse through a list, and keep track of the index, something like the following might work. 

createBars list barwidth index = 
	first bar :: rest of bars

the first bar will be something like: 
filled red (rect barwidth (head list)) |> move (index * barwidth,0)

the the rest of bars will be something like: 
createBars (tail list) barwidth (index + 1)

and there will need to be a stopping condition: 

here's the example from the elm documentation: 

case xs of
  hd::tl -> Just (hd,tl)
  []     -> Nothing

case n of
  0 -> 1
  1 -> 1
  _ -> fib (n-1) + fib (n-2)

In my case, I'll need to do something like:

case list of
	[] -> []
	head::tail -> stuff


The type of the function also needs to be determined. 

The arguments are List, Int, and Int
The output is [Form]

So the type declaration is List -> Int -> Int -> [Form]

So, I think I have everything I need to implement the function: 

createbars: List -> Int -> Int -> [Form]
createbars list barWidth i = 
	case list of
		[] -> []
		head::tail -> 
			let firstBar = filled red (rect barwidth head) |> move (index * barwidth, 0)
				restBars = createBars tail barwidth (index + 1)
			in	
				first :: rest 

This is the entire file I've got so far: 

myData = [10,20,30,40,50,60]

---=------------

config = {
  h = 400, 
  w = 400
  }


main = barchart myData config

--main = asText myData

barchart dataset config = 
  let c = config
      barWidth = c.w // (length dataset)
  in collage c.w c.h (createBars dataset barWidth 0)
  
createBars: [number] -> number -> number -> [Form]
createBars list barWidth i = 
  case list of
    [] -> []
    head::tail -> 
      let firstBar = filled red (rect barWidth head) |> move (i * barWidth - , (head / 2))
          restBars = createBars tail barWidth (i + 1) 
      in firstBar :: restBars

------------------I've now got a bar chart being rendered in my graphic, but I need to fix it up a bit, since the the first bar starts in the center of the collage, rather than at the left edge. 

I'll group all the bars together and move the entire group left by: 
 0.5 * collageWidth - barWidth

I've now got a working bar chart, though it's not using any interesting data or anything. 

Perhaps I can get the data into the system now. 

There are a few more tasks to complete with Elm: 

Incorporate my mockup chess data into the visualization. 
Make the chart respond to user input. 


To get the Javascript data working, I'll need to create some ports. 

First, the Elm side will look something like this 

module BarChart where

port dataset : Signal [number]

port move : Signal number
port move = (Mouse.position - (Window.width // 2)) // 200

I'll try to start off by simple making up a few data points in JavaScript, and then showing them in Elm. 


I'm now starting my first hour of data science practice. I'll start by asking myself the basic questions in The First 20 Hours. 

1. Choose a lovable project. 
I'm interested in data visualization, so I'd like to learn to make data come alive, in some sense. I've tried to use some tools in the past, but I haven't been able to make the graphics I'd like to. Interactive data visualizations offer a great way to explore large data sets. In other words, I've tried to learn things in this field, and have succeeded to a degree, but it still takes me a long time to make mediocre visualizations. 

2. Focus your energy on one skill at a time. 
I've often gotten distracted by other projects. For instance, I'm likely to be distracted by learning about chess or artificial intelligence. For the moment, I'll have to silence these urges and focus solely on data visualization. 

3. Define your target performance level. 
I've seen some of Bret Victor's work, and I've really enjoyed it. I've tried to make some things like it, but have not created anything nearly as nice. I'd like to be able to create things as good (or better!?) than displayed in his Ladder of Abstraction post, but do it very quickly. Let's say, I'd like to be able to take a data set or algorithm, and create a visualization of Bret Victor's quality in a single hour. Right now, it seems like it might take me twenty hours. (Or at least feel like 20 hours.)

4. Deconstruct the skills into subskills. 
Perhaps I could break data visualization into a few subskills: 
Data acquisition, data analysis, visualization design, styling, debugging, deployment, sharing, static images, dynamic imagery. 

At some level, you've got a lot of data, and you'd like to take user feedback to explore it. Among the problems faced in data visualization is obtaining good data, second is managing user feedback effectively, and lastly, one should be able to deploy the graphic. 

So, for now, I'll say there are three subtasks: 
 - Obtain and manage data
 - Design visualization (interfaces and interactions and goals)
 - Implementing a visualization

5. Obtain important tools. 
What tools are important when it comes to data visualization? 
There might be a few books on the matter, but there are also a number of programming tools which should be installed. I suspect that D3.js and its variants should be installed, along with matplotlib, perhaps. I'm not sure what other tools are required. There will presumably be some need to research this. 

6. Eliminate barriers to practice. 
The major barriers to practice are probably impromptu conversations, email checking, and zulip-conversing. Avoiding each of these things throughout each practice period is probably a prerequisite for success. 

7. Make dedicated time for practice. 
This shouldn't be too hard, since I plan to spend my entire waking day at Hacker School working on these things. There should be time (hopefully) to practice for around 8-10 hours. I don't know whether it will be possible to focus this long on a subject in a useful way, but I will certainly find out. 

8. Create fast feedback loops
This may require some help from other HSers that have had more experience with data visualization. Besides that, there will just be a problem of investing in a good programming setup, or design process for graphics. For instance, it might be a good idea to mock up a graphic before coding it up. It might also be possible to improve my coding setup to automate common tasks. 

9. Practice by the clock in short bursts. 
Right now, I'm planning on using one-hour periods to focus on a project, but I could split that up further and instead practice ever smaller skills.

When it comes to each subproblem in data visualization, I think I could identify several ways to practice it. For instance, I might practice obtaining data by taking ten minutes to download as much data as possible about chess moves or bird migrations or whatever. I could repeat this process multiple times over the course of an hour to become ever faster at finding and getting data into a usable form. 

Right now, I'm sort of failing in this respect. I'm not imposing any short-term structure on my practice, other than constraining the period to an hour. I should probably break each period into 15-minute chunks from now on. 

10. Emphasize quantity and speed. 
Given the parable of the clay pots (the more pots you make, the better they turn out to be), I understand I should focus on trying to visualize as many things as possible.  Perhaps I should also note that not all visualizations need be dynamic. I actually think I'll constrain all my project to be dynamic visualizations, but I may limit the scope in the beginning. Therefore, I could require that I use only a short period, or only a small dataset, or only a small portion of a visualization library. It's easy to limit the scope of a project, though it may be difficult to stay within the predefined scope you choose. 

How can I motivate myself to produce as many cycles of trial and error as possible? 

One way would be to aim for a record, or to aim to create a repository with as many examples as possible. 

I'm really not sure how to motivate myself to focus on speed and quantity. Perhaps I should again limit the scope of the entire project, and take the Bruce Lee advice of 'practicing one kick a thousand times'. If I could choose only three skills to practice, which ones would they be? Getting data, plotting it dynamically, and making the result beautiful. I really do want my work to be beautiful. Therefore, I need to practice that, because it's often a time-consuming part of my work. I'm often very quick when it comes to designing a visualization. 

11. (From Tim Ferris) Have stakes that depend on your skills. The stakes in this case are simply. Tomorrow, you'll give a talk on how to produce awesome, interactive visualizations. You WILL give a talk on the subject, and the talk will be crappy if you fail to keep focused. Therefore, it's imperative that you maintain focus on the goal of maximizing the speed of development. 

---- Learning (not skill-building)
1. Research the skill and related topics. 
I've found some good resources in Bret Victor's work (and Randall Munroe's), and I know there are many more great ways to learn to visualize data. 

2. Jump in over your head. 
According to this principle, I should try reading about visualizations that are very complex, or perhaps be reading the source code of such visualizations. In other words, if you aren't in a high state of confusion, then you aren't moving fast enough. This isn't to say you should maintain yourself in a state of constant frustration, but only that you should constantly be learning. 

3. Identify analogies
Craft analogies for how data visualizations work, or how the design process works.

4. Imagine the opposite of what you want. 
This is easy. I would hate to be able to produce only static, crappy-looking visualizations of small datasets that nevertheless take a long time to build. 

5. Talk to practitioners to set expectations. 
I'm not sure what to do here. I know of Victor's work, and what is possible, so I don't think I want to settle for less.

6. Eliminate distractions. 
7. Use spaced repetition for memorization. 
It's a useful idea -> you should be able to recite by memory the top strategies for visualizing data. You should be able to recall the most important things about each subskill -> How to get data (the sites involved, or programs used to handle data), designing visualizations (the type of interactions that are common, the types of visualizations), implementing the graphics (libraries, apis, methods, build tools, editors). 

8. Create scaffolds and checklists and cheatsheats
Encode as much information as possible in as pithy a form as possible. Make it difficult to forget or leave out important steps. Make notes of common errors, pitfalls, and timewasters. Create scaffolds so it's easy to start new projects. 
9. Make and test predictions. 
It's a good idea to make clear, falsifiable predictions, then seek to falsify them. With regard to graphics, it might be good to form theories about what types of graphics are most useful. 

10. Honor your biology. 
Take advantage of the normal ebb and flow of energy throughout the day. Eat in a healthy way, work out to increase energy. Try to get into good shape so you can think more effectively. Also make sure to take breaks in a useful way. 

-----
Next Steps
-----

One possibility for the next few hours is to try practicing each of the three subtasks: 

1. Getting data and exploring it
2. Designing visualizations
3. Implementing visualizations
(4.) Styling visualizations

I'll take the next hour to focus on each of these for 15 minutes. During that time, I'll explore some blogs if necessary to answer my questions. 

I'll get a head start right now by asking some basic questions about each of these subproblems. 

1. Getting data and exploring it. 
	What are the difficulties involved in getting data? 
	 - sometimes data will be in odd formats that are difficult to work with. 
	 - some datasets might be too large to work with in a flat file
2. Designing visualizations
 	What kinds of visualizations should you consider making? 
 	What kinds of visualizations have you found useful? 
 	 - Perhaps I should focus on creating a small set of visualizations. 
 	If you could only create one kind of visualization, what would it be? 
 	 - ladder of abstraction for sure - the final graph - area/color/axis/point/lower-level display
3. Implementing visualizations
	What tools are relevant? 
	What tools are hardest to learn? 
	Is it obvious which tools are best?
	What are you looking for in you tools? 
	What is the pipeline from raw data to launched graphics
4. Styling
	What are the primary time-consumers for visualizations? 
	What are the common mistakes? 
	 - spacing, whitespace, sizing, lines placement, subtle graphical features, interactive elements, speed, code clarity
I'm going to analyze each of the four subproblems now. 

# To start off with, I'll address the problem of getting data. 
What are the problems involved? What is the worst case scenario? 
 - I suppose the worst case scenario is that the data to solve a problem is unavailable. 
What are the subskills in obtaining useful data? 
 - I can think of three basic ways to obtain data: scraping, apis, downloads
Should I try to learn and practice each of these techniques? 
 - Not scraping (for now at least). That just seems painful, error-prone, and nasty. For now, I'd be happy to focus purely on downloaded data. I'd be open to working with an API to get data at some point, but not until I'm comfortable with downloaded data. 
Having found that your data exists and can be downloaded, what other problems might pop up? 
 - Perhaps the format of the data is difficult to use. What are the formats in which data are most often available? 

 ---
 After trying to find and download some useful chess data, I found my approach was flawed. First, I didn't know what data I was looking for. There are millions of games of chess. Which ones are relevant to you? Perhaps it would be good to focus on recent tournaments. I might want to consider a single event, or a single person. My hazy mental model when looking for data was, "all of it?". 

 Also, I'm not sure what form of data I want. I'm at least familiar with CSV files and the like, but I don't quite know what I'm looking for. I'll need something to eventually be represented as JSON, probably. 

# Next, I'll concern myself with the problem of designing a visualization. 
 What are the main problems of visualization design? 
  - Data is used to criticize, and thus corroborate a theory. 
  - What are the theories? 
 Should you know what theories you're forming before designing a visualization? 
 Perhaps it's best to identify a class of theories, that are rendered testable with a given design. Is it possible to test the dependence of a trend on time, or some other factor, or not? 

 Perhaps it's best to try to construct the reach of a graphic - the class of theories it can falsify or contradict. 

 What are the three questions when designing a visualization? 
  - What problem does this visualization solve? 
  - What interactions should be available? 
  - How should the visualization be deployed? 

 Let me try to design a visualization. 
 It will be about chess. 

 First, what aspect of chess would you like to explore? 
  - I'd like to explore pawn structures
 What types of theories would you like to explore? 
  - Frequency of certain structures in games with particular openings
  - Combinations of pawn structures
  - Complementary (black/white) pawn structures
  - Historical variation in pawn structures
  - small/large pawn structures
 What types of requirements do these classes of theories impose on the visualization? 
  - Presence of pawn structure information in vis. data
  - Data on opening types
  - Total num. of games, and count of each types of structure
  - -
  - There must be a way to distinguish different openings
  - There must be a way to distinguish frequency of structures
  - Relationships among structures (on a side and between sides)

It's worth noting that there's a good deal of work in generating all the data (or metadata) to falsify this large class of theories. 

Second, I'll have to limit the space of falsifiable theories I'm addressing in a visualization. 

# Third, I want to address the implementation of a visualization. 
What are the problems here? 
 - historically, I've created lots of plots in matlab and python, using Matplotlib, but these plots aren't dynamic. 
 - To make dynamic plots, I've learned javascript, and I've at least heard of D3.js
 - I've also used react to structure client-side data flows

How can I make the process of implementing a visualization as easy as possible? 
 - It may be possible to create a DSL for a particular type of visualization. 
 - It's clear that you could create a library to implement a small class of visualizations. It's less clear what progress might be made with regard to general visualizations. 
 - I should settle on a good set of tools and automate their use. 

Let's say you decide that, in the next hour, you're going to create a dynamic vis. where you display this data over time, and allow a user to hover over a particular point to see how much was spent on something at a given time. 

 - Presumably, I'd have a CSV file to start. I'd begin by converting this to JSON in Python. Then, I'd either hardcode this data into a javascript file, or separate it and GET it from within a Clientside JS script. 
 - Once the data was available, I'd use it to create a chart using D3.js
 - The hardest part, or the one that now consumes my attention, is the creation of user controls like sliders and such, and the making of a beautiful front-end. (I'll cover this in the next part, though. )
 - Really, the hardest part will be using D3.js to display the data in a sensible, if ugly way. 
 - It might also be a slight pain to set up my development environment to get quick feedback. For instance, I'll likely have to remind myself how to use yeoman or grunt compile coffeescript and so on. I might also benefit from using other languages and just compiling to JS. 
 - In the end, it's just a pain to have to use HTML, CSS, and JS, so perhaps I could use Elm to make dynamic visualizations easier. 
 - It's worth considering if Elm would be useful in creating Bret Victor's stuff. 

# Lastly, what are the subskills involved with making graphs beautiful? 
 There are a few ways to segment everything. Perhaps the first is graphic design, HTML/CSS, color schemes, tone of the visualization, presence of text, type of interactions, transitions, Jquery. 

 Perhaps I'll be able to use GSS finally, so as to ease the process of styling my documents. 

 I might also create some programs to scaffold my starting a project. 

 Suppose you're given a working visualization, perhaps like Victor's graph visualization of chess moves. How would you turn it into a professional-looking app?

 - First, I'd create a mockup, then I'd visualize the types of interactions I'd like to see, then I'd try to implement these ideas in CSS and javascript. 
 - one common problem that I've yet to address is the use of transitions with React or Elm. It's not at all clear how to manage these nice graphical features in an unusual sort of program structure. 

 Perhaps I should focus on understanding what makes graphics beautiful and a joy to use. Maybe I should be thinking about clarity, or the use of subtle explanations of how a graphic works. For instance, a transition can be used to show connections between certain elements, and could be really useful in helping explain, implicitly, how to use an interactive visualization. 

 Phrases differently, your design should clearly explain itself in subtle ways. Bad operations should be impossible and hard-to-phrase. The right operations should be plain to see. You might try limiting yourself to having only 5 or 10 words on a visualization (at a time). 

 What other subproblems are there? 
  - There general graphic design - like color schemes, ratios, spacing, curves, bezier polynomials, prototyping tools, quickly converting mockups to actual stylesheets. 

----
All told, I've now tried to give some thought to four subproblems of data visualization. I've tried to find further subproblems within each of these, and I've tried to identify the holes in my knowledge. 

What's the next step? 
From here, it's natural to move on to getting data for an hour. Perhaps it would be worth reading a blog post. What is the best case scenario? The best case scenario would be the instantaneous availability of any source of data, in any format. The closer I can get to that ideal, the better. This may involve finding what sources of data are easiest to use, or what questions to ask when looking for a data set. 

I'll structure my next hour as follows: 
1. Read a blog post on how to find data
2. Try to download several chess datasets (must be one or more games, from any source)
3. Having found a few datasets, try to do something interesting with them - load into Python and try to display subsets, find patterns, or create simple plots
4. Try to find and download a large chess dataset. Notes: 
1. Consider redesigning PGN, and providing compelling reasons to switch. 
2. (Unrelated) Learn Colemak keyboard layout

Today, I aim to spend 8 hours building my skills in data visualization. I'm not quite sure how to spend my time. Should I try to immediately complete one data visualization problem, or should I instead practice each subskill individually multiple times? For now, I'll opt for the latter. There is a risk, however, in that I may ignore important details that will only become clear when I try to complete an entire data-visualization problem. 

In any case, I'll spend the next few hours doing such things at building skill with D3.js, file formats, and design questions and concerns. 

To start, I'll try to get a chess dataset. The first time I tried, I found this difficult. This was partly because I wasn't sure what I was looking for. This time around, I'll look for Magnus Carlsen's games. I'll count this period a success if I can get 20 of his games on my computer and loaded into Python. 

The skills I'm trying to practice here are: 
 1. Finding data 
 2. Making (simple) use of it
---
I've now got some data. Next, I'll need to see if I can find a library to parse the PGNs that I've found. It might be a good exercise to create the parsing myself, but I'll avoid that for now. 
---
It turns out there are [major problems](http://zuttobenkyou.wordpress.com/2012/01/27/problems-with-the-portable-game-notation-pgn-standard/) with the PGN standard, so it may be a worthwhile project to redesign it and provide a great source of games for others to download. It would be an interesting project to put together at some point. 
---
Anyhow, I'll need to limit my distractions, and just find a python library that can grab pgns and do something useful with them. 
---
It was easy enough to download a python library, but it doesn't seem to recognize all the games in my file. Perhaps I'll have to rearrange it. 

What's the next step? I could read about the general problems of dealing with data, or I could just try to solve the latest problem - getting all the data represented and ready for use. 

What should my first use of the data be? One thing which might be useful is to print out the final FEN for each game. That is, every games should be downloaded, and I should have a FEN string that denotes board position after the last move of each game. Notes: 
1. potential blog post: queries and theories (a question dictates the theories that could serve as answers.)

My goal in this hour is to practice the design process for a visualization 

Here are a few questions to ask: 
What class of theories should your visualization render falsifiable/corroborable? 
How will the vis be deployed?
Who is the vis for? 
How will the vis be implemented? 
Who is the audience for the vis? 
What is the objective of the vis? 
Is there a particular theory the vis should corroborate?
Is the vis for purely entertainment value? 
What are the problems that might be present in the vis? 
What interactions should be allowed in the vis? 
How can you make it easy to falsify theories in the falsifiable class? 
How can you minimize the falsification time? 
How could you incorporate statistical knowledge into the graphics? 

If I had to choose three questions, what might I pick? 
- What theories do you wish to falsify? 
- What is the falsifying data for each theory?
- How can theories be falsified most quickly?

When you show a chart, and you explore a data set, what you're doing is noting the data that is available. Let's say there's a stock price vs. time chart. Once you see the axes, you're able to start forming theories which include changes in stock price over time. If specific dates are available, then you can begin to form theories that relate the stock price to other events in a chronological way. 

What are the subproblems involved in designing a graphic? 
What sort of activities have you normally engaged in? 
 - I'll often create a mockup in Inkscape, perhaps preceded by a pen-and-paper set of sketches. I'll also visualize the sort of interactions that should be possible. 

So, what does that mean for your project? 
The design process should require answering the three questions above, and drawing out some of the ideas on paper and in a vector graphics editor. The starting point is conceptual, and the end point is visual. 

----
Therefore, let me apply this process to chess. 

To start, what theories do I want to falsify? What questions would I like to answer?
 - I've chosen, after speaking with Margo, to investigate the use of pawn structures in chess games. I only have the following theories right now: 
 1. Pawn structure is important
 2. Pawn structure can be found by analyzing FENs of a games. 
 3. Pawn structures of past games might inform how one should play
 - One sort of theory might involve the repercussions or consequences of a pawn structure. For instance, once can ask about closed vs. open games, and how this affects something simply, perhaps, like game length. In this case, the falsifiable theories take the form: (Open/Closed) games are usually longer. I'll take this as the first and only relevant theory to start. 

Now, what is the falsifying data for this theory? 

The most basic data is the average length of games which are either closed or open. For the purposes here, I'll take open games to be those where central pawns are exchanged in the first ten moves (or something like that). 

At this highest level, I require only one bit: True/False for the theory that closed games are usually longer. 

If I'd like more insight, I can dig a bit deeper, and compute this value myself by comparing the average length of open and closed games. 

I could go still deeper and examine standard deviation of the game length. 

The distribution of game lengths is also relevant. A histogramm of game lengths for each type could be shown. The mean and standard devation should be shown. Supposing that game length follows a normal distribution, then there should be two distributions, with one's center farther right than the other, displaying the average length of closed games is longer than open ones. 

How can the desired theories be falsified most quickly? 
 - By an automated algorithm, for sure. It might be effective to avoid displaying the original data, and instead shown the results of various ways of assessing game length, open vs. closed positions, and so on. This would allow a much broader view of the game and the method of analysis. 

--- 
This last statement is a bit odd, since it introduces a new set of falsifiable theories. It brings into view the method for assessing the open/closed traits of a game. Presumably the definition of open vs. closed is fuzzy, if not specious. As such, a theory of open/closed positions might be misguided. Instead, it might be better to come up with a metric that addresses the same issues as that distinction, but without a hard classification. This might involve measuring the number of pawns in the center or something like that. 

In this case, it might be that we want to see what predicts game length. So, we'd be testing theories of the form: (Some metric) is correlated with game length. After corroborating some such theory, it would then be the task of an investigator to explain this. 
---
The more I think about this graphic, the more obvious it is that there are many theories which the data could corroborate or falsify, but not all of these are of interest. This opens the question: how do you decide which theories are relevant?

This itself requires a theory of people, and of what they wish to know. When it comes to chess, one needs a theory of what would help someone improve their chess game, or what would be funny or interesting to chess players. 

For instance, take the example of the historical changes in how often certain openings are played. This is of interest for a few reasons. First, it shows that the game of chess is changes. It shows how quickly the game changes. It also shows how the games changes. (If the chart was unlabeled, you'd know it changed, but not how or when.) The volatility in popularity among openings is also available in the chart. It's surprising how many theories one might corroborate given a data set. The set is infinite, really, but I suspect a more discriminating view of this set could be made. 

One question I have in mind is: Which theories are worth testing? Which theories/questions are more important? Note that a question presents one with a class of theories that could serve as answers. I'm a bit interested now in the connection between queries and theories. 

---
The other question I have in mind is this: how does interactivity relate to testability? 

I think that user input allows for a wider range of testable theories. That may be it. With user input, you can provide a means of testing many more theories and allowing the user to select which ones they'd like to test. 

If this is true, then what's the point of having a single, dynamic visualization, rather than having many static ones? Presumably, the user will only ever really see a single image at a time, so one could just lay out all the possible images and allow the user to scroll through them.

In some sense, a dynamic visualization just provides users with a way to navigate the many individual images available. But, it does more than that. It also embodies a theory of which comparisons and relationships are important. 

The dynamic elements in a vis. are like an axis in a plot. They provide an orderly way to view information. 

A dynamic vis also takes advantage of the human mind's ability to see change. A collection of static images must be displayed in a very special way to allow this machinery to work. 

---
In other words, most (if not all) relevant theories are testable with collections of static images, but not quickly. The primary advantage of dynamic visualizations is speed. For a given class of theories, it can best be explored with a dynamic visualization. 

Is that true though? Where a single image suffices, why add anything else? If a single bit is all that's required, then what's the point of additional sliders and inputs? 

I think that, where a single theory is being tested, simple displays are best. But, when many different theories are being tested (especially when some depend on others), it's best to provide a way to navigate the space of images and falsifying data quickly. 

---
What have I learned here? 
 - I've clarified the role of a graphic, and argued for interactive graphics.
What's next? 
 - With regard to the design of a visualization, I think I still have some work to do. I'm really not sure what I want to include. 
Is it necessary to figure that all out right now? 
 - If it isn't, then I may as well continue to mocking up the thing. 
I could spend the next hour finishing the conceptual design of the graphic, and then create an inkscape mockup of the vis. 

An alternative is to move on to the implementation of graphics. I think this is a really hard problem, so I should probably move on to it directly. 

---
Notes: 
1. It may be good to start each hour with an explicit goal (e.g. Find three libraries worth knowing for the project.)
2. I should redesign the cover for D3.js tips and tricks

What do I wish to accomplish during this hour? 
 - I'd like to select the tools for the job. 
I think I know which languages and tools I'll need: 
 1. Coffeescript (To easily produce javascript for web)
 2. Grunt (To compile Coffeescript easily and automatically)
 3. D3.js (To create SVG visualizations from data)
 4. (Probably not for now, but...) Mathbox (such awesome 3D graphics)
 5. HTML/CSS
 6. GSS (avoid use of css, and take advantage of new, better layout method)
 7. React (for creating components and managing updates with user feedback)
 8. Elm (great user input handling)

I suspect I'm leaving some things out here, but this is probably enough to get started. What's next? I'm least-familiar with D3.js, but I'm not all that competent with the other tools. I also don't know much about GSS.

So, there are potentially 7 practice topics. With my limited time, I'll choose to work on three subskills here.
 1. GSS
 2. D3.js
 3. React

Perhaps the main problem is using these tools together. I'm not sure. In any case, I'll spend a few minutes on D3.js first. I'll deconstruct the learning of D3 into three further subskills. 

I suspect it will be something like: 
 1. creating shapes
 2. handling user input
 3. making things look nice

---
I'm a bit stuck at the moment. Some distraction and tiredness have reached me. 
What's next? I'm a bit worried that I'm spending all my time on research, and not doing anythind useful regarding the actual skill I'm trying to build. 
---
I think the hardest, and most rewarding thing will be to master some uses of D3. Perhaps I can select three things I'd like to practive in D3. For instance, there might be a few kinds of charts that I'm likely to use. If I'm trying to just replicate the Bret Victor charts, then it's clear what kind of things I'll need. Let's see here. I'd like to deconstruct Bret Victor's visualization in The Ladder of Abstraction. 

I'll try to deconstruct it in four ways:
 1. Concepts
 2. Data
 3. Graphical elements
 4. Interactions

# Concepts - what theories can be corroborated/falsified by the graphic?
 1. (Sharper|wider) turning rules produce longer paths.
I'm having a hard time thinking in terms of theories. For now, I'll take a look at something simpler. What types of data are present, and what relationships are made visible?

# Types of data:
 1. Turning radius of controller
 2. Bend radius of road
 3. Path time
 4. Car paths
 
Relationships:
 1. Path time / bend radius / turn radius
 2. Path / turn radius (over all bends)
 3. Path / bend radius (over all turns)
 4. Path / turn radius / bend radius

So, there are four types of data, and four ways of showing it. Theories inexpressible in these terms are not falsifiable with this visualization. For example, one could not have a theory that referenced even these variables, but outside the tested range, like "Turning rates above 90 are unstable."

The visualization could be improved in a number of ways. First, a larger sample of turning rates and bend angles might be produced. There should also be some way to denote those paths which never reach the end of the road. It seems like this simulation limited the running time of each and simply displayed that limit for many trials, even though some combinations of road bend and control angle led to unstable paths. 

Another issue is that one should be able to click on a point, then have the secondary path plot persist. This would allow a user to control time and see the car follow the path. 

It's also a bit difficult to visualize the turning radius. I don't know the step size of the simulation, so seeing 6.1 degrees/step doesn't help much. It would be better to show the turning radius as a circle or arc. 

---
# Graphical elements
What graphical elements are present in this visualization? 
 1. Colored quadrangles representing path completion time coordinate:(bend,turn,time)
 2. Axes, labeled with bend and turn info
 3. (On hover) rectangle outline for each point
 4. (On hover) translucent line on axis hover
 5. Road (and transformed road)
 6. Path
 7. Collections of paths
 8. Note on test condition (e.g. turns by x degrees per step)

# Interactions
What interactions are allowed? 
 1. Static
 2. Hover point and move around
 3. Hover axis and move around

Some of these interactions could be improved. For instance you should be able to press a key, or otherwise enter a mode which constrains movement to some line (vertical, horizontal, or user-defined - the line could be arbitrarily shaped.) This would make it easier to explore the chart more systematically. 

---
Having deconstructed his visualization, what's next? 

I could try to imagine doing this with the chess visualization. 

What have I really learned here? 
 - I've learned what makes this graphic work, and even some ways in which it could be improved. I think that, on closer inspection, this graphic is simpler than I originally thought. It's really several different graphics in one. The key is that the different representations are linked and are easier to explore as a result. 

 In this graphic, there are really four entirely autonomous plots that are linked and so provide more information, and allow quicker corroboration than any plots alone. The plots, for instance, make it clear that that there are deficiencies (or at least some unexpected decisions) in how the algorithm was evaluated. This would not be so clear if the charts were entirely separate. 

So, when I think about making graphics like Bret Victor's, I should think in terms of many different displays, each connected somehow. The more graphics, and the more interactions, the better one will be able to test one's theories. 

Anyway, what will my next hour be devoted to? 
Let me lay out a few options: 
1. Design a chess graphic (identify required data and the shown relationships, and do a mockup)
2. Implement something in D3.js
3. read about d3.js

I'm thinking that I'd like to get a good idea what I'd like to implement, and then mock it up. 

So, I'll break up my next hour in the following way:
1. Identify data and relationships
2. Identify displays and interactions
3. Draw out some potential designs
4. Mockup up some designs in inkscapeNotes: 

So, I'll break up my next hour in the following way:
1. Identify data and relationships
2. Identify displays and interactions
3. Draw out some potential designs
4. Mockup up some designs in inkscape

Data and relationships:

What data would I like to present? 
 - Chess moves
 - Patterns in position (pawns, pieces, attacks, whatever)
 - Pieces/positions
 - dates
 - players
 - locations
 - ratings
 - white/black
 - win/loss
 - opening type

There is so much data readily available that it's likely unnecessary to add my own analysis to the data sets, although they'd be more interesting as a result. I think that there is a choice here. There is a tradeoff between the coolness of the end analysis, and the amount of time I can spend working on just the visualization skills. 

In my discussions earlier in the week, I decided to assess pawn structures in games. It should be fairly straightforward to identify those games which have the appropriate structures. 

I don't really know what kind of structures I'm looking for right now. 

But, like Bret Victor's plot, I'll choose four types of data: 
 1. Pawn Structure (which pawn structures were present in a game, and how long they lasted)
 2. Date
 3. white/black
 4. win/loss
 5. Actual moves and positions

Perhaps I should assess the changes of pawn structure throughout a game. 
For now, I've settled on using Magnus Carlsen's games to create my visualization.

Relationships: 
1. Pawn structures / black or white
2. Pawn structures / date
3. Pawn structures / win or loss
4. Pawn structures / date / win or loss
5. Positions / pawn structures

Primary questions: 
Which pawn structures are most common? 
Which are most effective?
How have the preferred pawn structures changed over time?
What are the preferred structures as white or black?

These ideas are hazy and poorly thought out so far. How can I make them clearer? 
What will the main, 3-dimension plot be? 
 - Pawn structures / date / win loss
If this is the main plot, what form will it take? Which will be the axes, and which will be the color? 
 - Date and pawn structure will be the axes / win-loss-draw will be the color.
What will happen as you hover over the plot? 
 - You'll be selecting a particular game
 ---
 Again, I've gotten a bit tired and distracted. I'll take a break and rest for a bit. 

Notes: 

I've had some trouble mocking up my graphic, or even deciding what it should consist of. 

I'll split this hour into four parts:
1. Diagnosing and correcting the failure to make progress in the last hour
2. Carefully design the concepts in the visualization 
3. Lay out (on paper) some designs for the vis
4. Mockup up the vis in inkscape

After this hour, I'll spend some time preparing a talk for some other hackerschoolers.

# Diagnosing the problem
In the previous hour, I wan't able to really make any hard decisions. I first thought that I'd identify the pawn structures in a game, and that I could leave the specifics for later. But, I felt uncomfortable with that and thought I might do better with a display of point values over the course of a game. For instance, I could have a plot for a single game which showed which side had an advantage, as well as how many pieces (or points) were on the board. 

Really, any of these can be made to work. The problem is that I have yet to state the criteria I am trying to satisfy in this decision. The problem is that the variable shown in Bret Victor's chart are continuous and can be finely sampled. If I have only historical data to work with, they might be very scattered. It's not at all clear whether I'll be able to make a smooth graph live Victor's. In any case, the problem is this: I'd like to model my visualization on Victor's, but my dataset is different. I'm trying to determine which features of Victor's chart I should keep, and which I don't mind changing. 

For instance, if I choose to look at the number of pieces on the board at one time or another, what will that tell me? 

In this case, I have two major questions: 
 1. Should I care about the number of pieces on the board? What sort of theories does this corroborate?
 2. How would I should this? 

In the last period, I failed to make these questions explicit, and simply succumbed to doubt and confusion. Most of my stress, discomfort, and failure is the result of failing to make problems explicit, and of failing to deconstruct them into smaller problems. 

# Designing the visualization
Let's take the idea of pieces on the board for a moment. There are a number of related ideas, like simply marking events where pieces are taken. There are also questions one might have about which pieces are taken. Another point of interest might be which pieces are taken when are certain type of opening is played. 

There are other features of interest as well. Perhaps I could take a look at open files or, again, at pawn structures. There are several problems here. I'm unfamiliar with many of these chess concepts (at least to the point of giving a clear, codeable description). I'm also not sure how I'd like to display them. 

Another question I have about the design of my graphic is whether the time axis should be binned. In other words, should each game have its own column, or should games of the same year, say, share a column? I suspect I'll need to bin things. 

The criteria I'm trying to satisfy include filling the entire graphic with data. I don't want to leave white space, but I'm not quite sure what to do. 

Let me think up a few different ways to address the question of pieces throughout a game. 

First I'll ask a few questions:
What is relevant about the number of pieces on the board in a game? 
 - The number of points available is very important in determining the strength of a player's potential attacks and defenses. 
 - As a long term goal, it would be impressive to create a tool to analyze board position in a very cheap way, much like a human might, which rivalled the performance of far more expensive techniques. 

So, the most basic purpose for including the number of pieces on the board throughout a game is that is can assess who is winning, and the type of position being played. This sort of thing would allow one to determine who started an attack, who was winning, and the pace of the game. 

How might you show this sort of thing? 
- The most straightforward plot is of piece values vs. move number. You'd start off with three lines. One for black's points, one for white's points, and one for the total. The total would be used to assess the game as a whole, and the individual's lines would be used to assess advantage. 

Another, slightly different way to pursue the same sort of questions is to represent the advantage of one player like a chess engine does - if white is winning, then the line is positive. If everything is equal then the line is at zero. In this case, there would be only two lines: an advantage indicator, and an indicator of how much firepower remains on the board. 

What else is relevant here? 
Though I hesitate to choose this option, I suspect it would be interesting to show how games progress relative to the opening that was used. 

What else might be done? 
---

So, though I've been more explicit in my deliberations, I haven't settled on a good visualization design. 

Let me quickly brainstorms some of the questions I'd like to answer with this data visualization. 

How do Magnus Carlsen's games progress? 
Do they end quickly? 
How often does Carlsen lose an advantage? 
How often is Carlsen able to win from a losing position? 
Is there a wide variance in how quickly a game winds down? 
What is the classification for the different parts of the game? 
Could I identify the length of the opening, middlegame, and endgame using this method? 
How much material is still on the board at the end of the game? 


This last question admits of an interesting visualization. One way to view it is to show a histogram of how many pieces are one the board at each move. 

I think that there would be something like a wave-packet spreading as time goes on. It should be possible to show a distribution of the number of pieces on the board. At first, every game would have a sharp value corresponding to all the pieces being present. Many games would end with far fewer pieces. 

One could have a slider that does one of two things. First, it might simply scroll through moves and show the distribution of pieces at each move. Another option is to normalize the games to a period from 0 to 1, and scroll through this instead. 

I like this visualization very much. My concern now is whether this should be the main frame, or a subsidiary one. My inclination is to make it a secondary plot, since it changes and isn't very data-dense. I'd prefer to create a full-bodies two-axis+color plot as the primary element in the graphic. 

What could serve this purpose? Presumably one of the axes in this case would be move number (either actual or normalized). What would the other axis be? How might I use the outcome of the game here? I could use it as the color, as discussed earlier. This coloring would really only apply to the outcome of games, though, and I plan to show each move in a game. What would the other axis be though? Might it be the date? In this case, I'd have a grid where columns represent individual games in chronological order, and the rows represent moves. 

In this case, you'd have several ways to look at the chart. First, you'd have a view where the total number of pieces on the board was represented by color, and there would be rows for moves and columns for games. 

You could hover over a move to show the game's position. You could click on it to play that game. There might also be a static (starting point) visual showing which pieces remain on the board. So, you'd see the actual board, as well as all the starting pieces which remain on the board. 

You could hover over a point on the move axis to show a distribution of the # of pieces for that move. 

You could hover over a point on the chronological game axis to show a single game and the plots I mentioned earlier -> 1. Advantage line and 2. Firepower line. Hovering over a particular point on a game should Notes:

I've gotten my project mocked up, so now it's time to mock up the data, and then use it to create a mock visualization. After this is complete, I should be able to complete the analysis for my actual data set. 

So, what data do I need, and what format should it be in? 
 - In the end, I think I'll want everything in JSON, so I'll make that my format of choice. 

As a reminder, I'll have a bunch of different representations of my data. 

There will be perhaps five representations: 
1. Moves | # Pieces | Games (ordered chronologically)
2. # Pieces | % Games
3. Moves | # Pieces & Advantage
4. Board position
5. Original board position, w/ currently-present pieces.

Organized by interaction, there are: 
1. The primary view
2. The point view (hover on a single point, corresponding to a move)
3. X-axis view (corresponding to a game)
4. Y-axis view (corresponding to a move #)

All told, there are five images that need to be created. 

I'll focus just on the first for now. 

I'll need something like the following format: 
I need three pieces of information: 
 x: date (sort of, since I'll just be ordering by the date, not defining position with it.)
 y: move number
 c: number of pieces

With a list containing the number of pieces on the board after each move, both the move number and nPieces data will be available. All that's needed after that is the date. 

{
	games: 
		[
			{
				nPieces: [], <- # of pieces after each move
				date: 14034800
			}
		]
}

Next, I'll need the data for the point view. In this case, I'll be displaying some game information, along with the board position, and a display of which pieces are still present on the board (shown from the initial configuration.)

So, now I'll need the metadata, board positions, the move that was played, and the set of pieces that was present. Some of these may be calculated, and others held in memory. I'm not sure how this should be done yet, but I'll figure it out.

{
	games: 
		[
			{
				meta: 
					{ 
						white: player,
						black: player
						result: 
						whiteElo:
						blackElo:
						ECO: <- opening (perhaps I could provide links to the appropriate openings)
					}
				moves: [], <- PGN or other (perhaps better) notation
				positions: [], <- FEN, probably
				piecePositions: {A1:A1} <- key=original position, value=current position (after move)
			}
		]
}
