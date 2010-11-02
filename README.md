# Databasion

## Google Spreadsheet/Excel -> YAML -> Ruby Migration -> Database Management Tool

A database management tool.  The theory is that a designer/planner can edit application data and a programmer can setup the database and it's fields, all in one happy little place.  As tables are added and data is changed, if the script is run once again it will update the target database.

TODO: While this system uses Rails Migrations, it isn't taking full advantage of them (i.e. tracking changes, allowing for rollbacks, etc.).  This was also created under a high pressure timeline, so it was unfortunate that I could not create a fully working test suite.

## Requirements

### Ruby

* Ruby >= 1.8.7

### Gems  

* ActiveRecord >= 2.3.5
* ActiveSupport >= 2.3.5
* Google Spreadsheet >= 0.1.1
* Spreadsheet >= 0.6.4.1

## Installation

### Install

    sudo gem install databasion
    
## Spreadsheet Conventions

None of this would really work if there weren't some conventions in place.  The following explains how the worksheet needs to be formatted, how the data spreadsheets themselves needs to be formatted, what fields are required, and what fields can be ignored.

At the highest level there needs to be a worksheet named _Database_.  This is simply a master list of related spreadsheets, and what database they correspond to (for split table designs).  The column names are required.

### Database

| spreadsheet | dbname| database| username| password| adapter| host     | port| options
|:------------|:------|:--------|:--------|:--------|:-------|:---------|:----|:-------
| superheroes | db1   | db_test | dbuser  | dbuser  | mysql  | 127.0.0.1|     |        

The options column currently support's _force_, which tells the database to drop and recreate the table.

Next we define the actual table spreadsheets.

### Superheroes

| column0  |             |              |                    
|:---------|:------------|:-------------|:-------------------
| ignore   |             |              |                    
| comment  |             |              |                    
| table    | superheroes |              |                    
| index    | yes         |              |
| field    | id          | name         | power              
| type     | integer     | string, 20   | string, 20, Wimp   
|          | 1           | Brian Jones  | Ruby Hacker        
|          | 2           | Superman     | Invincible         
|          | 3           | Batman       | Rich               

### Keywords

* ignore - Anything written in this column will cause this column and it's data to be ignored.
* table - The name of the table, and an optional comma delimited 'false' if the table name should not be auto-pluralized.
* index - If something is written in a columns field here, it will get flagged as an index and created via add_index(table, [fields]).
* field - The name of the table column.
* type  - A comma delimited list giving the type of the column (using Ruby migration terms), optional size, and optional default value.

Note: If an 'id' column is specified, then it is assumed the id's are supplied by hand.  Auto-incrementation is disabled, and 'id' is the primary key.

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

### Columns

Currently column0 is reserved for keywords and comments.

If something besides a keyword is written in column0, that row is ignored and will not be used.  This is useful if you need to edit out some data.

### Rows

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
    
Or run them all in order.

    databasion --google --migrate --load --git
    
You can supply a different config path as well.

    databasion -g -m -l -i --config config/my.other.config.yml
    
Someone administrating a production database with this tool would definitely want to run each script sequentially by hand.
    
### YAML Configuration

#### Google

* _login_: A valid Google username and password.
* _sheets_: A list of the keys gleaned from the Google Docs URL, and a human readable name.
* _output_: Where to output the relevant data.
* _svn_: SVN configuration data.
* _git_: GIT configuration data.

## SVN

If the currently created databasion project is committed to SVN, running the _--svn_ switch will auto-add and commit all the project files.  This is useful for maintaining version control of the system, especially if something goes wrong and you need to do a rollback.

## GIT

Much like SVN, if the project is commited to a GIT repo, the _--git_ switch will auto-add and commit all the project files.  If there isn't a repository, it will also initialize a new one for you.

## Roadmap

Long and winding.

## Testing

Currently Databasion uses the cucumber test suite.  The tests aren't complete, unfortunately.

## Author

__Brian Jones__ - Server Engineer, [Istpika](http://www.istpika.com)

* Work: <brian.jones@istpika.com>
* Personal: <mojobojo@gmail.com>
