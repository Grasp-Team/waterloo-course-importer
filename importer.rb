require 'net/http'
require 'json'
require 'pg'
require './waterloo_indexer'
require './pg_manager'

class CourseImporter
  def initialize
    @pg_manager = PGManager.new
    @indexer = WaterlooIndexer.new
  end

  def import
    puts 'Running importer...'
    @pg_manager.create_prepared_insert
    insert_courses(@pg_manager.connection, @indexer.get_data)
  end

  private

  def insert_courses(conn, courses)
    puts "\nWriting #{courses.count} courses to the db."
    subjects = Set.new
    courses.each_with_index do |course|
      begin
        subjects.add(course['subject'])
        puts "Inserting: #{course['course_code']}"
        conn.exec_prepared(
          'insert_course_catalog',
          [
           course['course_code'], course['subject'],
           course['catalog_number'], course['title'], course['description'],
           course['academic_level'], course['calendar_year'], course['url']
          ]
        )
        puts "\tSuccess"
      rescue Exception
        puts "\tFail"
      end
    end
    insert_subjects(conn, subjects)
  end

  def insert_subjects(conn, subjects)
    puts "\nWriting #{subjects.count} subjects to the db."
    subjects.each_with_index do |subject|
      begin
        puts "Inserting: #{subject}"
        conn.exec_prepared(
          'insert_subject',
          [subject]
        )
        puts "\tSuccess"
      rescue Exception
        puts "\tFail"
      end
    end
  end
end
