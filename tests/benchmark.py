"""Measure warm headless startup and first-use setup without downloads.

Run from any directory: python3 tests/benchmark.py --runs 5 --output /tmp/nvim.json
First-use timings dispatch the corresponding autocmd; they measure plugin setup,
not terminal rendering, typing, or asynchronous language-server responses.
"""

import argparse
import json
import os
from pathlib import Path
import re
import statistics
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--runs", type=int, default=5)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if args.runs < 1:
        parser.error("--runs must be positive")
    root = Path(__file__).resolve().parents[1]
    scenarios = (("empty", "", False), ("lua_file", "", True),
                 ("first_insert", "insert", True), ("first_command", "command", False))
    report = {"runs": args.runs, "parser_installation": False, "scenarios": {}}
    with tempfile.TemporaryDirectory(prefix="nvim-benchmark-") as directory:
        directory = Path(directory)
        source = directory / "example.lua"
        source.write_text('local example = "hello"\nreturn example\n')
        env = dict(os.environ, XDG_STATE_HOME=str(directory / "state"),
                   XDG_CACHE_HOME=str(directory / "cache"), NVIM_LOG_FILE=str(directory / "nvim.log"),
                   NVIM_BENCH_RUNNER=str(root / "tests/benchmark.lua"))
        for name, action, open_file in scenarios:
            samples = []
            for index in range(args.runs + 1):  # Discard one warm-up per scenario.
                log, result = directory / f"{name}-{index}.log", directory / "result.json"
                env.update(NVIM_BENCH_ACTION=action, NVIM_BENCH_RESULT=str(result))
                cmd = ["nvim", "--headless", "-u", str(root / "tests/init.lua"),
                       "-i", "NONE", "-n", "--startuptime", str(log)]
                if open_file:
                    cmd.append(str(source))
                cmd += ["+lua vim.schedule(function() dofile(vim.env.NVIM_BENCH_RUNNER) end)"]
                proc = subprocess.run(cmd, cwd=root, env=env, capture_output=True, text=True, timeout=30)
                if proc.returncode or "Error" in proc.stderr:
                    raise RuntimeError(proc.stderr or proc.stdout)
                sample = json.loads(result.read_text())
                match = re.search(r"^([0-9.]+).*--- NVIM STARTED ---", log.read_text(), re.M)
                if not match:
                    raise RuntimeError("Missing native startup timing")
                sample["startup_ms"] = float(match.group(1))
                if index:
                    samples.append(sample)
            values = {
                "startup_median_ms": statistics.median(s["startup_ms"] for s in samples),
                "first_action_median_ms": statistics.median(s["first_action_ms"] for s in samples),
                "loaded_at_startup": samples[-1]["loaded"],
                "samples": samples,
            }
            report["scenarios"][name] = values
            print(name + ": " + json.dumps({k: v for k, v in values.items() if k != "samples"}), flush=True)
    if args.output:
        args.output.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
