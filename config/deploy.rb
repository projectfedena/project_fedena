set :application, 'project_fedena'
set :user, 'fedenac'
set :domain, 'fedena.com'
#set :mongrel_port, 'put_your_assigned_mongrel_port_number_here'
set :server_hostname, 'demo.projectfedena.org'

set :git_account, 'projectfedena'

set :scm_passphrase,  Proc.new { Capistrano::CLI.password_prompt('timetable') }

role :web, server_hostname
role :app, server_hostname
role :db, server_hostname, :primary => true

default_run_options[:pty] = true
set :repository,  "git@github.com:#{git_account}/#{application}.git"
set :scm, "git"
set :user, user

ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :use_sudo, false
set :deploy_to, "/home/#{user}/rails/#{application}"
