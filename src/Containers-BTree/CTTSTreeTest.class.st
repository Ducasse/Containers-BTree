Class {
	#name : #CTTSTreeTest,
	#superclass : #TestCase,
	#instVars : [
		'tree',
		'empty'
	],
	#category : #'Containers-BTree-Tests'
}

{ #category : #setup }
CTTSTreeTest >> setUp [
	tree := CTTSTree new.
	self words shuffled do: [:ea | tree at: ea put: ea asUppercase].
	empty := CTTSTree new.
]

{ #category : #tests }
CTTSTreeTest >> testAt [
	self assert: (tree at: 'abear') equals: 'ABEAR'.
	self assert: (tree at: 'abelmosk') equals: 'ABELMOSK'.
	self assert: (tree at: 'abracadabra' ifAbsent: [42]) equals: 42.
	self assert: (tree at: '' ifAbsent: [42]) equals: 42.
	self assert: (empty at: 'foo' ifAbsent: [42]) equals: 42 
]

{ #category : #tests }
CTTSTreeTest >> testMatch [
	self assert: (tree matchesForString: 'abea' distance: 1) asSet equals: #(ABEAM ABEAR ABED ABEL ABET ABE) asSet.
	self assert: (tree matchesForString: 'abel' distance: 2) asSet equals: #(ABELIA ABEAM ABEAR) asSet.
	self assert: (tree matchesForString: 'abel' distance: 0) equals: #(ABEL).
	self assert: (tree matchesForString: '' distance: 1) equals: #().
	self assert: (empty matchesForString: 'foo' distance: 0) equals: #()
]

{ #category : #tests }
CTTSTreeTest >> testPrefix [
	self assert: (tree matchesForPrefix: 'abet') asSet equals: #(ABET ABETMENT) asSet.
	self assert: (tree matchesForPrefix: 'abelm') asSet equals: #(ABELMOSCHUS ABELMOSK) asSet.
	self assert: (tree matchesForPrefix: '') asSet equals: (self words asSet collect: [:ea | ea asUppercase]).
	self assert: (empty matchesForPrefix: 'foo') equals: #()
]

{ #category : #tests }
CTTSTreeTest >> testRemove [
	self assert: (tree at: 'abel') equals: 'ABEL'.
	self assert: (tree removeKey: 'abel') equals: 'ABEL'.
	self assert: (tree at: 'abel' ifAbsent: [42]) equals: 42.
	self assert: (tree at: 'abelmosk') equals: 'ABELMOSK'.
	self assert: (tree removeKey: 'foo' ifAbsent: [42]) equals: 42.
	self assert: (tree removeKey: 'abel' ifAbsent: [42]) equals: 42.
]

{ #category : #tests }
CTTSTreeTest >> testValues [
	self assert: tree values asSet equals: (self words asSet collect: [:ea | ea asUppercase]).
	self assert: empty values isEmpty
]

{ #category : #setup }
CTTSTreeTest >> words [
	^ #(
abe
abeam
abear
abearance
abecedarian
abecedarium
abecedary
abed
abeigh
abel
abele
abelia
abelian
abelicea
abelite
abelite
abelmoschus
abelmosk
abelonian
abeltree
abencerrages
abenteric
abepithymia
aberdeen
aberdevine
aberdonian
aberia
aberrance
aberrancy
aberrant
aberrate
aberration
aberrational
aberrator
aberrometer
aberroscope
aberuncator
abet
abetment) 
]
