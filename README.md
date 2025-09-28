# win-regadd
A tool to add registry entries and shortcuts to executables to make them appear in the start menu.

Instructions:
* Run the script
  * You may have to execute it in the windows terminal after using the following command: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` - to **temporarily** change your execution policy for the current process.
* Select the `.exe` of the app you want to do this to
* Enter the name you want to set it to
* Optionally select an icon - if none is selected, itll try to use the `exe`s icon and then fallback to windows' default executable icon.

Works for Windows 7 (or Windows Server 2008 R2 for servers) and later.
