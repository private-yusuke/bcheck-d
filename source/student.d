module student;

import course;
import rating;
import grade;

import std.algorithm : map, reduce, filter;
import std.array;

/**
 * 生徒
 */
class Student
{
    string id;
    string name;

    /// 各科目の成績
    private Grade[Course] grades;
    /// 科目番号から科目への対応
    private Course[string] courseIdToCourse;

    this(string id, string name)
    {
        this.id = id;
        this.name = name;
    }

    /**
     * 科目の成績を設定します。
     */
    void setGrade(Course course, Grade grade)
    {
        this.grades[course] = grade;
        this.courseIdToCourse[course.id] = course;
    }

    /**
     * 科目の成績を取得します。
     */
    Grade getGrade(string courseId)
    {
        return this.grades[this.courseIdToCourse[courseId]];
    }

    /**
     * 対応する科目番号の科目を返します。
     */
    Course getCourseById(string courseId)
    {
        return this.courseIdToCourse[courseId];
    }

    /**
     * Grade point の総和を返します。
     */
    float gradePointSum()
    {
        return this.grades
            .byPair
            .filter!(p => p.value.isGPACalculationTarget)
            .map!(p => p.value.rating.toScore * p.key.credit)
            .reduce!((a, b) => a + b);
    }

    /**
     * Grade point average（GPA）を返します。
     */
    float gradePointAverage()
    {
        float creditSum = this.grades
            .byPair
            .filter!(p => p.value.isGPACalculationTarget)
            .map!(p => p.key.credit)
            .reduce!((a, b) => a + b);

        return this.gradePointSum() / creditSum;
    }

    /**
     * 与えられた科目番号に対応する科目の単位が取れている場合は true を、そうでない場合は false を返します。
     */
    bool hasPassed(string courseId)
    {
        Course course = this.courseIdToCourse[courseId];
        return this.grades[course].hasPassed();
    }

    Course[] getPassedCourses()
    {
        return this.grades
            .byPair
            .filter!(p => p.value.hasPassed())
            .map!(p => p.key)
            .array;
    }

    Course[] getInProgressCourses()
    {
        return this.grades
            .byPair
            .filter!(p => p.value.rating == Rating.InProgress)
            .map!(p => p.key)
            .array;
    }
}
