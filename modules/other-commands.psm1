function Invoke-PreCommands([object]$options) {
    if (!$options -or $options.ignore -or !$options.install) {
        Write-Warning "Install Pre Commands: 'options' not found or section is 'ignored'. Skipped"
        return
    }

    if ($options.preCommands -and $options.preCommands.Count -gt 0) {
        Invoke-SimpleCommands $options.preCommands
    }
    else {
        Write-Host "OtherCommands: preCommands not found!"
    }
}

function Invoke-PostCommands([object]$options) {
    if (!$options -or $options.ignore) {
        Write-Warning "OtherCommands: 'options' not found or section is 'ignored'. Skipped"
        return
    }

    if ($options.postCommands -and $options.postCommands.Count -gt 0) {
        Invoke-SimpleCommands $options.postCommands
    }
    else {
        Write-Host "OtherCommands: postCommands not found!"
    }
}