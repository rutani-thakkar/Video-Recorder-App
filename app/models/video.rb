# frozen_string_literal: true

require 'rest-client'

class Video < ApplicationRecord
  belongs_to :user
  mount_uploader :file, VideoUploader

  validates :title, :file, presence: true

  after_save :transcribe_video, if: :should_transcribe?

  def transcribe_video
    Rails.logger.info "Starting transcription for video #{self.id}"
    
    audio_file_path = extract_audio(self.file.path)
    
    transcript = get_transcription(audio_file_path)
    Rails.logger.info "Transcription completed for video #{self.id}"

    self.update(transcript: transcript)
  end

  private

  def extract_audio(video_path)
    audio_path = "#{Rails.root}/tmp/#{File.basename(video_path, '.*')}.wav"
    unless File.exist?(audio_path)
      system("ffmpeg -i #{video_path} -vn -acodec pcm_s16le -ar 44100 -ac 2 #{audio_path}")
    end
    audio_path
  end

  def get_transcription(audio_file_path)
    key = Rails.application.credentials.dig(:assemblyai, :api_key)
    response = RestClient.post('https://api.assemblyai.com/v2/upload',
                               File.new(audio_file_path, 'rb'),
                               { "authorization": key})

    upload_url = JSON.parse(response.body)['upload_url']

    response = RestClient.post('https://api.assemblyai.com/v2/transcript',
                               { audio_url: upload_url }.to_json,
                               { "authorization": key, "content-type": :json })

    transcript_id = JSON.parse(response.body)['id']

    result = {}
    loop do
      response = RestClient.get("https://api.assemblyai.com/v2/transcript/#{transcript_id}",
                                { "authorization": key})
      result = JSON.parse(response.body)
      break if result['status'] == 'completed'
      sleep(5)
    end
    result['text']
  end

  def should_transcribe?
    saved_change_to_file?
  end
end
