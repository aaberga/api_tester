# api_tester


Simple app to see how write a simple REST api lib.

The overall scheme of the app is loosely inspired by VIPER, but it is a lot simpler (as the test app is, too).

Two screens make the app. The first screen gets some projects from the TeamWork API.

A detail screen lists the 'contents' of the selected project, through a second API call.

Instead of packing everything and his friend in the viewcontroller, the logic that would be split among the interactor and the presenter in a pure VIPER setup, is packed into a simple "Friend" class.

The REST API lib (it's actually just a quick starter of a lib) works reading REST paths and parameters from a config file.

So, the plan would be to have a file for each version of the API (or for different backends, in different apps).

