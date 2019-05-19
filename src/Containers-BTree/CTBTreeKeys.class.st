Class {
	#name : #CTBTreeKeys,
	#superclass : #Object,
	#category : #'Containers-BTree-Model'
}

{ #category : #testing }
CTBTreeKeys >> canGrow [
	^ (self at: self size) isNil
]

{ #category : #testing }
CTBTreeKeys >> canShrink [
	^  (self at: self size // 2 + 1) notNil
]

{ #category : #copying }
CTBTreeKeys >> emptyCopy [
	^ self class new: self size
]

{ #category : #private }
CTBTreeKeys >> findIndexForKey: aMagnitude [
	self withIndexDo:
		[:key :i |
		(key isNil or: [key > aMagnitude]) ifTrue:
			[^ i - 1]].
	^ self size

]

{ #category : #accessing }
CTBTreeKeys >> first [
	^ self at: 1
]

{ #category : #accessing }
CTBTreeKeys >> lastIndex [
	self withIndexDo:
		[:key :i |
		key isNil ifTrue:
			[^ i - 1]].
	^ self size

]

{ #category : #private }
CTBTreeKeys >> shiftLeftTo: index [
	index to: self size - 1 by: 1 do:
		[:i |
		self at: i put: (self at: i+1)].
	self at: self size put: nil.
]

{ #category : #private }
CTBTreeKeys >> shiftRightFrom: index [
	self size to: index+1 by: -1 do:
		[:i |
		self at: i put: (self at: i - 1)]
	
]

{ #category : #enumerating }
CTBTreeKeys >> withIndexDo: aBlock [
	1 to: self size do: [:i | aBlock value: (self at: i) value: i]
]
