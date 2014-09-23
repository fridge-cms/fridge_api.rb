require 'json'

module FridgeApi
  class Model

    def initialize(resource)
      @raw = resource.to_h
      @hash = parse
    end

    def inspect
      p @hash
    end

    def commit
      @raw.each do |key, val|
        if val.kind_of? Array
          if val.first[:part_definition_id]
            val.each do |i, part|
              part_name = part_name(part)
              unless part_value(part) == @hash[part_name]
                @raw[key][i][:value] = @hash[part_name]
              end
            end
            return
          end
        end

        @raw[key] = @hash[key] unless val == @hash[key]
      end
    end

    private

    def parse
      hash = {}
      @raw.each do |key, val|
        if val.kind_of? Array
          if val.first[:part_definition_id]
            val.each do |part|
              hash[part_name(part)] = part_value(part)
            end
          else
            hash[key] = val.map do |v|
              v[:id] ? Model.new(v) : v
            end
          end
        end

        hash[key] = val
      end
      hash
    end

    def part_name(part)
      name = part[:part] ? part[:part][:name] : part[:name]
      name.to_sym
    end

    def part_value(part)
      value ||= part[:value]

      if part[:part]
        if part[:part][:type] == "file" || part[:part][:type] == "image"
          value = JSON.parse part[:value]
        end
      end

      value
    end

  end
end
