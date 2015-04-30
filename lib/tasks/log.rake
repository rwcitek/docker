# log.rake - Setup logging

require 'logging'
@log= Logging.logger( './rake.log' )
@log.level = :debug

def log_warn msg, logger=@log
  logger.warn msg
end

def log_debug msg , logger=@log
 logger.debug msg
end

def log_info msg , logger=@log
 logger.info msg
end

def log_error msg , logger=@log
 logger.error msg
end

def log msg
  log_info msg
end


log 'Logging started'
