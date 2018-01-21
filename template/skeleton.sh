#! /bin/bash

# Created by Indiana Nikel
# Last edit on November 17, 2017

name=${1:-"Indiana Nikel"}
dir=${2:-"dsci_project"}

# Make a directory, if non-existent
mkdir $dir

if [ $? -ne 0 ] ; then
    echo "Script aborted."
else
  cd $dir

  # Create and populate README
  echo "# Overview" > README.md

  echo -e "\nThis is the main directory for the data science project: \`$dir\`.
The data science project \`$dir\` is for the purpose of <research/analysis> and
is for <personal/commercial> use." >> README.md

  echo -e "\n## Description" >> README.md

  echo -e "\n<summary>" >> README.md

  echo -e "\n## Use" >> README.md

  echo -e "\n<additional information>" >> README.md

  # Create and populate LICENSE

  echo "# The MIT License (MIT)" > LICENSE.md

  echo -e "\nCopyright $(date +"%Y") $name" >> LICENSE.md

  echo -e "\nPermission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation files (the
\"Software\"), to deal in the Software without restriction, including without
limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following conditions:" >> LICENSE.md

  echo -e "\nThe above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software." >> LICENSE.md

  echo -e "\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE." >> LICENSE.md

  # Create and populate CONTRIBUTING

  echo "###### Project structure developed by Indiana Nikel: [https://github.com/indiana-nikel/dsci_project](https://github.com/indiana-nikel/dsci_project)" > CONTRIBUTING.md

  echo "\n### Base structure pulled from [https://drivendata.github.io/cookiecutter-data-science/](https://drivendata.github.io/cookiecutter-data-science/)." >> CONTRIBUTING.md

  echo -e "\nProject created by $name." >> CONTRIBUTING.md

  echo -e "\n<additional collaborators>" >> CONTRIBUTING.md

  # Create and populate CITATION

  echo "###### Project created on $(date +"%m-%d-%Y")" > CITATION.md

  echo -e "\nProject author: $name." >> CITATION.md

  # Create Directories

  mkdir data results src docs img sandbox models template
  mkdir data/raw data/interim data/processed
  mkdir results/figures results/reports
  mkdir src/python src/r src/shell

  # Create blank README.md files

  echo > data/README.md
  echo > data/raw/README.md
  echo > data/interim/README.md
  echo > data/processed/README.md

  echo > results/README.md
  echo > results/figures/README.md
  echo > results/reports/README.md

  echo > src/README.md
  echo > src/python/README.md
  echo > src/r/README.md
  echo > src/shell/README.md

  echo > img/README.md
  echo > docs/README.md
  echo > sandbox/README.md
  echo > models/README.md

  cd ..
  cp README.md $dir/template/README.md
  cp skeleton.sh $dir/template/skeleton.sh

fi
