require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['apps/**/*.rb','lib/**/*.rb']   # optional
  t.options = [ '-o./doc/yard' ]  # optional
end

namespace :yard do
  
  desc "Opens the documentation in your browser"
  task :open => [:yard] do
    sh "open doc/yard/index.html" do |ok,res|
      if ok
        puts "Documentation opened in browser"
      else
        puts "Couldn't open your browser. Goto doc/yard/index.html in your browser to view the docs!"
      end
    end
  end
  
end