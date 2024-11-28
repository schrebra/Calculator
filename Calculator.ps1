Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Theme definitions
$themes = @{
    "Light" = @{
        "Background" = [System.Drawing.Color]::FromArgb(243, 243, 243)
        "Button" = [System.Drawing.Color]::FromArgb(250, 250, 250)
        "ButtonHover" = [System.Drawing.Color]::FromArgb(230, 230, 230)
        "Text" = [System.Drawing.Color]::Black
        "AccentBlue" = [System.Drawing.Color]::FromArgb(0, 120, 212)
        "AccentBlueHover" = [System.Drawing.Color]::FromArgb(0, 100, 180)
    }
    "Dark" = @{
        "Background" = [System.Drawing.Color]::FromArgb(32, 32, 32)
        "Button" = [System.Drawing.Color]::FromArgb(50, 50, 50)
        "ButtonHover" = [System.Drawing.Color]::FromArgb(70, 70, 70)
        "Text" = [System.Drawing.Color]::White
        "AccentBlue" = [System.Drawing.Color]::FromArgb(0, 120, 212)
        "AccentBlueHover" = [System.Drawing.Color]::FromArgb(0, 100, 180)
    }
}

# Initialize with dark theme
$currentTheme = $themes["Dark"]
$darkGray = $currentTheme["Background"]
$buttonGray = $currentTheme["Button"]
$buttonHoverGray = $currentTheme["ButtonHover"]
$textColor = $currentTheme["Text"]
$accentBlue = $currentTheme["AccentBlue"]
$accentBlueHover = $currentTheme["AccentBlueHover"]

$form = New-Object System.Windows.Forms.Form
$form.Text = " Calculator"
$form.Size = New-Object System.Drawing.Size(322, 530)
$form.StartPosition = "CenterScreen"
$form.BackColor = $darkGray
$form.ForeColor = $textColor
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

$titleBar = New-Object System.Windows.Forms.Panel
$titleBar.Size = New-Object System.Drawing.Size(320, 40)
$titleBar.Location = New-Object System.Drawing.Point(0, 0)
$titleBar.BackColor = $darkGray

# Theme menu popup
$themeMenu = New-Object System.Windows.Forms.ContextMenuStrip
$lightThemeItem = New-Object System.Windows.Forms.ToolStripMenuItem
$lightThemeItem.Text = "Light Theme"
$darkThemeItem = New-Object System.Windows.Forms.ToolStripMenuItem
$darkThemeItem.Text = "Dark Theme"
$themeMenu.Items.AddRange(@($lightThemeItem, $darkThemeItem))

$menuButton = New-Object System.Windows.Forms.Button
$menuButton.Text = "≡"
$menuButton.Size = New-Object System.Drawing.Size(40, 40)
$menuButton.Location = New-Object System.Drawing.Point(0, 0)
$menuButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$menuButton.FlatAppearance.BorderSize = 0
$menuButton.Font = New-Object System.Drawing.Font("Segoe UI", 14)
$menuButton.BackColor = $darkGray
$menuButton.ForeColor = $textColor
$titleBar.Controls.Add($menuButton)

# Theme switching function
function Switch-Theme {
    param($themeName)
    
    $script:currentTheme = $themes[$themeName]
    
    # Update form colors
    $form.BackColor = $currentTheme["Background"]
    $form.ForeColor = $currentTheme["Text"]
    
    # Update title bar
    $titleBar.BackColor = $currentTheme["Background"]
    $menuButton.BackColor = $currentTheme["Background"]
    $menuButton.ForeColor = $currentTheme["Text"]
    $typeLabel.BackColor = $currentTheme["Background"]
    $typeLabel.ForeColor = $currentTheme["Text"]
    $historyButton.BackColor = $currentTheme["Background"]
    $historyButton.ForeColor = $currentTheme["Text"]
    
    # Update displays
    $calcDisplay.BackColor = $currentTheme["Background"]
    $display.BackColor = $currentTheme["Background"]
    $display.ForeColor = $currentTheme["Text"]
    
    # Update memory panel
    $memoryPanel.BackColor = $currentTheme["Background"]
    foreach ($control in $memoryPanel.Controls) {
        if ($control -is [System.Windows.Forms.Button]) {
            $control.BackColor = $currentTheme["Background"]
        }
    }
    
    # Update button panel
    $buttonPanel.BackColor = $currentTheme["Background"]
    foreach ($control in $buttonPanel.Controls) {
        if ($control -is [System.Windows.Forms.Button]) {
            if ($control.Text -eq "=") {
                $control.BackColor = $currentTheme["AccentBlue"]
                $control.ForeColor = [System.Drawing.Color]::White
            }
            else {
                $control.BackColor = $currentTheme["Button"]
                $control.ForeColor = $currentTheme["Text"]
            }
            
            # Update hover events
            $control.Add_MouseEnter({
                $this.BackColor = if ($this.Text -eq "=") { 
                    $currentTheme["AccentBlueHover"] 
                } else { 
                    $currentTheme["ButtonHover"]
                }
            })
            
            $control.Add_MouseLeave({
                $this.BackColor = if ($this.Text -eq "=") { 
                    $currentTheme["AccentBlue"]
                } else { 
                    $currentTheme["Button"]
                }
            })
        }
    }
}

