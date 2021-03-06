"
http://www.cs.umbc.edu/~woodcock/cmsc341/btree/defn.html

A B-Tree of order m is a search tree, where the data 
  (or pointers to it) is stored at the leaves, such that:

1) the root is either a leaf (as well--i.e. the tree is 
     a single node) or has between 2 and m children""

2) all other (non-root) nodes have at least m/2 children,
     but no more than m children

3) all leaves are at the same depth""

"
Class {
	#name : #CTBTreeTest,
	#superclass : #TestCase,
	#category : #'Containers-BTree-Tests'
}

{ #category : #assertions }
CTBTreeTest >> assertConsistent: aBTree [
	| depths root |
	root := aBTree root.
	
 " http://www.cs.umbc.edu/~woodcock/cmsc341/btree/defn.html

A B-Tree of order m is a search tree, where the data 
  (or pointers to it) is stored at the leaves, such that:

	1) the root is either a leaf (as well--i.e. the tree is a single node) or has between 2 and m children"
	self assert: (root isLeaf or: [root values size between: 2 and: aBTree order]).
	
"  2) all other (non-root) nodes have at least m/2 children, but no more than m children"
	root allChildrenDo: [:ea | self assert: (ea values size between: (aBTree order // 2) and: aBTree order)]. 

"  3) all leaves are at the same depth"
	depths := Set new.
	root withAllChildrenDo: [:ea | ea isLeaf ifTrue: [depths add: ea depth]].
	self assert: depths size equals: 1
]

{ #category : #assertions }
CTBTreeTest >> assertSorted: aTree [
	| last |
	last := nil.
	aTree keysAndValuesDo:
		[:k :v |
		last ifNotNil: [self assert: last < k].
		last := k]
]

{ #category : #assertions }
CTBTreeTest >> checkTree: tree array: pairArray [
	pairArray withIndexDo:
		[:pair :i |
		tree at: pair first put: pair second.
		self assert: tree size equals: i.
		"self assertConsistent: tree.
		self assertSorted: tree"].
	pairArray shuffled do:
		[:pair |
		self assert: (tree at: pair first) equals: pair second].
	self assert: tree size equals: pairArray size.
	self assertConsistent: tree.
	self assertSorted: tree.
	^ tree
	
	 
]

{ #category : #assertions }
CTBTreeTest >> checkTree: tree items: count [
	| pairArray  |
	pairArray := ((1 to: count) collect: [:i | Array with: i asString with: i]) shuffled.
	self checkTree: tree array: pairArray
]

{ #category : #assertions }
CTBTreeTest >> checkTreeWithOrder: order items: count [
	self checkTree: (CTBTree order: order) items: count
]

{ #category : #tests }
CTBTreeTest >> testAddAndRetrieveWithSplit [
	self checkTreeWithOrder: 4  items: 5
]

{ #category : #tests }
CTBTreeTest >> testAddAndRetrieveWithTwoSplits [
	self checkTreeWithOrder: 4 items: 17
]

{ #category : #'test api' }
CTBTreeTest >> testAtIfAbsent [
	| tree |
	tree := CTBTree new.
	tree at: 1 put: 'foo'.
	tree at: 2 put: 'bar'.
	self assert: (tree at: 1 ifAbsent: [42]) equals: 'foo'.
	self assert: (tree at: 2 ifAbsent: [42]) equals: 'bar'.
	self assert: (tree at: 3 ifAbsent: [42]) equals: 42.
]

{ #category : #'test api' }
CTBTreeTest >> testAtPut [
	| tree |
	tree := CTBTree new.
	tree at: 1 put: 'one'.
	tree at: 2 put: 'two'.
	tree at: 3 put: 'three'.
	self assert: (tree at: 1) equals: 'one'.
	self assert: (tree at: 2) equals: 'two'.
	self assert: (tree at: 3) equals: 'three'.
	tree at: 3 put: 'four'.
	self assert: (tree at: 3) equals: 'four'.

]

{ #category : #tests }
CTBTreeTest >> testCommonKeysDifferentValues [
	| large small expectedResults results |
	large := CTBTree new.
	1 to: 1000 by: 2 do: [:i | large at: i put: i].
	small := CTBTree new.
	2 to: 2000 by: 11 do: [:i | small at: i put: i*2].
	
	expectedResults := ((-9 to: 1000 by: 22) allButFirst 
		collect: [:i | Array with: i with: i with: i*2]) asOrderedCollection.
	
	results := OrderedCollection new.
	large commonKeysWith: small keysAndValuesDo:
		[:k :v1 :v2 |
		results add: (Array with: k with: v1 with: v2)].
	self assert: results equals: expectedResults.
	
	results := OrderedCollection new.
	small commonKeysWith: large keysAndValuesDo:
		[:k :v1 :v2 |
		results add: (Array with: k with: v2 with: v1)].
	self assert: results equals: expectedResults
]

{ #category : #tests }
CTBTreeTest >> testCommonKeysSameValues [
	| large small expectedResults results |
	large := CTBTree new.
	1 to: 1000 by: 2 do: [:i | large at: i put: i].
	small := CTBTree new.
	2 to: 2000 by: 11 do: [:i | small at: i put: i].
	
	expectedResults := ((-9 to: 1000 by: 22) allButFirst collect: [:i | Array with: i with: i with: i]) asOrderedCollection.
	
	results := OrderedCollection new.
	large commonKeysWith: small keysAndValuesDo:
		[:k :v1 :v2 |
		results add: (Array with: k with: v1 with: v2)].
	self assert: results = expectedResults.
	
	results := OrderedCollection new.
	small commonKeysWith: large keysAndValuesDo:
		[:k :v1 :v2 |
		results add: (Array with: k with: v2 with: v1)].
	self assert: results = expectedResults
]

{ #category : #tests }
CTBTreeTest >> testEmptyTree [
	self checkTreeWithOrder: 5 items: 0
]

{ #category : #tests }
CTBTreeTest >> testFirstLast [
	| tree |
	tree := CTBTree new.
	self should: [ tree first ] raise: Error.
	self should: [ tree last ] raise: Error.
	tree at: SmallInteger minVal put: SmallInteger minVal.
	tree at: SmallInteger maxVal put: SmallInteger maxVal.
	10000 timesRepeat: [ 
		tree at: 536870911 atRandom put: nil.
		self assert: tree first = SmallInteger minVal.
		self assert: tree last = SmallInteger maxVal ]
]

{ #category : #tests }
CTBTreeTest >> testFound [
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
]

{ #category : #'test api' }
CTBTreeTest >> testKeys [
	| tree |
	tree := CTBTree new.
	tree at: 1 put: 'one'.
	tree at: 2 put: 'two'.
	tree at: 3 put: 'three'.
	self assert: tree keys equals: #(1 2 3)
]

{ #category : #'test api' }
CTBTreeTest >> testLarge [
	| tree |
	tree := CTBTree new.
	#(9 30 3 6 12 15 19 26 33 36 1 2 4 5 7 8 10 11 13 14 16 18 20 22 25 28 29 31 32 34 35 37 38 39 40 41)
		do: [ :each | tree at: each put: each ].
	self assert: tree depth equals: 3
]

{ #category : #tests }
CTBTreeTest >> testLargeTree [
	self checkTreeWithOrder: 8 items: 5000
	

]

{ #category : #tests }
CTBTreeTest >> testMissing [
	| tree |
	tree := CTBTree new.
	tree at: 1 put: 'one'.
	tree at: 2 put: 'two'.
	tree at: 3 put: 'three'.
	self assert: (tree at: 1) equals: 'one'.
	self assert: (tree at: 2) equals: 'two'.

]

{ #category : #tests }
CTBTreeTest >> testMultipleAddAndRetrieve [
	self checkTreeWithOrder: 5 items: 3
]

{ #category : #tests }
CTBTreeTest >> testRange [
	| tree keys |
	tree := CTBTree new.
	1 to: 100 by: 2 do: [:ea | tree at: ea put: ea * 2].
	self assert: tree size = 50.
	keys := OrderedCollection new.
	tree from: 12 to: 19 keysAndValuesDo:
		[:k :v |
		self assert: k * 2 = v.
		keys add: k].
	self assert: keys asArray = #(13 15 17 19).
	self assertSorted: tree.
	self assertConsistent: tree.
]

{ #category : #tests }
CTBTreeTest >> testRemoval [
	| tree |
	tree := CTBTree new.
	#(a b c d e f g h i j k l) do: [:ea | tree at: ea put: ea, '!'].
	self assert: tree size = 12.
	tree removeKey: #d.
	self assert: tree size = 11.
	self assert: (tree at: #d ifAbsent: [32]) = 32.
	tree removeKey: #k.
	self assert: tree size = 10.
	self assert: (tree at: #k ifAbsent: [32]) = 32.
	self assertSorted: tree.
	self assertConsistent: tree.
]

{ #category : #tests }
CTBTreeTest >> testRemoval2 [
	| tree |
	tree := CTBTree new.
	1 to: 15 do: [:i | tree at: i put: i].
	1 to: 15 do: [:i | tree removeKey: i].
	self assert: tree isEmpty
]

{ #category : #tests }
CTBTreeTest >> testRemoveAll [
	| tree |
	tree := CTBTree new.
	#(a b c d e f g h i j k l) do: [:ea | tree at: ea put: ea, '!'].
	self assert: tree size = 12.
	#(a b c d e f g h i j k l)  shuffled do: [:ea | tree removeKey: ea].
	self assert: tree size = 0.

	self assertSorted: tree.
	self assertConsistent: tree.
]

{ #category : #tests }
CTBTreeTest >> testRemoveAllFailing [
	| tree |
	tree := CTBTree new.
	#(a b c d e f g h i j k l) do: [:ea | tree at: ea put: ea, '!'].
	self assert: tree size = 12.
	#(#c #j #g #i #k #l #f #e #d #h #a #b) do: [:ea | tree removeKey: ea].
	self assert: tree size = 0.

	self assertSorted: tree.
	self assertConsistent: tree.
]

{ #category : #tests }
CTBTreeTest >> testRemoveLots [
	| tree |
	tree := CTBTree new.
	#(a b c d e f g h i j k l) do: [:ea | tree at: ea put: ea, '!'].
	self assert: tree size = 12.
	#(a c e g i k) shuffled do: [:ea | tree removeKey: ea].
	self assert: tree size = 6.

	self assertSorted: tree.
	self assertConsistent: tree.
]

{ #category : #tests }
CTBTreeTest >> testSimpleAddAndRetrieve [
	self checkTreeWithOrder: 5 items: 1
]

{ #category : #tests }
CTBTreeTest >> testStoreNil [
	self checkTree: CTBTree new array: {{'x'. 1}. {'y'. nil}}
]

{ #category : #tests }
CTBTreeTest >> testStringKeys [
	self checkTree: (CTBTree keys: CTBTreeStringKeys new) items: 100
]
