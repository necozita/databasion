Feature: Run System
  In order for the user to choose what they want to do
  The user should be able to pass in configuration settings
  
  Scenario: User calls google databate with config
    Given there is an actual yaml config file for google
    When the user runs databate for google
    Then Databasion should not fail for google
    
  Scenario: User calls google databate without config
    Given there is no config file for google
    When the user calls databate without config for google
    Then Databasion should fail for google
    
  Scenario: User calls excel databate with config
    Given there is an actual yaml config file for excel
    When the user runs databate for excel
    Then Databasion should not fail for excel

  Scenario: User calls excel databate without config
    Given there is no config file for excel
    When the user calls databate without config for excel
    Then Databasion should fail for excel