# Add menu click events
$lightThemeItem.Add_Click({ Switch-Theme "Light" })
$darkThemeItem.Add_Click({ Switch-Theme "Dark" })

# Add menu button click event
$menuButton.Add_Click({
    $themeMenu.Show($menuButton, 0, $menuButton.Height)
})

$typeLabel = New-Object System.Windows.Forms.Label
$typeLabel.Text = "Standard"
$typeLabel.Size = New-Object System.Drawing.Size(100, 40)
$typeLabel.Location = New-Object System.Drawing.Point(45, 0)
$typeLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$typeLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$typeLabel.BackColor = $darkGray
$typeLabel.ForeColor = $textColor
$titleBar.Controls.Add($typeLabel)

$historyButton = New-Object System.Windows.Forms.Button
$historyButton.Text = "⟳"
$historyButton.Size = New-Object System.Drawing.Size(40, 40)
$historyButton.Location = New-Object System.Drawing.Point(270, 0)
$historyButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$historyButton.FlatAppearance.BorderSize = 0
$historyButton.Font = New-Object System.Drawing.Font("Segoe UI", 14)
$historyButton.BackColor = $darkGray
$historyButton.ForeColor = $textColor
$titleBar.Controls.Add($historyButton)

$form.Controls.Add($titleBar)

$calcDisplay = New-Object System.Windows.Forms.TextBox
$calcDisplay.Multiline = $true
$calcDisplay.Size = New-Object System.Drawing.Size(300, 30)
$calcDisplay.Location = New-Object System.Drawing.Point(10, 50)
$calcDisplay.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$calcDisplay.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Right
$calcDisplay.ReadOnly = $true
$calcDisplay.BackColor = $darkGray
$calcDisplay.ForeColor = [System.Drawing.Color]::Gray
$calcDisplay.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$calcDisplay.Text = ""
$form.Controls.Add($calcDisplay)

$display = New-Object System.Windows.Forms.TextBox
$display.Multiline = $true
$display.Size = New-Object System.Drawing.Size(300, 60)
$display.Location = New-Object System.Drawing.Point(10, 80)
$display.Font = New-Object System.Drawing.Font("Segoe UI", 32)
$display.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Right
$display.ReadOnly = $true
$display.BackColor = $darkGray
$display.ForeColor = $textColor
$display.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$display.Text = "0"
$form.Controls.Add($display)

$memoryPanel = New-Object System.Windows.Forms.Panel
$memoryPanel.Size = New-Object System.Drawing.Size(320, 30)
$memoryPanel.Location = New-Object System.Drawing.Point(0, 140)
$memoryPanel.BackColor = $darkGray

$memoryButtons = @("MC", "MR", "M+", "M-", "MS", "M▾")
$memX = 5
$memWidth = 50

foreach ($mem in $memoryButtons) {
    $memButton = New-Object System.Windows.Forms.Button
    $memButton.Text = $mem
    $memButton.Size = New-Object System.Drawing.Size($memWidth, 25)
    $memButton.Location = New-Object System.Drawing.Point($memX, 2)
    $memButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $memButton.FlatAppearance.BorderSize = 0
    $memButton.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $memButton.BackColor = $darkGray
    $memButton.ForeColor = [System.Drawing.Color]::Gray
    $memoryPanel.Controls.Add($memButton)
    $memX += ($memWidth + 2)
}

$form.Controls.Add($memoryPanel)

