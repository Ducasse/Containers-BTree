"
| depths root |
	root := aBTree root.
	
 "" http://www.cs.umbc.edu/~woodcock/cmsc341/btree/defn.html

A B-Tree of order m is a search tree, where the data 
  (or pointers to it) is stored at the leaves, such that:

1) the root is either a leaf (as well--i.e. the tree is 
     a single node) or has between 2 and m children""
	
	self assert: (root isLeaf or: [root values size between: 2 and: aBTree order]).
	
""  2) all other (non-root) nodes have at least m/2 children,
     but no more than m children""

	root allChildrenDo: [:ea | self assert: (ea values size between: (aBTree order // 2) and: aBTree order)]. 

""  3) all leaves are at the same depth""

	depths := Set new.
	root withAllChildrenDo: [:ea | ea isLeaf ifTrue: [depths add: ea depth]].
	self assert: depths size = 1.
	

Examples


              (37 # _ )
            /           \
           /             \
          /               \
      (21 # 29)            (50 # _ )
     /    |     \          /       \
    /     |      \        /         \
(7,9,11) (21,23) (29,30) (37,49)   (50,100)

Notice that this is a B-Tree of order 3. The search property is clearly being met. Each interior node has at least 2 and no more than 3 children. All of the interior keys appear as the left most value in the leaf of the subtree indicated by that key.


Trace INSERT

Consider the insertion of 8 into this tree:

              (37 # _ )
            /           \
           /             \
          /               \
      (21 # 29)            (50 # _ )
     /    |     \          /       \
    /     |      \        /         \
(7,9,11) (21,23) (29,30) (37,49)   (50,100)

Clearly it belongs in the left most leaf. But that would overfill that leaf (4 keys instead of the maximum 3). So, we must split that node and pass a key up.

              (37 # _ )
            /             \
           /               ----
          /                    \
       (9 # 21 # 29)           (50 # _ )
     /  |      |     \          /       \
    /   |      |      \        /         \
(7,8) (9,11) (21,23) (29,30) (37,49)   (50,100)

But now the interior node is overfull, so it must be split as well.

              ( 21 # 37 )
            /    |        \
           /     |         ------
          /      |               \
       (9 # _) (29 # _)           (50 # _ )
     /  |       |     \           /       \
    /   |       |      \         /         \
(7,8) (9,11) (21,23) (29,30) (37,49)   (50,100)

Now, the root is full, but not overfull, so it does not need to split--the height of the tree remains the same.








"
Class {
	#name : #CTBTree,
	#superclass : #Collection,
	#instVars : [
		'root'
	],
	#category : #'Containers-BTree-Model'
}

{ #category : #'as yet unclassified' }
CTBTree class >> keys: aBTreeKeys [
	^ self basicNew initializeWithKeys: aBTreeKeys
]

{ #category : #'as yet unclassified' }
CTBTree class >> new [
	^ self order: 5
]

{ #category : #'as yet unclassified' }
CTBTree class >> order: aNumber [
	^ self keys: (CTBTreeKeysArray new: aNumber)
]

{ #category : #accessing }
CTBTree >> at: aMagnitude [
	^ self at: aMagnitude ifAbsent: [self error: aMagnitude printString, ' not found']
]

{ #category : #accessing }
CTBTree >> at: aMagnitude ifAbsent: errorBlock [
       | leaf |
       leaf := root existingLeafForKey: aMagnitude.
       leaf ifNil: [^ errorBlock value].
       ^ leaf valueForKey: aMagnitude ifAbsent: errorBlock
]

{ #category : #adding }
CTBTree >> at: aMagnitude ifAbsentPut: aBlock [
	^ self at: aMagnitude ifAbsent: [self at: aMagnitude put: aBlock value]
]

{ #category : #accessing }
CTBTree >> at: aMagnitude ifPresent: aBlock [
	| leaf |
	leaf := root existingLeafForKey: aMagnitude.
	leaf ifNil: [ ^ nil ].
	^ leaf valueForKey: aMagnitude ifPresent: aBlock
]

{ #category : #adding }
CTBTree >> at: aMagnitude put: anObject [
	| leaf |
	leaf := root leafForKey: aMagnitude.
	leaf insertKey: aMagnitude value: anObject.
	root := leaf root.
	^ anObject
]

{ #category : #enumerating }
CTBTree >> commonKeysWith: aTree keysAndValuesDo: aBlock [
	^ aTree depth < self depth
		ifTrue: [aTree root commonKeysWith: root keysAndValuesDo: aBlock flip: true]
		ifFalse: [root commonKeysWith: aTree root keysAndValuesDo: aBlock flip: false]
]

{ #category : #accessing }
CTBTree >> depth [
	^ root depth
]

{ #category : #enumerating }
CTBTree >> do: aBlock [
	root allLeavesDo: [:ea | ea valuesDo: aBlock]
]

{ #category : #copying }
CTBTree >> emptyCopy [
	^ CTBTree keys: root keyArray emptyCopy
]

{ #category : #accessing }
CTBTree >> first [
	^ root first
]

{ #category : #enumerating }
CTBTree >> from: start do: aBlock [
	self from: start to: nil keysAndValuesDo: [:k :v | aBlock value: v]
]

{ #category : #enumerating }
CTBTree >> from: start keysAndValuesDo: aBlock [
	self from: start to: nil keysAndValuesDo: aBlock
]

{ #category : #enumerating }
CTBTree >> from: start to: end do: aBlock [
	self from: start to: end keysAndValuesDo: [:k :v | aBlock value: v]
]

{ #category : #enumerating }
CTBTree >> from: start to: end keysAndValuesDo: aBlock [
	root leavesFrom: start to: end do:
		[:ea |
		ea keysAndValuesDo:
			[:k :v |
			((start isNil or: [k >= start]) and:
				[end isNil or: [k <= end]]) ifTrue:
					[aBlock value: k value: v]]]
]

{ #category : #initialization }
CTBTree >> initializeWithKeys: aBTreeKeys [
	aBTreeKeys size > 3 ifFalse: [self error: 'The BTree order must be at least 4'].
	root := CTBTreeLeafNode keys: aBTreeKeys
]

{ #category : #accessing }
CTBTree >> keys [
	^ Array streamContents:
		[:s |
		self keysDo: [:k | s nextPut: k]]
]

{ #category : #enumerating }
CTBTree >> keysAndValuesDo: aBlock [
	root allLeavesDo: [:ea | ea keysAndValuesDo: aBlock]
]

{ #category : #enumerating }
CTBTree >> keysDo: aBlock [
	root allLeavesDo: [:ea | ea keysDo: aBlock]
]

{ #category : #accessing }
CTBTree >> last [
	^ root last
]

{ #category : #accessing }
CTBTree >> order [
	^ root size
]

{ #category : #adding }
CTBTree >> removeKey: aMagnitude [
	^ self removeKey: aMagnitude ifAbsent: [self error: aMagnitude printString, ' not found.']
]

{ #category : #adding }
CTBTree >> removeKey: aMagnitude ifAbsent: aBlock [
	| leaf |
	leaf := root existingLeafForKey: aMagnitude.
	leaf ifNil: [^ aBlock value].
	leaf removeKey: aMagnitude ifAbsent: [^ aBlock value].
	root := leaf root
]

{ #category : #private }
CTBTree >> root [
	^ root
]

{ #category : #enumerating }
CTBTree >> upTo: end do: aBlock [
	self from: nil to: end keysAndValuesDo: [:k :v | aBlock value: v]
]

{ #category : #enumerating }
CTBTree >> upTo: end keysAndValuesDo: aBlock [
	self from: nil to: end keysAndValuesDo: aBlock
]

{ #category : #accessing }
CTBTree >> values [
	^ Array streamContents:
		[:s |
		self valuesDo: [:k | s nextPut: k]]
]

{ #category : #enumerating }
CTBTree >> valuesDo: aBlock [
	root allLeavesDo: [:ea | ea valuesDo: aBlock]
]
