# Script: Archive-logs.ps1
# Author: James Linden
# Date: 1/21/16
# Comments: .Net 4.5 required; Excerpts taken from Ed Wilson(technet) for CreateZip and GetZipFilesToBeOpened

 param($source_dir)
function CreateZip
{   ### This function takes the path to a source directory, and zips the files inside to a 
    param($source,$destination)
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::CreateFromDirectory($source, $destination)
    }


function GetFilesToBeZipped
{
    ### This function takes a path to a directory, pathstring, reads attributes of all .txt files , and returns an array of those files older than 
    ### 30 days
        
    param($pathstring)
    $arr = (Get-ChildItem -Path $pathstring -Filter *.txt |?{$_.LastWriteTime -lt (Get-Date).AddDays(-30)}).FullName 
    return $arr
    }

function CreateArchivalDir
{
    ### This function creates a directory to temporarily store the files to be archived

    param($rootdir)
    $newdir = [string]::Concat($rootdir,'\tmpArchive')
    New-Item $newdir -type directory




}

function MoveFilesToArchiveDir
{
    #  This function takes an array of filepaths and moves each one to the destination directory
    param([string[]]$arr, $destdir)

    foreach ($filepath in $arr){

    Move-Item $filepath $destdir
    }

}


while($true){
If(![string]::IsNullOrEmpty($source_dir)){
    If(Test-Path $source_dir){
        $archive_dir = [string]::Concat($source_dir,'\tmpArchive')

        $today = Get-Date
        $1monthago = $today.AddDays(-30)
        $2monthago = $1monthago.AddDays(-30)


        $zipname = [string]::Concat('u_ex',$2monthago.Year,$2monthago.Month,$2monthago.Day,'-',$1monthago.Year,$1monthago.Month,$1monthago.Day,'.zip')
        $zipdest = [string]::Concat($source_dir,'\',$zipname)
        CreateArchivalDir -rootdir $source_dir
        MoveFilesToArchiveDir -arr (GetFilesToBeZipped -pathstring $source_dir) -destdir $archive_dir
        CreateZip -source $archive_dir -destination $zipdest

        If(Test-Path $zipdest){
            Remove-Item $archive_dir -Recurse
            break;
        }Else{
            Write-Output "Error in archive creation"
            break;
        }

    }Else{
        
        $source_dir = Read-Host "Please enter a valid Path"
    }
}Else{
    $source_dir = Read-Host "Please enter a valid Path"
    }
}