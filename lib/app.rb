require 'sinatra'
require 'bundler'
require 'better_errors'
require_relative 'idea_box'



class IdeaBoxApp < Sinatra::Base
  set :static, true
  set :method_override, true
  set :root, 'lib/app'

  configure :development do
    register Sinatra::Reloader
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end
  
  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new}
  end

  get '/searchtags' do
    search_by_tag = params[:idea][:search_tags].downcase.gsub(",","").split(" ")
    erb :searchtags, locals: {search_by_tag: search_by_tag, ideas: IdeaStore.all.sort}
  end

  get '/searchday' do
    search_by_day = params[:idea][:search_day]
    erb :searchday, locals: {search_by_day: search_by_day, ideas: IdeaStore.all.sort}
  end

  get '/searchgroup' do
    search_group = params[:idea][:search_group]
    erb :searchgroup, locals: {search_group: search_group, ideas: IdeaStore.all.sort}
  end

  get '/searchhour' do
    search_by_hour = params[:idea][:search_hour]
    search_am_pm = params[:idea][:am_pm]
    erb :searchhour, locals: {search_by_hour: search_by_hour, search_am_pm: search_am_pm, ideas: IdeaStore.all.sort}
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
