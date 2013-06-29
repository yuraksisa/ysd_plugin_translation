require 'json' unless defined?JSON
require 'uri' unless defined?URI
require 'ysd_md_translation' unless defined? Model::Translation

module Sinatra
  module YSD
    module TranslationLanguageRESTApi
    
      def self.registered(app)
      
        #
        # Get all translation languages
        #
        app.get "/translationlanguages" do
        
          data = Model::Translation::TranslationLanguage.find_translatable_languages
        
          content_type :json
          data.to_json
        
        end
        
        #
        # Retrieve translation languages
        #
        ["/translationlanguages", "/translationlanguages/page/:page"].each do |path|
        
          app.post path do
             
            page = params[:page].to_i || 1
            limit = 12
            offset = (page-1) * 12

            data, total = Model::Translation::TranslationLanguage.find_all(:limit => limit, :offset => offset)
        
            status 200
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json

          end
        
        end
                
        #
        # Create a new translation language
        #
        app.post "/translationlanguage" do
        
          request.body.rewind        
          language_request = JSON.parse(URI.unescape(request.body.read))
          
          # Creates the new language
          language = Model::Translation::TranslationLanguage.new(language_request)
          language.save
          
          status 200
          content_type :json
          language.to_json             
        
        end
        
        #
        # Update a translation language
        #
        app.put "/translationlanguage" do
        
          request.body.rewind
          language_request = JSON.parse(URI.unescape(request.body.read))
          
          if language = Model::Translation::TranslationLanguage.get(language_request['code'])
            language.attributes=language_request
            language.save
          end

          status 200
          content_type :json
          language.to_json
          
        end
        
        #
        # Delete a translation language
        #
        app.delete "/translationlanguage" do
    
          request.body.rewind
          language_request = JSON.parse(URI.unescape(request.body.read))
          
          if language = Model::Translation::TranslationLanguage.get(params['code'])
            language.destroy
          end
          
          status 200
          content_type :json
          true.to_json
        
        end    
    
      
      end
    
    end # TranslationLanguageRESTApi
  end # YSD
end # Sinatra