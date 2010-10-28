module Databasion
  
  class Gitilize
    
    @@config = nil
    
    class GitilizeError < StandardError; end
    
    def self.config=(config)
      @@config = config
    end
    
    def self.config
      @@config
    end
    
    def self.git_path
      @@config['git']['bin']
    end
    
    def self.commit(path=Dir.pwd)
      raise GitilizeError, "A file lock is in place.  Cannot commit." if check_lock?
      create unless check_repo?
      create_lock
      Databasion::LOGGER.info 'running: git commit -am "databasion auto commit"'
      system git_path + ' commit -am "databasion auto commit"'
      remove_lock
    end
    
    def self.create
      Databasion::LOGGER.info 'creating new git repository'
      Databasion::LOGGER.info 'running: git init'
      system git_path + ' init'
    end
    
    def self.check_repo?
      File.exist?('.git') ? true : false
    end
    
    def self.check_lock?
      File.exist?('git.lock') ? true : false
    end
    
    def self.create_lock
      File.new('git.lock', 'w') unless check_lock?
    end
    
    def self.remove_lock
      FileUtils.rm 'git.lock'
    end
    
  end
  
end
