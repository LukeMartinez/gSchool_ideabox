
require 'yaml/store'

class IdeaStore

  def self.delete(position)
   database.transaction do
     database['ideas'].delete_at(position)
   end
 end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.database
    return @database if @database

    @database = YAML::Store.new('db/ideabox')
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end


  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.update(id, data)
    raw_idea = find_raw_idea(id)
    created_at = raw_idea["created_at"]
    unless created_at.nil?
      data["created_at"] = created_at
    else
      data["created_at"] = Time.now.utc.localtime
    end
    database.transaction do
      database['ideas'][id] = data
    end
  end
    
  def self.create(data)
    new_idea = Idea.new(data)
    database.transaction do
      database['ideas'] ||= []
      database['ideas'] << new_idea.to_h
    end
  end
end
