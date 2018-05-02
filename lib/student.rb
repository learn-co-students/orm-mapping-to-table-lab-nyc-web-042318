require 'pry'
require 'sqlite3'
require_relative '../lib/student'

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade)
    @name = name
    @grade = grade
  end
  #DB = {:conn => SQLite3::Database.new("db/students.db")}
  # Remember, you can access your database connection anywhere in this class
  # with DB[:conn]

  def self.exec_sql(sql_command)
    DB[:conn].execute(sql_command)
  end

  def self.create_table
    sql = <<-SQL
        CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade NUMERIC
      );
      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    exec_sql(<<-SQL)
     DROP TABLE students;
    SQL
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, @name, @grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(attrHash)
    newStudObj = Student.new(attrHash[:name], attrHash[:grade])
    newStudObj.save
    newStudObj
  end


end

