# Remove McAfee and set Chrome search engine to Google

# Function to remove McAfee products
function Remove-McAfeeProducts {
    $mcafeeProducts = @(
        "McAfee Security Scan Plus",
        "McAfee WebAdvisor",
        "McAfee LiveSafe",
        "McAfee Total Protection",
        "McAfee AntiVirus Plus",
        "McAfee Internet Security",
        "McAfee Small Business Security"
    )
    foreach ($product in $mcafeeProducts) {
        $app = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%$product%'"
        if ($app) {
            Write-Output "Uninstalling $product..."
            $app.Uninstall() | Out-Null
        }
    }

    $mcafeeFolders = @(
        "$env:ProgramFiles\McAfee",
        "$env:ProgramFiles (x86)\McAfee",
        "$env:ProgramData\McAfee",
        "$env:AppData\Local\McAfee",
        "$env:AppData\Roaming\McAfee"
    )
    foreach ($folder in $mcafeeFolders) {
        if (Test-Path $folder) {
            Write-Output "Removing folder $folder..."
            Remove-Item -Recurse -Force $folder
        }
    }

    $mcafeeServices = Get-Service | Where-Object { $_.DisplayName -like "McAfee*" }
    foreach ($service in $mcafeeServices) {
        Write-Output "Stopping and removing service $($service.DisplayName)..."
        Stop-Service $service.Name -Force
        Set-Service $service.Name -StartupType Disabled
        sc.exe delete $service.Name | Out-Null
    }

    $mcafeeTasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "McAfee*" }
    foreach ($task in $mcafeeTasks) {
        Write-Output "Deleting scheduled task $($task.TaskName)..."
        Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false
    }

    $mcafeeRegKeys = @(
        "HKLM:\SOFTWARE\McAfee",
        "HKLM:\SOFTWARE\WOW6432Node\McAfee",
        "HKCU:\SOFTWARE\McAfee"
    )
    foreach ($key in $mcafeeRegKeys) {
        if (Test-Path $key) {
            Write-Output "Removing registry key $key..."
            Remove-Item -Recurse -Force $key
        }
    }
}

# Function to reset Chrome search engine to Google
function Reset-ChromeToGoogle {
    $chromePreferencesPath = "$env:LocalAppData\Google\Chrome\User Data\Default\Preferences"
    if (Test-Path $chromePreferencesPath) {
        $chromePreferences = Get-Content $chromePreferencesPath -Raw | ConvertFrom-Json
        $chromePreferences.search_provider.search_url = "https://www.google.com/search?q={searchTerms}"
        $chromePreferences.search_provider.name = "Google"
        $chromePreferences.search_provider.keyword = "google.com"
        $chromePreferences.search_provider.suggest_url = "https://www.google.com/complete/search?output=toolbar&q={searchTerms}"
        $chromePreferences.search_provider.instant_url = "https://www.google.com/instant?query={searchTerms}"
        $chromePreferences.search_provider.image_url = "https://www.google.com/search?hl=en&tbm=isch&q={searchTerms}"
        $chromePreferences.search_provider.new_tab_url = "https://www.google.com/_/chrome/newtab"
        $chromePreferences.default_search_provider_data = $chromePreferences.search_provider
        $chromePreferences.default_search_provider_id = "google"
        $chromePreferences | ConvertTo-Json -Compress | Set-Content $chromePreferencesPath
    }
}

# Scheduled Task script
$scriptBlock = {
    while ($true) {
        try {
            Remove-McAfeeProducts
            Reset-ChromeToGoogle
        } catch {
            Write-Error "Error in execution: $_"
        }
        Start-Sleep -Seconds 300
    }
}

# Create a scheduled task to run this script continuously
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-NoProfile -WindowStyle Hidden -Command $scriptBlock"
$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -TaskName "RemoveMcAfeeAndResetChrome" -Description "Remove McAfee and reset Chrome search engine to Google"

Write-Output "Scheduled task 'RemoveMcAfeeAndResetChrome' has been created and will run at startup."
