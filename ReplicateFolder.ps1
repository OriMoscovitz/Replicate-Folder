function ReplicateFolder {
    param (
        $log_File,
        $source_folder,
        $destination_folder
    )

    # Both source and destination paths are valid
    Write-Output "Both paths are valid."

    # In case destination folder has content in it
    if ((IsFolderEmpty $destination_folder) -eq $false){

        Write-Output "Destination folder not empty"

        Write-Output "################################################"

        # Get the files in the destination folder
        Get-ChildItem -Path $destination_folder -Recurse -Force | ForEach-Object {
            
            # Print current timestamp to console
            Write-Host (Get-Date).DateTime

            # Print current timestamp to log file
            Write-Output (Get-Date).DateTime

            # Print deletion operation to console
            Write-Host "Removing: $($_.FullName)"

            # Print deletion operation to log file
            Write-Output "Removing: $($_.FullName)"

        } | Add-Content $log_File

        # Remove the destination folder with all its content
        $null = Remove-Item $destination_folder

        # Create a new destination folder
        $null = New-Item -ItemType Directory -Path $destination_folder
    }

    Write-Output "################################################"

    # After clearing destination folder from files that are not in source folder
    # Copy each file recursively from source folder to destination folder
    Get-ChildItem $source_folder -Recurse -Force | ForEach-Object {
        # Define the new path for the current object
        $cur_destination = (Join-Path $destination_folder $_.FullName.Substring($source_folder.Length))

        # Print current timestamp to console
        Write-Host (Get-Date).DateTime

        # Print timestamp to log file
        Write-Output (Get-Date).DateTime

        # Copy file to destination folder
        $_ | Copy-Item -Destination $cur_destination -Force

        # Print name of the created file to console
        Write-Host "Creating: $($_.Name) in $cur_destination"

        # Print name of the created file to log file
        Write-Output "Creating: $($_.Name) in $cur_destination"

        # Print name of the copied file to console
        Write-Host "Copying: $($_.FullName) to $cur_destination"

        # Print name of the copied file to log file
        Write-Output "Copying: $($_.FullName) to $cur_destination"
    
    } | Add-Content $log_File

}



# Recieve a folder path and returns false if not empty or true otherwise
function IsFolderEmpty {
    param (
            $folder_path
        )
    # get the amount of content in the given folder
    $folder_content = Get-ChildItem $folder_path | Measure-Object

    # return false if there's any file in the folder
    if ($folder_content.count -gt 0){
        return $false
    }

    # return true otherwise
    return $true
}


# Check if not enough args were given by the user
if ($args.Count -lt 3) {
    Write-Host "One of the arguments is missing, please provide log file path, source path and destination path."
} else {
    # recieve args from cmd
    $log_file = $args[0]
    $source_folder = $args[1]
    $destination_folder = $args[2]
    
    # validate paths
    $src_valid = Test-Path $source_folder
    $dst_valid = Test-Path $destination_folder

    # If source path invalid terminate program
    if ($src_Valid -eq $false) {
        Write-Output "Source path is invalid"
        return
    }

    # If destination path invalid terminate program
    if ($dst_Valid -eq $false) {
        Write-Output "Destination path is invalid"
        return
    }

    # Run the program
    replicateFolder $log_file $source_folder $destination_folder
}