# Databasion

## Google Spreadsheet/Excel -> YAML -> Ruby Migration -> Database Management Tool

A database management tool.  The theory is that a designer/planner can edit application data while a programmer setups up the database schema and it's fields, all in one happy little place.  As tables are added and data is changed, if the script is run once again it will update the target database.

TODO: While this system uses Rails Migrations, it isn't taking full advantage of them (i.e. tracking changes, allowing for rollbacks, etc).

NOTE: The system is currently undergoing major changes, and will not remain backwards compatible up until roughly a 0.9 release.

## Requirements

### Ruby

* Ruby >= 1.8.7

### Gems  

* ActiveRecord >= 2.3.5
* ActiveSupport >= 2.3.5
* Google Spreadsheet >= 0.1.2
* Spreadsheet >= 0.6.4.1
* Composite Primary Keys >= 3.0.9

## Installation

### Install

    sudo gem install databasion
    
## Spreadsheet Conventions

None of this would really work if there weren't some conventions in place.  The following explains how the worksheet needs to be formatted, how the data spreadsheets themselves needs to be formatted, what fields are required, and what fields can be ignored.

### Environment and Version Control

In order to manage your _environments_ and _versions_ of the data for each environment, an __Environments__ spreadsheet is required.

#### Keywords

Row0 is reserved for keywords, which are listed below.

* environment - Defines your environment.  These follow the standard _development, test, production_ breakdown.  Anything outside of these three are considered special case environments.
* version - The current version this environment is at in regards to the databasion spreadsheet.  This is also used for auto-updates via crontab.

A typical spreadsheet might look like the following.

| environment | version
|:------------|:-------
| development |      50
| test        |      49
| production  |      45
| brian_test  |      55
| bojo_test   |      50

Versions are tracked by a locally written version file when databasion is ran with the _--cron_ switch.

You will also need to create spreadsheets named after the typical _development, test, production_ keywords as listed in the Environments spreadsheet.  Within each spreadsheet, database descriptions need to be defined as written below.  The column names are required.

Note: Non-standard environments can also be created, however, they are treated as special case and not part of the environment chain.

### Example 'Development' Spreadsheet

| spreadsheet | dbname| database| username| password| adapter| host     | port| options
|:------------|:------|:--------|:--------|:--------|:-------|:---------|:----|:-------
| superheroes | db1   | db_test | dbuser  | dbuser  | mysql  | 127.0.0.1|     |        

The options column currently supports any SQL commands that can typically be passed to a Rails Migration.

Next we define the actual table spreadsheets.

### Example 'Superheroes' Table

| column0  |             |              |                    | 
|:---------|:------------|:-------------|:-------------------|:--------
| ignore   |             |              |                    | testing
| comment  |             |              |                    |
| table    | superheroes |              |                    |
| index    | yes         |              |                    |
| field    | id, primary | name         | power              | cape 
| type     | integer     | string, 20   | string, 20, Wimp   | boolean
|          | 1           | Brian Jones  | Ruby Hacker        | false
|          | 2           | Superman     | Invincible         | true
|          | 3           | Batman       | Rich               | true
| testing  | 4           | Hulk         | Huge               | false

### Table Spreadsheet Keywords

* ignore - Anything written in this column will cause this column and it's data to be ignored, with the exception of _environment names_.  See the Environment and Version Control section below for further usage.
* comment - Ideally a description of the field, what the values means, etc.
* table - The name of the table, and an optional comma delimited 'false' if the table name should not be auto-pluralized.
* index - This will create an index on the designated field.  If a multi-index is required, indices will be grouped by unique names.  Multiple multi-indices are possible.
* field - The name of the table column, with an optional comma delimited 'auto' or 'primary' parameter.  Auto is strictly limited to an 'id' field, and enables auto incrementation.  At least one field _must_ be labeled 'primary' or 'auto', otherwise the system will bail while trying to build that table.
* type  - A comma delimited list giving the type of the column (using Ruby migration terms), optional size, and optional default value.

__Ruby Migration Types__

* binary
* boolean
* date
* datetime
* decimal
* float
* integer
* string
* text
* time
* timestamp

#### Columns

Currently column0 is reserved for keywords and comments.

If something besides a keyword is written in column0, that row is ignored and will not be used.  This is useful if you need to edit out some data.

#### Rows

