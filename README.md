# bcheck-d

https://twins.tsukuba.ac.jp からダウンロードできる成績の CSV と、卒業要件が記述された JSON ファイルを入力としてとり、卒業可能であるかどうかを色付きでコンソールに出力します。

このプログラムにバグがあったために卒業できない事態になったとしても、開発者は責任を負いません。

## How to run

```
$ git clone git@github.com:private-yusuke/bcheck-d
$ dub build
$ ./bcheck-d -f SIRS202012345.csv -r rules/coins20-software-and-computing-science.json
```

このようにすると、2020 年度に入学した情報科学類の学生であって、主専攻がソフトウェアサイエンスである人を対象とした履修要覧の規則に従って卒業判定を行います。

`rules` ディレクトリの下に、2020 年度に入学した情報科学類の学生である人向けのルールファイルがあります。

## Development

### ユニットテストの実行

```
$ dub test
```

### ビルドと同時に実行

```
$ dub run -- -f SIRS202012345.csv -r coins20.json
```
