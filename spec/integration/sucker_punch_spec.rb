require 'spec_helper'
require 'sucker_punch'
require 'sucker_punch/testing/inline'

describe "Sucker Punch" do
  before :all do
    DelayedPaperclip.options[:background_job_class] = DelayedPaperclip::Jobs::SuckerPunch
  end

  let(:dummy) { Dummy.new(:image => File.open("#{ROOT}/spec/fixtures/12k.png")) }

  describe "integration tests" do
    include_examples "base usage"
  end

  describe "perform job" do
    before :each do
      debugger
      DelayedPaperclip.options[:url_with_processing] = true
      reset_dummy
    end

    it "performs a job" do
      debugger
      dummy.image = File.open("#{ROOT}/spec/fixtures/12k.png")
      Paperclip::Attachment.any_instance.expects(:reprocess!)
      dummy.save!
      DelayedPaperclip::Jobs::SuckerPunch.new.perform(dummy.class.name, dummy.id, :image)
    end
  end

  def process_jobs
    # job = SuckerPunch::Queue.new(:paperclip).each do |job|
    #   job.delete
    # end
    puts "PROCESS JOBS"
  end

  def jobs_count
    debugger
    Celluloid::Actor[:paperclip].size
  end

end