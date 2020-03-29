set activeKbdLayout to my getActiveKeyboardLayout() # ->, e.g., "U.S."
set i to 10
repeat until activeKbdLayout is "U.S." or i = 0
	my switchToInputSource("U.S.")
	set i to i - 1
	#log i
	#log activeKbdLayout
	set activeKbdLayout to my getActiveKeyboardLayout() # ->, e.g., "U.S."
end repeat

set EngCounter to 0
set HebCounter to 0
set the Eng_AZ to ";.abcdefghijklmnopqrstuvxyzw,"
set the Heb_AB to "ףץשנבגקכעיןחלךצמםפ/רדאוהסטז'ת'"
set orgclip to (get the clipboard)
log "slecting and copying"
tell application "System Events"
	log "right"
	key code 123 using {command down}
	log "left"
	key code 124 using {command down, shift down}
	log "ctrl C"
	keystroke "c" using {command down}
	delay 0.2
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
	set InputDisLangChomped to "Hebrew-PC"
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

log "selecting END"
tell application "System Events"
	key code 123 using {command down}
	key code 124 using {command down, shift down}
end tell

log "pasting"
tell application "System Events"
	keystroke "v" using {command down}
end tell

log "Setting keyboard to desired lang"
set i to 10
repeat until activeKbdLayout is InputDisLang or i = 0 or activeKbdLayout is InputDisLangChomped
	my switchToInputSource(InputDisLang)
	log "@@@@@@@@@@@@@"
	log InputDisLang
	log "@@@@@@@@@@@@@"
	set i to i - 1
	log i
	log "#############"
	log activeKbdLayout
	log "#############"
	set activeKbdLayout to my getActiveKeyboardLayout() # ->, e.g., "U.S."
end repeat

log "Restoring org clip"
delay 0.2
set the clipboard to orgclip
return "done"

on switchToInputSource(name)
	launch application "System Events"
	delay 0.2
	ignoring application responses
		tell application "System Events" to tell process "TextInputMenuAgent"
			click menu bar item 1 of menu bar 2
		end tell
	end ignoring
	do shell script "killall System\\ Events"
	delay 0.2
	tell application "System Events" to tell process "TextInputMenuAgent"
		tell menu bar item 1 of menu bar 2
			click menu item name of menu 1
		end tell
	end tell
	log "switchToInputSource fin"
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