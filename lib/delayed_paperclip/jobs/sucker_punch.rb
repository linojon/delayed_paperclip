require 'sucker_punch'

module DelayedPaperclip
  module Jobs
    class SuckerPunch < Struct.new(:instance_klass, :instance_id, :attachment_name)
      include ::SuckerPunch::Job

      def self.enqueue_delayed_paperclip(instance_klass, instance_id, attachment_name)
        # ::SuckerPunch.logger.info "@@@  @@@  @@@ enqueue_delayed_paperclip : #{instance_id} @@@ @@@ @@@"
        new.async.perform(instance_klass, instance_id, attachment_name)
      end

      def perform(instance_klass, instance_id, attachment_name)
        # ::SuckerPunch.logger.info "@@@@@@@@@@@@@@@@@@ In perform #{instance_id}"
        ActiveRecord::Base.connection_pool.with_connection do 
          DelayedPaperclip.process_job(instance_klass, instance_id, attachment_name)
        end
        # ::SuckerPunch.logger.info "leaving perform @@@@@@@@@@@@@@@@"
      end
    end
  end
end