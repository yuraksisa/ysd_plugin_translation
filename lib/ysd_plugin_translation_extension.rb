# encoding: utf-8
require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener
require 'ysd_md_translatable'

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
                                                                {:description => 'Español'}) 

        Model::Translation::TranslationLanguage.first_or_create({:code => 'en'}, 
                                                                {:description => 'English'})                                                       
       
        SystemConfiguration::Variable.first_or_create({:name => 'default_language'}, 
                                                      {:value => 'es', :description => 'Default site language', :module => :translation}) 
       
                                                              
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

      menu_items = [{:path => '/configuration/languages',              
                     :options => {:title => app.t.system_admin_menu.languages,
                                  :link_route => "/translationlanguage-management",
                                  :description => 'Manages the translation languages',
                                  :module => :translation,
                                  :weight => 2}
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
    
      routes = [{:path => '/translationlanguage-management',
                 :regular_expression => /^\/translationlanguage-management/, 
                 :title => 'Languages', 
                 :description => 'Manages the site languages',
                 :fit => 1,
                 :module => :translation }]
      
    end

    # ========= Blocks =====================

    # Retrieve all the blocks defined in this module 
    # 
    # @param [Hash] context
    #   The context
    #
    # @return [Array]
    #   The blocks defined in the module
    #
    #   An array of Hash which the following keys:
    #
    #     :name         The name of the block
    #     :module_name  The name of the module which defines the block
    #     :theme        The theme
    #
    def block_list(context={})
    
      app = context[:app]
    
      [{:name => 'translation_menu',
        :module_name => :translation,
        :theme => Themes::ThemeManager.instance.selected_theme.name}]
        
    end

    # Get a block representation 
    #
    # @param [Hash] context
    #   The context
    #
    # @param [String] block_name
    #   The name of the block
    #
    # @return [String]
    #   The representation of the block
    #    
    def block_view(context, block_name)
    
      app = context[:app]
        
      case block_name

        when 'translation_menu'

            locale = app.session[:locale] || SystemConfiguration::Variable.get_value('default_language')
            
            session_language = ::Model::Translation::TranslationLanguage.get(locale)

            # Defines the profile menu
            menu_translation = Site::Menu.new({:name => 'translation_menu', 
                                               :title => 'Translation menu', 
                                               :description => 'Language translation menu'})
          
            menu_item_translation = Site::MenuItem.new({:title => "#{app.t.translation_menu.language}: #{session_language.description}", 
                                                        :module => :translation,
                                                        :menu => menu_translation})
          
            menu_translation.menu_items << menu_item_translation
          
            ::Model::Translation::TranslationLanguage.all.each do |translation_language|
          
              menu_item_account_language = Site::MenuItem.new({:title => translation_language.description, 
                                                               :link_route => app.current_path_with_language(translation_language.code), 
                                                               :module => :translation, 
                                                               :menu => menu_translation,
                                                               :parent => menu_item_translation})      
   
              menu_item_translation.children << menu_item_account_language
              menu_translation.menu_items << menu_item_account_language
              
            end
                     
            # Render the menu
            menu_render = SiteRenders::MenuRender.new(menu_translation, context)
          
            menu_render.render
                  
      end

    end
    
  end #TranslationExtension
end #Huasi