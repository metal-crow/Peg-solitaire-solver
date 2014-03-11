%is there a peg at point x?
pegat(0,[1|_]).
pegat(Index,[_|Tail]) :- 
	pegat(Indexn,Tail),
  	Index is Indexn+1.

%set a peg at point x
setpeg(0,Peg,[Head|Tail],NewBoard,Final) :- 
	append(NewBoard,[Peg],NewBoardN),
	append(NewBoardN,Tail,NewBoardC),
	Final = NewBoardC.
	%i dont know why i need to use final, and have to set it equal to NewBoardC here instead of NewBoard being the return value, but this works
	
setpeg(Point,Peg,[Head|Tail],NewBoard,Final) :-
	PointN is Point-1,
	append(NewBoard,[Head],NewBoardN),
	setpeg(PointN,Peg,Tail,NewBoardN,Final).


%ignores padding spaces for the first user setpeg prompt
setpegfirst(1,Peg,[Head|Tail],NewBoard,Final) :- 
	(Head = '_' ->
		append(NewBoard,[Head],NewBoardN),
		setpegfirst(1,Peg,Tail,NewBoardN,Final)
	;
	append(NewBoard,[Peg],NewBoardN),
	append(NewBoardN,Tail,NewBoardC),
	Final = NewBoardC
	).

setpegfirst(Point,Peg,[Head|Tail],NewBoard,Final) :-
	(Head = '_' ->
		append(NewBoard,[Head],NewBoardN),
		setpegfirst(Point,Peg,Tail,NewBoardN,Final)
	;
	PointN is Point-1,
	append(NewBoard,[Head],NewBoardN),
	setpegfirst(PointN,Peg,Tail,NewBoardN,Final)
	).


goto2dindex([Head|Tail],_,Row,Col,Row,Col,Head).
goto2dindex([Head|Tail],Base,Row,Col,Pointrow,Pointcol,Fin) :-
	(	
	Pointcol<Base ->
			%write('nextcol: '),
			%write(Head),write(' '),
		Pointcoll is Pointcol+1,
			%write(Pointcoll),nl,
		goto2dindex(Tail,Base,Row,Col,Pointrow,Pointcoll,Fin)
		
	;		%write('nextROW: '),
			%write(Head),write(' '),
		Pointroww is Pointrow+1,
			%write(Pointroww),nl,
		goto2dindex([Head|Tail],Base,Row,Col,Pointroww,0,Fin)
	).
	



write2dtri([],_,_).

write2dtri([Head|Tail],Base,Count) :-
	(
	Count<Base ->
		write(Head),
		CountN is Count+1,
		write2dtri(Tail,Base,CountN)

	;
		nl,
		write2dtri([Head|Tail],Base,0)
	).

writespace(0).
writespace(N) :-
	N>0,
	write('_'),
	NN is N-1,
	writespace(NN).
	


maketri(Base,_,Base,Fin,Fin,_).% :-
	%BwW is Base+(Base-1),
	%write2dtri(Fin,BwW,0),nl,
	%goto2dindex(Fin,BwW,1,2,0,0,X).%indexs start at 0
	
	%start 0,	start 1
maketri(Numsinrowcount,Numsinrow,Base,FinArray,X,Default) :-
	(
	Numsinrowcount =:= 0 ->%first num in row
		B is Base-Numsinrow,
		writespaces(B,FinArray,FFArray),
		append(FFArray,[Default],NArray),
		NumsinrowcountN is Numsinrowcount+1,
		maketri(NumsinrowcountN,Numsinrow,Base,NArray,X,Default)
		
	;Numsinrowcount < Numsinrow ->%rest of nums in row
			%write('morenums'),nl,
		append(FinArray,['_'],NArray),
		append(NArray,[Default],RNArray),
		NumsinrowcountN is Numsinrowcount+1,
			%write(NumsinrowcountN),nl,
		maketri(NumsinrowcountN,Numsinrow,Base,RNArray,X,Default)
		
	;	B is Base-Numsinrow,
			%write('newl'),nl,
		writespaces(B,FinArray,FFArray),
		NumsinrowN is Numsinrow+1,%new row
			%write(FFArray),nl,
		maketri(0,NumsinrowN,Base,FFArray,X,Default)
	).

writespaces(0,Outarray,Outarray).
writespaces(N,InArray,Outarray) :-
	N>0,
	append(InArray,['_'],BArray),
	NN is N-1,
	writespaces(NN,BArray,Outarray).
	
convuserholetoactualhole(_,0,Final,Final).
convuserholetoactualhole([Head|Tail],Hole,Pointer,Final) :-
	(Head = '_' ->
		Pointerp is Pointer+1,
		convuserholetoactualhole(Tail,Hole,Pointerp,Final)
	;Pointerp is Pointer+1,
	Holen is Hole-1,
	convuserholetoactualhole(Tail,Holen,Pointerp,Final)
	).

usermakes2dboard([Endc|Rest],!,Final) :-
	reverse(Rest,Final).
usermakes2dboard(Inprogress,Endsignal,Final) :-
	write('Enter ''_''. for empty spaces, !. to finish '),
	read(I),
	usermakes2dboard([I|Inprogress],I,Final).
	
/*sportjump(Array) :-
	Array = [
		'_','_','_','_','_','_',1,'_',1,'_',1,'_','_','_','_','_','_',
		'_','_','_','_','_','_',1,'_',1,'_',1,'_','_','_','_','_','_',
		'_','_','_','_','_','_',1,'_',1,'_',1,'_','_','_','_','_','_',
		 1, '_', 1, '_', 1, '_',1,'_',1,'_',1,'_', 1, '_', 1, '_', 1,
		 1, '_', 1, '_', 1, '_',1,'_',1,'_',1,'_', 1, '_', 1, '_', 1,
		 1, '_', 1, '_', 1, '_',1,'_',1,'_',1,'_', 1, '_', 1, '_', 1,
		'_','_','_','_','_','_',1,'_',1,'_',1,'_','_','_','_','_','_',
		'_','_','_','_','_','_',1,'_',1,'_',1,'_','_','_','_','_','_',
		'_','_','_','_','_','_',1,'_',1,'_',1,'_','_','_','_','_','_'
		].
	*/
	
sportjump(Array) :-
	Array = [
		'_','_','_','_',1,'_',1,'_',1,'_','_','_','_',
		'_','_','_','_',1,'_',1,'_',1,'_','_','_','_',
		 1, '_', 1, '_',1,'_',1,'_',1,'_', 1, '_', 1, 
		 1, '_', 1, '_',1,'_',1,'_',1,'_', 1, '_', 1, 
		 1, '_', 1, '_',1,'_',1,'_',1,'_', 1, '_', 1, 
		'_','_','_','_',1,'_',1,'_',1,'_','_','_','_',
		'_','_','_','_',1,'_',1,'_',1,'_','_','_','_'
		].
