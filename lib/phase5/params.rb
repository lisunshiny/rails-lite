
URI
module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params
      parse_www_encoded_form(req.query_string)
      parse_www_encoded_form(req.body)

    end

    def [](key)

      @params[key.to_s]

    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return if www_encoded_form.nil?
      resp_hash = {}
      arr = URI.decode_www_form(www_encoded_form)
      arr.map!{|el| el[0] = parse_key(el[0]); el}

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

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
