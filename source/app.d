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

	Student s = toStudents(csvContent)[0];
	s.gradePointAverage.writeln;
	s.gradePointSum.writeln;

	GraduationValidator gv = new GraduationValidator(toRules(rulesJSONContent));
	gv.getValidationResult(s).writeln;

	return 0;
}
