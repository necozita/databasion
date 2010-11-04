Feature: Crontab
    Allow a user to run databasion updates via crontab
    
    Scenario: User configures the Version spreadsheet
        Given a version spreadsheet in Google Docs
        When the cron system is ran and the version changes
        Then databasion should have been ran