# Update the Create-CalculatorButton function's hover events to maintain text visibility
function Create-CalculatorButton {
    param(
        $text,
        $x,
        $y,
        $width = 75,
        $height = 60,
        $type = "number"
    )
    
    $button = New-Object System.Windows.Forms.Button
    $button.Size = New-Object System.Drawing.Size($width, $height)
    $button.Location = New-Object System.Drawing.Point($x, $y)
    $button.Text = $text
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderSize = 0
    
    switch ($type) {
        "number" {
            $button.Font = New-Object System.Drawing.Font("Segoe UI", 14)
            $button.BackColor = $currentTheme["Button"]
            $button.ForeColor = $currentTheme["Text"]
        }
        "operator" {
            $button.Font = New-Object System.Drawing.Font("Segoe UI", 14)
            $button.BackColor = $currentTheme["Button"]
            $button.ForeColor = $currentTheme["Text"]
        }
        "function" {
            $button.Font = New-Object System.Drawing.Font("Segoe UI", 12)
            $button.BackColor = $currentTheme["Button"]
            $button.ForeColor = $currentTheme["Text"]
        }
    }
    
    # Modified hover events to maintain text color during hover
    $button.Add_MouseEnter({
        $this.BackColor = $currentTheme["ButtonHover"]
        $this.ForeColor = if ($this.Text -eq "=") { [System.Drawing.Color]::White } else { $currentTheme["Text"] }
    })
    
    $button.Add_MouseLeave({
        $this.BackColor = if ($this.Text -eq "=") { $currentTheme["AccentBlue"] } else { $currentTheme["Button"] }
        $this.ForeColor = if ($this.Text -eq "=") { [System.Drawing.Color]::White } else { $currentTheme["Text"] }
    })
    
    if ($text -eq "=") {
        $button.BackColor = $currentTheme["AccentBlue"]
        $button.ForeColor = [System.Drawing.Color]::White
    }
    
    return $button
}

# Also update the Switch-Theme function's button panel section
function Switch-Theme {
    param($themeName)
    
    $script:currentTheme = $themes[$themeName]
    
    # Update form colors
    $form.BackColor = $currentTheme["Background"]
    $form.ForeColor = $currentTheme["Text"]
    
    # Update title bar
    $titleBar.BackColor = $currentTheme["Background"]
    $menuButton.BackColor = $currentTheme["Background"]
    $menuButton.ForeColor = $currentTheme["Text"]
    $typeLabel.BackColor = $currentTheme["Background"]
    $typeLabel.ForeColor = $currentTheme["Text"]
    $historyButton.BackColor = $currentTheme["Background"]
    $historyButton.ForeColor = $currentTheme["Text"]
    
    # Update displays
    $calcDisplay.BackColor = $currentTheme["Background"]
    $display.BackColor = $currentTheme["Background"]
    $display.ForeColor = $currentTheme["Text"]
    
    # Update memory panel
    $memoryPanel.BackColor = $currentTheme["Background"]
    foreach ($control in $memoryPanel.Controls) {
        if ($control -is [System.Windows.Forms.Button]) {
            $control.BackColor = $currentTheme["Background"]
        }
    }
    
    # Update button panel with modified hover behavior
    $buttonPanel.BackColor = $currentTheme["Background"]
    foreach ($control in $buttonPanel.Controls) {
        if ($control -is [System.Windows.Forms.Button]) {
            if ($control.Text -eq "=") {
                $control.BackColor = $currentTheme["AccentBlue"]
                $control.ForeColor = [System.Drawing.Color]::White
            }
            else {
                $control.BackColor = $currentTheme["Button"]
                $control.ForeColor = $currentTheme["Text"]
            }
            
            # Modified hover events to maintain text visibility
            $control.Add_MouseEnter({
                $this.BackColor = $currentTheme["ButtonHover"]
                $this.ForeColor = if ($this.Text -eq "=") { [System.Drawing.Color]::White } else { $currentTheme["Text"] }
            })
            
            $control.Add_MouseLeave({
                $this.BackColor = if ($this.Text -eq "=") { $currentTheme["AccentBlue"] } else { $currentTheme["Button"] }
                $this.ForeColor = if ($this.Text -eq "=") { [System.Drawing.Color]::White } else { $currentTheme["Text"] }
            })
        }
    }
}

$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Size = New-Object System.Drawing.Size(320, 320)
$buttonPanel.Location = New-Object System.Drawing.Point(0, 180)
$buttonPanel.BackColor = $darkGray

