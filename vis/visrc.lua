require('vis')

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- Your per window configuration options e.g.
	-- vis:command('set number')
	vis:command('set tw 4')
	vis:command('set theme seti')
end)
