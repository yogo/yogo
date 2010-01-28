# Welcome to Yogo

Yogo is a Data Management System built on Ruby on Rails, DataMapper, and Persevere.

## Getting Started with Development

1. Checkout the project:           `git clone http://github.com/yogo/yogo.git`
2. Change directories to the code: `cd yogo`
3. Initialize the environment:     `./setup.sh`
4. Start persevere:                `rake persvr:start`
5. Start the application:          `script/server`

2. Create a config/database.yml file (or copy the example provided in `config/database.yml.start`)
3. Update Git Submodules
    1. `git submodule init`
    2. `git submodule update`
4. Bundle Gems
    1. `gem install bundler`
    2. `gem bundle`
5. Setup Persevere 
    1. install Persevere (see: Setting up Persevere below)
    2. `rake persvr:start`
6. Seed the database with initial data: `rake db:seed`
7. Run the server: `script/server`
8. Go to http://localhost:3000/ and get the Yogo start page

## Submodules Missing?

Stick the following in your .git/config 

    [submodule "vendor/plugins/yogo-authz"]
           url = git://github.com/yogo/yogo-authz.git

Then run: `git submodule update`

## Setting up Persevere

1. Download Persevere 1.0 from: http://persevere-framework.googlecode.com/files/persevere1.0.1.rc2.tar.gz
2. Uncompress and move the Persevere installation to your desired location (`~/persevere`, `/usr/local/persevere`, etc)
3. Make the persvr command (`path_to_persevere/bin/persvr`) accessible by doing one of the following:
    - including the persevere/bin directory in your `PATH` (`export PATH=$PATH:path_to_persevere/bin`)
    - setting the `PERSVR` env variable to the absolute path of the persvr script (`export PERSVR=path_to_persevere/bin/persvr`)
    - setting `PERSEVERE_HOME` to the path of your persevere install (`export PERSEVERE_HOME=path_to_persevere`)

### Persevere Tasks
- Run `rake persvr:start` to create and run a persevere instance for the current rails environment.
- Run `rake persvr:stop` to stop the persevere instance for the current environment.
- Run `rake persvr:clear` to reset the persevere instance database to a clean state.
- Run `rake persvr:drop` to drop and destroy the current persevere instance.
- Run `rake -T persvr` to see other persevere related tasks.




