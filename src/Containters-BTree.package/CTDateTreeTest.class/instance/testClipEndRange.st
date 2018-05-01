tests
testClipEndRange
	| dateRanges returnedDates expectedDates |
	
	dateRanges := CTDateTree new.
	timespans do: [ :ea | dateRanges at: ea put: ea asString ].
	expectedDates := timespans select: [ :ea | (ea start >= now) and: [ ea end <= nextWeek ]] thenCollect: [ :ea | ea asString ].
	returnedDates := (dateRanges between: now and: nextWeek) collect: [ :ea | ea asString ].
	self assert: (returnedDates intersection: expectedDates) size = expectedDates size.