Row0 isn't technically reserved, but should ideally be saved for use with the _ignore_ flag.  If any text is written in a column (with the exception of column0), that column will be ignored.  This is useful for editing out columns that one doesn't currently want in the database.

## Usage
    
Setup the project space.    
    
    databasion --create project
    cd project

Edit _config/google.yml_.  Then run the scripts.

    databasion --google
    databasion --migrate
    databasion --load
    databasion --svn
    databasion --git
    databasion --cron
    databasion --env
    
Or run them all in order.

    databasion --google --migrate --load --git --env development
    
You can supply a different config path as well.

    databasion -g -m -l -i --config config/my.other.config.yml
    
The environment switch defaults to _development_.
    
### YAML Configuration

#### Google

* _login_: A valid Google username and password.
* _sheets_: A list of the keys gleaned from the Google Docs URL, and a human readable name.
* _output_: Where to output the relevant data.
* _svn_: SVN configuration data.
* _git_: GIT configuration data.
* _cron_: Crontab parameters.

## SVN

If the currently created databasion project is committed to SVN, running the _--svn_ switch will auto-add and commit all the project files.  This is useful for maintaining version control of the system, especially if something goes wrong and you need to do a rollback.

## GIT

Much like SVN, if the project is commited to a GIT repo, the _--git_ switch will auto-add and commit all the project files.  If there isn't a repository, it will also initialize a new one for you.

## Keyword Environment Management (Currently not implemented)

Keywords are also supported in the _ignore_ columns and rows of table definitions.  This allows us to not inadvertently add columns or data to systems which aren't configured to use them yet.  The following is an example.

 | column0      |             |              |                    |         |                       
 |:-------------|:------------|:-------------|:-------------------|:--------|:----------------------
 | ignore       |             |              |                    | test    | brian_test, bojo_test
 | comment      |             |              |                    |         |                       
 | table        | superheroes |              |                    |         |                       
 | index        | yes         |              |                    |         |                       
 | field        | id, primary | name         | power              | cape    | mask                  
 | type         | integer     | string, 20   | string, 20, Wimp   | boolean | boolean               
 |              | 1           | Brian Jones  | Ruby Hacker        | false   | false                 
 |              | 2           | Superman     | Invincible         | true    | false                 
 |              | 3           | Batman       | Rich               | true    | true                  
 | brian_test   | 4           | Hulk         | Huge               | false   | false                 
 | brian_test   | 5           | Spawn        | Demonic            | true    | true                  
 
Environments are updated in the following order:  development -> test -> production.  Special case environments are ignored with the exception of themselves.
 
The above definition states that the _cape_ field should only be deployed _up to test_, and no further.  The _mask_ field should *only* be deployed to both brian_test and bojo_test since they are not common environment names.  Everything else will be updated clear up to production.

It also follows that the field with the id's 4 and 5 should only be deployed to brian_test.

### Version Control

There is now a system in place to do crontab driven auto-updates.  This allows the data to be updated without anyone having to access any systems.

First update _config/google.yml_'s environment section to reflect your project settings for each given environment.  The _options_ are standard databasion switches.

Next, add an entry for your environment in the _Environments_ spreadsheet, along with the starting version number.  When using this to manage the project, if the number is higher than before then the system will be updated.  Currently version controlled rollbacks are not implemented.

Finally, add the databasion script to crontab.

Example crontab:

    */1 * * * * cd /home/my_user/project && databasion -r -e test
    
This checks the Environment spreadsheet once a minute, and if the version for the target system (test in this case) has changed, runs databasion with the supplied options.

Note:  This could easily be used from the commandline as well, and not just crontab.

## Planned Features

Plugins - It would be nice to be able to build plugin support so people can do pre/post processing of the data, and/or export out to other formats besides YAML, etc.  I also plan on designing this in such a way so that it isn't strictly RDMBS centric.

## Testing

Currently Databasion uses the cucumber test suite.  A functional set of rudimentary tests are currently available, but it does not test everything 100%.

## Author

__Brian Jones__ - Server Engineer, [Istpika](http://www.istpika.com)

* Work: <brian.jones@istpika.com>
* Personal: <mojobojo@gmail.com>

Twitter: [mojobojo](http://twitter.com/mojobojo) - If you are using databasion give me a shoutout, I'm curious to see who is using this system.
