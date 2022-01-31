module rating;

/**
 * 総合評価
 */
enum Rating
{
    APlus,
    A,
    B,
    C,
    D,
    P,
    F,
    Admitted,
    InProgress,
}

/**
 * 与えられた CSV 上での文字列に対応する Rating を返します。
 */
Rating toRating(string csvRatingString)
{
    const Rating[string] m = [
        "A+": Rating.APlus,
        "A": Rating.A,
        "B": Rating.B,
        "C": Rating.C,
        "D": Rating.D,
        "P": Rating.P,
        "F": Rating.F,
        "認": Rating.Admitted,
        "履修中": Rating.InProgress,
    ];
    if (csvRatingString !in m)
    {
        import std.string : format;

        throw new Exception("Unsupported rating string: %d".format(csvRatingString));
    }
    return m[csvRatingString];
}

/**
 * 与えられた Rating から対応する Grade point に変換します。
 * 対応する Grade point が未定義である場合は例外が発生します。
 */
float toScore(Rating rating)
{
    const float[Rating] m = [
        Rating.APlus: 4.3,
        Rating.A: 4,
        Rating.B: 3,
        Rating.C: 2,
        Rating.D: 0,
    ];

    if (rating !in m)
    {
        import std.string : format;

        throw new Exception("Unable to convert to score from given rating %d".format(rating));
    }

    return m[rating];
}
