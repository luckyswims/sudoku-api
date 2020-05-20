# Lucky's Sudoku

This application generates Sudoku puzzles that the user can then solve. It also
allows the user to view puzzles they have worked on previously and delete them
from their history. I am a big fan of Sudoku puzzles and so I wanted to try
building an application that could generate those puzzles.

## Setup Steps

1. [Fork and clone](https://github.com/luckyswims/sudoku-api) this repository.
2. Run `bundle` to install all dependencies
3. Use `bin/rails server` to spin up the server.

## Important Links

- [Other Repo](https://github.com/luckyswims/sudoku-client)
- [Deployed API](https://luckyswims-sudoku.herokuapp.com/)
- [Deployed Client](https://luckyswims.github.io/sudoku-client/#/)

## Planning Story

When I started planning out this application, one of the first things I needed
to figure out was how I was going to generate the puzzles. Would I do it in the
frontend or the backend? How would I even go about making a puzzle that was
solvable? How would I make sure there were enough different puzzles?  

The answer to the first question, was that I would generate the puzzle in the
backend. The primary reason I did this was to avoid exposing the method I used
to generate the puzzle to the user. I then worked out how the information would
flow between the frontend and backend. The frontend would request a new puzzle
from the backend. The backend would generate the puzzle and send it to the
frontend. The frontend would then send the users updates to the backend.  

I then needed to figure out how I would generate the puzzles. I started to do
some research on Sudoku puzzles solvability, and constraints. This was when I
learned how challenging generating these puzzle from scratch is. Creating a
Sudoku that is solvable to a unique solution is an NP-complete problem. This
means that while I could check if a given puzzle is valid in a reasonable time,
generating a puzzle that is valid would be much more time consuming.  

While doing some more research into generating Sudoku puzzles, I came across a
[post][1] which provided some great insight. The post explained that you can
generate a large number of visually distinct, valid puzzles by taking a puzzle
you know is valid, and applying certain transformations to it. Based on this
knowledge I was able to build an algorithm for generating puzzles.  

I started by randomly generating and checking boards until I had four valid
seed boards. The algorithm then takes one of those boards at random, and applies
two transformation functions to manipulate the seed. Finally it performs a
character substitution to mix up the starting values, for example it might
replace all of the 1's in the seed with 4's. The algorithm can generate a very
large number of potential puzzles, while still generating each puzzle very quickly.

### User Stories

- As a user I want to be able to sign up  
- As a registered user I want to be able to sign in  
- As a signed in user I want to be able to generate a sudoku board  
- As a signed in user I want to be able to make moves on a generated sudoku board  
- As a returning user I want to be able to see my statistics  

### Technologies Used

- Ruby  
- Ruby on Rails  
- PostgreSQL  

### Catalog of Routes

Verb         |	URI Pattern
------------ | -------------
GET | /games
GET | /games/:id
POST | /games
PATCH | /games/:id
DELETE | /games/:id

### Unsolved Problems

- Still need to prevent users from updating cells that were set by the starting board.
- Still need to check if the user's input is valid
- Still need to check if the user has successfully solved the puzzle
- Would like to eventually allow users to continue working on a puzzle they had started previously

## Images

#### ERD:
![ERD](./data/Sudoku-MVP-ERD)

[1]: https://gamedev.stackexchange.com/questions/56149/how-can-i-generate-sudoku-puzzles
