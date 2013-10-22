require 'bundler'
require 'idea_box'
Bundler.require

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  configure :development do
    register Sinatra::Reloader
  end
  
  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new}
  end

  get '/searchtags' do
    search_by_tag = params[:idea][:search_tags].gsub(",","").split(" ")
    erb :searchtags, locals: {search_by_tag: search_by_tag, ideas: IdeaStore.all.sort} #idea: Idea.new}
  end

  get '/searchtime' do
    search_by_time = params[:idea][:search_day]
    erb :searchtime, locals: {search_by_time: search_by_time, ideas: IdeaStore.all.sort}
  end

  get '/searchdescription' do
    search_by_description = params[:idea][:search_description].downcase.split(" ")
    erb :searchdescription, locals: {search_by_description: search_by_description, ideas: IdeaStore.all.sort}
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  
  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end
  
  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
      erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post "/:id/like" do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end
end
