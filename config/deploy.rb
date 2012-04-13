set :user, 'root'
set :domain, 'bm.yanxiang.me' 

set :application, "BetaMovies"
set :repository,  "#{user}@#{domain}:/opt/webapp/project_depo/depo.git"

set :deploy_to, "/opt/webapp/home/bm.yx.me/"

set :scm, "git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"


set :deploy_via, :remote_cache
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false



set :bundle_dir, ""
set :bundle_flags, ""

require 'rvm/capistrano'
set :rvm_ruby_string, "1.9.2"
set :rvm_type, :system
set :normalize_asset_timestamps, false
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

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

after "deploy:update_code", :bundle_install
desc 'install prerequisites'
task :bundle_install, :roles => :app do
   run "cd #{release_path} && bundle install"
end
