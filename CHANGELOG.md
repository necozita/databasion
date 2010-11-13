### 0.2.0

* [FIXED] Fields flagged with an index were not properly referenced.
* [CHANGE] There is now an Environment spreadsheet to define environments, and each environment replaces the old Database spreadsheet.  Databasion data is also broken down by directory, named after the relevant environment.  Specific environments are called with the new -e switch.
* [NEW] Version control is now handled in the Environment spreadsheet, and works via the -r switch.  Ideal for near-realtime updates using crontab.
* [NEW] Multiple primary keys can now be assigned by adding a comma delimited _primary_ to a field.
* [NEW] The _options_ field in a spreadsheet environment definition now works according to the Rails Migration rules.
