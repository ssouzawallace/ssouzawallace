#!/usr/bin/env python3
"""Rebuild the "Featured repos" block in README.md from the repo-pins images.

profile-icons/github-profile-repo-pins renders one SVG card per repo onto the
`generated` branch (repo_pin_imgs/0.svg, 1.svg, ...). Left to itself it also
writes them into README as markdown images, two per row, and markdown images
cannot be sized: in a narrow window each card stays 412px wide and hugs the
left edge. So README carries FEATURED-REPOS markers instead of the action's
REPO-PINS ones (the action then leaves README alone), and this script fills
them with one <picture> per card:

  * 1280px and wider: GitHub's README column is 846px, room for two cards at
    their natural 412px, so the 2x2 grid stays.
  * narrower: each card fills the column, one per row.

The narrow <source> uses a `w` descriptor, so the browser sizes the image from
the viewport and GitHub's `max-width: 100%` trims it to the column. The wide
<source> carries an explicit `1x` and a different URL (`?full-width` is only on
the narrow one); without both, Chrome keeps the full-width size after the
window grows past 1280px.

Run from the repository root, after fetching the generated branch:
    git fetch origin +refs/heads/generated:refs/remotes/origin/generated
    python3 .github/scripts/featured_repos.py
"""

import html
import os
import re
import subprocess
import sys

README = "README.md"
PINS_REF = "origin/generated"
PINS_DIR = "repo_pin_imgs"
WIDE_MEDIA = "(min-width: 1280px)"
BLOCK = re.compile(r"(<!-- FEATURED-REPOS:START.*?-->)(.*?)(<!-- FEATURED-REPOS:END -->)", re.S)


def git(*args: str) -> str:
    result = subprocess.run(["git", *args], capture_output=True, text=True)
    if result.returncode:
        sys.exit(f"git {' '.join(args)} failed: {result.stderr.strip()} README left as is.")
    return result.stdout


def this_repo() -> str:
    if os.environ.get("GITHUB_REPOSITORY"):
        return os.environ["GITHUB_REPOSITORY"]
    url = git("remote", "get-url", "origin").strip()
    match = re.search(r"github\.com[:/]([^/]+/[^/]+?)(?:\.git)?/?$", url)
    if not match:
        sys.exit(f"Can't tell which GitHub repo this is from origin {url!r}; set GITHUB_REPOSITORY.")
    return match.group(1)


def card(repo: str, file_name: str) -> str:
    svg = git("show", f"{PINS_REF}:{PINS_DIR}/{file_name}")
    name = re.search(r'aria-label="([^"]+)"', svg)
    if not name:
        sys.exit(f"{PINS_DIR}/{file_name} has no aria-label; the pin format changed, README left as is.")
    # The first link on a card is the repo's own page; stars/forks/issues links come after it.
    link = re.search(r'href="(https://github\.com/[^/"]+/[^/"]+?)/?"', svg)
    url = link.group(1) if link else f"https://github.com/{repo.split('/')[0]}/{name.group(1)}"
    img = f"https://raw.githubusercontent.com/{repo}/refs/heads/generated/{PINS_DIR}/{file_name}"
    return (
        f'<a href="{html.escape(url)}"><picture>'
        f'<source media="{WIDE_MEDIA}" srcset="{img} 1x">'
        f'<source srcset="{img}?full-width 1w">'
        f'<img src="{img}" alt="{html.escape(name.group(1))}">'
        "</picture></a>"
    )


def main() -> None:
    repo = this_repo()
    files = sorted(
        (f for f in git("ls-tree", "--name-only", f"{PINS_REF}:{PINS_DIR}").split() if re.fullmatch(r"\d+\.svg", f)),
        key=lambda f: int(f.split(".")[0]),
    )
    if not files:
        sys.exit(f"No pin images in {PINS_REF}:{PINS_DIR}; README left as is.")

    with open(README, encoding="utf-8") as fh:
        text = fh.read()
    if len(BLOCK.findall(text)) != 1:
        sys.exit(f"{README} needs exactly one <!-- FEATURED-REPOS:START --> ... <!-- FEATURED-REPOS:END --> block.")

    # A raw <p> block keeps GitHub from treating the cards as markdown; the line
    # breaks between cards are ordinary spaces, so they wrap like the old pins.
    body = "\n".join(["<p>", *(card(repo, f) for f in files), "</p>"])
    updated = BLOCK.sub(lambda m: f"{m.group(1)}\n{body}\n{m.group(3)}", text)
    if updated == text:
        print(f"Featured repos already up to date ({len(files)} cards).")
        return
    with open(README, "w", encoding="utf-8") as fh:
        fh.write(updated)
    print(f"Featured repos rebuilt with {len(files)} cards.")


if __name__ == "__main__":
    main()
