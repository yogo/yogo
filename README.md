# Welcome to Yogo

Yogo is a Data Management System built on Ruby on Rails, DataMapper, and Persevere.

## Getting Started with Development

1. Checkout the project:           `git clone http://github.com/yogo/yogo.git`
2. Change directories to the code: `cd yogo`
3. Initialize the environment:     `./setup.sh`
4. Start persevere:                `rake yogo:start`
5. Open http://localhost:3000/ and get the Yogo start page

### Yogo Tasks
- Run `rake yogo:start` to start up persevere and a server.
- Run `rake yogo:stop` to shutdown Yogo and a corresponding persevere adapter.
- Run `rake yogo:open` to start Yogo and open a web browser.
- Run `rake yogo:spec` to run all rspec tests.
- Run `rake yogo:cucumber` to run all feature tests.

The 'yogo' rake tasks manage starting, stopping, and resetting persevere for you.

### Persevere Tasks
- Run `rake persvr:setup` to download and install persevere into vendor/persevere.
- Run `rake persvr:remove` to remove a downloaded and installed persevere from vendor/persevere.
- Run `rake persvr:start` to create and run a persevere instance for the current rails environment.
- Run `rake persvr:stop` to stop the persevere instance for the current environment.
- Run `rake persvr:clear` to reset the persevere instance database to a clean state.
- Run `rake persvr:drop` to drop and destroy the current persevere instance.
- Run `rake -T persvr` to see other persevere related tasks.
