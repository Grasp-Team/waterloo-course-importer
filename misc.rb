#misc
# throw away code:

# psql table command
# CREATE TABLE temp_courses (
#   course_id text NOT NULL,
#   course_code text NOT NULL,
#   subject text NOT NULL,
#   catalog_number text NOT NULL,
#   name text,
#   description text,
#   academic_level text,
#   calendar_year text,
#   url text,
#   CONSTRAINT courses PRIMARY KEY (course_id)
# );

# CREATE TABLE brotha (
#   id integer PRIMARY KEY,
#   code text NOT NULL,
#   subject text NOT NULL,
#   catalog_number integer NOT NULL,
#   name text,
#   description text,
#   academic_level text,
#   calendar_year integer,
#   url text
# );

# test insert
# conn.exec_prepared('insert_course', ['1' , '2', '3', '4', '5' , '6' ,'7' ,'8' ,'9'])
# course = courses[0]
# conn.exec_prepared('insert_course', [course['course_id'], course['course_code'],
#   course['subject'], course['catalog_number'], course['title'], course['description'],
#   course['academic_level'], course['calendar_year'], course['url']])

# using ruby library
# https://github.com/amsardesai/uwaterlooapi
# api = UWaterlooAPI.new api_key
# my_favorite_courses = api.courses.subject('CS') # '/courses/CS/247'
# my_favorite_courses.get.each do |course|
#   puts course
# end
# Use the get method to manually retrieve the data and parse it
# puts current_weather.get.temperature_24hr_max_c
