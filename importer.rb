require 'net/http'
require 'json'
require 'pg'

class CourseImporter
  def import
    puts 'Running importer...'
    conn = get_db_connection
    data = get_course_specific_data(courses)
    create_prepared_insert(conn, "course.course_catalog")
    write_to_db(conn, data)
  end

  private

  def get_db_connection
    PG::Connection.open(
      host: ENV.fetch('DB_HOST'),
      port: ENV.fetch('DB_PORT'),
      dbname: ENV.fetch('DB_NAME'),
      user: ENV.fetch('DB_USER'),
      password: ENV.fetch('DB_PASS')
    )
  end

  def create_prepared_insert(conn, table_name)
    conn.prepare(
      'insert_course',
      "insert into #{table_name} (code, subject, catalog_number,
       course_name, description, academic_level, calendar_year, url)
       values ($1, $2, $3, $4, $5, $6, $7, $8)")
  end

  def courses
    res = Net::HTTP.get(get_uri('/courses.json'))
    JSON.parse(res)['data']
  end

  def get_uri(endpoint)
    uri = URI(ENV.fetch('API_ENDPOINT') + endpoint + '?key=' + ENV.fetch('API_KEY'))
  end

  def get_course_specific_data(courses)
    puts "#{courses.count} courses retrieved."
    puts "Getting detailed information for each course:"
    data = []
    courses.each_with_index do |course, index|
      course['course_code'] = "#{course['subject']}#{course['catalog_number']}"
      puts 'Getting data for: ' + course['course_code']
      #per course, make another request to get detailed info:
      uri = get_uri('/courses/' + courses[index]['course_id'] + '.json')
      course_info = JSON.parse(Net::HTTP.get(uri))['data']
      course['description'] = course_info['description']
      course['calendar_year'] = course_info['calendar_year']
      course['academic_level'] = course_info['academic_level']
      course['url'] = course_info['url']
      data.push(course)
    end
    data
  end

  def write_to_db(conn, courses)
    puts "\nWriting #{courses.count} courses to the db."
    courses.each_with_index do |course|
      begin
        puts "Inserting: #{course['course_code']}"
        conn.exec_prepared(
          'insert_course',
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
  end
end
