class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def self.run_sql(sql)
    DB[:conn].execute(sql)
  end

  def self.create_table
    run_sql <<-SQL
      CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);
    SQL
  end

  def self.drop_table
    run_sql <<-SQL
      DROP TABLE students;
    SQL
  end

  def save
    sql = <<-SQL
      INSERT INTO students(name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, grade)
    @id = DB[:conn].execute("SELECT MAX(id) FROM students").flatten.first
    self
  end

  def self.create(attributes)
    self.new(attributes[:name], attributes[:grade]).save
  end
end
