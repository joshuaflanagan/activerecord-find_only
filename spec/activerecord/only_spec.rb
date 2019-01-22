require "spec_helper"

RSpec.describe ActiveRecord::Only do

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

    specify "can call .only on a Relation" do
      other = Widget.create!(name: "Second", active: false)
      expect(Widget.where(active: true).only).to eq(@record)
    end

    specify "can call .only on an ActiveRecord::Base class" do
      expect(Widget.only).to eq(@record)
    end

    specify "can call .only on an association" do
      only_build = @record.builds.create!(name: "A")
      expect(@record.builds.only).to eq(only_build)
    end
  end

  context "when no records match the criteria" do
    before do
      @oldrecord = Widget.create!(name: "Old", active: false)
    end

    specify ".first returns nil" do
      expect(Widget.where(active: true).first).to be_nil
    end

    specify ".only returns nil" do
      expect(Widget.where(active: true).only).to be_nil
    end

    specify ".only! raises" do
      expect{
        Widget.where(active: true).only!
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

    specify ".only returns the record" do
      expect(Widget.where(active:true).only).to eq(@record)
    end

    specify ".only! returns the record" do
      expect(Widget.where(active:true).only).to eq(@record)
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

    specify ".only raises TooManyRecords" do
      expect{
        Widget.where(active:true).only
      }.to raise_error(ActiveRecord::Only::TooManyRecords)
    end

    specify ".only! raises TooManyRecords" do
      expect{
        Widget.where(active:true).only!
      }.to raise_error(ActiveRecord::Only::TooManyRecords)
    end
  end
end
