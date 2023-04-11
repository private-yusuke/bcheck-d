import std.stdio;
import std.getopt;
import std.file;
import std.typecons : Yes;
import std.array;
import std.range;
import std.conv : to;

import grade_csv_reader;
import student;
import graduation_rule.graduation_validator;
import graduation_rule.rule_reader;

struct ProgramOption
{
	string filePath;
	string rulesFilePath;
}

// unittest のランナーを silly にするときの代償
version (unittest)
{
}
else
{
	int main(string[] args)
	{
		return main2(args);
	}
}

int main2(string[] args)
{
	ProgramOption programOption;

	auto helpInformation = getopt(
		args,
		"file|f", "Path to the target CSV file. Without this option, this program reads stdin.", &programOption
			.filePath,
			config.required, "rules|r", "Path to the rules JSON file.", &programOption
			.rulesFilePath
	);

	if (helpInformation.helpWanted)
	{
		defaultGetoptPrinter("An application to check whether you as a coins20 student can graduate or not.", helpInformation
				.options);
		return 0;
	}

	if (programOption.filePath && !exists(programOption.filePath))
	{
		stderr.writefln("%s doesn't exist", programOption.filePath);
		return 1;
	}
	if (programOption.rulesFilePath && !exists(programOption.rulesFilePath))
	{
		stderr.writefln("%s doesn't exist", programOption.rulesFilePath);
		return 2;
	}

	File gradeFile = programOption.filePath ? File(programOption.filePath) : stdin;
	string csvContent = gradeFile.byLineCopy(Yes.keepTerminator).join.array.to!string;

	File rulesFile = programOption.rulesFilePath ? File(programOption.rulesFilePath) : stdin;
	string rulesJSONContent = rulesFile.byLineCopy(Yes.keepTerminator).join.array.to!string;

	// TODO: 複数の生徒について同時に裁けるようにする（stdin に cat で入ってきた複数の生徒のデータを処理するイメージ）
	// 以下にある表示部分を対応させれば実現可能
	Student s = toStudents(csvContent)[0];

	GraduationValidator gv = new GraduationValidator(toRules(rulesJSONContent));
	gv.getValidationResult(s).writeln;
	"GPA: %f".writefln(s.gradePointAverage());
	"取得済み単位数: %f".writefln(s.getPassedCreditSum());
	"A 以上率: %f".writefln(s.getRatioOfCoursesWithRatingOverA());

	return 0;
}
