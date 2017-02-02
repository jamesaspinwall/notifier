class Todo < ApplicationRecord
  include Attrs

  attribute :title, StrippedString.new
  attribute :show_at, Chronicle.new

  #validates :completed_at, timeliness: { on_or_after: :created_at, allow_nil: true }
  validates :started_at, timeliness: {on_or_after: :created_at, allow_nil: true}

  has_many :notices, dependent: :destroy
  belongs_to :user
  belongs_to :category, optional: true; accepts_nested_attributes_for :category
  has_and_belongs_to_many :tags; accepts_nested_attributes_for :tags


  after_create do
    mail_notice_create if mail
    alert_notice_create if alert
    Task.schedule_next_notice
  end

  after_update do
    if self.mail_changed?
      if self.mail
        mail_notice_create
      else
        raise "TODO: remove the task"
      end
    end
    if self.alert_changed? and self.alert
      alert_notice_create
    else
      raise "TODO: remove the task"
    end
    Task.schedule_next_notice
  end

  after_destroy do
    Task.schedule_next_notice
  end

  def mail_notice_create
    notices << Notice.create!(
      todo: self,
      title: title,
      description: description,
      notify_chronic: show_at,
      inst: Marshal.dump(NotifierMailer.notice(subject: title, content: description)),
      meth: 'deliver_now',
      args: Marshal.dump([]
      ))
  end

  def alert_notice_create
    notices << Notice.create!(
      todo: self,
      title: title,
      description: description,
      notify_chronic: show_at,
      inst: Marshal.dump(EmailReminderService),
      meth: 'pushover',
      args: Marshal.dump([title],
      ))
  end

  scope :for_user, -> (user) {
    user.present? ? where(user_id: user.id) : raise('error user expected')
  }
  scope :show_at, -> (time_to_show = nil) {
    if time_to_show.blank?
      where('show_at is NULL or show_at <= ?', Time.current.to_i)
    else
      show_at = Chronic.parse(time_to_show).to_i
      raise 'show at is invalid' if show_at.nil?
      where('show_at is NULL or show_at <= ?', show_at)
    end
  }

  scope :and_tags, -> (str) {
    if str.blank?
      all
    else
      args = str.split(',').map(&:strip)
      joins(innery(args.size)).where(whery(args.size), *args)
    end
  }

  scope :or_categories, -> (str) {
    if str.blank?
      all
    else
      names = str.split(',').map(&:strip)
      joins(:category).where(categories: {name: names})
    end
  }

  scope :completed_at, ->(time_range) {
    if time_range.present?
      where(completed_at: parse_time_range(time_range))
    else
      where(completed_at: nil)
    end
  }

  scope :started_at, ->(param) {
    if param.blank?
      all
    elsif param=='true' or param == true
      where.not(started_at: nil)
    elsif param =='false' or param == false
      where(started_at: nil)
    else
      raise 'started_at should be true/false'
    end
  }

  def self.parse_time_range(time_range)
    Chronic.time_class = Time.zone
    from_str, to_str = time_range.split(',')
    from_at = Chronic.parse(from_str)
    if to_str.nil?
      to_at = Time.current
    else
      to_at = Chronic.parse(to_str)
    end
    raise 'date parse error' if from_at.nil? or to_at.nil?
    from_at..to_at
  end

  def build_tags(tag_list_str)
    return if tag_list_str.nil?
    tag_list = tag_list_str.split(',').map(&:strip).reject(&:blank?)
    tags_destroy = []
    tags.each do |tag|
      unless tag_list.include?(tag.name)
        tags_destroy << tag
      end
      tag_list.delete(tag.name)
    end

    tags_destroy.each do |tag|
      tags.destroy tag
    end

    tag_list.each do |name|
      tag = Tag.find_by(name: name)
      unless tag
        tag = Tag.create(name: name)
      end
      tags << tag
    end
  end

  def self.innery(i)
    (1..i).map { |n| "INNER JOIN tags_todos td#{n} ON td#{n}.todo_id=todos.id INNER JOIN tags t#{n} ON t#{n}.id=td#{n}.tag_id" }.join(' ')
  end

  def self.whery(i)
    (1..i).map { |n| "t#{n}.name = ?" }.join(' AND ')
  end


end
