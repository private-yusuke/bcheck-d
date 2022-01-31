module graduation_rule.exact_match_rule;

import graduation_rule.rule;
import graduation_rule.graduation_validator;

import student;
import grade;
import rating;

/**
 * 単位の取れている科目のうち、完全一致する科目番号があるか確認するための Rule
 */
class ExactMatchRule : Rule
{
    string _id;
    string _name;
    string courseId;

    this(string id, string name, string courseId)
    {
        this._id = id;
        this._name = name;
        this.courseId = courseId;
    }

    @property string id()
    {
        return this._id;
    }

    @property string name()
    {
        return this._name;
    }

    @property float max()
    {
        return 100.0;
    }

    @property float min()
    {
        return 0.0;
    }

    StudentRuleStatus getStatus(GraduationValidator validator, Student student)
    {
        Grade grade = student.getGrade(this.courseId);

        if (grade.hasPassed())
            return StudentRuleStatus.Pass;
        else if (grade.rating == Rating.InProgress)
            return StudentRuleStatus.InProgress;
        else
            return StudentRuleStatus.Fail;
    }

    float getPassedCreditSum(GraduationValidator validator, Student student)
    {
        Grade grade = student.getGrade(this.courseId);

        if (grade.hasPassed())
            return student.getCourseById(this.courseId).credit;
        else
            return 0.0;
    }

    float getInProgressCreditSum(GraduationValidator validator, Student student)
    {
        Grade grade = student.getGrade(this.courseId);

        if (grade.rating == Rating.InProgress)
            return student.getCourseById(this.courseId).credit;
        else
            return 0.0;
    }

    override string toString()
    {
        import std.string : format;

        return "%s (%s)".format(this.name, this.courseId);
    }

    @("with student who passed the course passes the rule")
    unittest
    {
        import course, grade, rating;

        Rule r = new ExactMatchRule("専門基礎科目/必修科目/線形代数A", "GA15211");
        Student s = new Student("202000001", "student1");

        Course c = Course("GA15211", "線形代数A", 2.0, CourseCategory.BasicSpecialized);
        s.setGrade(c, Grade(Rating.A, true));

        assert(r.pass(s));
    }

    @("with student who couldn't pass the course won't pass the rule")
    unittest
    {
        import course, grade, rating;

        Rule r = new ExactMatchRule("専門基礎科目/必修科目/線形代数A", "GA15211");
        Student s = new Student("202000001", "student1");

        Course c = Course("GA15211", "線形代数A", 2.0, CourseCategory.BasicSpecialized);
        s.setGrade(c, Grade(Rating.D, true));

        assert(!r.pass(s));
    }
}
