setup
setUp
	tree := CTTSTree new.
	self words shuffled do: [:ea | tree at: ea put: ea asUppercase].
	empty := CTTSTree new.