import pandas as pd
import random
import datetime
import os
from faker import Faker
from datetime import date, timedelta

fake = Faker()
output_folder = 'output_csv'
os.makedirs(output_folder, exist_ok=True)

# Parameters
num_students = 50
num_employees = 20
num_classes = 6
num_terms = 3
num_grades = 6

def random_date(start_year, end_year):
    start = date(start_year, 1, 1)
    end = date(end_year, 12, 31)
    return start + timedelta(days=random.randint(0, (end - start).days))

# --- DimGradingScale ---
dim_grading_scale = []
grades = [
    (1, 0, 49.99, 'F', 0.0),
    (2, 50, 59.99, 'D', 1.0),
    (3, 60, 69.99, 'C', 2.0),
    (4, 70, 79.99, 'B', 3.0),
    (5, 80, 89.99, 'A', 4.0),
    (6, 90, 100, 'A+', 4.5)
]
for g in grades:
    dim_grading_scale.append({
        'GradeID': g[0], 'MinScore': g[1], 'MaxScore': g[2],
        'GradeLetter': g[3], 'GradePoint': g[4]
    })

# --- DimTerm ---
dim_term = []
for i in range(num_terms):
    year = random.choice(['2022/2023', '2023/2024', '2024/2025'])
    dim_term.append({
        'TermID': i+1,
        'TermName': f'Term{i+1}',
        'AcademicYear': year
    })

# --- DimClass ---
dim_class = []
for i in range(num_classes):
    dim_class.append({
        'ClassID': i+1,
        'ClassName': f'Grade{i+1}',
        'ClassTeacherID': None  # Will assign later
    })

# --- DimEmployee ---
dim_employee = []
for i in range(num_employees):
    hire_year = random.randint(2010, 2024)
    hire_date = fake.date_between_dates(date_start=date(hire_year,1,1), date_end=date(hire_year,12,31))
    employee_id = int(f"{hire_year}{i+1:03d}")
    dim_employee.append({
        'EmployeeID': employee_id,
        'FirstName': fake.first_name(),
        'LastName': fake.last_name(),
        'Role': random.choice(['Teacher', 'Admin', 'Counselor']),
        'Department': random.choice(['Science', 'Arts', 'Sports']),
        'PhoneNo': fake.phone_number(),
        'Address': fake.address(),
        'HireDate': hire_date,
        'SupervisorID': None
    })

# Assign ClassTeacherID from Teachers only
teacher_ids = [emp['EmployeeID'] for emp in dim_employee if emp['Role'] == 'Teacher']
for cls in dim_class:
    cls['ClassTeacherID'] = random.choice(teacher_ids) if teacher_ids else None

# --- DimSubject ---
junior_subjects = ['Math', 'English', 'Science']
senior_science = ['Math', 'English', 'Physics', 'Chemistry', 'Biology']
senior_arts = ['Math', 'English', 'Geography', 'Economics', 'Literature']

dim_subject = []
subject_id = 101
for grade in range(1, 4):  # Junior grades 1-3
    for subj in junior_subjects:
        dim_subject.append({
            'SubjectID': subject_id,
            'SubjectName': f"{subj}_G{grade}",
            'CreditUnit': 3
        })
        subject_id += 1

for grade in range(4, 7):  # Senior grades 4-6
    for subj in senior_science + senior_arts:
        dim_subject.append({
            'SubjectID': subject_id,
            'SubjectName': f"{subj}_G{grade}",
            'CreditUnit': 3
        })
        subject_id += 1

# --- DimStudent ---
dim_student = []
for i in range(num_students):
    enrollment_year = random.randint(2018, 2024)
    enrollment_date = fake.date_between_dates(date_start=date(enrollment_year,1,1), date_end=date(enrollment_year,12,31))
    student_id = int(f"{enrollment_year}{i+1:03d}")
    class_id = random.randint(1, num_classes)
    dob = fake.date_of_birth(minimum_age=6, maximum_age=18)
    dim_student.append({
        'StudentID': student_id,
        'FirstName': fake.first_name(),
        'LastName': fake.last_name(),
        'Gender': random.choice(['Male', 'Female', 'Other']),
        'DateOfBirth': dob,
        'ClassID': class_id,
        'EnrollmentDate': enrollment_date,
        'GraduationDate': None
    })

