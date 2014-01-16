require "capistrano/releaseboard/version"
require 'faraday'

module Capistrano
  module Releaseboard
  end
end

load File.expand_path("../tasks/releaseboard.rake", __FILE__)