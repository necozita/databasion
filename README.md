# Databasion

## Google Spreadsheet/Excel -> YAML -> Ruby Migration -> Database Management Tool

If we were all part of a hive mind, we wouldn't need management anything.  Databases would get built, the correct columns would get used, programmers would align their ORMs, and keeping it all together wouldn't be some kind of management nightmare.

Fortunately we aren't a hive mind (and if we were I would be just as confused as I am any other day, our office's main language is Japanese).  Still, even though my coworkers can't read my mind, we've come up with a tool that allows top end planners to describe system data in a spreadsheet, programmers to fudge in the column types, sizes, and database relationships, and everyone to export it out into YAML and Ruby migration scripts which update your infrastructure.  Ideally the fully automated suite is used in your test environment so your planner can quickly test changes, and a step by step process used if you are updating production machines.

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

| spreadsheet | database| username| password| adapter| host     | port| options
|:------------|:--------|:--------|:--------|:-------|:---------|:----|:-------
| superheroes | db1     | dbuser  | dbuser  | mysql  | 127.0.0.1|     |        

The options column currently support's _force_, which tells the database to drop and recreate the table.

Next we define the actual table spreadsheets.

### Superheroes

| column0  |             |              |                    
|:---------|:------------|:-------------|:-------------------
|          |             |              |                    
| comment  |             |              |                    
| table    | superheroes |              |                    
| field    | id          | name         | power              
| type     | integer     | string, 20   | string, 20, Wimp   
|          | 1           | Brian Jones  | Ruby Hacker        
|          | 2           | Superman     | Invincible         
|          | 3           | Batman       | Rich               

### Keywords

* table - The name of the table, and an optional comma delimited 'false' if the table name should not be auto-pluralized.
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

Row0 is another reserved space.  If any text is written in a column (with the exception of column0), that column will be ignored.  This is useful for editing out columns that one doesn't currently want in the database.

## Usage
    
Setup the project space.    
    
    databasion --create project
    cd project

Edit _config/google.yml_.  Then run the scripts.

    databasion --system google
    databasion --migrate
    
Or run them both in order.

    databasion --system google --migrate
    
You can supply a different config path as well.

    databasion -s google -m --config config/my.other.config.yml
    
### YAML Configuration

#### Google

* _login_: A valid Google username and password.
* _sheets_: A list of the keys gleaned from the Google Docs URL, and a human readable name.
* _output_: Where to output the relevant data.

## Roadmap

__0.0.2__

* Add ability to read existing tables, and make relative alter table migration scripts.

__0.0.1__

* <del>Write this documentation.</del>
* <del>Add table name specification.</del>
* <del>Add database level table relationships.</del>
* <del>Spit out ActiveRecord Models for migrations.</del>
* <del>Create Ruby migration script.</del> Still needs polished.
* <del>Add ability to read and update existing data.</del>
* <del>Build a command line tool.</del>
* Add logging.

## Testing

Currently Databasion uses the cucumber test suite.  Any patches or pull requests must have a corresponding Feature, and all tests must pass.  Feature branches get bonus points.

## Author

__Brian Jones__ - Server Engineer, [Istpika](http://www.istpika.com)

* Work: <brian.jones@istpika.com>
* Personal: <mojobojo@gmail.com>
