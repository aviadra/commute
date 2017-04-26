set activeKbdLayout to my getActiveKeyboardLayout() # ->, e.g., "U.S."
if activeKbdLayout is not "U.S." then
	my switchToInputSource("U.S.")
	log "stwitched to US"
	delay 1
else
	log "was already US"
end if
set EngCounter to 0
set HebCounter to 0
set the Eng_AZ to "abcdefghijklmnopqrstuvxyz,w"
set the Heb_AB to "שנבגקכעיןחלךצמםפ/רדאוה׳סטזת"
set orgclip to (get the clipboard)
delay 0.2
log "slecting and copying"
tell application "System Events"
	log "right"
	key code 123 using {command down}
	log "left"
	key code 124 using {command down, shift down}
	log "ctrl C"
	keystroke "c" using {command down}
	delay 0.5
end tell

log "this_text from clip"
set this_text to (get the clipboard as text)
log "start of loop wat lang"
repeat with aCharacter in this_text
	if (offset of aCharacter in Eng_AZ) is not 0 then
		set EngCounter to EngCounter + 1
	else
		set HebCounter to HebCounter + 1
	end if
end repeat
log "found HebCounter: " & HebCounter & " and EngCounter:" & EngCounter

if EngCounter is greater than HebCounter then
	log "need to revers ENG to HEB"
	set WantedLang to Heb_AB
	set DisWantedLang to Eng_AZ
	set InputDisLang to "Hebrew - PC"
else
	log "need to revers HEB to ENG"
	set WantedLang to Eng_AZ
	set DisWantedLang to Heb_AB
	set InputDisLang to "U.S."
end if
log "WantedLang:" & WantedLang & " and DisWantedLang:" & DisWantedLang
log "start of loop reverse"
set the new_text to ""
repeat with this_char in this_text
	set x to the offset of this_char in the DisWantedLang
	if x is not 0 then
		set the new_text to (the new_text & character x of the WantedLang) as string
	else
		set the new_text to (the new_text & this_char) as string
	end if
end repeat

set the new_text to replace_chars(new_text, "'", "w")

log "Setting clip"
set the clipboard to {text:(new_text as string), Unicode text:new_text}
delay 0.1
log "slecting END"
tell application "System Events"
	key code 123 using {command down}
	key code 124 using {command down, shift down}
end tell

log "pasting"
tell application "System Events"
	keystroke "v" using {command down}
end tell
log "switching lang"
#tell application "System Events" to keystroke space using control down
my switchToInputSource(InputDisLang)
log "Restoring org clip"
delay 2
set the clipboard to orgclip
return "done"



on switchToInputSource(name)
	tell application "System Events" to tell process "SystemUIServer"
		
		tell (1st menu bar item of menu bar 1 whose description is "text input") to {click, click (menu 1's menu item name)}
		
	end tell
end switchToInputSource


on getActiveKeyboardLayout()
	
	# Surprisingly, using POSIX-style paths (even with '~') works with 
	# the `property list file` type.
	set plistPath to "~/Library/Preferences/com.apple.HIToolbox.plist"
	
	# !! First, ensure that the plist cache is flushed and that the
	# !! *.plist file contains the current value; simply executing
	# !! `default read` against the file - even with a dummy
	# !! key - does that.
	try
		do shell script "defaults read " & plistPath & " dummy"
	end try
	
	tell application "System Events"
		
		repeat with pli in property list items of ¬
			property list item "AppleSelectedInputSources" of ¬
			property list file plistPath
			# Look for (first) entry with key "KeyboardLayout Name" and return
			# its value.
			# Note: Not all entries may have a 'KeyboardLayout Name' key, 
			# so we must ignore errors.
			try
				return value of property list item "KeyboardLayout Name" of pli
			end try
		end repeat
		
	end tell
end getActiveKeyboardLayout

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

#sudnv
#what if i wanted heb