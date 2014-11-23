Gem::Specification.new do |s|
  s.name    = "ysd_plugin_translation"
  s.version = "0.1.11"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2011-08-23"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb','views/**/*.erb','i18n/**/*.yml'] 
  s.summary = "Yurak Sisa Translation Plugin"

  s.add_runtime_dependency "json"
  
  s.add_runtime_dependency "ysd_core_plugins"
  s.add_runtime_dependency "ysd_core_themes"
  s.add_runtime_dependency "ysd_yito_core"
  s.add_runtime_dependency "ysd_yito_js"

  s.add_runtime_dependency "ysd_plugin_cms"       # Menu rendering

  s.add_runtime_dependency "ysd_md_cms"           # Menu model
  s.add_runtime_dependency "ysd_md_configuration" # Configuration
  s.add_runtime_dependency "ysd_md_translation"   # Translation model

end
