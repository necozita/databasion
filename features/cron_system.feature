Feature: Crontab
    Allow a user to run databasion updates via crontab
    
    Scenario: User configures the Environments spreadsheet
        Given an environment spreadsheet in Google Docs
        When the cron system is ran and the version changes
        Then databasion should have been ran
