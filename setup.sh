#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./setup.sh {project_name}" >&2
  exit 1
fi
if [ ! -f .env ]; then
  echo "Please create a .env file with your GitHub username." >&2
  echo "YOUR_GITHUB_USER_NAME=your_github_user_name" >&2
  exit 1
fi

. ./.env

PROJECT_NAME=$1
PROJECT_DIR="./${PROJECT_NAME}"

mkdir -p "${PROJECT_DIR}/fig"

TEX_FILE="${PROJECT_NAME}.tex"
touch "${PROJECT_DIR}/$TEX_FILE"

LATEXMKRC_FILE="${PROJECT_DIR}/.latexmkrc"
cat <<EOF > "$LATEXMKRC_FILE"
use POSIX qw(strftime);

\$latex = 'platex';
\$bibtex = 'pbibtex';
\$dvipdf = 'dvipdfmx %O -o %D %S';
\$makeindex = 'mendex -U %O -o %D %S';
\$pdf_mode = 3;
\$out_dir = '${PROJECT_DIR}/out';

END {
    my $timestamp = strftime("%Y-%m-%d %H:%M:%S", localtime);
    my \$commit_message = "${PROJECT_NAME}_\$timestamp";
    system("git init");
    system("git config --global --add safe.directory /workdir/${PROJECT_NAME}");
    system("git branch -M main");
    system("cp ./out/${PROJECT_NAME}.pdf ./${PROJECT_NAME}.pdf");
    system("git add ${TEX_FILE} ${PROJECT_NAME}.pdf");
    system("git commit -m '\$commit_message'");
    system("git remote add origin git\@github.com:${YOUR_GITHUB_USER_NAME}/${PROJECT_NAME}.git");
    system("git push origin main");
};
EOF

GITIGNORE_FILE="${PROJECT_DIR}/.gitignore"
cat <<EOF > "$GITIGNORE_FILE"
*.aux
*.dvi
*.fdb_latexmk
*.fls
*.synctex.gz
*.log
*.pdf
out/
EOF

echo "Project setup complete for '${PROJECT_NAME}' in directory '${PROJECT_DIR}'."
echo "Files created:"
echo "- ${TEX_FILE}"
echo "- ${LATEXMKRC_FILE}"
echo "- ${GITIGNORE_FILE}"
echo "- ${PROJECT_DIR}/fig directory"
