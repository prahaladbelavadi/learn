class DailyEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Send daily email to users
    # Items added to their favorite topics
    # New followers

    new_global_users = User.where("created_at > ?", Time.now.beginning_of_day - 1.day)
    new_items = Item.where("created_at > ?", Time.now.beginning_of_day - 1.day).limit(5)

    User.all.each do |u|
      next if u.email.blank?
      begin
        new_fav_items = TopicIdeaSet.where(topic: u.fav_topics).where("created_at > ?", Time.now.beginning_of_day - 1.day)
        new_followers = u.followers.where("user_user_relations.created_at > ?", Time.now.beginning_of_day - 1.day)
        new_global_users_except_me = new_global_users.reject { |v| v.id == u.id }

        unless new_fav_items.blank? and new_followers.blank? and new_global_users_except_me.blank? and new_items.blank?
          Rails.logger.info "Sending daily email to #{u.email}"
          UserMailer.with(
            user: u,
            new_followers: new_followers,
            new_fav_items: new_fav_items,
            new_global_users: new_global_users_except_me,
            new_items: new_items).daily_email.deliver_now
        end
      rescue Exception => ex
        Rails.logger.error("#{ex.message} in DailyEmailJob for #{u.id} #{u.nickname}")
      end
    end
  end
end
