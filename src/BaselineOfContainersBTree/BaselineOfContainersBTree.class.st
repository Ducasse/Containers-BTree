Class {
	#name : #BaselineOfContainersBTree,
	#superclass : #BaselineOf,
	#category : #BaselineOfContainersBTree
}

{ #category : #baselines }
BaselineOfContainersBTree >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [
			spec package: 'Containers-BTree'.
		]
]
