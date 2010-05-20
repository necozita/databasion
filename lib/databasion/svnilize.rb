require 'fileutils'

module Databasion
  
  class Svnilize
    
    @@config = nil
    
    class SvnilizeError < StandardError; end
    
    def self.config=(config)
      @@config = config
    end
    
    def self.config
      @@config
    end
    
    def self.svn_path
      @@config['svn']['bin']
    end
    
    def self.commit(path=Dir.pwd)
      raise SvnilizeError, "A file lock is in place.  Cannot commit." if check_lock?
      create_lock
      svn_add_files(path)
      begin
        Databasion::LOGGER.info 'running: svn commit -m "svn auto commit"'
        system svn_path + ' commit -m "svn auto commit"'
        Databasion::LOGGER.info 'running: svn update'
        system svn_path + ' update'
      rescue
        remove_lock
        raise SvnilizeError, "This isn't a valid SVN project."
      end
      remove_lock
    end
    
    def self.svn_add_files(path)
      files = Dir[Dir.pwd + "/" + path + "/**/*"]
      files.each do |file|
        Databasion::LOGGER.info 'running: svn add %s' % file
        system svn_path + ' add %s' % file
      end
    end
    
    def self.check_lock?
      return true if File.exist?('svn.lock')
      false
    end
    
    def self.create_lock
      File.new('svn.lock', 'w') unless check_lock?
    end
    
    def self.remove_lock
      FileUtils.rm 'svn.lock'
    end
    
  end
  
end