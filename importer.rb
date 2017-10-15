require 'net/http'
require 'json'
require 'uwaterlooapi'
require 'pg'

# puts 'Running importer...'
class CourseImporter
  def import
    # api constants:
    api_endpoint = 'https://api.uwaterloo.ca/v2'
    api_key = 'e9db265c52b8e5dcf2abb78ad35786d5'
    # db constants:
    db_uri = 'jdbc:postgres://ilsdsksvmgqggo:926c02bd811e5b9eb4c8b329a69feebe9b3'\
              'c0b9173117cac934de2b23dbfc25b@ec2-23-21-80-230.compute-1.amazonaws.'\
              'com:5432/d5pboef9dgbcoq'
    db_host = 'ec2-23-21-80-230.compute-1.amazonaws.com'
    db_name = 'd5pboef9dgbcoq'
    db_pass = '926c02bd811e5b9eb4c8b329a69feebe9b3c0b9173117cac934de2b23dbfc25b'
    db_user = 'ilsdsksvmgqggo'
    db_port = 5432

    actual_conn = PG::Connection.open(host: db_host, port: db_port, dbname: db_name, user: db_user, password: db_pass)

    uri = URI(api_endpoint + '/courses.json?key=' + api_key)
    res = Net::HTTP.get(uri)
    json = JSON.parse(res)
    courses = json['data']
    data = []

    courses.each_with_index do |course, index|
      course['course_code'] = "#{course['subject']}#{course['catalog_number']}"
      #per course, make another request to get detailed info:
      uri = URI(api_endpoint + '/courses/' + courses[0]['course_id'] + '.json?key=' + api_key)
      course_info = JSON.parse(Net::HTTP.get(uri))['data']
      course['description'] = course_info['description']
      course['calendar_year'] = course_info['calendar_year']
      course['academic_level'] = course_info['academic_level']
      course['url'] = course_info['url']
      data.push(course)
      break if index == 10
    end
    puts "#{courses.count} courses were pulled."

    table_name = "course.course_catalog"
    # conn = PG::Connection.open(dbname: 'gpsApp_test')
    actual_conn.prepare('insert_course', "insert into #{table_name} (id, code,
       subject, catalog_number, course_name, description, academic_level, calendar_year, url)
       values ($1, $2, $3, $4, $5, $6, $7, $8, $9)")

    data.each do |course|
      actual_conn.exec_prepared('insert_course', [course['course_id'], course['course_code'],
        course['subject'], course['catalog_number'], course['title'], course['description'],
        course['academic_level'], course['calendar_year'], course['url']])
    end
  end
end
