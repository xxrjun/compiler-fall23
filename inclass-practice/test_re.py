import re

def verify_student_number(student_number):
    pattern = re.compile(r'^(101|102|103)(403|502|522|525)(00[1-9]|0[1-9]\d|[1-5]\d\d)$')
    
    if pattern.match(student_number):
        return True
    else:
        return False

student_numbers = ["101502000", "101502042", "103525006", "102403587", "104525600", "101502600"]

for number in student_numbers:
    is_valid = verify_student_number(number)
    print(f"The student number {number} is valid: {is_valid}")

