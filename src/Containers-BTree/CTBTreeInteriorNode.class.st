Class {
	#name : #CTBTreeInteriorNode,
	#superclass : #CTBTreeNode,
	#type : #variable,
	#category : #'Containers-BTree-Model'
}

{ #category : #query }
CTBTreeInteriorNode >> childForKey: aMagnitude [
	| index |
	index := keys findIndexForKey: aMagnitude.
	index = 0 ifTrue:
		[keys at: 1 put: aMagnitude.
		^ self at: 1].
	^ self at: index
		

]

{ #category : #enumerating }
CTBTreeInteriorNode >> childrenDo: aBlock [
	self valuesDo: aBlock
]

{ #category : #enumerating }
CTBTreeInteriorNode >> commonKeysWith: aNode keysAndValuesDo: aBlock flip: aBoolean [
	| index |
	aNode firstKey < self firstKey ifTrue: [^ aNode commonKeysWith: self keysAndValuesDo: aBlock flip: aBoolean not].
	index := (keys findIndexForKey: aNode firstKey) max: 1.
	index to: self size do:
		[:i |
		(self at: i) ifNotNil: [:c | c commonKeysWith: aNode keysAndValuesDo: aBlock flip: aBoolean]]
]

{ #category : #accessing }
CTBTreeInteriorNode >> depth [
	^ 1 + self firstChild depth
]

{ #category : #query }
CTBTreeInteriorNode >> existingChildForKey: aMagnitude [
       "Unlike #childForKey:, this method looks for a child, but doesn't mess with the tree if it doesn't exist."
       | index |
       index := keys findIndexForKey: aMagnitude.
       index = 0
               ifTrue: [^ nil]
               ifFalse: [^ self at: index].
]

{ #category : #query }
CTBTreeInteriorNode >> existingLeafForKey: aMagnitude [
	"Unlike #leafForKey:, this method looks for a leaf but doesn't mess with the tree if it doesn't exist."

	| child |
	child := self existingChildForKey: aMagnitude.
	^ child ifNotNil: [ child existingLeafForKey: aMagnitude ]
]

{ #category : #accessing }
CTBTreeInteriorNode >> first [
	self childrenDo: [ :node | ^ node first ].
	self error: 'this tree is empty'
]

{ #category : #accessing }
CTBTreeInteriorNode >> firstChild [
	self childrenDo: [:ea | ^ ea].
	self error: 'No children'.
]

{ #category : #private }
CTBTreeInteriorNode >> insertKey: aMagnitude value: anObject at: index [
	super insertKey: aMagnitude value: anObject at: index.
	anObject parent: self
]

{ #category : #testing }
CTBTreeInteriorNode >> isLeaf [
	^ false
]

{ #category : #accessing }
CTBTreeInteriorNode >> last [
	| child |
	child := nil.
	self childrenDo: [ :node | child := node ].
	child isNil ifTrue: [ self error: 'this tree is empty' ].
	^ child last
]

{ #category : #query }
CTBTreeInteriorNode >> leafForKey: aMagnitude [
	^ (self childForKey: aMagnitude) leafForKey: aMagnitude
]

{ #category : #enumerating }
CTBTreeInteriorNode >> leavesFrom: start to: end do: aBlock [
	| startIndex endIndex |
	startIndex := start ifNil: [1] ifNotNil: [(keys findIndexForKey: start) max: 1].
	endIndex := end ifNil: [keys lastIndex] ifNotNil: [keys findIndexForKey: end].
	startIndex to: endIndex do: [:i | (self at: i) leavesFrom: start to: end do: aBlock]
]

{ #category : #query }
CTBTreeInteriorNode >> nextSiblingForChild: aNode [
	| index |
	index := keys findIndexForKey: aNode firstKey.
	^ (index = self size or: [(keys at: index+1) isNil]) 
		ifTrue: [index = 1 ifFalse: [self at: index - 1] ifTrue: [nil]]
		ifFalse: [self at: index + 1]
]

{ #category : #printing }
CTBTreeInteriorNode >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $[.
	aStream print: keys.
	aStream nextPut: $].
]

{ #category : #update }
CTBTreeInteriorNode >> updateKey: oldMagnitude to: newMagnitude [
       keys withIndexDo:
               [:key :i |
               key = oldMagnitude ifTrue:
                       [(i = 1 and: [parent notNil]) ifTrue:
                               [parent updateKey: oldMagnitude to: newMagnitude].
                       ^ keys at: i put: newMagnitude]].
       self error: 'No such key'
]
