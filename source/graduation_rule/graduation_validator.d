module graduation_rule.graduation_validator;

import student, graduation_rule.rule;
import colorize : fg, color;
import std.string;

class GraduationValidator
{
    private Rule[] rules;

    /// ID から Rule へのマッピング
    private Rule[string] ruleIdToRule;

    this(Rule[] rules)
    {
        Rule[string] tmp;
        foreach (rule; rules)
        {
            if (rule.id in tmp)
            {
                import std.string : format;

                throw new Exception("Duplicated id for rule: %s".format(rule.id));
            }
            tmp[rule.id] = rule;
        }
        this.ruleIdToRule = tmp;

        this.rules = rules;
    }

    Rule getRule(string ruleId)
    {
        if (ruleId !in ruleIdToRule)
        {
            import std.string : format;

            throw new Exception("Rule(id: %s) couldn't be found.".format(ruleId));
        }
        return ruleIdToRule[ruleId];
    }

    string getValidationResult(Student student)
    {
        string res;

        string statusToString(StudentRuleStatus status)
        {
            const string[StudentRuleStatus] m = [
                StudentRuleStatus.Pass: "pass".color(fg.green),
                StudentRuleStatus.InProgress: "wip ".color(fg.yellow),
                StudentRuleStatus.Fail: "fail".color(fg.red),
            ];
            return m[status];
        }

        foreach (rule; rules)
        {
            StudentRuleStatus status = rule.getStatus(this, student);
            res ~= format("%s(%2.1f / %2.1f): %s\n", statusToString(status), rule.getPassedCreditSum(this, student), rule
                    .min, rule);
        }

        return res;
    }
}
