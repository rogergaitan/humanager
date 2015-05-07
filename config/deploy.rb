set :application, "reasapp"
set :repository,  "git@bitbucket.org:dotcreek/dcerp.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "missionfig.lognllc.com"                           # Your HTTP server, Apache/etc
role :app, "ec2-184-73-44-205.compute-1.amazonaws.com"                          # This may be the same as your `Web` server
set :user, "ec2-user"
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :deploy_to, "/home/ec2-user/reasapp"
#set :deploy_subdir, 'Server/missionfig_game'

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"r
#after 'deploy:update', 'bundle:install', 'deploy:migrate'

after :deploy, "deploy:restart"
#after "deploy:update_swf", "deploy:restore_assets"
#before :deploy, "deploy:backup_assets"


namespace :deploy do

  task :restart do
    run "sudo service httpd restart"
  end


end

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