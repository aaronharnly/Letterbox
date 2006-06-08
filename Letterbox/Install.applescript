-- Simple installer for "Letterbox" plugin for Mail.app.
-- Send suggestions, bug reports, praise, and cookies to
-- letterbox@
--                software.harnly.net
-- copyright 2006 Aaron Harnly

property mail_folder_subpath : "Library:Mail:"
property plugins_folder_name : "Bundles"
property plugin_filename : "Letterbox.mailbundle"

property announce_intro : "Welcome to the Letterbox plugin installer."
property announce_quit_mail_warning : return & " ** I will have to quit Mail to install. ** " & return
property announce_prompt : "Shall I install the plugin?"

property install_success : "Letterbox is activated. " & return & "To remove (if you must!), run the installer again and choose 'Uninstall', or simply remove the plugin from ~/Library/Mail/Bundles"
property uninstall_success : "Letterbox has been removed."

global debug

set debug to true

do_announce()

return debug

-- ------- do_announce is the main control sequence ----------
on do_announce()
	-- prepare the installation dialog
	set announce_text to announce_intro
	set mail_is_already_running to my is_app_running("Mail")
	
	if (mail_is_already_running) then set announce_text to announce_text & announce_quit_mail_warning
	set announce_text to announce_text & announce_prompt
	
	-- show the dialog & let the user choose the action
	set install_choice_record to display dialog announce_text buttons {"Cancel", "Uninstall", "Install"} default button "Install"
	set install_choice to the button returned of install_choice_record
	
	-- if the user chooses "Cancel", the installer stops immediately.
	-- the next sequence depends upon what the user chooses, and whether Mail.app is already running
	
	if (mail_is_already_running) then
		do_quit()
		delay 5
	end if
	
	if the install_choice is "Uninstall" then
		my do_uninstall()
		if (mail_is_already_running) then
			my do_launch()
			tell application "Mail" to display dialog uninstall_success
		else
			display dialog uninstall_success
		end if
	else if the install_choice is "Install" then
		my do_defaults()
		my do_install()
		if (mail_is_already_running) then
			my do_launch()
			delay 5
			my do_show_message_pane()
			tell application "Mail" to display dialog install_success
		else
			display dialog install_success
		end if
	end if
	
end do_announce

-- ----- common to both install & uninstall ----------
on do_quit()
	tell application "Mail" to quit
end do_quit

on do_launch()
	tell application "Mail"
		launch
	end tell
end do_launch


-- ------------- Installation --------------------

on do_defaults()
	do shell script "defaults write com.apple.mail EnableBundles -bool true"
	do shell script "defaults write com.apple.mail BundleCompatibilityVersion 2"
end do_defaults

on do_install()
	tell application "Finder"
		-- first make sure the destination folder exists
		my create_folder_if_needed(plugins_folder_name, my get_mail_folder())
		-- remove old version if it exists		
		my remove_item_from_folder("MailWidescreen.mailbundle", my get_destination_folder())
		-- then copy!
		my install_item_into_folder(plugin_filename, my get_source_folder(), my get_destination_folder())
	end tell
end do_install

on do_create_plugin_folder_if_needed()
end do_create_plugin_folder_if_needed

on do_show_message_pane()
	tell application "Mail"
		set message_viewer to message viewer 1
		tell message_viewer to set preview pane is visible to true
	end tell
end do_show_message_pane
-- ------------- Uninstallation --------------------

on do_uninstall()
	my remove_item_from_folder(plugin_filename, my get_destination_folder())
end do_uninstall


-- ------- utilities ----------------
on create_folder_if_needed(folder_name, container_folder)
	tell application "Finder"
		if folder folder_name of (container_folder as alias) exists then
			-- do nothing
		else
			-- create it!
			make new folder at (container_folder as alias) with properties {name:folder_name}
		end if
	end tell
end create_folder_if_needed

on install_item_into_folder(item_name, source_folder, destination_folder)
	tell application "Finder"
		duplicate ((source_folder & item_name as text) as alias) to (destination_folder as alias) with replacing
	end tell
end install_item_into_folder

on remove_item_from_folder(item_name, target_folder)
	tell application "Finder"
		if item item_name of (target_folder as alias) exists then
			-- remove it!
			move item item_name of (target_folder as alias) to the trash
		else
			-- do nothing
		end if
	end tell
end remove_item_from_folder


on is_app_running(appname)
	tell application "System Events"
		set running_processes to the name of every application process
		if running_processes contains appname then
			return true
		else
			return false
		end if
	end tell
end is_app_running

on get_source_folder()
    tell application "Finder"
	set container_path to (the container of (the path to me) as text)
    end tell
    return container_path
end get_source_folder

on get_mail_folder()
	return ((path to the home folder as text) & mail_folder_subpath as text)
end get_mail_folder

on get_destination_folder()
	return (my get_mail_folder() & plugins_folder_name as text)
end get_destination_folder

on get_plugin_to_install()
	return (my get_source_folder() & plugin_filename as text)
end get_plugin_to_install

on get_installed_plugin()
	return (my get_destination_folder() & plugin_filename as text)
end get_installed_plugin

