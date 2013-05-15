module Lalala::Cache

  def self.setup!(app, servers, username, password)
    if servers.blank?
      return
    end

    require 'dalli'

    app.config.cache_store = [
      :dalli_store,
      *servers,
      {
        :namespace  => "lalala",
        :expires_in => 1.day,
        :compress   => true,
        :username   => username,
        :password   => password
      }
    ]

    app.config.to_prepare do
      Lalala::Cache.flush!
    end

    ActiveRecord::Base.send(:include, Lalala::Cache::Flusher)
  end

  def self.flush!
    unless "ActiveSupport::Cache::DalliStore" === Rails.cache.class.to_s
      return
    end

    Rails.logger.info("memcache: Flushing all entries")
    Rails.cache.clear
  end

  module Flusher
    extend ActiveSupport::Concern

    included do
      after_commit :lalala_flush_cache
    end

  private

    def lalala_flush_cache
      Lalala::Cache.flush!
    end

  end

end
