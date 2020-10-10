### first test script video capture :)

## https://www.powershellgallery.com/packages/psScreenRecorder/1.0.5/Content/psScreenRecorder.psm1
<#
Module Mixed by BarTender
    A Framework for making PowerShell Modules
    Version: 6.1.21
    Author: Adrian.Andersson
    Copyright: 2019 Domain Group

Module Details:
    Module: psScreenRecorder
    Description: Desktop Video Capture with PowerShell
    Revision: 1.0.4.1
    Author: Adrian.Andersson
    Company: Adrian Andersson

Check Manifest for more details
#>

function convert-mp4togif
{
<#
    .SYNOPSIS
        Use FFMPEG to convert an mp4 to a gif
    .DESCRIPTION
     
        Use FFMPEG to convert an mp4 to a gif
  
         
  
    .PARAMETER mp4Path
        path to the mp4File
             
    .PARAMETER gifPath
        path to export the gif file
 
    .PARAMETER ffMPegPath
        Path to ffMpeg
        Suggest you modify this to be where yours is by default
 
    .PARAMETER tempPath
        Where to keep the palette file
 
    .PARAMETER fps
        The FPS to use for the gif
  
         
     
    .EXAMPLE
        convert-mp4togif -mp4Path c:\input.mp4 -gifPath c:\output.gif
     
     
    .NOTES
        Author: Adrian Andersson
                 
        Changelog
         
            13-09-2019 - AA
                - Initial Script
 
  
    .COMPONENT
        psScreenCapture
#>    
 
    [CmdletBinding()]
    PARAM(
        [Parameter(Mandatory=$true,Position=0)]
        [Alias("path")]
        [string]$mp4Path,
        [Parameter(Mandatory=$true,Position=1)]
        [Alias("destination")]
        [string]$gifPath,
        [string]$ffMPegPath = $(get-childitem -path "$($env:ALLUSERSPROFILE)\ffmpeg" -filter 'ffmpeg.exe' -Recurse|sort-object -Property LastWriteTime -Descending|select-object -First 1).fullname,
        [string]$tempPath = "$($env:temp)\ffmpeg",
        [ValidateRange(1,60)]
        [int]$fps = 5
    )
    begin{
 
        
        #Return the script name when running verbose, makes it tidier
        write-verbose "===========Executing $($MyInvocation.InvocationName)==========="
        #Return the sent variables when running debug
        Write-Debug "BoundParams: $($MyInvocation.BoundParameters|Out-String)"
 
    }process{

        write-verbose 'Checking for ffmpeg'
        if(!$(test-path -Path $ffMPegPath -ErrorAction SilentlyContinue))
        {
            throw 'FFMPEG not found - either provide the path variable or run the install-ffmmpeg command'
        }

        if(!$(test-path $tempPath))
        {
            write-verbose 'Creating ffmpeg temp directory'
            try{
                $outputDir = new-item -ItemType Directory -Path $tempPath -Force -ErrorAction Stop
                write-verbose 'Directory Created'
            }catch{
                throw 'Unable to create ffmpeg temp directory'
            }
        }

        
        write-verbose 'Checking the input MP4 file'
        if(!$(test-path $mp4Path))
        {
            throw "Input MP4: $mp4Path not found"
        }else{
            $mp4File = $(get-item $mp4Path)
            $mp4Path = $mp4File.FullName
        }

        if(!$mp4Path -or ($mp4File.extension -ne '.mp4'))
        {
            throw "Error parsing mp4path"
        }


        if(test-path $gifPath)
        {
            write-warning "$gifpath exists and will be removed"
            try{
                remove-item $gifPath -Force
            }catch{
                write-warning 'Unable to remove existing file'
            }
            
        }


        write-verbose 'Making Frames'
        $palettePath = "$($(get-item $tempPath).fullname)\palette.png"
        $filters = "fps=$fps,scale=320:-1:flags=lanczos"
        
        $ffmpegArg = " -i $mp4Path -vf `"$filters,palettegen`" -y $($palettePath)"
        Start-Process -FilePath $ffMPegPath -ArgumentList $ffmpegArg -Wait

        write-verbose 'Creating GIF using palette'
        $ffmpegArg = " -i $($mp4Path) -i $($palettePath) -filter_complex `"$filters[x];[x][1:v]paletteuse`" $gifPath"
        Start-Process -FilePath $ffMPegPath -ArgumentList $ffmpegArg -Wait

    }
 
}

