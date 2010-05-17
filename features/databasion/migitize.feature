Feature: Parse YAML into Ruby migrations
  In order to run Ruby migrations
  We must build the migrations from YAML
  
  Scenario: Build Ruby migrations
    Given a complete set of YAML definitions
    When the YAML files are parsed
    Then the result is Ruby migration files