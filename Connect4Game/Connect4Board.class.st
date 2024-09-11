Class {
	#name : #Connect4Board,
	#superclass : #Object,
	#instVars : [
		'grid',
		'currentPlayer'
	],
	#category : #Connect4Game
}

{ #category : #checking }
Connect4Board >> announceWin: player [ 
    Transcript show: player, ' pobeda'; cr.

]

{ #category : #checking }
Connect4Board >> checkHorizontalFor: player [ 
    1 to: 6 do: [:row |
        1 to: 4 do: [:col |  
            ((grid at: row) at: col) = player ifTrue: [
                ((grid at: row) at: col + 1) = player ifTrue: [
                    ((grid at: row) at: col + 2) = player ifTrue: [
                        ((grid at: row) at: col + 3) = player ifTrue: [^true].
                    ].
                ].
            ].
        ].
    ].
    ^false.

]

{ #category : #checking }
Connect4Board >> checkVerticalFor: player [ 
    1 to: 7 do: [:col |
        1 to: 3 do: [:row |  
            ((grid at: row) at: col) = player ifTrue: [
                ((grid at: row + 1) at: col) = player ifTrue: [
                    ((grid at: row + 2) at: col) = player ifTrue: [
                        ((grid at: row + 3) at: col) = player ifTrue: [^true].
                    ].
                ].
            ].
        ].
    ].
    ^false.

]

{ #category : #checking }
Connect4Board >> checkWinForPlayer: player [ 
    (self checkHorizontalFor: player) ifTrue: [self announceWin: player].
    (self checkVerticalFor: player) ifTrue: [self announceWin: player].

]

{ #category : #'visual properties' }
Connect4Board >> displayBoard [ 
    Transcript show: 'Trenutna tabla:'; cr.
    1 to: 6 do: [:row | 
        | currentRow displayRow |
        currentRow := grid at: row.
        displayRow := currentRow collect: [:cell | cell ifNil: ['.'] ifNotNil: [cell]].

        Transcript show: (String streamContents: [:stream | 
            displayRow do: [:each | stream nextPutAll: each; nextPut: $ ]]).
        Transcript cr.
    ].

]

{ #category : #moving }
Connect4Board >> dropPiece: player atColumn: column [ 
    | rowPlaced currentRow |

    (column < 1 or: [column > 7]) ifTrue: [
        Error new: 'out of bounds!' signal.
    ].

    rowPlaced := false.

    6 to: 1 by: -1 do: [:row | 
        currentRow := grid at: row.  

        Transcript show: 'provera ', row printString, ' kolona ', column printString; cr.

        (currentRow at: column) ifNil: [
            currentRow at: column put: player. 
            rowPlaced := true.
            Transcript show: 'Postavio ', player, ' u redu: ', row printString, ' kolona: ', column printString; cr.
            ^self.
        ].
    ].

    rowPlaced ifFalse: [Error new: 'kolona je puna' signal].

]

{ #category : #moving }
Connect4Board >> dropPieceAtColumn: column [ 
    | rowPlaced currentRow |
    
    (column < 1 or: [column > 7]) ifTrue: [
        Error new: 'out of bounds!' signal.
    ].

    rowPlaced := false.
    6 to: 1 by: -1 do: [:row | 
        currentRow := grid at: row.

        (currentRow at: column) ifNil: [
            currentRow at: column put: currentPlayer.  
            rowPlaced := true.
            Transcript show: 'Je postavio ', currentPlayer, ' u redu: ', row printString, ' kolona: ', column printString; cr.
            self checkWinForPlayer: currentPlayer.  
            self switchPlayer.  
            ^self.
        ].
    ].

    rowPlaced ifFalse: [Error new: 'kolona je puna!' signal].

]

{ #category : #initialization }
Connect4Board >> initialize [ 
        grid := Array new: 6.
        1 to: 6 do: [ :row | grid at: row put: (Array new: 7) ].
		currentPlayer := 'X'.
    
]

{ #category : #'instance creation' }
Connect4Board >> new [ 
    ^ super new initialize
    
]

{ #category : #moving }
Connect4Board >> switchPlayer [ 
    currentPlayer := (currentPlayer = 'X') ifTrue: ['O'] ifFalse: ['X'].

]
