Feature: Use Googlize
  In order for a user to access google
  They need to connect first
    
  Scenario: Log into Google
    Given a google account
    When Googlize logs in
    Then we should have a GoogleSpreadsheet session
    
  Scenario: Run system with config
    Given a google yaml config
    When Googlize starts up
    Then Googlize should not fail