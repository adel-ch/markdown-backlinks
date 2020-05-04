# markdown-backlinks

## Overview
This script creates backlinks for markdown files. Especially useful for those using the zettelkasten note taking method.

## Behavior
This script adds backlinks if they exist at the end of every markdown document in a directory. files are expected to to have 14 digit names ending with .md extension.
The script will add a section at the end of markdown files with backlinks. On subsequent re-runs, it will delete existing backlinks section and update it with a new one

## Usage
./backlinks.sh path/to/md/directory

## planned improvement
* support for other filenames other than 14 digit ones
* add the a description in front of backlinks (first line from file)
* writing output to another folder without modifying existing
