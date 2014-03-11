anysolution :-
	consult('triangleboard'),
	write('Enter size of base (sportjump size is 9): '),
	read(Base),
	
	write('Type "S". to use preconstructed sport jump, "C". to create your own board, "T". to have a triangle board created '),
	read(User),
	(User =:= "S"->
		sportjump(Triangle)
	;User =:= "C" ->
		write('Remember to include padding!'),nl,
		usermakes2dboard([],0,Triangle)
	;maketri(0,1,Base,[],Triangle,1)
	),
	write('Enter peg # to be the initial empty hole: '),
	read(Hole),
	Basewpadding is Base+(Base-1),
	setpegfirst(Hole,0,Triangle,[],Starttriangle),
	write('Starting Triangle'),nl,
	write2dtri(Starttriangle,Basewpadding,0),nl,
	     %number of pegs in triangle
	pegcount(Starttriangle,0,Numbpegs),
	write('Please wait, this may take a while'),nl,!,
	solve(Numbpegs,Starttriangle,Basewpadding,[Starttriangle],Finaltriangle,Solutionsteplist),
	write('SOLVED'),nl,
	showsolutions(Solutionsteplist,Basewpadding).
	
allsolutions :-
	consult('triangleboard'),
	write('Enter size of base (sportjump size is 9): '),
	read(Base),
	write('Type "S". to use preconstructed sport jump, "C". to create your own board, "T". to have a triangle board created '),
	read(User),
	(User =:= "S"->
		sportjump(Triangle)
	;User =:= "C" ->
		write('Remember to include padding!'),nl,
		usermakes2dboard([],0,Triangle)
	;maketri(0,1,Base,[],Triangle,1)
	),
	write('Enter peg # to be the initial empty hole: '),
	read(Hole),
	Basewpadding is Base+(Base-1),
	setpegfirst(Hole,0,Triangle,[],Starttriangle),
	write('Starting Triangle'),nl,
	write2dtri(Starttriangle,Basewpadding,0),nl,
	     %number of pegs in triangle
	pegcount(Starttriangle,0,Numbpegs),
	write('Please wait, this WILL take a while to show them all'),nl,!,
	solve(Numbpegs,Starttriangle,Basewpadding,[Starttriangle],Finaltriangle,Solutionsteplist),
	write2dtri(Finaltriangle,Basewpadding,0),nl,
	fail.
	
invertedsolution :-
	consult('triangleboard'),
	write('Enter size of base (Note:anything less than 5 is impossible): '),
	read(Base),
	maketri(0,1,Base,[],Triangle,1),
	write('Enter peg # to be the initial empty hole: '),
	read(Hole),
	Basewpadding is Base+(Base-1),
	setpegfirst(Hole,0,Triangle,[],Starttriangle),
	write('Starting Triangle'),nl,
	write2dtri(Starttriangle,Basewpadding,0),nl,
	     %number of pegs in triangle
	pegcount(Starttriangle,0,Numbpegs),
	write('Please wait, this WILL take a while'),nl,
	
	maketri(0,1,Base,[],OTriangle,0),
	setpegfirst(Hole,1,OTriangle,[],ZTriangle),!,
	
	solve(Numbpegs,Starttriangle,Basewpadding,[Starttriangle],FinaltriSolution,Steps),

	ZTriangle = FinaltriSolution,
	write('SOLVED'),nl,
	showsolutions(Steps,Basewpadding).
	
pegsleft :-
	consult('triangleboard'),
	write('Enter size of base: '),
	read(Base),
	maketri(0,1,Base,[],Triangle,1),
	write('Enter peg # to be the initial empty hole: '),
	read(Hole),
	Basewpadding is Base+(Base-1),
	setpegfirst(Hole,0,Triangle,[],Starttriangle),
	write('Starting Triangle'),nl,
	write2dtri(Starttriangle,Basewpadding,0),nl,
	     %number of pegs in triangle
	pegcount(Starttriangle,0,Numbpegs),
	write('How many pegs do you want remaining? '),
	read(Remaining),
	Remaining > 0, Remaining =< Numbpegs,
	Numbpegsacountforremaing is Numbpegs-(Remaining-1),
	write('Please wait, this may take a while'),nl,!,
	solve(Numbpegsacountforremaing,Starttriangle,Basewpadding,[Starttriangle],Finaltriangle,Solutionsteplist),
	
	findall(X,pegat(X,Finaltriangle),Xlist),
	trytojump(Xlist,Basewpadding,Finaltriangle).
	

trytojump([],Base,T) :- write2dtri(T,Base,0).
trytojump([X|Rest],Base,Triangle) :-
	\+canjumpknowx(1,Triangle,Base,X,Y,Z,0),
	\+canjumpknowx(2,Triangle,Base,X,Y,Z,0),
	\+canjumpknowx(3,Triangle,Base,X,Y,Z,0),
	\+canjumpknowx(4,Triangle,Base,X,Y,Z,0),
	\+canjumpknowx(5,Triangle,Base,X,Y,Z,0),
	\+canjumpknowx(6,Triangle,Base,X,Y,Z,0),
	\+canjumpknowx(7,Triangle,Base,X,Y,Z,0),
	\+canjumpknowx(8,Triangle,Base,X,Y,Z,0),
	trytojump(Rest,Base,Triangle).
	
	
	
solve(1,_,Base,[Resulttri|Solutionsteps],Resulttri,[Resulttri|Solutionsteps]).
	
