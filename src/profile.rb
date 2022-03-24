class Profile < ActiveRecord::Base

def get_top_recipients
    puts "*"*50
    puts "get_top_recipients"
    recipients_raw = Profile.find_by_sql([
          "SELECT e_t.address, COUNT(*) AS Count, EXTRACT(month FROM e.date) AS Month
          FROM emails e, emails_tos e_t, profiles p
          WHERE e.sentreceived = 'sent' AND e_t.email_id = e.id AND e_t.recipient_type = 'to'
          AND e.profile_id = p.id and p.id = ?
          GROUP BY e_t.address, Month
          ORDER BY Month, Count DESC;", self.id])
    recipients = []
    if recipients_raw == []
     recipients = Recipient.create_empty_array
    else
      recipients_raw.each do |r|
        recipients << Recipient.new(r.address, r.count.to_i, r.month.to_i)
      end
    end
    Recipient.get_top(recipients, 5)
  end
end
