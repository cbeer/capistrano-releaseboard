namespace :deploy do
  task :notify_releaseboard do

    on roles(:all) do |host|
      @client = Faraday.new(:url => fetch(:release_board_url))

      version = within release_path do
        if test("[ -f VERSION ]")
          capture(:cat, "VERSION")
        else
          fetch(:current_revision)
        end
      end

      version ||= "none"

      @client.post "projects/#{fetch(:application)}/releases" do |req|
        req.params[:project] = { :name => fetch(:application) }
        req.params[:release] = { :version => version, :released_by => local_user, :repository => fetch(:repository), :branch => fetch(:branch), :sha => fetch(:current_revision) }
        req.params[:environment] = { :deployment_host => host, :destination => fetch(:deploy_to) }
      end
    end
  end

  after :finished, :notify_releaseboard
end

namespace :load do
  task :defaults do
    set :release_board_url, ENV['RELEASE_BOARD_URL']
  end
end