Gem::Specification.new do |s|
  s.name    = "ysd_plugin_translation"
  s.version = "0.1.3"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2011-08-23"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb','views/**/*.erb','i18n/**/*.yml'] 
  s.summary = "Yurak Sisa Translation Plugin"

  s.add_runtime_dependency "json"
  
  s.add_runtime_dependency "ysd_plugin_cms"               # Site builder
    
  s.add_runtime_dependency "ysd_md_translation"   # Translation model
   
end
