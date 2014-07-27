require 'sucker_punch'

module DelayedPaperclip
  module Jobs
    class SuckerPunch
      include ::SuckerPunch::Job
      @queue = :paperclip

      def self.enqueue_delayed_paperclip(instance_klass, instance_id, attachment_name)
        byebug
        ::SuckerPunch.new.async.perform(instance_klass, instance_id, attachment_name)
      end
      
      def self.perform(instance_klass, instance_id, attachment_name)
        byebug
        ActiveRecord::Base.connection_pool.with_connection do 
          DelayedPaperclip.process_job(instance_klass, instance_id, attachment_name)
        end
      end
    end
  end
end