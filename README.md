# Lazy Git

Create a basic web project boilerplate and a Github repo in one step

# Disclaimer

I am not a bash expert! It was created for my personal use and for learning purposes. I works allright on my setup (Linux Mint, bash, Perl for regex) but might necessitate tweaks on yours. Anyway it was fun and I learned a lot.

# Why

While creating a web project is fun, have to go through the same setup process again and again is boring!

That is create project structure, populate files, create Github repo, and so on

So I came up with the idea that I could automate stuff using a bash script.

Ok, this is not the next wonder and could be improved in many ways, but it works for me and could as well for you.

Additionally it was fun to mess with bash and learn stuff 😉

# Requirements

> You will need to create a Token with Github first. you can find instrcutions [here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

# How to Use

## Install

- clone (or Fork) [this repo](https://github.com/Letitbe133/lazy-git)

- cd into repo folder

- Edit `lazyGit.sh` file providing your Github Credentials

```bash
# Add your Github credentials here
USER_TOKEN="YOUR_GITHUB_TOKEN"
GITHUB_USERNAME="YOUR_GITHUB_USERNAME"

```

- Move `lazyGit.sh` file to your `/usr/local/bin` folder

```bash
mv lazyGit.sh /usr/local/bin
```

or

```bash
sudo mv lazyGit.sh /usr/local/bin
```

- cd into `usr/local/bin` and make file executable

```bash
chmod 755 lazyGit.sh
```

or

```bash
sudo chmod 755 lazyGit.sh
```

Now you should be able to run that script from anywhere on your computer by just typing

```bash
lazyGit
```

## Create a Project

- Open terminal and type `lazyGit`

- When prompted, type in your repo's name

  > name should be lowercase and contain no spaces

- Then proceed with repo description

- Specify the folder name in which the project should be created (**case sensitive**)

      The script will look for this folder in your `Home` directory and attempt to create your project here.

  > e.g `Projects` would result in the project being created in `~/Projects/my-project/`
  >
  > If folder does not exists script will exit with an informative message
  >
  > If repo already exists script will exit with an informative message

# Script Steps

- The script will create a folder given name and path provided and initiate `git` in it

- A basic web structure (HTML, CSS, JS,) and files populated

```
project
│
│   index.html
│   README.md
│   .gitignore
│
└───css
│   │
│   └───style.css
│
└───js
    │
    └───main.js
```

- A repo will be created on Github matching your project name

- Changes will committed and pushed to the `master` branch on your Github repo

- A link to the newly created Github repo will be displayed

Well, by now you should be all set to start coding !

# Specials

"If you liked this content, be sure to like and subscribe to my channel to see more content like this !"

Just Kidding 😂 🖖

Feel free to comment, fork, use as you like

PR welcome 👍
