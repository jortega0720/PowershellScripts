$homeDir = "D:\ProviderTestDirectory\test\archives\"

$Farm = "Provider"
$year = Get-Date -UFormat %Y
$date = Get-Date -UFormat %m-%d-%Y
$ArchiveDir = "\\archive.prod02.aws.local\archive$"
$hostname = hostname

$username = "archive\ArchiveUser"
$password = ConvertTo-SecureString -String "4m3two@rchive!" -asPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($username, $password)

#Test network drive and if does not exits it creates it. 
if (Get-PSDrive -Name Vaultlogs -ErrorAction SilentlyContinue){
    Write-host "Vaultlogs Exists"
}
else{
	Write-host "Creating Vaultlogs"
    New-PSDrive -Name "Vaultlogs" -PSProvider FileSystem -Root $Archive -Credential $credentials
}

#Creates Directory array for verifying directory exists and moving files from each directory  
$DirList = (Get-ChildItem -Path $homeDir -Recurse -Directory).FullName
$DirList = , (Get-Item -Path $homeDir).FullName +$DirList

 
Foreach ($dir in $DirList)
{

$newDir = $dir.Replace($homeDir,"$ArchiveDir\$year\$date\$Farm\$hostname\archive\")
    #Verify that the file structure exists on the remote server
    if (Test-Path -Path $newDir)
        {
        Write-Host "Archive Path Exists"
        }
    else{
        Write-host "Creating Archive Path"
        New-Item -ItemType directory -Path $newDir
        }

$filePresent = Get-ChildItem -Path $dir -File
    
    if ($filePresent)
        {
        	Foreach($File in $FilePresent)
	        {
		    $FileName = ($File.Name)
            #Move files to Archive Server
		    Move-Item -Path $dir\$FileName -Destination $newDir -ErrorVariable DeleteVar

		    if(!$DeleteVar)
		        {
			    Write-host "$FileName was moved to $newDir"
		        }
		    else
		        {
			    Write-Host "Unable to move $FileName to $newDir"
		        }
           
            }
        } 
}