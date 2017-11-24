class PGManager
  attr_accessor :connection
  def initialize
    @connection = PG::Connection.open(
      host: ENV.fetch('DB_HOST'),
      port: ENV.fetch('DB_PORT'),
      dbname: ENV.fetch('DB_NAME'),
      user: ENV.fetch('DB_USER'),
      password: ENV.fetch('DB_PASS')
    )
  end

  def create_prepared_insert
    @connection.prepare(
      'insert_course_catalog',
      "insert into course.course_catalog (code, subject, catalog_number,
       course_name, description, academic_level, calendar_year, url)
       values ($1, $2, $3, $4, $5, $6, $7, $8)")
    @connection.prepare(
      'insert_subject',
      "insert into course.subjects (subject) values ($1)")
  end
end
