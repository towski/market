require 'rubygems'
require 'config'

[Reddit, Github].each do |site|
  domain = site::DOMAIN
  name = site::NAME
  site = Site.first(:domain => domain)
  if !site
    site = Site.create(:name => name, :domain => domain)
  end
  site
end
