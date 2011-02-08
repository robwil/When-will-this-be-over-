-- When will this be over?
-- Simple extension which displays the time when the current media will be finished playing
-- To install, simply put this in the appropriate directory:
-- C:\Program Files\VideoLAN\VLC\lua\extensions\ on Windows;
-- VLC.app/Contents/MacOS/share/lua/extensions/ on Mac OS X;
-- /usr/share/vlc/lua/extensions/ on Linux.
-- Then you simply use it by going to the "View" menu and selecting "When will this be over?"

-- Extension description
function descriptor()
    return { title = "When will this be over?" ;
             version = "1.0" ;
             author = "Rob Williams" ;
             url = 'http://www.robwilliams.me/';
             shortdesc = "Displays the time when the current media will be finished playing";
             description = "Displays the time when the current media will be finished playing" ;
             capabilities = { }
		    }
end

-- Activation hook
function activate()
	-- get elapsed time in seconds
	local input = vlc.object.input()
	local current = vlc.var.get(input, "time")
	-- get duration in seconds
	local duration = vlc.input.item():duration()
	-- calculate hour, minute, second values for remaining time
	local remaining = duration - current
	local remainingHour = math.floor(remaining / 3600)
	local remainingMinute = math.floor((remaining % 3600) / 60)
	local remainingSecond = math.floor(remaining % 60)
	-- get system seconds, minutes, hours
	local systemHour = os.date("%I")
	local systemMinute = os.date("%M")
	local systemSecond = os.date("%S")
	-- add the two together, carrying as needed
	local endingSecond = math.floor((systemSecond + remainingSecond) % 60)
	local endingMinute = math.floor(((systemSecond + remainingSecond) / 60 + (systemMinute + remainingMinute)) % 60)
	local endingHour = math.floor((((systemSecond + remainingSecond) / 60 + (systemMinute + remainingMinute)) / 60 + systemHour + remainingHour) % 12)
	
	-- show the result on the on-screen display (OSD)
	local outputString = string.format("%02d %02d %02d", endingHour, endingMinute, endingSecond)
	vlc.osd.message("Show will be done at " .. outputString,channel1)
	
	-- below undefined function will cause extension to die.
	-- (and thus automatically uncheck it from view menu)
	-- I'm using this UGLY hack because the obvious call to deactivate() doesn't work
	fail()
end

-- Deactivation hook
function deactivate()
    
end

