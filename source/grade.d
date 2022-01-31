module grade;

import course;
import rating;

/**
 * 成績
 */
struct Grade
{
    Rating rating;
    bool gpaCalculationTarget;
}

/**
 * 与えられた成績が GPA 計算対象である場合は true を、そうでない場合は false を返します。
 */
bool isGPACalculationTarget(Grade grade)
{
    import std.algorithm : canFind;

    with (Rating)
    {
        return [APlus, A, B, C, D].canFind(grade.rating) && grade.gpaCalculationTarget;
    }
}

/**
 * 与えられた成績が単位を取れたことに相当している場合は true を、そうでない場合は false を返します。
 */
bool hasPassed(Grade grade)
{
    import std.algorithm : canFind;

    with (Rating)
    {
        return [APlus, A, B, C, P, Admitted].canFind(grade.rating);
    }
}
