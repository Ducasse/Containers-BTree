tests
testFound
	| tree found |
	found := false.
	tree := CTBTree new.
	tree at: 1 put: 'foo'.
	tree
		at: 1
		ifPresent: [ :val | 
			self assert: 'foo' equals: val.
			found := true ].
	self assert: found