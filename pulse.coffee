startbtn = $ ".start"
stopbtn = $ ".stop"
resetbtn = $ ".reset"
input = $ "input.beats"
desc = $(".timeleft .desc")
timeLeftDisplay = $(".timeleft .number")

desiredDing = new Audio "http://www.sounddogs.com/previews/2125/mp3/249993_SOUNDDOGS__be.mp3"

running = false
timeLeft = null
timeStarted = null
startedAnyTimer = false
resetAfterLastTimeRunning = false

startbtn.click ->
	if not timeLeft
		timeLeft = +input.val()
	running = true
	startedAnyTimer = true
	resetAfterLastTimeRunning = false
	timeStarted = +new Date
	updateDisplay()

stopbtn.click ->
	running = false
	timeLeft -= (+new Date - timeStarted) / 86400 # convert ms to beats
	updateDisplay()

resetbtn.click -> 
	timeLeft = input.val()
	timeStarted = +new Date
	resetAfterLastTimeRunning = not running
	updateDisplay true


updateDisplay = (live=running) ->
	if live
		liveAmountLeft = timeLeft - ((+new Date - timeStarted) / 86400)
		if liveAmountLeft > 0
			textTimeLeft = liveAmountLeft.toFixed(2)
			textTimeLeft = "0.01" if textTimeLeft is "0.00"
			timeLeftDisplay.text textTimeLeft
		else
			timeLeftDisplay.text ""
			running = false
			timeLeft = 0
			timeStarted = null
			desiredDing.play()

	if not startedAnyTimer
		desc.text "No Timer Started"
	else if timeLeft > 0
		desc.text " Beats Left"
	else
		desc.text "Done!"

	if (not running and timeStarted is null) or resetAfterLastTimeRunning
		startbtn.text "Start"
	else
		startbtn.text "Restart"


setInterval updateDisplay, 100
