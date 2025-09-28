import os
import csv
from flask import Flask, jsonify, request

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_FILE = os.path.join(BASE_DIR, "students.csv")
FIELDS = ["id", "first_name", "last_name", "age"]
REQUIRED_POST_FIELDS = {"first_name", "last_name", "age"}
REQUIRED_PUT_FIELDS = {"first_name", "last_name", "age"}
REQUIRED_PATCH_FIELDS = {"age"}


def read_students_from_file():
    if not os.path.exists(CSV_FILE):
        return []
    try:
        with open(CSV_FILE, mode='r', newline='', encoding='utf-8') as f:
            if f.read().strip() == "":
                return []
            f.seek(0)
            reader = csv.DictReader(f)
            return list(reader)
    except Exception:
        return []


def write_students_to_file(students):
    with open(CSV_FILE, mode='w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(students)


def get_next_id():
    students = read_students_from_file()
    if not students:
        return 1
    return max(int(s['id']) for s in students) + 1


@app.route('/students', methods=['GET'])
def get_all_or_by_lastname():
    students = read_students_from_file()
    last_name_query = request.args.get('last_name')

    if last_name_query:
        filtered_students = [s for s in students if s['last_name'].lower() == last_name_query.lower()]
        if not filtered_students:
            return jsonify({"error": f"No students found with last name '{last_name_query}'"}), 404
        return jsonify(filtered_students), 200

    return jsonify(students), 200


@app.route('/students/<int:student_id>', methods=['GET'])
def get_student_by_id(student_id):
    students = read_students_from_file()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if student:
        return jsonify(student), 200
    return jsonify({"error": f"Student with ID {student_id} not found"}), 404


@app.route('/students', methods=['POST'])
def create_student():
    if not request.json:
        return jsonify({"error": "No data provided"}), 400

    data = request.json
    if set(data.keys()) != REQUIRED_POST_FIELDS:
        return jsonify({"error": "You must provide exactly these fields: first_name, last_name, age"}), 400

    new_student = {
        "id": get_next_id(),
        "first_name": data["first_name"],
        "last_name": data["last_name"],
        "age": data["age"]
    }

    students = read_students_from_file()
    students.append(new_student)
    write_students_to_file(students)

    return jsonify(new_student), 201


@app.route('/students/<int:student_id>', methods=['PUT'])
def update_student_put(student_id):
    if not request.json:
        return jsonify({"error": "No data provided"}), 400

    data = request.json
    if set(data.keys()) != REQUIRED_PUT_FIELDS:
        return jsonify({"error": "You must provide exactly these fields: first_name, last_name, age"}), 400

    students = read_students_from_file()
    student_to_update = None
    for s in students:
        if int(s['id']) == student_id:
            student_to_update = s
            break

    if not student_to_update:
        return jsonify({"error": f"Student with ID {student_id} not found"}), 404

    student_to_update['first_name'] = data['first_name']
    student_to_update['last_name'] = data['last_name']
    student_to_update['age'] = data['age']

    write_students_to_file(students)
    return jsonify(student_to_update), 200


@app.route('/students/<int:student_id>', methods=['PATCH'])
def update_student_patch(student_id):
    if not request.json:
        return jsonify({"error": "No data provided"}), 400

    data = request.json
    if set(data.keys()) != REQUIRED_PATCH_FIELDS:
        return jsonify({"error": "You must provide exactly this field: age"}), 400

    students = read_students_from_file()
    student_to_update = None
    for s in students:
        if int(s['id']) == student_id:
            student_to_update = s
            break

    if not student_to_update:
        return jsonify({"error": f"Student with ID {student_id} not found"}), 404

    student_to_update['age'] = data['age']

    write_students_to_file(students)
    return jsonify(student_to_update), 200


@app.route('/students/<int:student_id>', methods=['DELETE'])
def delete_student(student_id):
    students = read_students_from_file()

    student_exists = any(int(s['id']) == student_id for s in students)
    if not student_exists:
        return jsonify({"error": f"Student with ID {student_id} not found"}), 404

    students_after_deletion = [s for s in students if int(s['id']) != student_id]
    write_students_to_file(students_after_deletion)

    return jsonify({"message": f"Student with ID {student_id} has been deleted successfully."}), 200


if __name__ == '__main__':
    app.run(debug=True)