function install-ffMpeg
{

    <#
        .SYNOPSIS
            Download ffmpeg
             
        .DESCRIPTION
            Download FFMPEG zip file
            Extract to allUsersProfile folder
             
        .PARAMETER ffmpegUri
            URI for where the zip file lives
 
        .PARAMETER tempPath
            Path to save the zip file
 
        .PARAMETER installPath
            Where to extract the zip file
             
        ------------
        .EXAMPLE
            install-ffMpeg
             
             
             
        .NOTES
            Author: Adrian Andersson
             
             
            Changelog:
 
                2019-03-14 - AA
                    - Initial Script
                    - Tested and working
                     
        .COMPONENT
            psScreenRecorder
    #>

    [CmdletBinding()]
    PARAM(
        [string]$ffmpegUri = 'https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-20190312-d227ed5-win64-static.zip',
        [string]$tempPath = "$($env:temp)\ffmpeg.zip",
        [string]$installPath = "$($env:ALLUSERSPROFILE)\ffmpeg"

    )
    begin{
        #Return the script name when running verbose, makes it tidier
        write-verbose "===========Executing $($MyInvocation.InvocationName)==========="
        #Return the sent variables when running debug
        Write-Debug "BoundParams: $($MyInvocation.BoundParameters|Out-String)"
        
    }
    
    process{
        write-verbose 'Download ffmpeg'
        try{
            Invoke-WebRequest -Uri $ffmpegUri -OutFile $tempPath -ErrorAction Stop
        }catch{
            throw 'Unable to download ffmpeg'
        }

        write-verbose 'Checking for install folder'
        if(!(test-path $installPath))
        {
            try{
                new-item -ItemType Directory -Path $installPath -Force
            }catch{
                throw 'Unable to create installPath'
            }
            
        }
        
        write-verbose 'Uncompressing zip'
        try{
            Expand-Archive -Path $tempPath -DestinationPath $installPath -Force
        }catch{
            throw 'Unable to expand archive'
        }
       
        write-verbose 'Installation Complete'
    }
    end{
        if(test-path $tempPath)
        {
            write-verbose 'Removing zip file'
            try{
                remove-item $tempPath -Force
                write-verbose 'Zip file removed'
            }catch{
                write-warning 'Unable to remove the ffmpeg zip file'
            }
        }
        
    }
    
}

function new-psScreenRecord
{
<#
    .SYNOPSIS
        Simple Screen-Capture done in PowerShell
  
        Needs ffmpeg: https://www.ffmpeg.org/
             
    .DESCRIPTION
        Simple Screen-Capture done in PowerShell.
        Useful for making tutorial and demonstration videos
  
        Also draws a big red dot where your cursor is, if it is in the defined window bounds
  
        Uses FFMPeg to make a video file
        Video file can then be edited in your fav video editor
        Like Blender :)
 
 
        You will need to download and setup FFMPEG first
 
        https://www.ffmpeg.org/
 
        The default path to the ffmpeg exe is c:\program files\ffmpeg\bin
  
         
  
    .PARAMETER outFolder
        The folder to
            a) Temporarily keep the jpegs
            b) Save the mpeg file
  
            Is Mandatory
  
             
    .PARAMETER fps
        Framerate used to calculate both how often to take a screenshot
        And what to use to process the ffmpeg call
  
    .PARAMETER videoName
        Name + Extension to output the video file as
        By default will use out.mp4
  
    .PARAMETER ffMPegPath
        Path to ffMpeg
        Suggest you modify this to be where yours is by default
  
    .PARAMETER confirm
        Skip asking if you want to continue
 
    .PARAMETER leaveImages
        Skip deleting the temporary images after screen-capture
 
    .PARAMETER tempPath
        Where to store the images before compiling them into a video
     
  
    .EXAMPLE
        new-psScreenRecord -outFolder 'C:\temp\testVid' -Verbose
  
    DESCRIPTION
    ------------
        Will create a new video file with 'out.mp4' filename in c:\temp\testVid folder
  
  
    OUTPUT
    ------------
        N/A
  
     
     
    .NOTES
        Author: Adrian Andersson
        Last-Edit-Date: 13-09-2017
             
             
        Changelog
         
            13-09-2017 - AA
                - New script, cleaned-up from an old one I had saved
 
            14-03-2019 - AA
                - Moved to bartender module
              
            14-03-2019 - AA
                - Changed the ffmpegPath to use the allUsersProfile path
                - Throw better errors
                - Added a couple write-hosts so users were not left wondering what was going on with the capture process
                    - Normally I don't condone write-host but it seemed to make sense in this case
                -Changed var name to ffmpegArg
                - Moved images to temp folder rather than output folder
                - Fixed confirm switch so it actually works
                - Fixed the help
  
    .COMPONENT
        psScreenCapture
