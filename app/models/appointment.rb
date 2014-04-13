class Appointment < ActiveRecord::Base
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :start_time, presence: true
    validates :end_time, presence: true
    validate :on_the_future?
    validate :time_period_valid?
    validate :time_period_available?

    private 

        def on_the_future?
            if start_time.present?  && start_time < DateTime.now 
                errors.add(:start_time, "Start time must be greater than current time")
            end
        end

        def time_period_valid?
            if start_time.present? && end_time.present?
                if end_time < start_time
                    errors.add(:end_time, "End time must be greater than end time")
                end
            end
        end

        def time_period_available?
            # When creating checks for all appointments 
            if new_record? && start_time.present? && end_time.present? 
                if Appointment.where('( ? >= start_time and ? < end_time) 
                                       or ( ? > start_time and ? <= end_time) 
                                       or (? <= start_time and ? >= end_time)', 
                                       start_time, start_time, end_time, end_time, 
                                       start_time, end_time).any?
                    errors.add(:base, "Time period can not overlap with existing appointments")
                end
            # When updating checks for all, except the one that is being updated
            else start_time.present? && end_time.present? 
                if Appointment.where.not(id: id).where('( ? >= start_time and ? < end_time) 
                                       or ( ? > start_time and ? <= end_time) 
                                       or (? <= start_time and ? >= end_time)', 
                                       start_time, start_time, end_time, end_time, 
                                       start_time, end_time).any?
                    errors.add(:base, "Time period can not overlap with existing appointments")
                end
            end
        end
end
