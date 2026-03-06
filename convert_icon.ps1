param (
    [string]$imagePath,
    [string]$iconPath
)

try {
    Add-Type -AssemblyName System.Drawing
    $img = [System.Drawing.Image]::FromFile($imagePath)
    $memStream = New-Object System.IO.MemoryStream
    $img.Save($memStream, [System.Drawing.Imaging.ImageFormat]::Png)
    $memStream.Position = 0
    
    $fileStream = New-Object System.IO.FileStream($iconPath, [System.IO.FileMode]::Create)
    $binaryWriter = New-Object System.IO.BinaryWriter($fileStream)
    
    $width = $img.Width
    if ($width -ge 256) { $width = 0 }
    $height = $img.Height
    if ($height -ge 256) { $height = 0 }

    $binaryWriter.Write([short]0)
    $binaryWriter.Write([short]1)
    $binaryWriter.Write([short]1)
    $binaryWriter.Write([byte]$width)
    $binaryWriter.Write([byte]$height)
    $binaryWriter.Write([byte]0)
    $binaryWriter.Write([byte]0)
    $binaryWriter.Write([short]0)
    $binaryWriter.Write([short]32)
    $binaryWriter.Write([int]$memStream.Length)
    $binaryWriter.Write([int]22)
    
    $memStream.CopyTo($fileStream)
    
    $binaryWriter.Close()
    $fileStream.Close()
    $memStream.Close()
    $img.Dispose()
    
    "Success" | Out-File "ps_out.txt"
} catch {
    "Error: $($_.Exception.Message)" | Out-File "ps_out.txt"
}