#>    
 
    [CmdletBinding()]
    PARAM(
        [Parameter(Mandatory=$false,Position=0)]
        [Alias("path")]
        [string]$outFolder = 'C:\temp\ffmpeg\out',
        [Parameter(Mandatory=$false,Position=1)]
        [Alias("framerate")]
        [string]$fps = 24, 
        [Parameter(Mandatory=$false,Position=2)]
        [string]$videoName = 'out.mp4',
        [Parameter(Mandatory=$false,Position=3)]
        [string]$ffMPegPath = $(get-childitem -path "$($env:ALLUSERSPROFILE)\ffmpeg" -filter 'ffmpeg.exe' -Recurse|sort-object -Property LastWriteTime -Descending|select-object -First 1).fullname,
        [Parameter(Mandatory=$false,Position=5)]
        [switch]$confirm,
        [Parameter(Mandatory=$false,Position=6)]
        [switch]$leaveImages,
        [Parameter(Mandatory=$false,Position=4)]
        [string]$tempPath = "$($env:temp)\ffmpeg"
    )
    begin{
 
        
        #Return the script name when running verbose, makes it tidier
        write-verbose "===========Executing $($MyInvocation.InvocationName)==========="
        #Return the sent variables when running debug
        Write-Debug "BoundParams: $($MyInvocation.BoundParameters|Out-String)"
 
 
        Write-Verbose 'Adding a new C# Assembly to get the Foreground Window'
        #This assembly is needed to get the current process
        #So we know when we have gone BACK to PowerShell
        #Use an array since its tidier than a here string
        $typeDefinition = @(
            'using System;',
            'using System.Runtime.InteropServices;',
            'public class UserWindows {',
            ' [DllImport("user32.dll")]',
            ' public static extern IntPtr GetForegroundWindow();',
            '}'
        )

        Add-Type $($typeDefinition -join "`n")

        write-verbose 'Loading other required assemblies'
        Add-Type -AssemblyName system.drawing
        add-type -AssemblyName system.windows.forms




        #We need to calculate the sleep-time based on the FPS
        #We want to know how many miliseconds to take a snap - as a whole number
        #Based on the frame-rate
        #This should be accurate enough
        write-verbose 'Calculating capture time'
        $msWait =[math]::Floor(1/$($fps/1000)) 
    
 
    }process{

        write-verbose 'Checking for ffmpeg'
        if(!$(test-path -Path $ffMPegPath -ErrorAction SilentlyContinue))
        {
            throw 'FFMPEG not found - either provide the path variable or run the install-ffmmpeg command'
        }

        if(!$(test-path $tempPath))
        {
            write-verbose 'Creating ffmpeg temp directory'
            try{
                $outputDir = new-item -ItemType Directory -Path $tempPath -Force -ErrorAction Stop
                write-verbose 'Directory Created'
            }catch{
                throw 'Unable to create ffmpeg temp directory'
            }
        }
        
 
        Write-Verbose 'Getting THIS POWERSHELL Session handle number so we know what to ignore'
        #This is used in conjunction with the above service, to identify when we get back to the ps window
        $thisWindowHandle = $(Get-Process -Name *powershell* |Where-Object{$_.MainWindowHandle -eq $([userwindows]::GetForegroundWindow())}).MainWindowHandle
 
        Write-Verbose 'Ensuring output folder is ok'
        if(Test-Path $outfolder -ErrorAction SilentlyContinue)
        {
            Write-Verbose 'Folder exists, will need to remove '
            Write-Warning 'Output folder already exists. This process will recreate it'
            if(!$confirm)
            {
                if($($Host.UI.PromptForChoice('Continue','Are you sure you wish to continue', @('No','Yes'), 1)) -eq 1)
                {
                    write-host 'Continuing with screen capture'
                }else{
                    return -1
                }
 
            }
            Write-Verbose 'Removing existing jpegs in folder and video file if it exists'
            remove-item "$tempPath\*.jpg" -Force
            remove-item $outFolder\$videoName -Force -ErrorAction SilentlyContinue #SilentlyCont in case the file doesn't exist
 
        }else{
            Write-Verbose 'Creating new output folder'
            new-item -Path $outFolder -ItemType Directory -Force
 
        }


        #Get the window size
        Write-Verbose 'Getting the Window Size'
        Read-Host 'VIDEO RECORD, put mouse cursor in top left corner of capture area and press any key'
        $start = [System.Windows.Forms.Cursor]::Position
        Read-Host 'VIDEO RECORD, put mouse cursor in bottom right corner of capture area and press any key'
        $end = [System.Windows.Forms.Cursor]::Position
 
        $horStart = get-EvenNumber $start.x
        $verStart = get-EvenNumber $start.y
        $horEnd = get-EvenNumber $end.x
        $verEnd = get-EvenNumber $end.y
        $boxSize = "box size: Xa: $horStart, Ya: $verStart, Xb: $horEnd, Yb: $verEnd, $($horEnd - $horStart) pixels wide, $($verEnd - $verStart) pixles tall"
        Write-Verbose $boxSize
        if(!$confirm)
        {
            $startCapture = $($Host.UI.PromptForChoice('Continue',"Capture will start 2 seconds after this window looses focus. `n Press CTRL+C to force stop", @('No','Yes'), 1))
        }else{
            $startCapture = $true
        }
        if($startCapture -eq $true -or $startCapture -eq 1)
        {
            write-host 'Starting screen capture'
            #Start up the capture process
            $num = 1 #Iteration number for screenshot naming
            $capture = $false #Switch to say when to stop capture
            #Wait for PowerShell to loose focus
            while($capture -eq $false)
            {
                if([userwindows]::GetForegroundWindow() -eq $thisWindowHandle)
                {
                    write-verbose 'Powershell still in focus'
                    Start-Sleep -Milliseconds 60
                }else{
                    write-verbose 'Powershell lost focus'
                    write-host 'Focus Lost - Starting screen capture'
                    Start-Sleep -Seconds 2
                    $capture=$true
                    $stopwatch = [System.Diagnostics.stopwatch]::StartNew()
                }
            }
            #Do another loop until PowerShell regains focus
            while($capture -eq $true)
            {
                if([userwindows]::GetForegroundWindow() -eq $thisWindowHandle)
                {
                    write-verbose 'Powershell has regained focus, so exit the loop'
                    $capture = $false
                }else{
                    write-verbose 'Powershell does not have focus, so capture a screenshot'
                    $x = "{0:D5}" -f $num
                    $path = "$tempPath\$x.jpg"
                    Out-screenshot -horStart $horStart -verStart $verStart -horEnd $horEnd -verEnd $verEnd -path $path -captureCursor
                    $num++
                    Start-Sleep -milliseconds $msWait
                }    
            }
 
        }else{
            return -1
        }
 
 
    }End{
        $stopwatch.stop()
        $numberOfImages = $(get-childitem $tempPath -Filter '*.jpg').count
        #Gasp ... a write host appeared
        #Since we aren't returning any objects this seems like a good option
        Write-Host 'Capture complete, compiling video'
        $actualFrameRate = $numberOfImages / $stopwatch.Elapsed.TotalSeconds
        $actualFrameRate = [math]::Ceiling($actualFrameRate)
        Write-Verbose "Time Elapsed: $($stopwatch.Elapsed.ToString())"
        Write-Verbose "Total Number of Images: $numberOfImages"
        Write-Verbose "ActualFrameRate: $actualFrameRate"
        Write-Verbose 'Creating video using ffmpeg'
        $ffmpegArg = "-framerate $actualFrameRate -i $tempPath\%05d.jpg -c:v libx264 -vf fps=$actualFrameRate -pix_fmt yuv420p $outFolder\$videoName -y"
        Start-Process -FilePath $ffMPegPath -ArgumentList $ffmpegArg -Wait
        if(!$leaveImages)
        {
            Write-Verbose 'Cleaning up jpegs'
            remove-item "$tempPath\*.jpg" -Force
        }
 
    }
 
}


