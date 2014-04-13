require 'spec_helper'

describe Appointment do

    describe 'validations' do
        before do
            @appointment = Fabricate(:appointment, start_time: DateTime.now + 1.minute, 
                end_time: DateTime.now  + 1.hour)
        end

        it { expect(@appointment).to validate_presence_of(:first_name) }
        it { expect(@appointment).to validate_presence_of(:last_name) }
        it { expect(@appointment).to validate_presence_of(:start_time) }
        it { expect(@appointment).to validate_presence_of(:end_time) }
    end
    
    describe 'db table' do
        before do
            @appointment = Fabricate(:appointment)
        end

        it { expect(@appointment).to have_db_index(:id) }
        it { expect(@appointment).to have_db_column(:first_name).
                of_type(:string).with_options(null: false)}
        it { expect(@appointment).to have_db_column(:last_name).
                of_type(:string).with_options(null: false)}
        it { expect(@appointment).to have_db_column(:start_time).
                of_type(:datetime).with_options(null: false)}
        it { expect(@appointment).to have_db_column(:end_time).
                of_type(:datetime).with_options(null: false)}
        it { expect(@appointment).to have_db_column(:comment).
                of_type(:string).with_options(null: true)}
    end

end
