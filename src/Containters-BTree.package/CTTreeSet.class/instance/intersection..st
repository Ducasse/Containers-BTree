public
intersection: aCollection
	| newTree intersection |
	(self isCompatibleTreeSetWith: aCollection) ifFalse: [^ super intersection: aCollection].

	newTree := tree emptyCopy.
	
	tree commonKeysWith: aCollection tree keysAndValuesDo:
		[:key :left :right |
		intersection := left select: [:ea | self bucket: right includes: ea].
		intersection isEmpty ifFalse: [newTree at: key put: intersection]].
	
	^ CTTreeSet basicNew setTree: newTree sortSelector: self sortSelector equalitySelector: self equalitySelector