#Since libx264 needs easily divisible numbers,
#Make a function that finds the nearest even number
function get-EvenNumber
{
    Param(
    [int]$number
    )
    if($($number/2) -like '*.5')
    {
        $number = $number-1
    }
    return $number
}

function Out-screenshot
{
    param(
        [int]$verStart,
        [int]$horStart,
        [int]$verEnd,
        [int]$horEnd,
        [string]$path,
        [switch]$captureCursor
    )
    $bounds = [drawing.rectangle]::FromLTRB($horStart,$verStart,$horEnd,$verEnd)
    $jpg = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.height
    $graphics = [drawing.graphics]::FromImage($jpg)
    $graphics.CopyFromScreen($bounds.Location,[Drawing.Point]::Empty,$bounds.Size)
    if($captureCursor)
    {
        write-verbose "CaptureCursor is true"
        $mousePos = [System.Windows.Forms.Cursor]::Position
        if(($mousePos.x -gt $horStart)-and($mousepos.x -lt $horEnd)-and($mousePos.y -gt $verStart) -and ($mousePos.y -lt $verEnd))
        {
            write-verbose "Mouse is in the box"
            #Get the position in the box
            $x = $mousePos.x - $horStart
            $y = $mousePos.y - $verStart
            write-verbose "X: $x, Y: $y"
            #Add a 4 pixel red-dot
            $pen = [drawing.pen]::new([drawing.color]::Red)
            $pen.width = 5
            $pen.LineJoin = [Drawing.Drawing2D.LineJoin]::Bevel
            #$hand = [System.Drawing.SystemIcons]::Hand
            #$arrow = [System.Windows.Forms.Cursors]::Arrow
            #$graphics.DrawIcon($arrow, $x, $y)
            $graphics.DrawRectangle($pen,$x,$y, 5,5)
            #$mousePos
        }
    }
    $jpg.Save($path,"JPEG")
}
