module graduation_rule.addition_rule;

import graduation_rule.rule;
import graduation_rule.graduation_validator;

import student;
import grade;
import rating;

/**
 * 他の Rule で数え上げられている取得済み単位の数を合わせたときに最低数を上回っているか確認するための Rule
 */
class AdditionRule : Rule
{
    string _id;
    string _name;
    string[] ruleIds;
    float minCredit;
    float maxCredit;
    private float passedCreditSum;
    private float inProgressCreditSum;

    this(string id, string name, string[] ruleIds, float minCredit, float maxCredit)
    {
        this._id = id;
        this._name = name;
        this.ruleIds = ruleIds;
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

    private float getPassedCreditSumOfRules(GraduationValidator validator, Student student)
    {
        float passedCreditNum = 0.0;

        foreach (ruleId; this.ruleIds)
        {
            import std.stdio;
            import std.algorithm : min;

            Rule rule = validator.getRule(ruleId);
            rule.writeln;

            float creditNum = rule.getPassedCreditSum(validator, student);
            passedCreditNum += min(rule.max, creditNum);
        }

        return passedCreditNum;
    }

    private float getInProgressCreditSumOfRules(GraduationValidator validator, Student student)
    {
        float inProgressCreditNum = 0.0;

        foreach (ruleId; this.ruleIds)
        {
            import std.algorithm : max;

            Rule rule = validator.getRule(ruleId);

            float creditNum = rule.getInProgressCreditSum(validator, student);
            inProgressCreditNum += max(rule.max, creditNum);
        }

        return inProgressCreditNum;
    }

    StudentRuleStatus getStatus(GraduationValidator validator, Student student)
    {
        float passedCreditNum = getPassedCreditSumOfRules(validator, student);
        this.passedCreditSum = passedCreditNum;

        if (minCredit <= passedCreditNum)
            return StudentRuleStatus.Pass;

        float inProgressCreditNum = getInProgressCreditSumOfRules(validator, student);
        this.inProgressCreditSum = inProgressCreditNum;

        if (minCredit <= passedCreditNum + inProgressCreditNum)
            return StudentRuleStatus.InProgress;
        else
            return StudentRuleStatus.Fail;
    }

    float getPassedCreditSum(GraduationValidator validator, Student student)
    {
        if (this.passedCreditSum != -1.0)
            return this.passedCreditSum;
        else
            return this.passedCreditSum = getPassedCreditSumOfRules(validator, student);
    }

    float getInProgressCreditSum(GraduationValidator validator, Student student)
    {
        if (this.inProgressCreditSum != -1.0)
            return this.inProgressCreditSum;
        else
            return this.inProgressCreditSum = getInProgressCreditSumOfRules(validator, student);
    }

    override string toString()
    {
        import std.string : format;

        // return "%.1f ~ %.1f %s".format(this.minCredit, this.maxCredit, this.name);

        return this.name;
    }
}
