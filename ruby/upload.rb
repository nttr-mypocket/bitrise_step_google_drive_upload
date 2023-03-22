# frozen_string_literal: true

require 'logger'
require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'json'
require 'stringio'

logger = Logger.new($stderr)

SCOPE = Google::Apis::DriveV3::AUTH_DRIVE_FILE
# GoogleDriveに存在するアップロード先フォルダIDを指定
FOLDER_ID = ENV["drive_directory_id"]
# GoogleCloudServiceにプロジェクトのサービスアカウント作成時の秘密鍵
PRIVATE_KEY = ENV["service_account_private_key"].gsub("\\n", "\n")
# GoogleCloudService プロジェクトのサービスアカウントのメールアドレス
CLIENT_EMAIL = ENV["service_account_id"]
# Content Type
CONTENT_TYPE = ENV["output_content_type"]

# 静的解析結果のファイル
INPUT_FILE = ENV["lint_file"]

# GoogleDriveへアップロードするファイルのファイル名
OUTPUT_FILE_NAME = ENV['lint_output']

# GoogleDriveAPIを初期化
service = Google::Apis::DriveV3::DriveService.new
begin
  # GoogleCloudServiceから取得したデータを使う
  credentials = {
    "private_key": PRIVATE_KEY,
    "client_email": CLIENT_EMAIL
  }
  # GoogleDriveにログインする
  service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
    json_key_io: StringIO.new(credentials.to_json),
    scope: SCOPE
  )
  logger.info('Authorization successful')
rescue StandardError => e
  logger.error("Authorization failed: #{e.message}")
  throw e
end

def upload_files_to_google_drive(content_type, input_file, output_file_name, service, logger)
  # GoogleDriveにファイルの存在を確認する
  existing_files = service.list_files(
    q: "name='#{output_file_name}' and parents in '#{FOLDER_ID}'", fields: 'files(id)'
  ).files

  file_id = existing_files.first&.id
  if file_id
    # ファイルがある場合、更新する
    service.update_file(
      file_id,
      upload_source: input_file,
      content_type: content_type
    )

    logger.info("#{file_extension} file updated on GoogleDrive successfully.")
  else
    # ファイル名とフォルダーを設定する
    file_metadata = {
      name: output_file_name,
      parents: [FOLDER_ID]
    }

    # ファイルが無い場合、作成する
    service.create_file(
      file_metadata,
      fields: 'id',
      upload_source: input_file,
      content_type: content_type
    )

    logger.info("#{file_extension} file uploaded to GoogleDrive successfully.")
  end
rescue StandardError => e
  logger.error("Failed to create file: #{e.message}")
  throw e
end

upload_files_to_google_drive(CONTENT_TYPE, INPUT_FILE, OUTPUT_FILE_NAME, service, logger)
