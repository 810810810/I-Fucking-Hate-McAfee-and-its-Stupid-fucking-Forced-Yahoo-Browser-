Remove McAfee and Reset Chrome Search Engine
This PowerShell script is designed to automatically remove any traces of McAfee software and continuously ensure that Google is set as the default search engine in Chrome. The script runs as a scheduled task, consuming minimal RAM.

Features
Uninstalls all McAfee products.
Removes McAfee-related folders, services, scheduled tasks, and registry entries.
Resets Chrome's search engine to Google.
Runs continuously as a scheduled task, ensuring the changes are enforced.
Prerequisites
Windows 10
PowerShell
Administrator privileges
Usage
Step 1: Save the Script
Step 2: Run said script. 
Step 3: Wait for the scheduled tasks for prevent this non-sense.

BONUS: Change the Batch file in your CPU using the following steps: 
Open Notepad as Administrator:

Press Win + S, type "Notepad", right-click, and select "Run as administrator".
Open the hosts File:

In Notepad, go to File > Open.
Navigate to C:\Windows\System32\drivers\etc\.
Change the file type to "All Files" to see the hosts file.
Select the hosts file and click Open.
Add the Blocking Entry:

At the end of the file, add the following line:
plaintext
Copy code
127.0.0.1 search.yahoo.com
Save the File:

Save the changes (File > Save).

Additional Manual Steps:
Check Installed Programs:

Go to Control Panel > Programs > Programs and Features.
Look for any McAfee-related programs and uninstall them manually.
Clean Registry Entries:

Open the Registry Editor (Win + R, type regedit).
Manually search for and delete any remaining McAfee keys (be cautious and create a backup before making changes).
Use McAfee Removal Tool:

Download and run the McAfee Consumer Product Removal tool (MCPR) from McAfee's official website. This tool is designed to remove all traces of McAfee products from your system.
Download MCPR Tool
Check Browser Extensions/Add-ons:

Open your browsers (Chrome, Firefox, Edge).
Go to the extensions/add-ons menu and manually remove any McAfee or Yahoo-related extensions.
Reset Browser Settings:

For more thorough browser resets, consider using each browser's built-in reset feature:
Chrome: Settings > Advanced > Reset and clean up > Restore settings to their original defaults.
Firefox: Help > Troubleshooting Information > Refresh Firefox.
Edge: Settings > Reset settings > Restore settings to their default values.


Explanation For PS1 Script:
Remove-McAfeeProducts: This function uninstalls McAfee products, removes related folders, services, scheduled tasks, and registry entries.
Reset-ChromeToGoogle: This function modifies the Chrome preferences file to set Google as the default search engine.
Scheduled Task: A scheduled task is created to run a script block continuously, every 300 seconds (5 minutes), to ensure McAfee is removed and Chrome's search engine is set to Google.
