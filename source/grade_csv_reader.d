module grade_csv_reader;

import student;
import course;
import rating;
import grade;

/**
 * CSV に記載されているレコード
 */
struct GradeCSVRecord
{
    // CSV の並び順でフィールドが定義されている

    string studentId;
    string studentName;
    string courseId;
    string courseName;
    string courseCreditString;
    string springRating;
    string fallRating;
    string overallRating;
    string courseCategory;
    string courseHeldYear;
    string courseHeldCategory;
}

/**
 * CSV 文字列を与えると、grades フィールドが設定された Student の配列を返します。
 */
Student[] toStudents(string csvContent)
{
    import std.csv;
    import std.string;
    import std.conv : to;

    // 学籍番号から生徒へのマッピング
    Student[string] students;

    foreach (GradeCSVRecord record; csvReader!GradeCSVRecord(csvContent))
    {
        // CSV のヘッダーと思わしきものは無視
        if (record.studentId == "学籍番号")
        {
            continue;
        }

        if (record.studentId !in students)
        {
            students[record.studentId] = new Student(record.studentId, record.studentName);
        }

        CourseCategory courseCategory = record.courseCategory[0].toCourseCategory();
        bool gpaCalculationTarget = record.courseCategory[$ - 1] != '0';

        Course course = Course(record.courseId, record.courseName, record.courseCreditString.strip.to!float, courseCategory);
        Rating rating = record.overallRating.toRating();
        Grade grade = Grade(rating, gpaCalculationTarget);

        students[record.studentId].setGrade(course, grade);
    }

    return students.values;
}
