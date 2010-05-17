Feature: Convert parsed hash into YAML
  In order to convert the higher level into YAML
  We need to process it and write it out to files
  
  Scenario: Google passes data
    Given a chunk of google data
    When we parse it
    Then it should create a relevant YAML file