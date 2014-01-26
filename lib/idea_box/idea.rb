class Idea
  include Comparable

  attr_reader :title, :description, :rank, :id, :tags, :created_at, :group

  def initialize(attributes = {})
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"] 
    @tags = attributes["tags"]
    @created_at = attributes["created_at"] ||= Time.now.utc.localtime
    @group = attributes["group"]
  end
  
  def searchable_tags
    tags.downcase.gsub(",","").split(" ")
  end

  def tag_match?(params)
    self.searchable_tags.any? {|tag_letter| params.include?(tag_letter)}
  end

  def searchable_description
    description.downcase.gsub(/[^\w\s]/,"").split(" ")
  end

  def day_of_the_week
    if created_at.wday == 0
      "Sunday"
    elsif created_at.wday == 1
      "Monday"
    elsif created_at.wday == 2
      "Tuesday"
    elsif created_at.wday == 3
      "Wednesday"
    elsif created_at.wday == 4
      "Thursday"
    elsif created_at.wday == 5
      "Friday"
    else
      "Saturday"
    end
  end

  def am_or_pm
    created_at.strftime("%p")
  end

  def <=>(other)
    other.rank <=> rank
  end

  def save
    IdeaStore.create(to_h)
  end

  def to_h
    {
      "title" => title,
      "description" => description, 
      "rank" => rank,
      "tags" => tags,
      "created_at" => created_at,
      "group" => group
    }
  end

  def database
    Idea.database
  end

  def like!
    @rank += 1
  end
end
