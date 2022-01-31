module graduation_rule.rule_reader;

import std.json;

import graduation_rule;

Rule[] toRules(string rulesString)
{
    Rule[] rules;

    JSONValue json = parseJSON(rulesString);
    foreach (rulesJSON; json.array)
    {
        Rule rule;

        switch (rulesJSON["type"].str)
        {
        case "exact_match":
            rule = new ExactMatchRule(rulesJSON["id"].str, rulesJSON["name"].str, rulesJSON["course_id"]
                    .str);
            break;
        case "regex_match":
            rule = new RegexMatchRule(rulesJSON["id"].str, rulesJSON["name"].str, rulesJSON["matcher"].str, rulesJSON["min"]
                    .floating, rulesJSON["max"]
                    .floating);
            break;
        case "name_regex_match":
            rule = new NameRegexMatchRule(rulesJSON["id"].str, rulesJSON["name"].str, rulesJSON["matcher"].str, rulesJSON["min"]
                    .floating, rulesJSON["max"]
                    .floating);
            break;
        case "addition":
            import std.algorithm;
            import std.range;

            string[] additionRules = rulesJSON["rules"].array.map!(e => e.str).array;

            rule = new AdditionRule(rulesJSON["id"].str, rulesJSON["name"].str, additionRules, rulesJSON["min"]
                    .floating, rulesJSON["max"]
                    .floating);
            break;
        default:
            assert(0);
        }

        rules ~= rule;
    }

    return rules;
}
