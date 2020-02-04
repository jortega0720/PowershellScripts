$DirPath = ""
$SearchSTR = ""
$Files =get-childitem -Path D:\StampsDCO\Script\*\* -File

foreach ($file in $Files) {

$content = get-content $File.FullName | Select-String -Pattern "$SearchSTR"
if ($content){echo $file.FullName}

}