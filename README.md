### About the repository
This repository contains a dart and OOPS based CLI which mimicks Discord. It was made as an assignment for the ***Information Management Group , IIT Roorkee***

### Steps to set up on local (For UNIX based systems)

#### Clone repo by using
For HTTPS
```
git clone https://github.com/pranavkonidena/IMG_Dart_Ass.git
```
For SSH
```
git clone git@github.com:pranavkonidena/IMG_Dart_Ass.git
```
Navigate to the cloned folder and run
```
dart pub get
```
to get all the dependencies

#### Set up Alias for discodart
_Open terminal and open the .zshrc or .bashrc file using VIM or nano_
```
alias discodart='path to main.dart file'
```
Add the above in your terminal profile file

### Documentation for the CLI

#### Register a User
You have to register a user before logging in
Roles are of two types , by default role is set to member. However , text and announcement channels require mod user privileges to send messages. Hence , specify role accordingly.
```
discodart -r -u "Username here" -p "Password here" --role "Enter mod here for mod user"
```

#### Login a User
Only registered users can login, make sure to enter the correct details
```
discodart -l -u "Registered username here" -p "Password here"
```

#### Logout a user
```
disodart --logout -u "Username here"
```
#### Joining and creating a server
Servers contain many users at once. They are made up of categories which are in turn made up of channels which are made up of users.
Example:
IITR is a server , ECE is a category and Freshers , Sophomores , Junior , Senior etc are channels.

***You must create a server before joining a server***

##### Create a server
```
discodart --server "Server name"
```
##### Join a server
```
discodart --join --server "Server name" -u "Username here"
```

#### Adding a category/channel to a server 
***You must add a category to a server before adding channels***

##### Adding a category
```
discodart --server "Server name" --category "Category name"
```

##### Adding a channel
There are only 5 channel types - Text , Announcement , Stage , Voice , Rules.
By default , Text and announcement channels are restricted and only mod users can send messages in those channels
###### To create a channel which is not restricted
```
discodart -c --channel "Channel name" --category "Category name" --server "Server Name" -u "Username here" --type "Valid type here"
```
###### To create a channel which is restricted
```
discodart -c --channel "Channel name" --category "Category name" --server "Server Name" -u "Username here" --type "Valid type here" --restrict
```

#### Sending message in a channel
```
discodart --channelDM --channel "Channel Name" --message "Message here"
```

#### Printing categories in a server
```
discodart --print --category --server "Server name"
```

#### Printing mod users in a server
```
discodart --print --mU --server "Server name"
```

#### Sending DM to any registered user by a logged in user
```
discodart --dm --recipient "Reciever here" --message "Message here"
```



Made by Pranav



