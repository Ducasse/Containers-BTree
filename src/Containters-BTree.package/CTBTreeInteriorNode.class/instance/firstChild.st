accessing
firstChild
	self childrenDo: [:ea | ^ ea].
	self error: 'No children'.