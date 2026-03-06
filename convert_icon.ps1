param (
    [string]$imagePath,
    [string]$iconPath
)

Add-Type -AssemblyName System.Drawing

try {
    $img = [System.Drawing.Image]::FromFile($imagePath)
    $memStream = New-Object System.IO.MemoryStream
    $img.Save($memStream, [System.Drawing.Imaging.ImageFormat]::Png)
    $memStream.Position = 0
    
    $fileStream = New-Object System.IO.FileStream($iconPath, [System.IO.FileMode]::Create)
    $binaryWriter = New-Object System.IO.BinaryWriter($fileStream)
    
    # Write ICO header
    $binaryWriter.Write([short]0) # Reserved
    $binaryWriter.Write([short]1) # Type -> Icon
    $binaryWriter.Write([short]1) # Count -> 1 Image

    # Write Image Entry
    $width = $img.Width
    if ($width -ge 256) { $width = 0 }
    $height = $img.Height
    if ($height -ge 256) { $height = 0 }

    $binaryWriter.Write([byte]$width)
    $binaryWriter.Write([byte]$height)
    $binaryWriter.Write([byte]0)   # Color count
    $binaryWriter.Write([byte]0)   # Reserved
    $binaryWriter.Write([short]0)  # Color planes
    $binaryWriter.Write([short]32) # Bits per pixel
    $binaryWriter.Write([int]$memStream.Length) # Image size in bytes
    $binaryWriter.Write([int]22)   # Offset
    
    $memStream.CopyTo($fileStream)
    
    $binaryWriter.Close()
    $fileStream.Close()
    $memStream.Close()
    
    Write-Host "Success"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
