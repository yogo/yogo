# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

begin

  print 'Creating Users...'

  # Create the system administrator user
  User.create(:login => 'yogo', :email => "nobody@home.com", :first_name => "System", :last_name => "Administrator", :password => 'change me', :password_confirmation => 'change me', :admin => true)
  # Create a test user
  User.create(:login => 'test', :email => "test@user.org",   :first_name => "Test",   :last_name => "User",          :password => "VOEISdude", :password_confirmation => "VOEISdude")
  # Create the actual users...
  User.create(:login => "ivan.judson",       :email => "ivan.judson@montana.edu",         :first_name => "Ivan",     :last_name => "Judson",     :password => "judsoni",    :password_confirmation => "judsoni",   :admin => true)
  User.create(:login => "sean.cleveland",    :email => "sean.b.cleveland@gmail.com",      :first_name => "Sean",     :last_name => "Cleveland",  :password => "clevelands", :password_confirmation => "clevelands",:admin => true)
  User.create(:login => "andy.hansen",       :email => "hansen@montana.edu",              :first_name => "Andy",     :last_name => "Hansen",     :password => "hansena",    :password_confirmation => "hansena")
  User.create(:login => "barbara.kucera",    :email => "bakuce2@uky.edu",                 :first_name => "Barbara",  :last_name => "ucera",      :password => "kucerab",    :password_confirmation => "kucerab")
  User.create(:login => "bob.crabtree",      :email => "crabtree@yellowstoneresearch.org",:first_name => "Bob",      :last_name => "Crabtree",   :password => "crabtreeb",  :password_confirmation => "crabtreeb")
  User.create(:login => "bonnie.ellis",      :email => "bonnie.ellis@umontana.edu",       :first_name => "Bonnie",   :last_name => "Ellis",      :password => "ellisb",     :password_confirmation => "ellisb")
  User.create(:login => "brian.mcglynn",     :email => "bmcglynn@montana.edu",            :first_name => "Brian",    :last_name => "McGlynn",    :password => "mcglynnb",   :password_confirmation => "mcglynnb")
  User.create(:login => "chris.gotschalk",   :email => "gots@lifesci.ucsb.edu",           :first_name => "Chris",    :last_name => "Gotschalk",  :password => "gotschalkc", :password_confirmation => "gotschalkc")
  User.create(:login => "clemente.izurieta", :email => "clemente.izurieta@cs.montana.edu",:first_name => "Clemente", :last_name => "Izurieta",   :password => "izurietac",  :password_confirmation => "izurietac")
  User.create(:login => "dan.goodman",       :email => "goodman@rivers.msu.montana.edu",  :first_name => "Dan",      :last_name => "Goodman",    :password => "goodmand",   :password_confirmation => "goodmand")
  User.create(:login => "david.white",       :email => "david.white@murraystate.edu",     :first_name => "David",    :last_name => "White",      :password => "whited",     :password_confirmation => "whited")
  User.create(:login => "geoff.poole",       :email => "gpoole@montana.edu",              :first_name => "Geoff",    :last_name => "Poole",      :password => "pooleg",     :password_confirmation => "pooleg")
  User.create(:login => "gretchen.rupp",     :email => "grupp@montana.edu",               :first_name => "Gretchen", :last_name => "Rupp",       :password => "ruppg",      :password_confirmation => "ruppg")
  User.create(:login => "gwen.jacobs",       :email => "gwen@cns.montana.edu",            :first_name => "Gwen",     :last_name => "Jacobs",     :password => "jacobsg",    :password_confirmation => "jacobsg")
  User.create(:login => "jack.stanford",     :email => "jack.stanford@mso.umt.edu",       :first_name => "Jack",     :last_name => "Stanford",   :password => "stanfordj",  :password_confirmation => "stanfordj")
  User.create(:login => "jeff.mossey",       :email => "epscor@uky.edu",                  :first_name => "Jeff",     :last_name => "Mossey",     :password => "mosseyj",    :password_confirmation => "mosseyj")
  User.create(:login => "jeremy.nigon",      :email => "jeremy.nigon@flbs.umt.edu",       :first_name => "Jeremy",   :last_name => "Nigon",      :password => "nigonj",     :password_confirmation => "nigonj")
  User.create(:login => "jessica.mason",     :email => "jessica.elyce.mason@gmail.com",   :first_name => "Jessica",  :last_name => "Mason",      :password => "masonj",     :password_confirmation => "masonj")
  User.create(:login => "john.kimball",      :email => "john.kimball@umontana.edu",       :first_name => "John",     :last_name => "Kimball",    :password => "kimballj",   :password_confirmation => "kimballj")
  User.create(:login => "katie.gibson",      :email => "katie_gibson@ieee.org",           :first_name => "Katie",    :last_name => "Gibson",     :password => "gibsonk",    :password_confirmation => "gibsonk")
  User.create(:login => "leslie.piper",      :email => "leslie.piper@msu.montana.edu",    :first_name => "Leslie",   :last_name => "Piper",      :password => "piperl",     :password_confirmation => "piperl")
  User.create(:login => "mark.lorang",       :email => "mark.lorang@mso.umt.edu",         :first_name => "Mark",     :last_name => "Lorang",     :password => "lorangm",    :password_confirmation => "lorangm")
  User.create(:login => "mark.young",        :email => "myoung@montana.edu",              :first_name => "Mark",     :last_name => "Young",      :password => "youngm",     :password_confirmation => "youngm")
  User.create(:login => "patrick.dellacroce",:email => "patrick.dellacroce@gmx.ch",       :first_name => "Patrick",  :last_name => "Della Croce",:password => "dellacrocep",:password_confirmation => "dellacrocep")
  User.create(:login => "paul.lencioni",     :email => "plencioni408@msn.com",            :first_name => "Paul",     :last_name => "Lencioni",   :password => "lencionip",  :password_confirmation => "lencionip")
  User.create(:login => "ray.ford",          :email => "raymond.ford@umontana.edu",       :first_name => "Ray",      :last_name => "Ford",       :password => "fordr",      :password_confirmation => "fordr")
  User.create(:login => "ric.hauer",         :email => "ric.hauer@umontana.edu",          :first_name => "Ric",      :last_name => "Hauer",      :password => "hauerr",     :password_confirmation => "hauerr")
  User.create(:login => "steve.running",     :email => "swr@ntsg.umt.edu",                :first_name => "Steve",    :last_name => "Running",    :password => "runnings",   :password_confirmation => "runnings")
  User.create(:login => "wyatt.cross",       :email => "wyatt.cross@montana.edu",         :first_name => "Wyatt",    :last_name => "Cross",      :password => "crossw",     :password_confirmation => "crossw")
  User.create(:login => "youngee.cho",       :email => "ycho@ntsg.umt.edu",                :first_name => "Young-ee",:last_name => "Cho",        :password => "choy",       :password_confirmation => "choy")
  puts 'done.'

  print 'Creating Roles...'
  Role.create(:name => "Principal Investigator", :description => "Principal Investigators create projects to pursue research goals.")
  Role.create(:name => "Field Technician",       :description => "Field Technicians manage field activities.")
  Role.create(:name => "Laboratory Technician",  :description => "Lab Technicians manage lab activities.")
  Role.create(:name => "Data Manager",           :description => "Data Managers manage all the data for a project.")
  Role.create(:name => "Member",                 :description => "General members of projects.")
  puts 'done.'

  print 'Creating Projects...'
  big_sky = Project.create(:name => "Big Sky",    :description => "In recent decades, the Rocky Mountain West has been one of the fastest growing regions in the United States. Headwater streams in mountain environments may be particularly susceptible to nitrogen enrichment from residential and resort development. The West Fork of the Gallatin River in the northern Rocky Mountains of southwestern Montana drains Big Sky, Moonlight Basin, Yellowstone Club, and Spanish Peaks resort areas. Streams in the West Fork watershed range from first-order, high-gradient, boulder dominated mountain streams in the upper elevations to fourth-order, alluvial streams near the watershed outlet. Since resort development in the Big Sky area, streamwater nitrate concentrations in the West Fork of the Gallatin River have followed a similar upward trend as development. Current work demonstrates the importance of 1) incorporating spatial relationships into water quality modeling, and 2) investigating streamwater chemistry across seasons to gain a more complete understanding of development impacts on streamwater quality.")
  tcef    = Project.create(:name => "Tenderfoot", :description => "The Tenderfoot Creek Experimental Forest (TCEF) comprises 2,200 ha in the Little Belt Mountains of central Montana, and the forest is characteristic of the vast expanses of lodgepole pine found east of the continental divide. TCEF is drained by Tenderfoot Creek, which flows into the Smith River, a tributary of the Missouri River. At TCEF, freezing temperatures and snow can occur every month of the year, with mean annual temperature of 0°C. Mean annual precipitation is 880 mm. The elevation ranges from 1840 to 2421 m and has a full range of slope, aspect, and topographic convergence and divergence. The most compelling aspects of this set of 7 nested TCEF research watersheds are 1) that they are among the most comprehensively instrumented and data rich sites for watershed science; 2) the strongly varying watershed shapes/structures and streamflow response from one similar sized adjacent watershed to the next; 3) the opportunity to build on cumulative understanding of catchment dynamics and elucidating emergent behavior to be captured in watershed models.")
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
