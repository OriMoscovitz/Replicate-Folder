# Replicate-Folder

For two paths given, a source path and destination path, the function will replicate the source path content into the destination path.
Edge Cases:
1.	Source path or destination path do not exist:
In this scenario, the function will return error message “Path _ is not valid.” And terminate.
2.	Destination folder is not empty:
In this scenario, the function will first will delete destination path and its content and then create a new folder.
Then, the function will copy every element in source path into destination path. The function logs with timestamp the files that are being either created, copied or deleted.

In order to run the script you must provide the arguments in the order:
Log file, source path and destination path.

For example:
powershell.exe -File "<Insert-Path-To-PS-File>" "<Insert-Path-To-Source-Folder>" "<Insert-Path-To-Destination-Folder>"
