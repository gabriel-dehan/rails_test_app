require 'spec_helper'
require 'fileutils'
require 'media/media'

include Media
=begin
describe "Media" do

  before do
    @json = [
        { id: 1, path: '/test/image.png' },
        { id: 2, path: '/test/video.avi' }
    ]
  end

  describe 'Set Persistent store' do
    it 'should raise an ArgumentError if no adapter nor model are specified' do
      ->{ Media::set_persistent_store db: 'mysql' }.should raise_error(ArgumentError)
    end
    it 'should raise an ArgumentError if only a model is specified' do
      ->{ Media::set_persistent_store adapter: 'json' }.should raise_error(ArgumentError)
    end
    it 'should raise an ArgumentError if only an adapter is specified' do
      ->{ Media::set_persistent_store model: @json }.should raise_error(ArgumentError)
    end
  end

  describe 'Uploader' do
    before(:each) do
      Media::set_persistent_store adapter: 'json', model: @json
      current_dir = File::dirname(__FILE__)
      @uploader = Media::Uploader.new ( File::open("#{current_dir}/media.ext", "r") )
    end

    after(:each) do
      Rails.root.open do
        Dir::chdir('public') do
          # Cuz directory ain't no empty
          FileUtils.rm_rf 'test'
        end
      end
    end

    describe 'upload method' do
      it 'should create a directory if one does not exists' do
        @uploader.upload( 'test' )

        Rails.root.open do
          Dir::chdir('public') do |dir|
            File.directory?( 'test' ).should be_true
          end
        end
      end

      it 'should upload the media to the file system' do
        @uploader.upload( 'test' ).should be_true
        Rails.root.open do
          Dir::chdir('public') do |dir|
            ( File.exists? 'test/media.ext' ).should be_true
          end
        end
      end

    end

    it 'should be able to write the media path in to the persistent store' do
      new_media = { id: 3, path: 'test/media.ext' }
      @uploader.upload( 'test' )
      @uploader.save
      @json.should include( new_media )
    end
  end

  describe 'Finder' do
    describe 'should be able to retrieve data from JSON' do
      before do
        Media::set_persistent_store adapter: 'json', model: @json
      end
      specify 'for a video' do
        (Media::Finder.find_by( id: 2 ) == @json[1]).should be_true
      end
      specify 'for a image' do
        (Media::Finder.find_by( path: '/test/image.png' ) == @json[0]).should be_true
      end
    end
    describe 'should be able to retrieve data from a Model' do
      before do
        @video = DataFile::Video.create( path: '/test/video.mp4')
        @image = DataFile::Image.create( path: '/test/image.png')
      end
      specify 'for a video' do
        Media::set_persistent_store adapter: 'active_record', model: @video

        (Media::Finder.find_by( id: 1 ) == @video).should be_true
      end
      specify 'for a image' do
        Media::set_persistent_store adapter: 'active_record', model: @image

        (Media::Finder.find_by( path: '/test/image.png' ) == @image).should be_true
      end
    end
  end

  describe 'Representer' do
    before { Media::set_persistent_store adapter: 'json', model: @json }
    let(:media) { Media::Representer.new }

    it 'should be able to represent the media as an image in HTML Element' do
      media.display_representation_for( id: 1 ).should =~ /<img src='\/test\/image\.png'>/
    end

    it 'should be able to represent the media as a video in HTML Element' do
      media.display_representation_for( id: 2 ).should =~ /<video src='\/test\/video\.avi'><\/video>/
    end
  end

  describe 'Adapter' do
    before { module Media; class TestAdapter < Media::Adapter; end end }
    describe '#save' do
      it 'should raise an error if the interface is not implemented' do
        ->{ Media::TestAdapter.new( nil ).save }.should raise_error(MissingImplementationError)
      end
    end
    describe '#find_by' do
      it 'should raise an error if the interface is not implemented' do
        ->{ Media::TestAdapter.new( nil ).find_by }.should raise_error(MissingImplementationError)
      end
    end
  end
end
=end