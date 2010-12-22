### 0.2.3
* [FIXED] JSON-like data wasn't being properly formatted in the yaml_builder, resulting in the system bailing.

### 0.2.2
* [FIXED] Template newline bug.

### 0.2.1
* [FIXED] Tables without an 'id' field weren't updating via the load command and bailing, a dramatic oversight on my part.  Databasion now includes the composite primary keys gem for ActiveRecord, and correctly drops and loads master data now.

### 0.2.0

* [FIXED] Fields flagged with an index were not properly referenced.
* [FIXED] Default field values are now correctly inserted into database.
* [CHANGE] There is now an Environment spreadsheet to define environments, and each environment replaces the old Database spreadsheet.  Databasion data is also broken down by directory, named after the relevant environment.  Specific environments are called with the new -e switch.
* [CHANGE] If an id field is assigned as "id, auto" then it will be set as an auto incrementing primary key, and all other primary keys are ignored.
* [NEW] Version control is now handled in the Environment spreadsheet, and works via the -r switch.  Ideal for near-realtime updates using crontab.
* [NEW] Multiple primary keys can now be assigned by adding a comma delimited _primary_ to a field.
* [NEW] The _options_ field in a spreadsheet environment definition now works according to the Rails Migration rules.
