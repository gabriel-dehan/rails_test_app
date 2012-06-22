# Used to implement an equivalent for java interfaces
class MissingImplementationError < StandardError; end

module Media
  require 'pathname'

  @@adapter = nil
  def set_persistent_store options
    if options.include?( :adapter ) && options.include?( :model )
      adapter_class = "Media::#{options[:adapter].classify}Adapter".constantize
      @@adapter = adapter_class.new options[:model]
    else
      raise ArgumentError, 'No adapter nor model specified'
    end
  end

  class Uploader
    def initialize file
      @file = file
      @path = nil
    end

    def upload directory
      Rails.root.open do
        Dir::chdir( 'public' ) do
          Dir::mkdir directory unless File.directory? "#{directory}"
            Dir::chdir directory do
              begin
                file_name = File::basename @file.path
                File::open( file_name , 'w' ).write @file.read

                @path = "#{directory}/#{file_name}"
              end
            end
        end
      end
    end

    def save
      if @path
        @@adapter.save path: @path
      else
        raise NoArgumentError, 'You may want to upload a file first, none defined'
      end
    end
  end

  class Finder
    # Query is a simple hash containing one query argument
    # Examples : { id: 1 } | { name: 'Media'}
    class << self
        def find_by query
          query = query.flatten
          @@adapter.find_by query.first, query.last
        end
    end
  end

  class Representer
    def initialize
      @video_ext = %w{.avi .mp4 .mov'}
      @image_ext = %w{.png .jpg .jpeg .gif'}
    end

    def display_representation_for query
      media = Media::Finder.find_by query
      ext = File.extname media[:path]
      type = check_type ext
      if type === :video
        "<video src='#{media[:path]}'></video>"
      elsif type === :image
        "<img src='#{media[:path]}'>"
      end
    end

    private
    def check_type ext
      if @video_ext.include? ext
        :video
      elsif @image_ext.include? ext
        :image
      end
    end
  end

  class Adapter
    attr_writer :model
    def initialize model
      @model = model
    end
    def save
      raise MissingImplementationError, __missing_method_message__( __method__ )
    end

    # Will receive two arguments
    # @argument : key to search
    # @argument : expected value
    # Examples : { id: 1 } | { name: 'Media'}
    def find_by
      raise MissingImplementationError, __missing_method_message__( __method__ )
    end

    private
    def __missing_method_message__ method_name; "#{self.class.inspect}##{method_name} is not implemented" end
  end
end

module Media
  class JsonAdapter < Media::Adapter
    def save entry
      entry[:id] = @model.last[:id].next
      @model << entry
    end

    def find_by key, value
      @model.find do | hash |
        (hash[key] == value)
      end
    end
  end
  class ActiveRecordAdapter < Media::Adapter
    def initialize model
      @model = model.class
    end

    def save entry
      @model.create entry
    end

    def find_by key, value
      if key === :id
        method = "find"
      else
        method = "find_by_#{key.to_s}"
      end
      @model.public_send method.to_sym, value
    end
  end
end