$buttons = @(
    @("%", "√x", "x2", "1/x"),
    @("CE", "C", "⌫", "÷"),
    @("7", "8", "9", "×"),
    @("4", "5", "6", "-"),
    @("1", "2", "3", "+"),
    @("±", "0", ".", "=")
)

$buttonWidth = 75
$buttonHeight = 50
$spacing = 2
$startX = 5
$startY = 5

for ($row = 0; $row -lt $buttons.Count; $row++) {
    for ($col = 0; $col -lt $buttons[$row].Count; $col++) {
        $x = $startX + ($col * ($buttonWidth + $spacing))
        $y = $startY + ($row * ($buttonHeight + $spacing))
        $text = $buttons[$row][$col]
        
        $type = switch -Regex ($text) {
            '[0-9.]' { "number" }
            '[+\-×÷=]' { "operator" }
            default { "function" }
        }
        
        $height = if ($text -eq "=") { ($buttonHeight * 0.95 + $spacing) } else { $buttonHeight }
        $button = Create-CalculatorButton -text $text -x $x -y $y -width $buttonWidth -height $height -type $type
        
        if ($text -eq "=") {
            $button.BackColor = $accentBlue
        }
        
        $buttonPanel.Controls.Add($button)
    }
}

$form.Controls.Add($buttonPanel)

$script:firstNumber = $null
$script:operation = $null
$script:newNumber = $true
$script:lastResult = 0

$buttonPanel.Controls | ForEach-Object {
    if ($_ -is [System.Windows.Forms.Button]) {
        $_.Add_Click({
            $buttonText = $this.Text
            
            switch -Regex ($buttonText) {
                '[0-9]' {
                    if ($script:newNumber) {
                        $display.Text = $buttonText
                        $script:newNumber = $false
                    }
                    else {
                        if ($display.Text -eq "0") {
                            $display.Text = $buttonText
                        }
                        else {
                            $display.Text += $buttonText
                        }
                    }
                }
                '[+\-×÷]' {
                    $script:firstNumber = [double]::Parse($display.Text)
                    $script:operation = $buttonText
                    $script:newNumber = $true
                    $calcDisplay.Text = "$script:firstNumber $script:operation"
                }
                '=' {
                    if ($script:operation -ne $null -and $script:firstNumber -ne $null) {
                        $secondNumber = [double]::Parse($display.Text)
                        $calcDisplay.Text = "$script:firstNumber $script:operation $secondNumber ="
                        
                        $result = switch ($script:operation) {
                            "+" { $script:firstNumber + $secondNumber }
                            "-" { $script:firstNumber - $secondNumber }
                            "×" { $script:firstNumber * $secondNumber }
                            "÷" { 
                                if ($secondNumber -eq 0) {
                                    "Cannot divide by zero"
                                    return
                                }
                                $script:firstNumber / $secondNumber
                            }
                        }
                        
                        $display.Text = $result.ToString()
                        $script:lastResult = $result
                        $script:firstNumber = $null
                        $script:operation = $null
                        $script:newNumber = $true
                    }
                }
                'CE|C' {
                    $display.Text = "0"
                    if ($buttonText -eq "C") {
                        $script:firstNumber = $null
                        $script:operation = $null
                        $calcDisplay.Text = ""
                    }
                    $script:newNumber = $true
                }
                '⌫' {
                    if ($display.Text.Length -gt 1) {
                        $display.Text = $display.Text.Substring(0, $display.Text.Length - 1)
                    }
                    else {
                        $display.Text = "0"
                    }
                }
                '%' {
                    $display.Text = ([double]::Parse($display.Text) / 100).ToString()
                }
                '±' {
                    $display.Text = (-[double]::Parse($display.Text)).ToString()
                }
                '\.' {
                    if (-not $display.Text.Contains(".")) {
                        $display.Text += "."
                    }
                }
                '√x' {
                    $calcDisplay.Text = "√(" + $display.Text + ")"
                    $display.Text = [Math]::Sqrt([double]::Parse($display.Text)).ToString()
                }
                'x²' {
                    $num = [double]::Parse($display.Text)
                    $calcDisplay.Text = "(" + $display.Text + ")²"
                    $display.Text = ($num * $num).ToString()
                }
                '1/x' {
                    $num = [double]::Parse($display.Text)
                    if ($num -eq 0) {
                        $display.Text = "Cannot divide by zero"
                        return
                    }
                    $calcDisplay.Text = "1/(" + $display.Text + ")"
                    $display.Text = (1 / $num).ToString()
                }
            }
        })
    }
}

$form.ShowDialog()