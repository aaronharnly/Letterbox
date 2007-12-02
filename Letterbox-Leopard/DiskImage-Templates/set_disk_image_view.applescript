-- get the settings from env variables
set dmg_name to system attribute "dmg_name"
set plugin_filename to system attribute "plugin_filename"
set manager_app_filename to system attribute "manager_app_filename"
set background_filename to system attribute "background_filename"
set readme_filename to system attribute "readme_filename"
set releasenotes_filename to system attribute "releasenotes_filename"
set releasenotes_css_filename to system attribute "releasenotes_css_filename"

tell application "Finder"
	-- get the file paths
	set dmg_root to disk dmg_name
	set plugin_file to file plugin_filename of dmg_root
	set readme_file to file readme_filename of dmg_root
	set installer_file to file manager_app_filename of dmg_root
	set background_file to file background_filename of dmg_root
	set releasenotes_file to item releasenotes_filename of dmg_root
	set releasenotes_css_file to item releasenotes_css_filename of dmg_root
	open dmg_root
	
	-- get the window
	set all_windows to every Finder window
	set dmg_window to ""
	repeat with this_window in all_windows
		if (target of this_window is dmg_root) then
			set dmg_window to this_window
		end if
	end repeat
	if (dmg_window is equal to "") then return false
	open dmg_window
	
	-- set the window view prefs
	set dmg_window_options to the icon view options of dmg_window
	tell dmg_window_options
		set arrangement to not arranged
		set icon size to 64
		set shows item info to false
		set shows icon preview to true
		set text size to 11
		set label position to bottom
		set the background picture to background_file
	end tell
	
	-- set the window size
	tell dmg_window
		set toolbar visible to false
		set statusbar visible to false
		set bounds to {100, 100, 500, 450}
	end tell
	
	-- to make sure the window size sticks, we click the zoom button twice
	-- This tip is from http://joemaller.com/2006/07/09/setting-icon-position-and-window-size-on-disk-images/
	tell application "System Events"
		tell process "Finder"
			click button 2 of window 1
			click button 2 of window 1
		end tell
	end tell
	
	-- set the icon positions
	set the position of plugin_file to {85, 60}
	set the position of readme_file to {85, 200}
	set the position of installer_file to {300, 200}
	set the position of background_file to {300, 60}
	if ((exists of releasenotes_file) is true) then
		set the position of releasenotes_file to {200, 200}
	end if
	if ((exists of releasenotes_css_file) is true) then
		set the position of releasenotes_css_file to {250, 100}
	end if
end tell

