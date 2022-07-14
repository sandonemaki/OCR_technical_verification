require 'net/http'
require 'uri'
require 'json'

File.open('secret_read.json') do |f|
  secret_json = JSON.load(f)
  KEY = secret_json['Ocp-Apim-Subscription-Key']
  ENDPOINT_URI_PATH = secret_json['ENDPOINT_URI_PATH']
end

IMAGE_URL = 'https://assets.st-note.com/production/uploads/images/32935407/picture_pc_894abae8e409d7550d9cd694ff0ae6d6.png'

#def call_read_api
  uri = URI(ENDPOINT_URI_PATH)
  uri.query = URI.encode_www_form({
      # Request parameters
      'language' => 'ja',
      'pages' => '1',
      'readingOrder' => 'natural',
      'model-version' => 'latest'
  })

  request = Net::HTTP::Post.new(uri.request_uri)
  # Request headers
  request['Content-Type'] = 'application/json'
  # Request headers
  request['Ocp-Apim-Subscription-Key'] = KEY
  # Request body
  request.body = "{\"url\":\"#{IMAGE_URL}\"}"

  response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
  end

  if response.code == '202'
    operation_location = response['Operation-Location']
  else
    ''
  end

def get_result(operation_location)
  uri = URI(operation_location)
  uri.query = URI.encode_www_form({
  })
  request = Net::HTTP::Get.new(uri.request_uri)
  # Request headers
  request['Ocp-Apim-Subscription-Key'] = KEY
  # Request body
  request.body = "{\"url\":\"#{IMAGE_URL}\"}"

  response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
  end

  if response.code == '200'
    JSON.parse(response.body)
  else
    {}
  end
end

# puts '1秒待機...'
sleep(1.0)
hash = get_result(operation_location)

## 欧文
# en_lines = hash["analyzeResult"]["readResults"][0]["lines"]#[0]["text"]
## 改行なし
#en_line_ary = []
#en_lines.each do |line|
#  en_line_ary.push(line["text"])
#end
#print en_line_ary.join(" ")

# 改行あり
# en_lines.each do |line|
  # puts line["text"]
# end

# 日本語
ja_lines = hash["analyzeResult"]["readResults"][0]["lines"]#[0]["text"]
# 横組み　改行なし
#ja_line_ary = []
#ja_lines.each do |line|
#  ja_line_ary.push(line["text"])
#end
#print ja_line_ary

##横組み　改行あり
#ja_lines.each do |line|
#  puts line["text"]
#end

## 縦組み
ja_line_ary = []
ja_lines.each do |line|
  ja_line_ary.push(line["text"])
end
## 改行あり
puts ja_line_ary.reverse!
## 改行なし
## print ja_line_ary.reverse!.join("")
#

