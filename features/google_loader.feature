Feature: Use GoogleLoader
    In order for a user to access google
    They need to connect first
    
    Scenario: Log into Google
        Given a google account from the yaml config
        When GoogleLoader logs in
        Then we should have a GoogleSpreadsheet session
