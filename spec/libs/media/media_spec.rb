require 'spec_helper'

describe "Media" do
  before do
    @json = [
        { id: 1, path: '/upload/image.png' },
        { id: 2, path: '/upload/video.avi' }
    ]
  end

  describe 'Uploader' do
    before do
      Media::set_persistent_store adapter: 'json', model: @json
      @uploader = Media::Uploader.new ( File.new("media.ext", "r") )
    end

    it 'should be able to upload a media to the file system' do
       @uploader.upload( 'upload/' ).should be_true
    end

    it 'should be able to write the media path in to the persistent store' do
      new_media = { id: 3, path: '/upload/media.ext' }
      @uploader.save
      @json.should include( new_media )
    end
  end

  describe 'Finder' do
    it 'should be able to retrieve data from JSON' do
      before do
        Media::set_persistent_store adapter: 'json', model: @json
      end
      specify 'for a video' do
        (Media::Finder.find_by( id: 1 ) == @json[1]).should be_true
      end
      specify 'for a image' do
        (Media::Finder.find_by( name: 1 ) == @json[1]).should be_true
      end
    end
    describe 'should be able to retrieve data from a Model' do
      specify 'for a video' do
        Media::set_persistent_store adapter: 'active_record', model: Video
        @video = Video.create( path: '/video.mp4')

        (Media::Finder.find_by( id: 1 ) == @video).should be_true
      end
      specify 'for a image' do
        Media::set_persistent_store adapter: 'active_record', model: Image
        @image = Image.create( path: '/image.png')

        (Media::Finder.find_by( name: 2 ) == @image).should be_true
      end
    end
  end

  describe 'Representer' do
    before { Media::set_persistent_store adapter: 'json', model: @json }
    let(:media) { Media::Representer.new }

    it 'should be able to represent the media as an image in HTML Element' do
      Media.display_representation_for( 1 ).should =~ /<img src="\/upload\/image\.png">/
    end

    it 'should be able to represent the media as a video in HTML Element' do
      Media.display_representation_for( Media::Finder.find_by( id: 2 ) ).should =~ /<video src="\/upload\/video\.avi">/
    end
  end
end