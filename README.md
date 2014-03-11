Peg-solitaire-solver
====================

Peg solitaire solver in Prolog that solves any shaped board, and can output inverted solutions and failure solutions

The biggest thing in here is the creation of the canjump method, which, using the getrowandcol method, checks for jumpable positions on the board.  The solve method calls canjump with the direction variable as 1. The canjump then sends the direction variable to getrowandcol, which has hardcoded offset 2d values for each 8 directions. It then returns the 2d positions with the offsets for the asked direction, but if the row or col are off the board, it returns the 2d row and col of the current X peg position, because that will fail the rest of canjump. Else, can jump takes the row and col for both the Y peg and Z peg, and uses the 2dindexfinder method to find the peg at that position. If the Y peg is 1 and the Z peg is 0, the program changes a quit variable to 1, otherwise it leaves it 0. It then recuses with the next direction. If the quit is 1, it reaches the base case and exits with the Y and Z positions converted into 1d form, otherwise it recuses into the next direction.  
Next, using the 1d X, Y and Z positions solve changes each of those positions on the board to 0, 0 and 1 respectively to simulate the jump, and recuses with the new board and the old board stored in a list, and 1 removed from the pegs on board count. Once this count reaches 1 (1 peg left on the board), it has found a solution and takes the list of all previous boards, and outputs each one, requiring the user to press enter to show the next.   
  
For allsolutions, it nearly identical, except at the end it only shows the final (solution) board it got, then fails, and solves the board again until no more solutions are possible.  
  
For inverted solution it’s the same as anysolution, except before trying to solve the triangle the invert triangle is constructed with all 0's instead of 1, and a 1 where the original board's zero is. Solve is then called, and once it has solved the triangle the inverted triangle has to match the outputted solution triangle. If it doesn’t it fails and solve tries again.
