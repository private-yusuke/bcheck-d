module graduation_rule.rule;

import student;
import graduation_rule.graduation_validator;

/**
 * それぞれの卒業要件に対する生徒の状態
 */
enum StudentRuleStatus
{
    Pass,
    Fail,
    InProgress,
}

/**
 * 卒業要件
 */
interface Rule
{
    @property string id();
    @property string name();
    @property float min();
    @property float max();
    StudentRuleStatus getStatus(GraduationValidator validator, Student student);
    float getPassedCreditSum(GraduationValidator validator, Student student);
    float getInProgressCreditSum(GraduationValidator validator, Student student);
}
