require 'pry'
class Dog
    attr_accessor :name, :breed
    attr_reader :id
    
   @@table_name = "dogs"
    
    def initialize (id: nil, name:, breed:)
    @name = name
    @breed = breed
    @id = id
    end

    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY, 
              name TEXT, 
              breed TEXT
              );
              SQL

        DB[:conn].execute(sql)
    end

    def self.drop_table
        DB[:conn].execute("DROP TABLE dogs")
    end

    def new_from_db
        
    end

    def save
        if self.id
          self.update
        else
          sql = <<-SQL
            INSERT INTO dogs (name, breed)
            VALUES (?, ?)
          SQL
    
          DB[:conn].execute(sql, self.name, self.breed)
          @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
        end
        self
      end

      def update
        sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
        DB[:conn].execute(sql, self.name, self.breed, self.id)
      end

      def self.create(name:, breed:)
        dog = Dog.new(name: name, breed: breed)
        dog.save
        dog
      end

      def self.new_from_db(row)
        dog = Dog.new(id: row[0], name: row[1], breed: row[2])
        dog.save
        dog
      end

      def self.find_by_id(id_num)
          sql = <<-SQL
          SELECT * FROM dogs WHERE id = ?
          SQL

        row = DB[:conn].execute(sql, id_num)[0]
        self.new_from_db(row)
        # dog = Dog.new(id: row[0], name: row[1], breed: row[2])
        # dog

      end

      def self.find_by_name(name)
        sql = <<-SQL
        SELECT * FROM dogs WHERE name = ?
        SQL

      row = DB[:conn].execute(sql, name)[0]
      self.new_from_db(row)
      end

      def self.find_or_create_by(name:, breed:)
          dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
          if !dog.empty?
            data = dog[0][0] 
            dog = Dog.new_from_db(data)
          else
            dog = self.create(name: name, breed: breed)
          end
          dog
      end


    


    
    
    
    end
