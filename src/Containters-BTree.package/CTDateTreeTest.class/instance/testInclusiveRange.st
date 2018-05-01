tests
testInclusiveRange
	| dateRanges returnedDates expectedDates |
	
	dateRanges := CTDateTree new.
	timespans do: [ :ea | dateRanges at: ea put: ea asString ].
	expectedDates := timespans collect: [ :ea | ea asString ].
	returnedDates := (dateRanges between: now and: threeWeeks) collect: [ :ea | ea asString ].
	self assert: (returnedDates intersection: expectedDates) size = expectedDates size.