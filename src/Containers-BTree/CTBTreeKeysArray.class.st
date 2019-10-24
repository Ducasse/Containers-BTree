Class {
	#name : #CTBTreeKeysArray,
	#superclass : #CTBTreeKeys,
	#type : #variable,
	#category : #'Containers-BTree-Model'
}

{ #category : #printing }
CTBTreeKeysArray >> printOn: aStream [
	super printOn: aStream.
	
	1 to: self size do: [ :each | 
		aStream
			space ; nextPutAll: (self at: each) asString
			]
]
