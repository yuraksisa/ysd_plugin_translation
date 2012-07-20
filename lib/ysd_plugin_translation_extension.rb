require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener

#
# Site Extension
#
module Huasi

  class TranslationExtension < Plugins::ViewListener

    # ========= Installation =================

    # 
    # Install the plugin
    #
    def install(context={})
            
        Model::Translation::TranslationLanguage.first_or_create({:code => 'es'}, 
                                                                {:description => 'Spanish'}) 

        Model::Translation::TranslationLanguage.first_or_create({:code => 'en'}, 
                                                                {:description => 'English'})                                                       
       
        SystemConfiguration::Variable.first_or_create({:name => 'default_language'}, 
                                                      {:value => 'es'}) 
       
                                                              
    end

    # --------- Menus --------------------
    
    #
    # It defines the admin menu menu items
    #
    # @return [Array]
    #  Menu definition
    #
    def menu(context={})
      
      app = context[:app]

      menu_items = [{:path => '/system/languages',              
                     :options => {:title => app.t.system_admin_menu.languages,
                                  :link_route => "/translationlanguage-management",
                                  :description => 'Manages the translation languages',
                                  :module => :translation,
                                  :weight => 1}
                    }
                    ]                      
    
    end    

    # ========= Routes ===================
    
    # routes
    #
    # Define the module routes, that is the url that allow to access the funcionality defined in the module
    #
    #
    def routes(context={})
   
      routes = [{:path => '/translate/content/:content_id',
                 :parent_path => '/content-management',
                 :regular_expression => /^\/translate\/content\/.+/, 
                 :title => 'Content translation', 
                 :description => 'Translate a content',
                 :fit => 1,
                 :module => :translation },
                {:path => '/translate/menuitem/:menuitem_id',
                 :regular_expression => /^\/translate\/menuitem\/.+/, 
                 :title => 'Menu item translation', 
                 :description => 'Translate a menu item',
                 :fit => 1,
                 :module => :translation },                 
                {:path => '/translate/term/:term_id',
                 :regular_expression => /^\/translate\/term\/.+/,                  
                 :title => 'Term translation',
                 :description => 'Translate a term.',
                 :fit => 1,
                 :module => :translation }]
      
    end

    # ========= Content extension ===========
    
    #
    # Content element action
    #
    def content_element_action(context={})
    
      app = context[:app]
      
      app.render_element_action_button({:title => app.t.content_action_button.translate, 
                                        :text  => app.t.content_action_button.translate, 
                                        :id    => 'content_translate' })
    
    end
    
    #
    # Content element action extension
    #
    def content_element_action_extension(context={})
      
      app = context[:app]
      
      template_path = File.join(File.dirname(__FILE__), '..', 'views', "content-element-action-extension.erb")
      template = Tilt.new(template_path)
      the_render = template.render(app)    
    
    end

  end #TranslationExtension
end #Huasi