module graduation_rule.name_regex_match_rule;

import graduation_rule.rule;
import graduation_rule.graduation_validator;

import student;
import course;

class NameRegexMatchRule : Rule
{
    string _id;
    string _name;
    string matcher;
    float minCredit;
    float maxCredit;
    private float passedCreditSum;
    private float inProgressCreditSum;

    this(string id, string name, string matcher, float minCredit, float maxCredit)
    {
        this._id = id;
        this._name = name;
        this.matcher = matcher;
        this.minCredit = minCredit;
        this.maxCredit = maxCredit;
        this.passedCreditSum = -1.0;
        this.inProgressCreditSum = -1.0;
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
        if (this.maxCredit == -1.0)
            return 100;
        else
            return this.maxCredit;
    }

    @property float min()
    {
        if (this.minCredit == -1.0)
            return 0;
        else
            return this.minCredit;
    }

    /**
     * 与えられた正規表現にマッチするような科目番号に対応する科目であって、単位を取れているものの配列を返します。
     */
    private Course[] getRegexPassedCourses(Student student)
    {
        import std.regex;
        import std.algorithm : filter;
        import std.range;

        auto r = regex(matcher);
        Course[] passedCourses = student.getPassedCourses();

        return passedCourses.filter!(
            course => !matchFirst(course.name, r)
                .empty)
            .array;
    }

    /**
     * 与えられた正規表現にマッチするような科目番号に対応する科目であって、履修中のものの配列を返します。
     */
    Course[] getRegexInProgressCourses(Student student)
    {
        import std.regex;
        import std.algorithm : filter;
        import std.range;

        auto r = regex(matcher);
        Course[] inProgressCourses = student.getInProgressCourses();

        return inProgressCourses.filter!(
            course => !matchFirst(course.name, r)
                .empty)
            .array;
    }

    /**
     * 与えられた正規表現にマッチするような科目番号に対応する科目であって、単位を取れているものの単位数の総和を返します。
     */
    float regexPassedCount(Student student)
    {
        import std.regex;
        import std.string : join;
        import std.algorithm : map, reduce, filter;
        import std.range;

        auto r = regex(matcher);
        Course[] passedCourses = student.getPassedCourses();

        import std.stdio;

        this.name.writeln;
        getRegexPassedCourses(student).map!(course => course.name).writeln;

        float[] passedCourseCredits = getRegexPassedCourses(student)
            .map!(course => course.credit)
            .array;
        if (passedCourseCredits.empty)
            return 0.0;
        else
            return passedCourseCredits
                .reduce!((a, b) => a + b);
    }

    /**
     * 与えられた正規表現にマッチするような科目番号に対応する科目であって、履修中の単位の単位数の総和を返します。
     */
    float regexInProgressCount(Student student)
    {
        import std.regex;
        import std.string : join;
        import std.algorithm : map, reduce, filter;
        import std.range;

        auto r = regex(matcher);
        Course[] inProgressCourses = student.getInProgressCourses();

        float[] inProgressCourseCredits = getRegexInProgressCourses(student)
            .map!(course => course.credit)
            .array;
        if (inProgressCourseCredits.empty)
            return 0.0;
        else
            return inProgressCourseCredits
                .reduce!((a, b) => a + b);
    }

    StudentRuleStatus getStatus(GraduationValidator validator, Student student)
    {
        float passedCount = this.regexPassedCount(student);
        this.passedCreditSum = passedCount;

        if (passedCount >= minCredit)
            return StudentRuleStatus.Pass;
        float inProgressCount = this.regexInProgressCount(student);
        if (passedCount + inProgressCount >= minCredit)
            return StudentRuleStatus.InProgress;
        else
            return StudentRuleStatus.Fail;
    }

    float getPassedCreditSum(GraduationValidator validator, Student student)
    {
        if (this.passedCreditSum != -1.0)
            return this.passedCreditSum;
        else
            return this.passedCreditSum = this.regexPassedCount(student);
    }

    float getInProgressCreditSum(GraduationValidator validator, Student student)
    {
        if (this.inProgressCreditSum != -1.0)
            return this.inProgressCreditSum;
        else
            return this.inProgressCreditSum = this.regexInProgressCount(student);
    }

    override string toString()
    {
        import std.string : format;

        // return "%.1f ~ %.1f %s".format(this.minCredit, this.maxCredit, this.name);

        return this.name;
    }
}
