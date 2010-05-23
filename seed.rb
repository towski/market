require 'rubygems'
require 'config'

[Reddit, Github, Google].each do |site|
  domain = site.domain
  name = site.name
  site = Site.first(:domain => domain)
  if !site
    site = Site.create(:name => name, :domain => domain)
  end
  site
end