# --- FactStudentPerformance ---
fact_performance = []
perf_id = 1
for student in dim_student:
    class_id = student['ClassID']
    # Select relevant subjects
    if class_id <= 3:
        subjects = [sub for sub in dim_subject if f"G{class_id}" in sub['SubjectName'] and any(j in sub['SubjectName'] for j in junior_subjects)]
    else:
        # Randomly assign Science or Arts track
        track = random.choice(['Science', 'Arts'])
        subjects = [sub for sub in dim_subject if f"G{class_id}" in sub['SubjectName'] and
                    any(s in sub['SubjectName'] for s in (senior_science if track == 'Science' else senior_arts))]
    for subj in subjects:
        fact_performance.append({
            'PerformanceID': perf_id,
            'StudentID': student['StudentID'],
            'SubjectID': subj['SubjectID'],
            'TermID': random.randint(1, num_terms),
            'GradeID': random.randint(1, num_grades),
            'ScoreObtained': round(random.uniform(40, 100), 2)
        })
        perf_id += 1

# --- FactAttendance --- (Updated)
fact_attendance = []
attend_id = 1

# Define realistic term date ranges (adjust these as needed)
term_dates = {
    1: (date(2022, 1, 1), date(2022, 4, 30)),
    2: (date(2022, 5, 1), date(2022, 8, 31)),
    3: (date(2022, 9, 1), date(2022, 12, 31)),
}

for student in dim_student:
    for term_id, (start_date, end_date) in term_dates.items():
        total_days_in_term = (end_date - start_date).days + 1
        all_term_dates = [start_date + timedelta(days=x) for x in range(total_days_in_term)]

        # For example: student attends 80% of days (you can adjust)
        num_attendance_days = int(total_days_in_term * 0.8)

        # Sample unique attendance dates for this student in this term
        attendance_dates = random.sample(all_term_dates, num_attendance_days)

        for att_date in attendance_dates:
            status = random.choices(
                ['Present', 'Absent', 'Late'],
                weights=[0.85, 0.10, 0.05],
                k=1
            )[0]

            fact_attendance.append({
                'AttendanceID': attend_id,
                'StudentID': student['StudentID'],
                'ClassID': student['ClassID'],
                'TermID': term_id,
                'Date': att_date,
                'AttendanceStatus': status
            })
            attend_id += 1

# --- FactPayment ---
fact_payment = []
payment_id = 1
for student in dim_student:
    for term in dim_term:
        status = random.choice(['Paid', 'Partial', 'Unpaid'])
        payment_date = random_date(2022, 2024) if status in ['Paid', 'Partial'] else None
        fact_payment.append({
            'PaymentID': payment_id,
            'StudentID': student['StudentID'],
            'TermID': term['TermID'],
            'AmountPaid': round(random.uniform(200, 500), 2),
            'PaymentStatus': status,
            'PaymentDate': payment_date
        })
        payment_id += 1

# --- TaughtBy ---
taught_by = []
for cls in dim_class:
    class_id = cls['ClassID']
    relevant_subjects = [sub for sub in dim_subject if f"G{class_id}" in sub['SubjectName']]
    for subj in relevant_subjects:
        taught_by.append({
            'EmployeeID': random.choice(teacher_ids),
            'ClassID': class_id,
            'SubjectID': subj['SubjectID']
        })

# --- Export to CSV ---
pd.DataFrame(dim_student).to_csv(f'{output_folder}/DimStudent.csv', index=False)
pd.DataFrame(dim_employee).to_csv(f'{output_folder}/DimEmployee.csv', index=False)
pd.DataFrame(dim_class).to_csv(f'{output_folder}/DimClass.csv', index=False)
pd.DataFrame(dim_term).to_csv(f'{output_folder}/DimTerm.csv', index=False)
pd.DataFrame(dim_grading_scale).to_csv(f'{output_folder}/DimGradingScale.csv', index=False)
pd.DataFrame(dim_subject).to_csv(f'{output_folder}/DimSubject.csv', index=False)
pd.DataFrame(fact_performance).to_csv(f'{output_folder}/FactStudentPerformance.csv', index=False)
pd.DataFrame(fact_attendance).to_csv(f'{output_folder}/FactAttendance.csv', index=False)
pd.DataFrame(fact_payment).to_csv(f'{output_folder}/FactPayment.csv', index=False)
pd.DataFrame(taught_by).to_csv(f'{output_folder}/TaughtBy.csv', index=False)

print("✅ All tables generated and saved as CSV in 'output_csv' folder.")
