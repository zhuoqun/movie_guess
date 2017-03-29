set :application, "MovieGuess"
set :repository,  "git@mapp.cc:the_place.git"

set :scm, :git

set :port, 30022
set :deploy_to, "/home/zhuoqun/MovieGuess"
set :use_sudo, false

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "124.42.35.140"                          # Your HTTP server, Apache/etc
role :app, "124.42.35.140"                          # This may be the same as your `Web` server
role :db,  "124.42.35.140", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
require 'capistrano-unicorn'
before "deploy:update", "unicorn:stop"
after "deploy:update", "unicorn:start"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
