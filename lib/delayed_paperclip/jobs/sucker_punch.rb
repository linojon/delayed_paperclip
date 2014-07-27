require 'sucker_punch'

module DelayedPaperclip
  module Jobs
    class SuckerPunch < Struct.new(:instance_klass, :instance_id, :attachment_name)
      include ::SuckerPunch::Job

      def self.enqueue_delayed_paperclip(instance_klass, instance_id, attachment_name)
        # debugger
        ::SuckerPunch.logger.ino "@@@  @@@  @@@ enqueue_delayed_paperclip : #{instance_id} @@@ @@@ @@@"
        new.async.perform(instance_klass, instance_id, attachment_name)
      end

      def perform(instance_klass, instance_id, attachment_name)
        # debugger
        ::SuckerPunch.logger.info "@@@@@@@@@@@@@@@@@@ In perform #{instance_id}"
        ActiveRecord::Base.connection_pool.with_connection do 
          DelayedPaperclip.process_job(instance_klass, instance_id, attachment_name)
        end
        ::SuckerPunch.logger.info "leaving perform @@@@@@@@@@@@@@@@"
      end
    end
    # class SuckerPunch
    #   include ::SuckerPunch::Job
    #   @queue = :paperclip

    #   def self.enqueue_delayed_paperclip(instance_klass, instance_id, attachment_name)
    #     debugger
    #     ::SuckerPunch.new.async.perform(instance_klass, instance_id, attachment_name)
    #   end
    #   def perform(instance_klass, instance_id, attachment_name)
    #     debugger
    #     ActiveRecord::Base.connection_pool.with_connection do 
    #       DelayedPaperclip.process_job(instance_klass, instance_id, attachment_name)
    #     end
    #   end
    # end
  end
end