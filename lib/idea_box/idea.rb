class Idea
  include Comparable

  attr_reader :title, :description, :rank, :id, :tags, :created_at, :group

  def initialize(attributes = {})
    @title =        attributes["title"]
    @description =  attributes["description"]
    @rank =         attributes["rank"] || 0
    @id =           attributes["id"] 
    @tags =         attributes["tags"]
    @created_at =   attributes["created_at"] ||= Time.now.utc.localtime
    @group =        attributes["group"]
  end
  
  def searchable_tags
    tags.downcase.gsub(",","").split(" ")
  end

  def tag_match?(params)
    self.searchable_tags.any? {|tag_letter| params.include?(tag_letter)}
  end

  def time_match?(searchhour, ampm)
    hour_match?(searchhour) && am_pm_match?(ampm)
  end

  def hour_match?(searchhour)
    created_at.hour == searchhour.to_i || created_at.hour == searchhour.to_i + 12
  end

  def am_pm_match?(ampm)
    am_or_pm == ampm
  end

  def searchable_description
    description.downcase.gsub(/[^\w\s]/,"").split(" ")
  end

  def day_of_the_week
    {
      0 => "Sunday",
      1 => "Monday",
      2 => "Tuesday",
      3 => "Wednesday",
      4 => "Thursday",
      5 => "Friday",
      6 => "Saturday"
    }
  end

  def w_day
    created_at.wday
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
