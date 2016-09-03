require "carrierwave/digest/version"
require 'digest/sha1'

module Carrierwave
  module Digest
    # Modified from https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3a-Use-file%27s-digest-%28e.g.-MD5,-SHA-1%29-as-file-path
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      def ensure_digest_for(name)
        define_method("#{name}_digest") do
          if send("#{name}_changed?") &&
            send("#{name}").file.present? &&
            send("#{name}").file.respond_to?(:path) &&
            File.exists?(send("#{name}").file.path)
            ::Digest::SHA1.file(send("#{name}").file.path).hexdigest
          else # Reading image
            self["#{name}_digest".to_sym]
          end
        end

        define_method("update_#{name}_digest") do
          self.send("#{name}_digest=", send("#{name}_digest")) if send("#{name}_changed?")
        end
        before_save "update_#{name}_digest".to_sym
      end
    end
  end
end
