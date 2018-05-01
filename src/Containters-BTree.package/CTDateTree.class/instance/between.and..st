enumerating
between: startDateAndTime and: endDateAndTime
	"I return all events between a given start date and end date."
	
	| values |
	values := CTTreeSet new.
	self between: startDateAndTime and: endDateAndTime keysAndValuesDo: [ :key :val | values add: val ].
	^ values