# number of courses user can create each day
MAX_COURSE_PER_DAY = 5

# number of courses required by user until SecurityService.fake_courses? checks if there are enough students
FAKE_COURSES_CHECK_MIN = 6

# acceptable minimum number of students for courses checked by SecurityService.fake_courses?
FAKE_COURSES_STUDENT_MIN = 10

# characters used in XSS check. These are not allowed in course name or coursekey
BAD_CHARACTERS = ["&", "<", ">", '"', "'", "`", "!", "@", "$", "%", "(", ")", "=", "+", "{", "}", "[", "]"]

# max length for course's name
MAX_COURSE_NAME_LENGTH = 40

# max length for coursekey
MAX_COURSE_KEY_LENGTH = 25

# max length for schedule's name
MAX_SCHEDULE_NAME_LENGTH = 30
