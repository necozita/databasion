Feature: Create Project
    In order to run databasion
    A project directory should be built
    
    Scenario: User runs databasion with the --create command
        Given a project named test_project
        When the databasion create command is ran
        Then a project folder and config file should exist
