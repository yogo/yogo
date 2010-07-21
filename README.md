# Welcome to Yogo

Yogo is a Data Management System built on Ruby on Rails, DataMapper, and Persevere.

## Getting Started with Development

1. Checkout the project:           `git clone http://github.com/yogo/yogo.git`
2. Change directories to the code: `cd yogo`
3. Initialize the environment:     `./setup.sh`
4. Start persevere:                `rake persvr:start`
5. Add example data if desired:    `rake yogo:db:example:load`
6. Start the application:          `script/server`
7. Go to http://localhost:3000/ and get the Yogo start page

### Persevere Tasks
- Run `rake persvr:setup` to download and install persevere into vendor/persevere.
- Run `rake persvr:remove` to remove a downloaded and installed persevere from vendor/persevere.
- Run `rake persvr:start` to create and run a persevere instance for the current rails environment.
- Run `rake persvr:stop` to stop the persevere instance for the current environment.
- Run `rake persvr:clear` to reset the persevere instance database to a clean state.
- Run `rake persvr:drop` to drop and destroy the current persevere instance.
- Run `rake -T persvr` to see other persevere related tasks.

### Yogo Tasks
- Run `rake yogo:start` to start up persevere and a server.
- Run `rake yogo:stop` to shutdown Yogo and a corresponding persevere adapter.
- Run `rake yogo:open` to start Yogo and open a web browser.
- Run `rake yogo:spec` to run all rspec tests.
- Run `rake yogo:cucumber` to run all feature tests.

The 'yogo' rake tasks manage starting, stopping, and resetting persevere for you.

### Changelog
0.9.5 2010-07-21
 - Many UI updates
 - Updating the search function to search over all fields except dates
 - Fix loading settings from the database
 
0.9.4 2010-07-09
 - Added in complete support for projects to have users and groups
 - Updated the look and feel
 - Branched yogo into a stable and development (master) branch
 

0.9.3 2010-07-02
 - Improved pagination
 - Improved csv downloading
 - Bumped the required dm-persevere gem version
 
0.9.2 2010-06-24
 - Bumped the required dm-reflection gem version
