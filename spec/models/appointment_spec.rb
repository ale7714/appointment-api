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

    describe 'times validations' do 

        it "will not be valid if start time is lower than now" do
            appointment = Fabricate.build(:appointment, start_time: DateTime.now - 1.day)
            appointment.valid?
            expect(appointment.errors.get(:start_time)).to include("Start time must be greater than current time")
        end

        it "will not be valid if end time is lower than start time" do
            appointment = Fabricate.build(:appointment, start_time: DateTime.now, end_time: DateTime.now - 1.hour)
            appointment.valid?
            expect(appointment.errors.get(:end_time)).to include("End time must be greater than end time")
        end

        describe 'overlaps' do 
            before do
                @appointment = Fabricate(:appointment)
            end
            it "will not be valid if overlaps another one" do
                overlap = Fabricate.build(:appointment, start_time: DateTime.now + 10.minutes, 
                    end_time: DateTime.now  + 1.hour)
                overlap.valid?
                expect(overlap.errors.full_messages).to include("Time period can not overlap with existing appointments")
            end
        end

    end

end
