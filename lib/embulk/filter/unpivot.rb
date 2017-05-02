require 'pry'
require 'pry-nav'

  module Embulk
    module Filter

      class Unpivot < FilterPlugin
        Plugin.register_filter("unpivot", self)

        def self.transaction(config, in_schema, &control)

          task = {
            "outer_key"  => config.param("outer_key", :string),
            "inner_key"  => config.param("inner_key", :string),
            "columns"    => config.param("columns", :array, default: []),
            "additional" => config.param("additional", :array, default: []),
          }

          out_columns = [
            Column.new(nil, task["outer_key"], :string),
            Column.new(nil, task["inner_key"], :long),
          ]

          task["additional"].each do |name|
            col = in_schema.find { |sch| sch.name == name }
            col.index = nil
            out_columns.push(col)
          end

          yield(task, out_columns)
        end

        def init
          # initialization code:
          @outer_key = task["outer_key"]
          @inner_key = task["inner_key"]
          @idx_columns = {}
          task["columns"].each do |target|
            col = in_schema.select{|c| c.name == target["name"] }
            @idx_columns[target["name"]] = col[0].index
          end
        end

        def close
        end

        def add(page)
          idx_outer = get_index(@outer_key, page)
          idx_inner = get_index(@inner_key, page)

          page.each do |record|
            new_record = []
            new_record.push(record[idx_outer])
            new_record.push(record[idx_inner])
            task["additional"].each do |name|
              index = get_index(name, page)
              new_record.push(record[index])
            end
            task["columns"].each do |target|
              index = @idx_columns[target["name"]]
              next if record[index] == 0 or record[index] == ''
              new_record[1] = target["id"]
              page_builder.add(new_record)
            end
          end
        end

        def finish
          page_builder.finish
        end

        private

        def get_index(name, page)
          col = page.schema.select{|c| c.name == name }
          col[0].index
        end

      end

    end
  end

