require 'rvm/capistrano'      #add rvm integration
require 'bundler/capistrano'  # add bundler integration
load 'deploy/assets'          # make sure assets are precompiled

set :user, 'ubuntu'
set :domain, 'bm.yanxiang.me' 

set :application, "BetaMovies"
set :repository,  "#{user}@#{domain}:/opt/webapp/projects_repo/bm.yanxiang.me.git"

set :deploy_to, "/opt/webapp/webhome/bm.yanxiang.me"

set :scm, "git"
set :branch, 'master'
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"


set :deploy_via, :remote_cache

set :scm_verbose, true
set :use_sudo, false

set :bundle_dir, ""
set :bundle_flags, ""


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
  end
end

after "deploy", "deploy:migrate"
