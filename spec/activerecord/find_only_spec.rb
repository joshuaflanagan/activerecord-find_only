require "spec_helper"

RSpec.describe ActiveRecord::FindOnly do

  class Build < ActiveRecord::Base

  end
  class Widget < ActiveRecord::Base
    has_many :builds
  end

  before do
    Widget.delete_all
  end

  context "callsites" do
    before do
      @record = Widget.create!(name: "First", active: true)
    end

    specify "can call .find_only on a Relation" do
      other = Widget.create!(name: "Second", active: false)
      expect(Widget.where(active: true).find_only).to eq(@record)
    end

    specify "can call .find_only on an ActiveRecord::Base class" do
      expect(Widget.find_only).to eq(@record)
    end

    specify "can call .find_only on an association" do
      only_build = @record.builds.create!(name: "A")
      expect(@record.builds.find_only).to eq(only_build)
    end
  end

  context "when no records match the criteria" do
    before do
      @oldrecord = Widget.create!(name: "Old", active: false)
    end

    specify ".first returns nil" do
      expect(Widget.where(active: true).first).to be_nil
    end

    specify ".find_only returns nil" do
      expect(Widget.where(active: true).find_only).to be_nil
    end

    specify ".find_only! raises" do
      expect{
        Widget.where(active: true).find_only!
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when one record matches the criteria" do
    before do
      @record = Widget.create!(name: "First", active: true)
      @oldrecord = Widget.create!(name: "Old", active: false)
    end

    specify ".first returns the record" do
      expect(Widget.where(active:true).first).to eq(@record)
    end

    specify ".find_only returns the record" do
      expect(Widget.where(active:true).find_only).to eq(@record)
    end

    specify ".find_only! returns the record" do
      expect(Widget.where(active:true).find_only).to eq(@record)
    end

  end

  context "when more than one records match the criteria" do
    before do
      @first = Widget.create!(name: "First", active: true)
      @second = Widget.create!(name: "Second", active: true)
      @third = Widget.create!(name: "Third", active: true)
    end

    specify ".first returns a record" do
      expect(Widget.where(active:true).first).to_not be_nil
    end

    specify ".find_only raises TooManyRecords" do
      expect{
        Widget.where(active:true).find_only
      }.to raise_error(ActiveRecord::FindOnly::TooManyRecords)
    end

    specify ".find_only! raises TooManyRecords" do
      expect{
        Widget.where(active:true).find_only!
      }.to raise_error(ActiveRecord::FindOnly::TooManyRecords)
    end
  end

  context "when an association is not loaded" do
    before do
      @record = Widget.create!(name: "First", active: true)
      @record.builds.create!(name: "A")
      @record.reload
    end

    specify ".first makes a database query" do
      accessed_db = check_db_access{
        expect(@record.builds.first).to_not be_nil
      }

      expect(accessed_db).to be_truthy
    end

    specify ".find_only makes a database query" do
      accessed_db = check_db_access{
        expect(@record.builds.find_only).to_not be_nil
      }

      expect(accessed_db).to be_truthy
    end
  end

  context "when an association is loaded" do
    before do
      @record = Widget.create!(name: "First", active: true)
      @record.builds.create!(name: "A")
      @record.builds.to_a
    end

    specify ".first does not make a database query" do
      accessed_db = check_db_access{
        expect(@record.builds.first).to_not be_nil
      }

      expect(accessed_db).to be_falsey
    end

    specify ".find_only does not make a database query" do
      accessed_db = check_db_access{
        expect(@record.builds.find_only).to_not be_nil
      }

      expect(accessed_db).to be_falsey
    end

    specify ".find_only! does not make a database query" do
      accessed_db = check_db_access{
        expect(@record.builds.find_only!).to_not be_nil
      }

      expect(accessed_db).to be_falsey
    end

    context "and association has more than one record" do
      before do
        @record.builds.create!(name: "B")
        @record.builds.to_a
      end

      specify ".find_only raises without making a database query" do
        accessed_db = check_db_access{
          expect{
            @record.builds.find_only
          }.to raise_error(ActiveRecord::FindOnly::TooManyRecords)
        }

        expect(accessed_db).to be_falsey
      end

      specify ".find_only! raises without making a database query" do
        accessed_db = check_db_access{
          expect{
            @record.builds.find_only!
          }.to raise_error(ActiveRecord::FindOnly::TooManyRecords)
        }

        expect(accessed_db).to be_falsey
      end
    end
  end
end
