# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

begin

  print 'Creating default settings...'
  Setting.create(:name => 'local_only', :value => false)
  Setting.create(:name => 'asset_directory', :value => 'yogo_assets')
  Setting.create(:name => 'anonymous_user_name', :value => 'anonymous')
  Setting.create(:name => 'allow_api_key', :value => true)
  Setting.create(:name => 'api_key_name', :value => 'api_key')
  puts 'done.'

  print 'Creating System Roles...'
  user_role = SystemRole.create(:name => 'User', :description => 'Default user in the system',
                                :actions => ["project$retrieve"])
  user_role.move(:to => 1)
  project_manager_role = SystemRole.create(:name => 'Project Manager', :description => 'Able to create projects',
                                     :actions => ["project$retrieve", "project$update", "role$retrieve", "user$retrieve", "role$retrieve"])
  project_manager_role.move(:to => 2)
  sys_admin = SystemRole.first_or_new(:name => 'Administrator', :description => 'System role for Administrators',
                                      :actions => SystemRole.available_permissions)
  sys_admin.move(:to => 3)
  puts 'Done.'

  print 'Creating Users...'
  User.create(:login => 'yogo', :email => "nobody@home.com", :first_name => "System", :last_name => "Administrator", :password => 'change me', :password_confirmation => 'change me', :system_role => sys_admin)
  User.create(:login => 'test', :email => "test@user.org",   :first_name => "Test",   :last_name => "User",          :password => "VOEISdude", :password_confirmation => "VOEISdude", :system_role => user_role)

  User.create(:login => "alice.jones",       :email => "alice.jones@eku.edu",               :first_name => "Alice",    :last_name => "Jones",      :password => "jonesa",     :password_confirmation => "jonesa",       :system_role => project_manager_role)
  User.create(:login => "andy.hansen",       :email => "hansen@montana.edu",                :first_name => "Andy",     :last_name => "Hansen",     :password => "hansena",    :password_confirmation => "hansena",      :system_role => project_manager_role)
  User.create(:login => "barbara.kucera",    :email => "bakuce2@uky.edu",                   :first_name => "Barbara",  :last_name => "Kucera",     :password => "kucerab",    :password_confirmation => "kucerab",      :system_role => project_manager_role)
  User.create(:login => "bill.ford",         :email => "wiford2@uky.edu",                   :first_name => "Bill",     :last_name => "Ford",       :password => "fordb",      :password_confirmation => "fordb",        :system_role => project_manager_role)
  User.create(:login => "bob.crabtree",      :email => "crabtree@yellowstoneresearch.org",  :first_name => "Bob",      :last_name => "Crabtree",   :password => "crabtreeb",  :password_confirmation => "crabtreeb",    :system_role => project_manager_role)
  User.create(:login => "bob.madsen",        :email => "bmadsen@cdkc.edu",                  :first_name => "Bob",      :last_name => "Madsen",     :password => "madsenb",    :password_confirmation => "madsenb",      :system_role => project_manager_role)
  User.create(:login => "bonnie.ellis",      :email => "bonnie.ellis@umontana.edu",         :first_name => "Bonnie",   :last_name => "Ellis",      :password => "ellisb",     :password_confirmation => "ellisb",       :system_role => project_manager_role)
  User.create(:login => "brian.mcglynn",     :email => "bmcglynn@montana.edu",              :first_name => "Brian",    :last_name => "McGlynn",    :password => "mcglynnb",   :password_confirmation => "mcglynnb",     :system_role => project_manager_role)
  User.create(:login => "chris.gotschalk",   :email => "gots@lifesci.ucsb.edu",             :first_name => "Chris",    :last_name => "Gotschalk",  :password => "gotschalkc", :password_confirmation => "gotschalkc",   :system_role => project_manager_role)
  User.create(:login => "cindy.harnett",     :email => "cindy.harnett@louisville.edu",      :first_name => "Cindy",    :last_name => "Harnett",    :password => "harnettc",   :password_confirmation => "harnettc",     :system_role => project_manager_role)
  User.create(:login => "clemente.izurieta", :email => "clemente.izurieta@cs.montana.edu",  :first_name => "Clemente", :last_name => "Izurieta",   :password => "izurietac",  :password_confirmation => "izurietac",    :system_role => project_manager_role)
  User.create(:login => "dan.goodman",       :email => "goodman@rivers.msu.montana.edu",    :first_name => "Dan",      :last_name => "Goodman",    :password => "goodmand",   :password_confirmation => "goodmand",     :system_role => project_manager_role)
  User.create(:login => "debra.earl",        :email => "debra.earl@montana.edu",            :first_name => "Debra",    :last_name => "Earl",       :password => "earld",      :password_confirmation => "earld",        :system_role => project_manager_role)
  User.create(:login => "denise.barnes",     :email => "dbarnes@nsf.gov",                   :first_name => "Denise",   :last_name => "Barnes",     :password => "barnesd",    :password_confirmation => "barnesd",      :system_role => project_manager_role)
  User.create(:login => "david.white",       :email => "david.white@murraystate.edu",       :first_name => "David",    :last_name => "White",      :password => "whited",     :password_confirmation => "whited",       :system_role => project_manager_role)
  User.create(:login => "don.schenck",       :email => "don.schenck@umontana.edu",          :first_name => "Don",      :last_name => "Schenck",    :password => "schenckd",   :password_confirmation => "schenckd",     :system_role => project_manager_role)
  User.create(:login => "ellie.zignego",     :email => "ezignego@gmail.com",                :first_name => "Ellie",    :last_name => "Zignego",    :password => "zignegoe",   :password_confirmation => "zignegoe",     :system_role => project_manager_role)
  User.create(:login => "geoff.poole",       :email => "gpoole@montana.edu",                :first_name => "Geoff",    :last_name => "Poole",      :password => "pooleg",     :password_confirmation => "pooleg",       :system_role => project_manager_role)
  User.create(:login => "gordon.luikart",    :email => "gordon.luikart@umontana.edu",       :first_name => "Gordon",   :last_name => "Luikart",    :password => "luikartg",   :password_confirmation => "luikartg",     :system_role => project_manager_role)
  User.create(:login => "gretchen.rupp",     :email => "grupp@montana.edu",                 :first_name => "Gretchen", :last_name => "Rupp",       :password => "ruppg",      :password_confirmation => "ruppg",        :system_role => project_manager_role)
  User.create(:login => "gwen.jacobs",       :email => "gwen@cns.montana.edu",              :first_name => "Gwen",     :last_name => "Jacobs",     :password => "jacobsg",    :password_confirmation => "jacobsg",      :system_role => project_manager_role)
  User.create(:login => "ivan.judson",       :email => "ivan.judson@montana.edu",           :first_name => "Ivan",     :last_name => "Judson",     :password => "judsoni",    :password_confirmation => "judsoni",      :system_role => sys_admin)
  User.create(:login => "jack.stanford",     :email => "jack.stanford@mso.umt.edu",         :first_name => "Jack",     :last_name => "Stanford",   :password => "stanfordj",  :password_confirmation => "stanfordj",    :system_role => project_manager_role)
  User.create(:login => "james.irvine",      :email => "irvine@yellowstoneresearch.org",    :first_name => "James",    :last_name => "Irvine",     :password => "irvinej",    :password_confirmation => "irvinej",      :system_role => project_manager_role)
  User.create(:login => "jeff.mossey",       :email => "epscor@uky.edu",                    :first_name => "Jeff",     :last_name => "Mossey",     :password => "mosseyj",    :password_confirmation => "mosseyj",      :system_role => project_manager_role)
  User.create(:login => "jeremy.nigon",      :email => "jeremy.nigon@flbs.umt.edu",         :first_name => "Jeremy",   :last_name => "Nigon",      :password => "nigonj",     :password_confirmation => "nigonj",       :system_role => project_manager_role)
  User.create(:login => "jessica.mason",     :email => "jessica.elyce.mason@gmail.com",     :first_name => "Jessica",  :last_name => "Mason",      :password => "masonj",     :password_confirmation => "masonj",       :system_role => project_manager_role)
  User.create(:login => "jim.fox",           :email => "jffox2@uky.edu",                    :first_name => "Jim",      :last_name => "Fox",        :password => "foxj",       :password_confirmation => "foxj",         :system_role => project_manager_role)
  User.create(:login => "jim.griffioen",     :email => "griff@uky.edu",                     :first_name => "Jim",      :last_name => "Griffioen",  :password => "griffioenj", :password_confirmation => "griffioenj",   :system_role => project_manager_role)
  User.create(:login => "jim.myers",         :email => "jimmyers@ncsa.uiuc.edu",            :first_name => "Jim",      :last_name => "Myers",      :password => "myersj",     :password_confirmation => "myersj",       :system_role => project_manager_role)
  User.create(:login => "john.kimball",      :email => "john.kimball@umontana.edu",         :first_name => "John",     :last_name => "Kimball",    :password => "kimballj",   :password_confirmation => "kimballj",     :system_role => project_manager_role)
  User.create(:login => "john.lucotch",      :email => "john.lucotch@umontana.edu",         :first_name => "John",     :last_name => "Lucotch",    :password => "lucotchj",   :password_confirmation => "lucotchj",     :system_role => project_manager_role)
  User.create(:login => "julia.melkers",     :email => "julia.melkers@pubpolicy.gatech.edu",:first_name => "Julia",    :last_name => "Melkers",    :password => "melkersj",   :password_confirmation => "melkersj",     :system_role => project_manager_role)
  User.create(:login => "kathryn.watson",    :email => "kwatson@montana.edu",               :first_name => "Kathryn",  :last_name => "Watson",     :password => "watsonk",    :password_confirmation => "watsonk",      :system_role => project_manager_role)
  User.create(:login => "katie.gibson",      :email => "katie_gibson@ieee.org",             :first_name => "Katie",    :last_name => "Gibson",     :password => "gibsonk",    :password_confirmation => "gibsonk",      :system_role => project_manager_role)
  User.create(:login => "leslie.piper",      :email => "leslie.piper@msu.montana.edu",      :first_name => "Leslie",   :last_name => "Piper",      :password => "piperl",     :password_confirmation => "piperl",       :system_role => project_manager_role)
  User.create(:login => "lindell.ormsbee",   :email => "lindell.ormsbee@uky.edu",           :first_name => "Lindell",  :last_name => "Ormsbee",    :password => "ormsbeel",   :password_confirmation => "ormsbeel",     :system_role => project_manager_role)
  User.create(:login => "lucy.marshall",     :email => "lmarshall@montana.edu",             :first_name => "Lucy",     :last_name => "Marshall",   :password => "marshalll",  :password_confirmation => "marshalll",    :system_role => project_manager_role)
  User.create(:login => "mari.eggers",       :email => "mari.eggers@biofilm.montana.edu",   :first_name => "Mari",     :last_name => "Eggers",     :password => "eggersm",    :password_confirmation => "eggersm",      :system_role => project_manager_role)
  User.create(:login => "mark.lorang",       :email => "mark.lorang@mso.umt.edu",           :first_name => "Mark",     :last_name => "Lorang",     :password => "lorangm",    :password_confirmation => "lorangm",      :system_role => project_manager_role)
  User.create(:login => "mark.young",        :email => "myoung@montana.edu",                :first_name => "Mark",     :last_name => "Young",      :password => "youngm",     :password_confirmation => "youngm",       :system_role => project_manager_role)
  User.create(:login => "matt.williamson",   :email => "mattew.williamson@murraystate.edu", :first_name => "Matt",     :last_name => "Williamson", :password => "williamsonm",:password_confirmation => "williamsonm",  :system_role => project_manager_role)
  User.create(:login => "maury.valett",      :email => "maury.valett@umontana.edu",         :first_name => "Maury",    :last_name => "Valett",     :password => "valettm",    :password_confirmation => "valettm",      :system_role => project_manager_role)
  User.create(:login => "mike.mckay",        :email => "mmckay@bfcc.org",                   :first_name => "Mike",     :last_name => "McKay",      :password => "mckaym",     :password_confirmation => "mckaym",       :system_role => project_manager_role)
  User.create(:login => "nathan.jacobs",     :email => "jacobsn@gmail.com",                 :first_name => "Nathan",   :last_name => "Jacobs",     :password => "jacobsn",    :password_confirmation => "jacobsn",      :system_role => project_manager_role)
  User.create(:login => "patrick.dellacroce",:email => "patrick.dellacroce@gmx.ch",         :first_name => "Patrick",  :last_name => "Della Croce",:password => "dellacrocep",:password_confirmation => "dellacrocep",  :system_role => project_manager_role)
  User.create(:login => "paul.lencioni",     :email => "plencioni408@msn.com",              :first_name => "Paul",     :last_name => "Lencioni",   :password => "lencionip",  :password_confirmation => "lencionip",    :system_role => project_manager_role)
  User.create(:login => "ric.hauer",         :email => "ric.hauer@umontana.edu",            :first_name => "Ric",      :last_name => "Hauer",      :password => "hauerr",     :password_confirmation => "hauerr",       :system_role => project_manager_role)
  User.create(:login => "robert.stewad",     :email => "rlst223@gmail.com",                 :first_name => "Robert",   :last_name => "Stewad",     :password => "stewadr",    :password_confirmation => "stewadr",      :system_role => project_manager_role)
  User.create(:login => "scott.frazier",     :email => "frazier@yellowstoneresearch.org",   :first_name => "Scott",    :last_name => "Frazier",    :password => "fraziers",   :password_confirmation => "fraziers",     :system_role => project_manager_role)
  User.create(:login => "sean.cleveland",    :email => "sean.b.cleveland@gmail.com",        :first_name => "Sean",     :last_name => "Cleveland",  :password => "clevelands", :password_confirmation => "clevelands",   :system_role => sys_admin)
  User.create(:login => "shandin.pete",      :email => "shandinp@yahoo.com",                :first_name => "Shandin",  :last_name => "Pete",       :password => "petes",      :password_confirmation => "petes",        :system_role => project_manager_role)
  User.create(:login => "stephanie.jenkins", :email => "swjenk2@email.uky.edu",             :first_name => "Stephanie",:last_name => "Jenkins",    :password => "jenkins",    :password_confirmation => "jenkins",      :system_role => project_manager_role)
  User.create(:login => "steve.running",     :email => "swr@ntsg.umt.edu",                  :first_name => "Steve",    :last_name => "Running",    :password => "runnings",   :password_confirmation => "runnings",     :system_role => project_manager_role)
  User.create(:login => "susan.hendricks",   :email => "susan.hendricks@murraystate.edu",   :first_name => "Susan",    :last_name => "Hendricks",  :password => "hendrickss", :password_confirmation => "hendrickss",   :system_role => project_manager_role)
  User.create(:login => "terry.mclaren",     :email => "tmclaren@ncsa.illinois.edu",        :first_name => "Terry",    :last_name => "McLaren",    :password => "mclarent",   :password_confirmation => "mclarent",     :system_role => project_manager_role)
  User.create(:login => "tom.bansak",        :email => "tom.bansak@flbs.umt.edu",           :first_name => "Tom",      :last_name => "Bansak",     :password => "bansakt",    :password_confirmation => "bansakt",      :system_role => project_manager_role)
  User.create(:login => "wyatt.cross",       :email => "wyatt.cross@montana.edu",           :first_name => "Wyatt",    :last_name => "Cross",      :password => "crossw",     :password_confirmation => "crossw",       :system_role => project_manager_role)
  User.create(:login => "youngee.cho",       :email => "ycho@ntsg.umt.edu",                 :first_name => "Young-ee", :last_name => "Cho",        :password => "choy",       :password_confirmation => "choy",         :system_role => project_manager_role)
  puts 'done.'

  print 'Creating Roles...'
  pi = Role.create(:name => "Principal Investigator", :description => "Principal Investigators create projects to pursue research goals.", :actions => ((Role.available_permissions - Role.to_permissions) + ['role$retrieve'] - ['project$destroy']))
  pi.move(:to => 1)
  Role.create(:name => "Field Technician",       :description => "Field Technicians manage field activities.", :actions => ['voeis/meta_tag$retrieve','voeis/sensor_type$update','voeis/sensor_type$retrieve','voeis/sensor_type$create','voeis/data_stream_column$update','voeis/data_stream_column$retrieve','voeis/data_stream_column$create','voeis/data_stream$update','voeis/data_stream$retrieve','voeis/data_stream$create','voeis/sensor_value$update','voeis/sensor_value$retrieve','voeis/sensor_value$create','project$retrieve','voeis/unit$retrieve','voeis/variable$retrieve','voeis/variable$create','voeis/site$update','voeis/site$retrieve','voeis/site$create']).move(:to => 2)
  Role.create(:name => "Laboratory Technician",  :description => "Lab Technicians manage lab activities.", :actions => ['voeis/meta_tag$retrieve','voeis/meta_tag$create','voeis/sensor_type$retrieve','voeis/data_stream_column$retrieve','voeis/data_stream$retrieve','voeis/sensor_value$retrieve','project$retrieve','voeis/unit$retrieve','voeis/variable$retrieve','voeis/site$retrieve']).move(:to => 3)
  Role.create(:name => "Data Manager",           :description => "Data Managers manage all the data for a project.", :actions => ['voeis/meta_tag$update','voeis/meta_tag$retrieve','voeis/meta_tag$create','voeis/sensor_type$update','voeis/sensor_type$retrieve','voeis/sensor_type$create','voeis/data_stream_column$update','voeis/data_stream_column$retrieve','voeis/data_stream_column$create','voeis/data_stream$update','voeis/data_stream$retrieve','voeis/data_stream$create','voeis/sensor_value$update','voeis/sensor_value$retrieve','voeis/sensor_value$create','project$retrieve','voeis/unit$update','voeis/unit$retrieve','voeis/unit$create','voeis/variable$update','voeis/variable$retrieve','voeis/variable$create','voeis/site$update','voeis/site$retrieve','voeis/site$create']).move(:to => 4)
  Role.create(:name => "Member",                 :description => "General members of projects.", :actions => ['voeis/meta_tag$retrieve','voeis/sensor_type$retrieve','voeis/data_stream_column$retrieve','voeis/data_stream$retrieve','voeis/sensor_value$retrieve','project$retrieve','voeis/unit$retrieve','voeis/variable$retrieve','voeis/site$retrieve']).move(:to => 5)
  Role.create(:name => "Program Manager",        :description => "Program Managers for the research project.", :actions => ['voeis/meta_tag$retrieve','voeis/sensor_type$retrieve','voeis/data_stream_column$retrieve','voeis/data_stream$retrieve','voeis/sensor_value$retrieve','project$retrieve','voeis/unit$retrieve','voeis/variable$retrieve','voeis/site$retrieve']).move(:to => 6)
  puts 'done.'

  print 'Creating Projects...'
  big_sky = Project.create(:name => "Big Sky",    :description => "In recent decades, the Rocky Mountain West has been one of the fastest growing regions in the United States. Headwater streams in mountain environments may be particularly susceptible to nitrogen enrichment from residential and resort development. The West Fork of the Gallatin River in the northern Rocky Mountains of southwestern Montana drains Big Sky, Moonlight Basin, Yellowstone Club, and Spanish Peaks resort areas. Streams in the West Fork watershed range from first-order, high-gradient, boulder dominated mountain streams in the upper elevations to fourth-order, alluvial streams near the watershed outlet. Since resort development in the Big Sky area, streamwater nitrate concentrations in the West Fork of the Gallatin River have followed a similar upward trend as development. Current work demonstrates the importance of 1) incorporating spatial relationships into water quality modeling, and 2) investigating streamwater chemistry across seasons to gain a more complete understanding of development impacts on streamwater quality.")

  tcef    = Project.create(:name => "Tenderfoot", :description => "The Tenderfoot Creek Experimental Forest (TCEF) comprises 2,200 ha in the Little Belt Mountains of central Montana, and the forest is characteristic of the vast expanses of lodgepole pine found east of the continental divide. TCEF is drained by Tenderfoot Creek, which flows into the Smith River, a tributary of the Missouri River. At TCEF, freezing temperatures and snow can occur every month of the year, with mean annual temperature of 0C. Mean annual precipitation is 880 mm. The elevation ranges from 1840 to 2421 m and has a full range of slope, aspect, and topographic convergence and divergence. The most compelling aspects of this set of 7 nested TCEF research watersheds are 1) that they are among the most comprehensively instrumented and data rich sites for watershed science; 2) the strongly varying watershed shapes/structures and streamflow response from one similar sized adjacent watershed to the next; 3) the opportunity to build on cumulative understanding of catchment dynamics and elucidating emergent behavior to be captured in watershed models.")
  puts 'done.'

  print 'Adding Users to Projects...'
  ['brian.mcglynn', 'lucy.marshall', 'geoff.poole', 'ivan.judson', 'sean.cleveland', 'yogo'].each{|login| big_sky.memberships.create(:user => User.find_by_login(login), :role => pi)}
  ['brian.mcglynn', 'lucy.marshall', 'geoff.poole', 'ivan.judson', 'sean.cleveland', 'yogo'].each{|login| tcef.memberships.create(:user => User.find_by_login(login), :role => pi)}
  puts 'done.'

  print 'Creating Sites...'
  big_sky.prepare_models
  big_sky.managed_repository do
    Voeis::Site.create(:name => "South Fork of the West Fork of the Gallatin River",
                       :code => 'UPGL-GLTNR04--MSU_UPGL-GLTNR04_EH',
                       :latitude => 45.2665, :longitude => -111.2802, :state => "Montana")
    Voeis::Site.create(:name => "North Fork of the West Fork of the Gallatin River",
                       :code => 'UPGL-GLTNR11--MSU_UPGL-GLTNR11_LM',
                       :latitude => 45.2692, :longitude => -111.3209,
                       :state => "Montana")
    Voeis::Site.create(:name => "Middle Fork of - West Fork of the Gallatin River",
                       :code => 'UPGL-GLTNR24--MSU_UPGL-GLTNR24_MF_ESTBSWS',
                       :latitude => 45.2698, :longitude => -111.2788,
                       :state => "Montana")
    Voeis::Site.create(:name => "Upper, West Fork of the Gallatin River",
                       :code => 'UPGL-GLTNR36--MSU_UPGL-GLTNR36_WF',
                       :latitude => 45.2656, :longitude => -111.2577,
                       :state => "Montana")
    Voeis::Site.create(:name => "Upper Gallatin River, Big Sky Weather Station 01",
                       :code => 'BS-STA01--MSU_BIGSKY_BS-STA01',
                       :latitude => 45.268921, :longitude => -111.291334,
                       :state => "Montana")
    Voeis::Site.create(:name => "Yellowstone Club Base Station",
                       :code => 'YCBS',
                       :latitude => 45.24186111, :longitude => -111.4105611,
                       :state => "Montana")
    Voeis::Site.create(:name => "Timber Station",
                       :code => 'TIMBERS',
                       :latitude => 45.23768611, :longitude => -111.4545722,
                       :state => "Montana")
    Voeis::Site.create(:name => "Andesite Mt Station",
                       :code => 'ANDEMS',
                       :latitude => 45.273225, :longitude => -111.3944139,
                       :state => "Montana")
    Voeis::Site.create(:name => "American Spirit Station",
                       :code => 'AMERSS',
                       :latitude => 45.23945278, :longitude => -111.4431111,
                       :state => "Montana")
    Voeis::Site.create(:name => "Big Sky Lone Peak Station",
                       :code => 'BS-LPS',
                       :latitude => 45.2777, :longitude => -111.4514639,
                       :state => "Montana")
    Voeis::Site.create(:name => "Jack Creek Station (Moonlight Basin)",
                       :code => 'JACKCRS',
                       :latitude => 45.28331389, :longitude => -111.4421806,
                       :state => "Montana")
    Voeis::Site.create(:name => "Lookout Ridge (Moonlight Basin)",
                       :code => 'LOOKOUTRS',
                       :latitude => 45.28823889, :longitude => -111.4445611,
                       :state => "Montana")
  end
  tcef.prepare_models
  tcef.managed_repository do
    Voeis::Site.create(:name => "Upper Tenderfoot, Onion Park SNOTEL",
                       :code => 'SNOTEL.1008--MSU_TCEF_OP_SNOTEL.1008',
                       :latitude => 46.54, :longitude => -110.51,
                       :state => "Montana")
    Voeis::Site.create(:name => "Upper Tenderfoot, Stringer Creek SNOTEL",
                       :code => 'SNOTEL.1009--MSU_TCEF_ST_SNOTEL.1009',
                       :latitude => 46.55, :longitude => -110.54,
                       :state => "Montana")

  end
  puts 'done.'

  if RUBY_PLATFORM == "java"
    puts 'Seeding Variables from HIS'
    Variable.update_from_his
    puts 'done'

    puts 'Seeding Units from HIS'
    Unit.update_from_his
    puts 'done'

    puts 'Seeding Sites from HIS'
    Site.update_from_his
    puts 'done'
  end
end
