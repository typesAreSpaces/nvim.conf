"""File operations shared by the TeX and Markdown UltiSnips snippets."""

from pathlib import Path


def stringify_args(rex, num):
    args = ["'" + value + "'" for value in rex.group(1).split(",")]
    return args if num == -1 else args[:num]


def removeExtraQuotes(value):
    return value[1:-1]


def create_input(rex):
    args = [value.strip() for value in rex.group(1).split(",")]
    name = args[0]
    title = args[1] if len(args) > 1 else ""
    header = args[2] if len(args) > 2 else "section"
    try:
        # Exclusive creation preserves existing files, including symlink targets.
        with Path(name + ".tex").open("x", encoding="utf-8") as output:
            if title:
                output.write("\\" + header + "{" + title + "}\n")
    except FileExistsError:
        pass
    return "\\input{" + name + "}"


def add_entry(kind, rex):
    args = [value.strip() for value in rex.group(1).split(",")]
    key = args[0]
    if kind == "knowledge":
        path = Path("kldb.tex")
        marker = "index=" + key + "}"
        content = "\\knowledge{notion, index=" + key + "}\n"
        content += "".join("| " + value + "\n" for value in args)
        result = "\\intro{" + key + "}"
    elif kind == "glossary":
        path = Path("idxdb.tex")
        marker = "\\newglossaryentry{" + key + "}"
        name = args[1] if len(args) > 1 else ""
        description = args[2] if len(args) > 2 else ""
        content = marker + "{name={" + name + "},description={" + description + "}}\n"
        result = "\\glsadd{" + key + "}"
    else:
        raise ValueError("Unknown entry type: " + kind)
    # a+ creates missing databases and never truncates existing content.
    with path.open("a+", encoding="utf-8") as output:
        output.seek(0)
        existing = output.read()
        if marker not in existing:
            if existing and not existing.endswith("\n"):
                output.write("\n")
            output.write(content)
    return result
