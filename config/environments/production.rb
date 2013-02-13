Bonsaierp::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  #config.action_dispatch.x_sendfile_header = "X-Sendfile"
  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store


  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = {:host => 'bonsaierp.com'}
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    :address => 'localhost',
    :port => 25
  }
  #config.action_mailer.smtp_settings = {
  #  :address => "smtp.gmail.com",
  #  :port => "587",
  #  :domain => "gmail.com",
  #  :user_name => "bonsaierp",
  #  :password => "M4ilBonsa!L4bs",
  #  :authentication => "plain",
  #  :enable_starttls_auto => true
  #}

  # Enable threaded mode
  # config.threadsafe!

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Specify the default JavaScript compressor
  #config.assets.js_compressor  = :uglifier
  #config.assets.css_compresor= :scss
  
  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  config.assets.precompile += %w(email.css)
  # Disable query caching until it's fixed for PostgreSQL schemas
  #config.middleware.delete ActiveRecord::QueryCache

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Prepend all log lines with the following tags
  config.log_tags = [:subdomain]

  ## Notifications
  #config.middleware.use ExceptionNotifier,
  #:email_prefix => "[Seema] ",
  #:sender_address => %{"notifier" <notifier@bonsaierp.com>},
  #:exception_recipients => %w{boriscyber@gmail.com}
end
