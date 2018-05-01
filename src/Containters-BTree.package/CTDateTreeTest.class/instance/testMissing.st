tests
testMissing
	| dateRanges timespan missingTimespan |
	dateRanges := CTDateTree new.
	timespan := Timespan starting: now ending: twoWeeks.
	missingTimespan := Timespan starting: now ending: tomorrow.
	dateRanges at: timespan put: timespan.
	self assert: (dateRanges at: missingTimespan ifAbsent: [ false ]) = false.