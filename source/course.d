module course;

/**
 * 科目の種類
 */
enum CourseCategory
{
    Basic, // 基礎科目
    BasicSpecialized, // 専門基礎科目
    Specialized, // 専門科目
}

/**
 * 与えられた科目区分に対応する CourseCategory を返します。
 */
CourseCategory toCourseCategory(char categoryChar)
{
    const CourseCategory[char] m = [
        'A': CourseCategory.Basic,
        'B': CourseCategory.BasicSpecialized,
        'C': CourseCategory.Specialized,
    ];
    if (categoryChar !in m)
    {
        import std.string : format;

        throw new Exception("Unsupported course category string: %s".format(categoryChar));
    }
    return m[categoryChar];
}

/**
 * 科目
 */
struct Course
{
    string id;
    string name;
    float credit;
    CourseCategory category;
}
