import requests
import json

BASE_URL = "http://localhost:5000/students"
RESULTS_FILE = "results.txt"


def log_result(message):
    print(message)
    with open(RESULTS_FILE, 'a', encoding='utf-8') as f:
        f.write(message + '\n')


def run_tests():
    open(RESULTS_FILE, 'w').close()

    log_result("--- 1. GET ALL STUDENTS (Initial) ---")
    response = requests.get(BASE_URL)
    log_result(f"Status: {response.status_code}")
    log_result(f"Response: {json.dumps(response.json(), indent=2)}\n")

    log_result("--- 2. CREATE THREE STUDENTS (POST) ---")
    students_to_create = [
        {"first_name": "Harry", "last_name": "Potter", "age": 20},
        {"first_name": "Hermione", "last_name": "Granger", "age": 21},
        {"first_name": "Ron", "last_name": "Weasley", "age": 22}
    ]
    created_students = []
    for student_data in students_to_create:
        response = requests.post(BASE_URL, json=student_data)
        log_result(f"Creating {student_data['first_name']}: Status {response.status_code}")
        created_students.append(response.json())
    log_result(f"Created students data: {json.dumps(created_students, indent=2)}\n")

    student_1_id = created_students[0]['id']
    student_2_id = created_students[1]['id']
    student_3_id = created_students[2]['id']

    log_result("--- 3. GET ALL STUDENTS (After creation) ---")
    response = requests.get(BASE_URL)
    log_result(f"Status: {response.status_code}")
    log_result(f"Response: {json.dumps(response.json(), indent=2)}\n")

    log_result(f"--- 4. UPDATE AGE OF STUDENT {student_2_id} (PATCH) ---")
    patch_data = {"age": 25}
    response = requests.patch(f"{BASE_URL}/{student_2_id}", json=patch_data)
    log_result(f"Status: {response.status_code}")
    log_result(f"Response: {json.dumps(response.json(), indent=2)}\n")

    log_result(f"--- 5. GET STUDENT {student_2_id} (After PATCH) ---")
    response = requests.get(f"{BASE_URL}/{student_2_id}")
    log_result(f"Status: {response.status_code}")
    log_result(f"Response: {json.dumps(response.json(), indent=2)}\n")

    log_result(f"--- 6. UPDATE STUDENT {student_3_id} (PUT) ---")
    put_data = {"first_name": "Ronald", "last_name": "Bilius", "age": 23}
    response = requests.put(f"{BASE_URL}/{student_3_id}", json=put_data)
    log_result(f"Status: {response.status_code}")
    log_result(f"Response: {json.dumps(response.json(), indent=2)}\n")

    log_result(f"--- 7. GET STUDENT {student_3_id} (After PUT) ---")
    response = requests.get(f"{BASE_URL}/{student_3_id}")
    log_result(f"Status: {response.status_code}")
    log_result(f"Response: {json.dumps(response.json(), indent=2)}\n")

    log_result("--- 8. GET ALL STUDENTS (After updates) ---")
    response = requests.get(BASE_URL)
    log_result(f"Status: {response.status_code}")
    log_result(f"Response: {json.dumps(response.json(), indent=2)}\n")

    log_result(f"--- 9. DELETE STUDENT {student_1_id} ---")
    response = requests.delete(f"{BASE_URL}/{student_1_id}")
    log_result(f"Status: {response.status_code}")
    log_result(f"Response: {json.dumps(response.json(), indent=2)}\n")

    log_result("--- 10. GET ALL STUDENTS (Final state) ---")
    response = requests.get(BASE_URL)
    log_result(f"Status: {response.status_code}")
    log_result(f"Response: {json.dumps(response.json(), indent=2)}\n")


if __name__ == '__main__':
    run_tests()