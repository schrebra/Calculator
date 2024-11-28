Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$darkGray = [System.Drawing.Color]::FromArgb(32, 32, 32)
$buttonGray = [System.Drawing.Color]::FromArgb(50, 50, 50)
$buttonHoverGray = [System.Drawing.Color]::FromArgb(70, 70, 70)
$white = [System.Drawing.Color]::White
$accentBlue = [System.Drawing.Color]::FromArgb(0, 120, 212)
$accentBlueHover = [System.Drawing.Color]::FromArgb(0, 100, 180)

$form = New-Object System.Windows.Forms.Form
$form.Text = " Calculator"
$form.Size = New-Object System.Drawing.Size(322, 530)
$form.StartPosition = "CenterScreen"
$form.BackColor = $darkGray
$form.ForeColor = $white
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

$titleBar = New-Object System.Windows.Forms.Panel
$titleBar.Size = New-Object System.Drawing.Size(320, 40)
$titleBar.Location = New-Object System.Drawing.Point(0, 0)
$titleBar.BackColor = $darkGray

$menuButton = New-Object System.Windows.Forms.Button
$menuButton.Text = "≡"
$menuButton.Size = New-Object System.Drawing.Size(40, 40)
$menuButton.Location = New-Object System.Drawing.Point(0, 0)
$menuButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$menuButton.FlatAppearance.BorderSize = 0
$menuButton.Font = New-Object System.Drawing.Font("Segoe UI", 14)
$menuButton.BackColor = $darkGray
$menuButton.ForeColor = $white
$titleBar.Controls.Add($menuButton)

$typeLabel = New-Object System.Windows.Forms.Label
$typeLabel.Text = "Standard"
$typeLabel.Size = New-Object System.Drawing.Size(100, 40)
$typeLabel.Location = New-Object System.Drawing.Point(45, 0)
$typeLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$typeLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$typeLabel.BackColor = $darkGray
$typeLabel.ForeColor = $white
$titleBar.Controls.Add($typeLabel)

$historyButton = New-Object System.Windows.Forms.Button
$historyButton.Text = "⟳"
$historyButton.Size = New-Object System.Drawing.Size(40, 40)
$historyButton.Location = New-Object System.Drawing.Point(270, 0)
$historyButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$historyButton.FlatAppearance.BorderSize = 0
$historyButton.Font = New-Object System.Drawing.Font("Segoe UI", 14)
$historyButton.BackColor = $darkGray
$historyButton.ForeColor = $white
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
$display.ForeColor = $white
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
            $button.BackColor = $buttonGray
        }
        "operator" {
            $button.Font = New-Object System.Drawing.Font("Segoe UI", 14)
            $button.BackColor = $buttonGray
        }
        "function" {
            $button.Font = New-Object System.Drawing.Font("Segoe UI", 12)
            $button.BackColor = $buttonGray
        }
    }
    
    $button.ForeColor = $white
    
    $button.Add_MouseEnter({
        $this.BackColor = $buttonHoverGray
    })
    
    $button.Add_MouseLeave({
        $this.BackColor = if ($this.Text -eq "=") { $accentBlue } else { $buttonGray }
    })
    
    return $button
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