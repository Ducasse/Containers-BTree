tests
testAdd
	| dateRanges timespan |
	dateRanges := CTDateTree new.
	timespan := Timespan starting: now ending: twoWeeks.
	dateRanges at: timespan put: timespan.
	self assert: ((dateRanges at: timespan) = timespan)