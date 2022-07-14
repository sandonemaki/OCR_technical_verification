require 'net/http'
require 'uri'
require 'json'

File.open('secret.json') do |f|
  secret_json = JSON.load(f)
  KEY = secret_json['Ocp-Apim-Subscription-Key']
  ENDPOINT_URI_PATH = secret_json['ENDPOINT_URI_PATH']
end

# IMAGE画像を設定する
local_image_path = './img/picture_ja.jpg'
file = File.open(local_image_path, 'rb')
data = [['file', file, { filename: File.basename(local_image_path) }]]
#IMAGE_URL = 'https://assets.st-note.com/production/uploads/images/10234364/rectangle_large_type_2_a374e86f9f94c2850f101414fd1a621a.jpeg'

uri = URI(ENDPOINT_URI_PATH)
uri.query = URI.encode_www_form({
    # Request parameters
    'language' => 'ja',
    'detectOrientation' => 'true',
    'model-version' => 'latest'
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# Request headers
request['Ocp-Apim-Subscription-Key'] = KEY
# Request body
# request.body = "{\"url\":\"#{IMAGE_URL}\"}"
# 画像ファイルをset_formでPOSTする
request.set_form(data, "multipart/form-data")

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end
response.body

hash = JSON.parse(response.body)

## 欧文の場合
#en_lines = hash["regions"][0]["lines"]
#en_word_ary = []
## lines<hash>の中の4つのline<hash>のkey"words"の値をeachで回して出力する
#en_lines.each do |line|
#  # pp line["words"]
#  # 複数の配列をeachで回す
#  line["words"].each do |word|
#    en_word_ary.push(word["text"])
#  end
#end
#print en_word_ary.join(" ")

# 日本語の場合
ja_lines = hash["regions"][0]["lines"]
# lines<hash>の中の4つのline<hash>のkey"words"の値をeachで回して出力する
ja_lines.each do |line|
  # pp line["words"]
  # 複数の配列をeachで回す
  line["words"].each do |word|
    print word["text"]
  end
end
