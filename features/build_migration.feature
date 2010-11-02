Feature: Build Ruby Migrations
    In order to run ruby migrations
    We must build a file suite
    
    Scenario: Build Ruby Migrations
        Given a set of YAML data
        When we run the BuildMigration system
        Then it should build a migration, model, and database file
