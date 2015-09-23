module FridgeApi
  class Model

    def self.new_from_part(part, data)
      # TODO
    end

    def initialize(resource)
      @raw = resource.to_h
      @attrs = parse
    end

    def inspect
      p @attrs
    end

    def commit
      @raw.each do |key, val|
        if val.kind_of? Array
          if is_part? val
            val.each do |i, part|
              part_name = part_name(part)
              unless part_value(part) == @attrs[part_name]
                @raw[key][i][:value] = @attrs[part_name]
              end
            end
            return
          end
        end

        @raw[key] = @attrs[key] unless val == @attrs[key]
      end
    end

    # Allow fields to be retrieved via Hash notation
    def [](method)
      send(method.to_sym)
    rescue NoMethodError
      nil
    end

    # Retrieve field value
    def method_missing(method, *args)
      @attrs.has_key?(method.to_sym) ? @attrs[method.to_sym] : super
    end

    def attrs
      @attrs
    end

    private

    def parse
      hash = {}
      @raw.each do |key, val|
        if val.kind_of? Array
          if is_part? val
            val.each do |part|
              hash[part_name(part)] = part_value(part)
            end
          elsif is_part_definition? val
            val.each do |part_definition|
              hash[part_name(part_definition)] = part_definition
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

    def is_part?(val)
      val.first && val.first[:part_definition_id]
    end

    def is_part_definition?(val)
      val.first && val.first[:definition_id] && val.first[:definition_type]
    end

    def part_name(part)
      name = part[:part] ? part[:part][:name] : part[:name]
      name.to_sym
    end

    def part_value(part)
      part[:value]
    end

  end
end
