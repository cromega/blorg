#module Jekyll
  #CONTENT = "{{ site.posts | where_exp:\"item\", \"item.category == 'dev'\" | build_posts | jsonify }}"

  #class CategoryPage < Page
    #def initialize(site, base, dir, category)
      #@site = site
      #@base = base
      #@dir = dir
      #@name = 'index.html'

      #self.process(@name)
      #self.data["permalink"] = "/categories/#{category}.json"
      #self.content = CONTENT
    #end
  #end

  #class CategoryPageGenerator < Generator
    #safe true

    #def generate(site)
      #site.config["categories"].each do |category|
        #site.pages << CategoryPage.new(site, site.source, "categories/#{category}", category)
      #end
    #end
  #end
#end
