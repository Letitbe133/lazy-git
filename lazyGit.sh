#! /bin/bash

# Add your Github credentials here
USER_TOKEN="YOUR_PERSONAL_ACCESS_TOKEN_HERE"
GITHUB_USERNAME="YOUR_GITHUB_USERNAME_HERE"

# color settings
TEXT_COLOR="\e[96m"
TEXT_COLOR_ERROR="\e[91m"
TEXT_NORMAL="\e[0m"

# clear terminal
clear

# display ASCII in color
echo -e $TEXT_COLOR

cat << "EOF"
   __                        ___  _  _   
  / /   __ _  ____ _   _    / _ \(_)| |_ 
 / /   / _` ||_  /| | | |  / /_\/| || __|
/ /___| (_| | / / | |_| | / /_\\ | || |_ 
\____/ \__,_|/___| \__, | \____/ |_| \__|
                   |___/                 

EOF

echo -e $TEXT_NORMAL

# ask user for repo name
echo "Give your repo an awesome name !"
# remove trailing spaces
# replace spaces with '-'
# switch to lowercase
read RAW_REPO_NAME
REPO_NAME=$(echo $RAW_REPO_NAME | sed -e 's/ /-/g' | tr '[:upper:]' '[:lower:]')

# exit script if repo name is empty and display message to user
if [ -z "$REPO_NAME" ]; then
    echo "Repo name cannot be empty"
    exit 1
fi

# ask user for repo description
echo "Tell the world what it's all about !"
read REPO_DESCRIPTION

# ask user for path to local project
echo "Where do you want to store your awesome project (e.g Projects) ?"
read RAW_PATH

# remove trailing spaces
USER_PATH=$(echo $RAW_PATH | sed -e 's/ /-/g')

# if no folder specified, defaults to Home
if [ -z "$USER_PATH" ]; then
    BASE_PATH="${HOME}"
else
    BASE_PATH="${HOME}/${USER_PATH}"
fi

# check if path is correct
if [ ! -d "$BASE_PATH" ]; then
  echo "Path ${BASE_PATH} is incorrect. Exiting..."
  exit
fi

# exit if folder exists exist
PROJECT_PATH="${BASE_PATH}/${REPO_NAME}"
if [ -d "$PROJECT_PATH" ]; then
  echo "Folder ${DIR} already exists. Exiting..."
  exit
fi

echo -e "${TEXT_COLOR}Creating your local repo in ${PROJECT_PATH}${TEXT_NORMAL}"

# create folder && cd into it
echo -e "${TEXT_COLOR}Switching to ${PROJECT_PATH}${TEXT_NORMAL}"
mkdir "$PROJECT_PATH/"
cd "$PROJECT_PATH"

# initialize the repo locally and create project structure
echo -e "${TEXT_COLOR}Initializing local git repo${TEXT_NORMAL}"
git init
echo -e "${TEXT_COLOR}Creating folder structure${TEXT_NORMAL}"
mkdir -p assets css js
touch index.html css/style.css js/main.js README.md .gitignore

# populate files
# HTML
cat <<- HTML > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$REPO_NAME</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="js/main.js" defer></script>
</head>
<body>
    
</body>
</html>
HTML

# CSS
cat <<- CSS > css/style.css
html, body {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-size: 16px;
}
CSS

# JS
cat <<- JS > js/main.js
console.log('JS loaded');
JS

# .gitignore
cat <<- GITIGNORE > .gitignore
# Ignore the node_modules directory
node_modules/

# Ignore Logs
logs
*.log

# Ignore the build directory
/dist

# The file containing environment variables 
.env

# Ignore IDE specific files
.idea/
.vscode/
*.sw*
GITIGNORE

# add files and commit changes
echo -e "${TEXT_COLOR}Commiting changes\e[0m"
git add .
git commit -m "Initial commit using bash script"

# log user in with Github API
echo -e "${TEXT_COLOR}Creating Github repo\e[0m"
CURL_RESPONSE_CODE=$(curl -i -H "Authorization: token ${USER_TOKEN}" https://api.github.com/user/repos -d "{\"name\":\"${REPO_NAME}\",\"description\":\"${REPO_DESCRIPTION}\"}" | grep -i -P "http\/\d.?\d?\s\d{3}" | grep -oP "(\d{3})")

# check if curl response status is 200
if [[ "$CURL_RESPONSE_CODE" == "422" ]]; then
    echo -e "${TEXT_COLOR_ERROR}A repo with the same name already exists !${TEXT_NORMAL}"
    echo -e "${TEXT_COLOR_ERROR}Rewinding...${TEXT_NORMAL}"
    cd "$BASE_PATH"
    rm -rf "$REPO_NAME"
    echo -e "${TEXT_COLOR}Project removed successfully !${TEXT_NORMAL}"
    exit

elif [[ "$CURL_RESPONSE_CODE" != "201" ]]; then
    echo -e "${TEXT_COLOR_ERROR}Couldn't create Github repo. Check your credentials !${TEXT_NORMAL}"
    echo -e "${TEXT_COLOR_ERROR}Rewinding...${TEXT_NORMAL}"
    cd "$BASE_PATH"
    rm -rf "$REPO_NAME"
    echo -e "${TEXT_COLOR}Project removed successfully !${TEXT_NORMAL}"
    exit
fi

# add remote Github repo to local repo
echo -e "${TEXT_COLOR}Remote origin added to local repo${TEXT_NORMAL}"
git remote add origin git@github.com:${GITHUB_USERNAME}/${REPO_NAME}.git

# push to remote origin
echo -e "${TEXT_COLOR}Pushing to remote\e[0m"
git push origin master
if [ $? -eq 0 ]; then
    echo -e "${TEXT_COLOR}Done. Your repo is visible at https://github.com/$GITHUB_USERNAME/$REPO_NAME ${TEXT_NORMAL}"
else
    echo -e "${TEXT_COLOR_ERROR}Unable to push to remote repo. Rewinding...${TEXT_NORMAL}"
    cd "$BASE_PATH"
    rm -rf "$REPO_NAME"
    curl -X DELETE -H "Authorization: token ${USER_TOKEN}" https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME
fi

