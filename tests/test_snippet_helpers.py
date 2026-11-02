import os
from pathlib import Path
import re
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "pythonx"))
from nvim_snippet_helpers import add_entry, create_input


def args(value):
    return re.fullmatch(r"(.*)", value)


class SnippetFiles(unittest.TestCase):
    def setUp(self):
        self.previous = Path.cwd()
        self.directory = tempfile.TemporaryDirectory()
        os.chdir(self.directory.name)

    def tearDown(self):
        os.chdir(self.previous)
        self.directory.cleanup()

    def test_existing_input_is_preserved(self):
        path = Path("chapter.tex")
        path.write_text("existing work", encoding="utf-8")
        self.assertEqual(create_input(args("chapter, Replacement")), r"\input{chapter}")
        self.assertEqual(path.read_text(), "existing work")

    def test_input_header_and_plain_file(self):
        create_input(args("chapter, My title, subsection"))
        self.assertEqual(Path("chapter.tex").read_text(), "\\subsection{My title}\n")
        create_input(args("empty"))
        self.assertEqual(Path("empty.tex").read_text(), "")

    def test_shell_characters_are_literal(self):
        create_input(args("my chapter, $(touch unexpected)"))
        self.assertEqual(Path("my chapter.tex").read_text(), "\\section{$(touch unexpected)}\n")
        self.assertFalse(Path("unexpected").exists())

    def test_symlink_target_is_preserved(self):
        Path("target.tex").write_text("original", encoding="utf-8")
        Path("alias.tex").symlink_to("target.tex")
        create_input(args("alias, Replacement"))
        self.assertEqual(Path("target.tex").read_text(), "original")

    def test_databases_append_and_deduplicate(self):
        Path("kldb.tex").write_text("existing", encoding="utf-8")
        for _ in range(2):
            self.assertEqual(add_entry("knowledge", args("ideal, synonym")), r"\intro{ideal}")
            self.assertEqual(add_entry("glossary", args("ring, Ring, A structure")), r"\glsadd{ring}")
        self.assertEqual(Path("kldb.tex").read_text(), "existing\n\\knowledge{notion, index=ideal}\n| ideal\n| synonym\n")
        self.assertEqual(Path("idxdb.tex").read_text(), "\\newglossaryentry{ring}{name={Ring},description={A structure}}\n")


if __name__ == "__main__":
    unittest.main()
