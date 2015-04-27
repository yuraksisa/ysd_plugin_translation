# encoding: utf-8
require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener
require 'ysd_md_translatable'
require 'ysd_md_configuration' unless defined?SystemConfiguration::Variable
require 'ysd_md_cms' unless defined?Site::Menu
require 'ysd_core_themes' unless defined?Themes::ThemeManager

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
                                  :link_route => "/admin/languages",
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
        :theme => Themes::ThemeManager.instance.selected_theme.name},
       {:name => 'translation_list',
        :module_name => :translation,
        :theme => Themes::ThemeManager.instance.selected_theme.name},
       {:name => 'translation_form',
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

      locale = app.session[:locale] || SystemConfiguration::Variable.get_value('default_language')
      session_language = ::Model::Translation::TranslationLanguage.get(locale)

      case block_name

        when 'translation_menu'

            menu_translation = Site::Menu.new({:name => 'translation_menu', 
                                               :title => 'Translation menu', 
                                               :description => 'Language translation menu',
                                               :language_in_routes => false})
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
                     
            SiteRenders::MenuRender.new(menu_translation, context).render

        when 'translation_list'

            menu_translation_list = Site::Menu.new({:name => 'translation_list',
              :title => 'Translation list menu',
              :description => 'Language translation list',
              :language_in_routes => false})

            Model::Translation::TranslationLanguage.all.each do |translation_language|
              menu_translation_list.menu_items << Site::MenuItem.new({
                :title => translation_language.description,
                :link_route => app.current_path_with_language(translation_language.code),
                :module => :translation,
                :menu => menu_translation_list})
            end

            SiteRenders::MenuRender.new(menu_translation_list, context).render
                 
        when 'translation_form'

            form = <<-HTML
               <form name="change_language" action="/change-language" method="POST">
                 <select name="language">
                   <option name="language" value="en" #{app.session[:locale]=='en'?:'selected="true"':''}>English</option>
                   <option name="language" value="es" #{app.session[:locale]=='es'?:'selected="true"':''}>Español</option>
                 </selection>
                 <input type="hidden" id="url" name="url" value="/"/>
                 <input type="submit" value="Cambiar"></input>
               </form>
               <script type="text/javascript">
                 require(['jquery'], function($) {
                   $(document).ready(function() {
                     $("#url").val(window.location.pathname);
                     //alert(window.location.href);
                     //document.forms["change_language"]["url"]=window.location.pathname;
                   });
                 });
               </script>
            HTML

      end

    end
    
  end #TranslationExtension
end #Huasi