solve(Pegsleft,Starttriangle,Base,Solution,Finsolution,Solutionsteps) :-
	canjump(Starttriangle,Base,Newboard),
		%write2dtri(Newboard,Base,0),nl,
	P is Pegsleft-1,
		%write('1 jump down'),nl,
		%get0(_),
	solve(P,Newboard,Base,[Newboard|Solution],Finsolution,Solutionsteps).
	
canjump(Board,Base,Newboard) :-
		%write2dtri(Board,Base,0),nl,
	pegat(X,Board),%Get 1d position of starting peg
		%XR is truncate(X/Base),
		%XC is mod(X,Base),
		%write('*Starting peg: ' + XR),write(' '),write(XC),nl,
	canjumpknowx(1,Board,Base,X,Y,Z,0),%start going a direction, 1st direction
		%write('***GOT THEM*** Peg X: ' + X + ' Y:' + Y + ' Z:' +Z),nl,
		%get0(_),
	setpeg(X,0,Board,[],Newboard1),
	setpeg(Y,0,Newboard1,[],Newboard2),
	setpeg(Z,1,Newboard2,[],Newboard).


canjumpknowx(_,_,_,_,_,_,1).%NEED A BASE CASE BECAUSE CANJUMP IS RECURSIVE

canjumpknowx(Directionnum,Board,Base,X,Y,Z,Quit) :-	

	Directionnum < 9,

 		%write('direction # ' +Directionnum),nl,
 		
	getrowandcol(Directionnum,Board,Base,X,Row,Col,Row3,Col3),%for direction, create row and col for Y and Z

	goto2dindex(Board,Base,Row,Col,0,0,Peg),%get peg at position for Y
	goto2dindex(Board,Base,Row3,Col3,0,0,Peg3),%get peg at Z
	
	(Peg = 1, Peg3 = 0 ->
		Y is Row*Base+Col,
		Z is Row3*Base+Col3,
		NowQuit is 1
	;NowQuit is 0
	),

	Directionnump is Directionnum+1,

	canjumpknowx(Directionnump,Board,Base,X,Y,Z,NowQuit).	
	

getrowandcol(Directionunum,Board,Base,X,RowFin,ColFin,Row3Fin,Col3Fin) :-%find the 2d position given direction(have to offset by amount),and x position
	(
	Directionunum = 1 ->%TOP LEFT
		Rowoff is -1,
		Coloff is -1,
		Row3o is -2,
		Col3o is -2
	;Directionunum = 2 ->%TOP Right
		Rowoff is -1,
		Coloff is 1,
		Row3o is -2,
		Col3o is 2
	;Directionunum = 3 ->%Same LEFT
		Rowoff is 0,
		Coloff is -2,
		Row3o is 0,
		Col3o is -4
	;Directionunum = 4 ->%SAME RIGHT
		Rowoff is 0,
		Coloff is 2,
		Row3o is 0,
		Col3o is 4
	;Directionunum = 5 ->%BOTTOM LEFT
		Rowoff is 1,
		Coloff is -1,
		Row3o is 2,
		Col3o is -2
	;Directionunum = 6 ->%BOTTOM RIGHT
		Rowoff is 1,
		Coloff is 1,
		Row3o is 2,
		Col3o is 2
	;Directionunum = 7 ->%Top CENTER
		Rowoff is -1,
		Coloff is 0,
		Row3o is -2,
		Col3o is 0
	;Directionunum = 8 ->%BOTTOM Center
		Rowoff is 1,
		Coloff is 0,
		Row3o is 2,
		Col3o is 0
	),
	
	%if going off board, return the same index as x peg so that canjump will fail
	listcount(Board,Max),
	Maxrow is truncate(Max/Base)-1,
	Maxcol is Base-1,
	Directionnump is Directionunum+1,
	
	Row is truncate(X/Base)+Rowoff,
		%write(Row),write(' '),
	Col is mod(X,Base)+Coloff,
		%write(Col),write(' '),
	Row3 is truncate(X/Base)+Row3o,
		%write(Row3),write(' '),
	Col3 is mod(X,Base)+Col3o,
		%write(Col3),write(' '),nl,

	(
	Row3 > Maxrow -> RowFin is Row-Rowoff, ColFin is Col-Coloff, Row3Fin is Row3-Row3o, Col3Fin is Col3-Col3o
	;Row3 < 0 -> RowFin is Row-Rowoff, ColFin is Col-Coloff, Row3Fin is Row3-Row3o, Col3Fin is Col3-Col3o
	;Col3 > Maxcol -> RowFin is Row-Rowoff, ColFin is Col-Coloff, Row3Fin is Row3-Row3o, Col3Fin is Col3-Col3o
	;Col3 < 0 -> RowFin is Row-Rowoff, ColFin is Col-Coloff, Row3Fin is Row3-Row3o, Col3Fin is Col3-Col3o
	;RowFin is Row, ColFin is Col, Row3Fin is Row3, Col3Fin is Col3
	).

showsolutions([],_).
showsolutions([Solution|Solutionss],Base) :-
		write2dtri(Solution,Base,0),nl,
		write('Press enter to continue'),
		get0(_),
		showsolutions(Solutionss,Base).
		
		
listcount([],0).
listcount([_|Tail],Length) :- 
			listcount(Tail,TailLength),
			Length is TailLength+1.


pegcount([],Length,Length).
pegcount([Head|Tail],Length,Count) :- 
			(Head = 1 ->
				Lengthn is Length+1,
				pegcount(Tail,Lengthn,Count)
			;pegcount(Tail,Length,Count)
			).
