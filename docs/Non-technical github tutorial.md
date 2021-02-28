# Explanation of github for non-programmers
Since anyone can join to contribute, I will try to give a brief tutorial on github for those people who are not programmers or haven't used github before.

For a non-programmer, the simplest explanation of "github" (where the project files are hosted) is a google drive / dropbox shared folder, where anyone can edit files, and the files are synced to anyone who has the project downloaded. Pretty neat, huh ?

Github is not as automatic as google drive / dropbox though. You have to manually upload your updates, and download other people's updates. But you will see it won't be a hussly.

Also, you might see me saying words "repo" or "repository" often. It just means "this project on github", or equivalent to gdrive / dropbox's shared folder.

## Cloning project using github desktop
1. Download github desktop: https://desktop.github.com/
2. Sign in with your account on github desktop.
3. Clone this repository by going to file -> clone repository -> TM_online_remake
  - *You will not see the project unless you have editing permissions (see `Readme.md` file, requesting editing permissions to the project)*
4. You may be asked if you want to use github enterprise server, or regular server. Choose regular server in this case.

Now, the project should be available in folder where you specified to clone the repo in step 3. By default on (on windows and mac) it is in folder `Documents/Github/TM_online_remake`.

## Opening project in godot
You should now be able to run the project from godot editor by opening godot engine and clicking `Import` button.

## Running the project
Shortcut to run the project within editor is F5. You can also run the project from project's home screen (before you open this project)

### Running more than one instance of project (multiplayer testing)
On godot project selection screen (the screen which opens when you just open the godot engine), click the project and click `Run` button to the right. You can open new instance of godot and run project again. This way you will be able to join/host multiple games at the same time on your own machine.

# Syncing changes
## Downloading changes (pull)
When somebody else makes changes, you have to manually download those changes.
1. Click "Fetch changes" in top part of github desktop.
2. If there are any new changes, the same button will say `Pull origin`. That means there are some pending changes you need to download.

## Commit your changes
**It is highly important that you "commit" and upload your changes often**

Just edit the project in godot editor like you normally would. When you want to share those changes, you must follow these steps:
1. In changes tab of left-hand side of github desktop, you will see list of all files you have changed. Carefully check if that is the list of files you did change.
2. Below changes, above "Description" textbox, edit "Summary" text field. You must describe what changes did you make in a short sentence. For example `Created a new car: MY_COOL_CAR_NAME`. Other people will read those descriptions and understand your work better. This is important in team environment.
3. Click `Commit to main` button.

This will only save these changes on your computer. You will be able to undo that if you want. However, others won't see your changes until you:
## Upload your changes (push)
When you have some not-uploaded commits, you must "push" those changes so that others can see and download your changes.

1. Click "Push origin" button in upper part of github desktop.

In case 
