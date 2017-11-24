require './course_indexer'

class WaterlooIndexer < CourseIndexer
  def get_data
    get_course_specific_data(get_course_list)
  end

  private

  def get_course_list
    res = Net::HTTP.get(get_uri('/courses.json'))
    JSON.parse(res)['data']
  end

  def get_uri(endpoint)
    URI(ENV.fetch('API_ENDPOINT') + endpoint + '?key=' + ENV.fetch('API_KEY'))
  end

  def get_course_specific_data(courses)
    puts "#{courses.count} courses retrieved."
    puts "Getting detailed information for each course:"
    data = []
    courses.each_with_index do |course, index|
      begin
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
        puts "\tData retrieved."
      rescue
        puts "\tRetrieval failed."
      end
    end
    data
  end
end
