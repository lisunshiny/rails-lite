require 'byebug'
require 'uri'
@params = {}
def parse_www_encoded_form(www_encoded_form)
  return if www_encoded_form.nil?
  resp_hash = {}
  arr = URI.decode_www_form(www_encoded_form)
  arr.map!{|el| el[0] = parse_key(el[0]); el}
  # byebug
  arr.each do |keyval|
    keys = keyval[0]
    hash = @params
    if keys.length > 1
      keys[0..-2].each do |key|
        hash[key] = {} unless hash[key]
        hash = hash[key]
      end
    end
    hash[keys[-1]] = keyval[1]
  end

end
def parse_key(key)
  key.split(/\]\[|\[|\]/)
end
test = "{ 'user' => { 'address' => { 'street' => 'main', 'zip' => '89436' } } }"
