$OldDir = "D:\ei\archives"
$NewDir = "D:\ei\archives_old"


$DirList = (Get-ChildItem -Path $OldDir -Recurse -Directory).FullName
$DirList = , (Get-Item -Path $OldDir).FullName +$DirList

$DirList
echo "##########################################"

Foreach ($dir in $DirList)

{
$New = $dir.Replace($OldDir,$NewDir)
    #Verify that the file structure exists on the remote server
    if (Test-Path -Path $New)
        {
        Write-Host "Archive Path Exists"
        }
    else{
        Write-host "Creating Archive Path"
        New-Item -ItemType directory -Path $New
        }


}

$filePresent = Get-ChildItem -Path $dir -File -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-2)}
    
    if ($filePresent)
        {
        	Foreach($File in $FilePresent)
	        {
		    $FileName = ($File.Name)
            #Move files to Archive Server
		    Move-Item -Path $dir\$FileName -Destination $newDir    
            }
        } 
}