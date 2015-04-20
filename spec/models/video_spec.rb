require 'spec_helper'

describe Video do

  it 'saves itself' do
    video = Video.new title: 'my video', description: 'simsa la bim', avatar: 'video.png'
    expect(Video.first).to eq(video)
  end

end