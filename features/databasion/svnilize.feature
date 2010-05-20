Feature: SVN Auto Commit
  In order to save files in SVN
  We need a system that runs the commands for us
  
  Scenario: A typical auto commit
    Given a databasion created file structure
    When the commit command is ran
    Then the data should be stored in SVN