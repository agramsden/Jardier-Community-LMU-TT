Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# Function to convert seconds to timestamp format
function Convert-SecondsToTimestamp {
    param([double]$seconds)
    $ts = [TimeSpan]::FromSeconds($seconds)
    if ($ts.TotalMinutes -lt 1) {
        return "{0:00}.{1:000}" -f $ts.Seconds, $ts.Milliseconds
    }
    else {
        return "{0:00}:{1:00}.{2:000}" -f $ts.Minutes, $ts.Seconds, $ts.Milliseconds
    }
}

# XAML for the GUI
$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Le Mans Ultimate - Jardier Community TT"
    Width="820"
    Height="800"
    MinWidth="800"
    MinHeight="600"
    WindowStartupLocation="CenterScreen"
    Background="#FF1A1A2E">
    
    <Window.Resources>
        <!-- Gradient Brushes -->
        <LinearGradientBrush x:Key="BackgroundGradient" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#1A1A2E" Offset="0"/>
            <GradientStop Color="#16213E" Offset="1"/>
        </LinearGradientBrush>
        
        <LinearGradientBrush x:Key="CardGradient" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#0F3460" Offset="0"/>
            <GradientStop Color="#1A1A2E" Offset="1"/>
        </LinearGradientBrush>
        
        <!-- Car Class Brushes -->
        <LinearGradientBrush x:Key="HyperBrush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#FF4444" Offset="0"/>
            <GradientStop Color="#C23C0C" Offset="1"/>
        </LinearGradientBrush>
        
        <LinearGradientBrush x:Key="LMP2Brush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#4834D4" Offset="0"/>
            <GradientStop Color="#686DE0" Offset="1"/>
        </LinearGradientBrush>
        
        <LinearGradientBrush x:Key="GTEBrush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#F39C12" Offset="0"/>
            <GradientStop Color="#E67E22" Offset="1"/>
        </LinearGradientBrush>
        
        <LinearGradientBrush x:Key="GT3Brush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#07D300" Offset="0"/>
            <GradientStop Color="#01A40F" Offset="1"/>
        </LinearGradientBrush>
        
        <!-- Fastest Time Brush -->
        <SolidColorBrush x:Key="FastestBrush" Color="#BB86FC"/>
        
        <!-- Styles -->
        <Style x:Key="HeaderStyle" TargetType="TextBlock">
            <Setter Property="FontSize" Value="28"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="0,10"/>
        </Style>
        
        <Style x:Key="TrackInfoStyle" TargetType="TextBlock">
            <Setter Property="FontSize" Value="16"/>
            <Setter Property="Foreground" Value="#BBBBBB"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="0,5"/>
        </Style>
        
        <Style x:Key="StatCardStyle" TargetType="Border">
            <Setter Property="Background" Value="{StaticResource CardGradient}"/>
            <Setter Property="CornerRadius" Value="10"/>
            <Setter Property="Padding" Value="15"/>
            <Setter Property="Margin" Value="10"/>
            <Setter Property="BorderBrush" Value="#0F3460"/>
            <Setter Property="BorderThickness" Value="1"/>
        </Style>
        
        <Style x:Key="CarClassStyle" TargetType="Border">
            <Setter Property="CornerRadius" Value="4"/>
            <Setter Property="Padding" Value="8,4"/>
            <Setter Property="Margin" Value="2"/>
        </Style>
        
        <Style x:Key="LapTimeStyle" TargetType="TextBlock">
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Foreground" Value="White"/>
        </Style>
        
        <Style x:Key="SectorStyle" TargetType="TextBlock">
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Foreground" Value="#BBBBBB"/>
        </Style>
        
        <Style x:Key="FastestSectorStyle" TargetType="TextBlock" BasedOn="{StaticResource SectorStyle}">
            <Setter Property="Foreground" Value="{StaticResource FastestBrush}"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>
    </Window.Resources>
    
    <Grid Background="{StaticResource BackgroundGradient}">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        
        <!-- Header -->
        <Grid Grid.Row="0" Margin="20">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            
            <StackPanel Grid.Column="0" HorizontalAlignment="Center">
                <TextBlock Text="Le Mans Ultimate - Jardier Community TT" Style="{StaticResource HeaderStyle}"/>
                <TextBlock Name="TrackInfoText" Text="Waiting for session..." Style="{StaticResource TrackInfoStyle}"/>
            </StackPanel>
            
            <Button Name="LeaderboardButton" Grid.Column="1" Width="100" Height="40" VerticalAlignment="Top"
                    FontSize="12" FontWeight="Bold" Foreground="White" Content="Leaderboard" Margin="0,10,0,0">
                <Button.Background>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                        <GradientStop Color="#FF6B35" Offset="0"/>
                        <GradientStop Color="#D63031" Offset="1"/>
                    </LinearGradientBrush>
                </Button.Background>
                <Button.Style>
                    <Style TargetType="Button">
                        <Setter Property="BorderThickness" Value="0"/>
                        <Setter Property="Cursor" Value="Hand"/>
                        <Setter Property="Template">
                            <Setter.Value>
                                <ControlTemplate TargetType="Button">
                                    <Border Background="{TemplateBinding Background}" 
                                            CornerRadius="10" 
                                            BorderThickness="{TemplateBinding BorderThickness}"
                                            BorderBrush="{TemplateBinding BorderBrush}">
                                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    </Border>
                                    <ControlTemplate.Triggers>
                                        <Trigger Property="IsMouseOver" Value="True">
                                            <Setter Property="Background">
                                                <Setter.Value>
                                                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                                                        <GradientStop Color="#FF7F50" Offset="0"/>
                                                        <GradientStop Color="#E74C3C" Offset="1"/>
                                                    </LinearGradientBrush>
                                                </Setter.Value>
                                            </Setter>
                                        </Trigger>
                                    </ControlTemplate.Triggers>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </Button.Style>
            </Button>
        </Grid>
        
        <!-- Session Info Cards -->
        <Grid Grid.Row="1" Margin="20,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="2*"/>
                <ColumnDefinition Width="2*"/>
                <ColumnDefinition Width="1*"/>
            </Grid.ColumnDefinitions>
            
            <Border Grid.Column="0" Style="{StaticResource StatCardStyle}">
                <StackPanel HorizontalAlignment="Center">
                    <TextBlock Name="DriverText" Text="--" FontSize="18" FontWeight="Bold" Foreground="#4CAF50" HorizontalAlignment="Center" TextWrapping="Wrap"/>
                    <TextBlock Text="Driver" FontSize="10" Foreground="#BBBBBB" HorizontalAlignment="Center"/>
                </StackPanel>
            </Border>
            <Border Grid.Column="1" Style="{StaticResource StatCardStyle}">
                <StackPanel HorizontalAlignment="Center">
                    <TextBlock Name="CarText" Text="--" FontSize="18" FontWeight="Bold" Foreground="#4CAF50" HorizontalAlignment="Center" TextWrapping="Wrap"/>
                    <TextBlock Text="Car" FontSize="10" Foreground="#BBBBBB" HorizontalAlignment="Center"/>
                </StackPanel>
            </Border>
            <Border Grid.Column="2" Style="{StaticResource StatCardStyle}">
                <StackPanel HorizontalAlignment="Center">
                    <TextBlock Name="ClassText" Text="--" FontSize="14" FontWeight="Bold" Foreground="#4CAF50" HorizontalAlignment="Center"/>
                    <TextBlock Text="Class" FontSize="10" Foreground="#BBBBBB" HorizontalAlignment="Center"/>
                </StackPanel>
            </Border>
        </Grid>
        
        <!-- Best Lap Section -->
        <Grid Grid.Row="2" Margin="20,10">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            
            <Border Grid.Column="0" Background="{StaticResource CardGradient}" CornerRadius="10" Padding="15" BorderBrush="#0F3460" BorderThickness="1" Margin="0,0,10,0">
                <StackPanel HorizontalAlignment="Center">
                    <TextBlock Text="Best Lap" FontSize="14" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center"/>
                    <TextBlock Name="BestLapText" Text="--:--.---" FontSize="18" FontWeight="Bold" FontFamily="Consolas" Foreground="White" HorizontalAlignment="Center"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,3">
                        <TextBlock Name="BestS1Text" Text="---.---" FontSize="12" FontFamily="Consolas" Foreground="White" Margin="0,0,8,0"/>
                        <TextBlock Name="BestS2Text" Text="---.---" FontSize="12" FontFamily="Consolas" Foreground="White" Margin="0,0,8,0"/>
                        <TextBlock Name="BestS3Text" Text="---.---" FontSize="12" FontFamily="Consolas" Foreground="White"/>
                    </StackPanel>
                </StackPanel>
            </Border>
            
            <Border Grid.Column="1" Background="{StaticResource CardGradient}" CornerRadius="10" Padding="15" BorderBrush="#0F3460" BorderThickness="1" Margin="0,0,10,0">
                <StackPanel HorizontalAlignment="Center">
                    <TextBlock Text="Optimal Lap" FontSize="14" FontWeight="Bold" Foreground="#BB86FC" HorizontalAlignment="Center"/>
                    <TextBlock Name="OptimalLapText" Text="--:--.---" FontSize="18" FontWeight="Bold" FontFamily="Consolas" Foreground="#BB86FC" HorizontalAlignment="Center"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,3">
                        <TextBlock Name="OptimalS1Text" Text="---.---" FontSize="12" FontFamily="Consolas" Foreground="#BB86FC" Margin="0,0,8,0"/>
                        <TextBlock Name="OptimalS2Text" Text="---.---" FontSize="12" FontFamily="Consolas" Foreground="#BB86FC" Margin="0,0,8,0"/>
                        <TextBlock Name="OptimalS3Text" Text="---.---" FontSize="12" FontFamily="Consolas" Foreground="#BB86FC"/>
                    </StackPanel>
                </StackPanel>
            </Border>
            
            <StackPanel Grid.Column="2" Orientation="Vertical" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="0,10,0,0">
                <Button Name="UploadButton" Width="100" Height="40" Margin="0,0,0,10"
                        FontSize="12" FontWeight="Bold" Foreground="White" Content="Upload Data">
                    <Button.Background>
                        <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                            <GradientStop Color="#5A4FCF" Offset="0"/>
                            <GradientStop Color="#3B2F7F" Offset="1"/>
                        </LinearGradientBrush>
                    </Button.Background>
                    <Button.Style>
                        <Style TargetType="Button">
                            <Setter Property="BorderThickness" Value="0"/>
                            <Setter Property="Cursor" Value="Hand"/>
                            <Setter Property="Template">
                                <Setter.Value>
                                    <ControlTemplate TargetType="Button">
                                        <Border Background="{TemplateBinding Background}" 
                                                CornerRadius="10" 
                                                BorderThickness="{TemplateBinding BorderThickness}"
                                                BorderBrush="{TemplateBinding BorderBrush}">
                                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        </Border>
                                        <ControlTemplate.Triggers>
                                            <Trigger Property="IsMouseOver" Value="True">
                                                <Setter Property="Background">
                                                    <Setter.Value>
                                                        <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                                                            <GradientStop Color="#6B5BD6" Offset="0"/>
                                                            <GradientStop Color="#4A3F8F" Offset="1"/>
                                                        </LinearGradientBrush>
                                                    </Setter.Value>
                                                </Setter>
                                            </Trigger>
                                        </ControlTemplate.Triggers>
                                    </ControlTemplate>
                                </Setter.Value>
                            </Setter>
                        </Style>
                    </Button.Style>
                </Button>
                
                <Button Name="ExportButton" Width="100" Height="40"
                        FontSize="12" FontWeight="Bold" Foreground="White" Content="Export Data">
                    <Button.Background>
                        <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                            <GradientStop Color="#28A745" Offset="0"/>
                            <GradientStop Color="#1E7E34" Offset="1"/>
                        </LinearGradientBrush>
                    </Button.Background>
                    <Button.Style>
                        <Style TargetType="Button">
                            <Setter Property="BorderThickness" Value="0"/>
                            <Setter Property="Cursor" Value="Hand"/>
                            <Setter Property="Template">
                                <Setter.Value>
                                    <ControlTemplate TargetType="Button">
                                        <Border Background="{TemplateBinding Background}" 
                                                CornerRadius="10" 
                                                BorderThickness="{TemplateBinding BorderThickness}"
                                                BorderBrush="{TemplateBinding BorderBrush}">
                                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        </Border>
                                        <ControlTemplate.Triggers>
                                            <Trigger Property="IsMouseOver" Value="True">
                                                <Setter Property="Background">
                                                    <Setter.Value>
                                                        <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                                                            <GradientStop Color="#34CE57" Offset="0"/>
                                                            <GradientStop Color="#2A8F47" Offset="1"/>
                                                        </LinearGradientBrush>
                                                    </Setter.Value>
                                                </Setter>
                                            </Trigger>
                                        </ControlTemplate.Triggers>
                                    </ControlTemplate>
                                </Setter.Value>
                            </Setter>
                        </Style>
                    </Button.Style>
                </Button>
            </StackPanel>
        </Grid>
        
        <!-- Lap Times Grid -->
        <Border Grid.Row="3" Margin="20,0" Background="Transparent" CornerRadius="10" BorderBrush="#0F3460" BorderThickness="1">
            <ScrollViewer VerticalScrollBarVisibility="Auto">
                <StackPanel Name="LapTimesContainer" Orientation="Vertical">
                    <!-- Header Row -->
                    <Border Background="{StaticResource CardGradient}" BorderBrush="#2A2A3E" BorderThickness="0,0,0,1">
                        <Grid Height="40">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="80"/>
                                <ColumnDefinition Width="120"/>
                                <ColumnDefinition Width="120"/>
                                <ColumnDefinition Width="120"/>
                                <ColumnDefinition Width="140"/>
                                <ColumnDefinition Width="120"/>
                            </Grid.ColumnDefinitions>
                            
                            <TextBlock Grid.Column="0" Text="Lap" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="1" Text="Sector 1" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="2" Text="Sector 2" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="3" Text="Sector 3" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="4" Text="Lap Time" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="5" Text="Delta" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Grid>
                    </Border>
                    <!-- Lap entries will be added here dynamically -->
                </StackPanel>
            </ScrollViewer>
        </Border>
        
        <!-- Status Bar -->
        <Border Grid.Row="4" Background="#0F3460" Padding="10">
            <StackPanel Orientation="Horizontal">
                <TextBlock Name="StatusText" Text="Waiting for connection..." Foreground="#BBBBBB" VerticalAlignment="Center"/>
                <TextBlock Name="ConnectionStatus" Text="●" Foreground="Red" FontSize="16" Margin="10,0,0,0" VerticalAlignment="Center"/>
            </StackPanel>
        </Border>
    </Grid>
</Window>
"@

# Load XAML
$reader = [System.Xml.XmlNodeReader]::new([xml]$xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get controls
$trackInfoText = $window.FindName("TrackInfoText")
$driverText = $window.FindName("DriverText")
$carText = $window.FindName("CarText")
$classText = $window.FindName("ClassText")
$bestLapText = $window.FindName("BestLapText")
$bestS1Text = $window.FindName("BestS1Text")
$bestS2Text = $window.FindName("BestS2Text")
$bestS3Text = $window.FindName("BestS3Text")
$optimalLapText = $window.FindName("OptimalLapText")
$optimalS1Text = $window.FindName("OptimalS1Text")
$optimalS2Text = $window.FindName("OptimalS2Text")
$optimalS3Text = $window.FindName("OptimalS3Text")
$lapTimesContainer = $window.FindName("LapTimesContainer")
$statusText = $window.FindName("StatusText")
$connectionStatus = $window.FindName("ConnectionStatus")
$uploadButton = $window.FindName("UploadButton")
$exportButton = $window.FindName("ExportButton")
$leaderboardButton = $window.FindName("LeaderboardButton")

# Global variables
$script:startloop = $true
$script:previousCompletedLaps = 0
$script:laps = @()
$script:newsession = $true
$script:sessionData = @{}
$script:warningTimer = $null
$script:successTimer = $null

# Warning/Success message functions
function Show-Warning {
    param([string]$message)
    
    try {
        $statusText.Text = $message
        $connectionStatus.Foreground = "Orange"
        
        # Stop existing timer if running
        if ($script:warningTimer) {
            $script:warningTimer.Stop()
        }
        
        # Create new timer to hide warning after 5 seconds
        $script:warningTimer = New-Object System.Windows.Threading.DispatcherTimer
        $script:warningTimer.Interval = [TimeSpan]::FromSeconds(5)
        $script:warningTimer.Add_Tick({
            try {
                $statusText.Text = "Connected to LMU"
                $connectionStatus.Foreground = "Green"
                $script:warningTimer.Stop()
            } catch {
                Write-Host "Error in warning timer: $($_.Exception.Message)" -ForegroundColor Red
            }
        })
        $script:warningTimer.Start()
    } catch {
        Write-Host "Error showing warning: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-Success {
    param([string]$message)
    
    try {
        $statusText.Text = $message
        $connectionStatus.Foreground = "Green"
        
        # Stop existing timer if running
        if ($script:successTimer) {
            $script:successTimer.Stop()
        }
        
        # Create new timer to hide success message after 5 seconds
        $script:successTimer = New-Object System.Windows.Threading.DispatcherTimer
        $script:successTimer.Interval = [TimeSpan]::FromSeconds(5)
        $script:successTimer.Add_Tick({
            try {
                $statusText.Text = "Connected to LMU"
                $connectionStatus.Foreground = "Green"
                $script:successTimer.Stop()
            } catch {
                Write-Host "Error in success timer: $($_.Exception.Message)" -ForegroundColor Red
            }
        })
        $script:successTimer.Start()
    } catch {
        Write-Host "Error showing success: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-Error {
    param([string]$message)
    
    try {
        $statusText.Text = $message
        $connectionStatus.Foreground = "Red"
        
        # Stop existing timer if running
        if ($script:successTimer) {
            $script:successTimer.Stop()
        }
        
        # Create new timer to hide error message after 5 seconds
        $script:successTimer = New-Object System.Windows.Threading.DispatcherTimer
        $script:successTimer.Interval = [TimeSpan]::FromSeconds(5)
        $script:successTimer.Add_Tick({
            try {
                $statusText.Text = "Connected to LMU"
                $connectionStatus.Foreground = "Green"
                $script:successTimer.Stop()
            } catch {
                Write-Host "Error in error timer: $($_.Exception.Message)" -ForegroundColor Red
            }
        })
        $script:successTimer.Start()
    } catch {
        Write-Host "Error showing error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Function to populate lap times entries
function Populate-LapTimesEntries {
    param($lapsData)
    
    # Get the container reference to ensure it's accessible
    $lapContainer = $window.FindName("LapTimesContainer")
    
    # Clear existing entries (but keep the header)
    $childrenToRemove = @()
    foreach ($child in $lapContainer.Children) {
        if ($child -ne $lapContainer.Children[0]) {  # Keep first child (header)
            $childrenToRemove += $child
        }
    }
    foreach ($child in $childrenToRemove) {
        $lapContainer.Children.Remove($child)
    }
    
    if (-not $lapsData -or $lapsData.Count -eq 0) {
        return
    }
    
    # Find best times for highlighting
    $validLaps = $lapsData | Where-Object OriginalLapTime -gt 0
    if ($validLaps.Count -gt 0) {
        $bestLapTime = ($validLaps | Sort-Object OriginalLapTime | Select-Object -First 1).OriginalLapTime
        $bestS1Time = ($validLaps | Where-Object OriginalSector1 -gt 0 | Sort-Object OriginalSector1 | Select-Object -First 1).OriginalSector1
        $bestS2Time = ($validLaps | Where-Object OriginalSector2 -gt 0 | Sort-Object OriginalSector2 | Select-Object -First 1).OriginalSector2
        $bestS3Time = ($validLaps | Where-Object OriginalSector3 -gt 0 | Sort-Object OriginalSector3 | Select-Object -First 1).OriginalSector3
    }
    
    # Add each lap entry
    foreach ($lap in $lapsData) {
        # Create border with gradient background for the row
        $entryBorder = New-Object System.Windows.Controls.Border
        $entryBorder.Height = 35
        $entryBorder.Margin = "0,1,0,0"
        
        # Create gradient background matching main boxes
        $gradientBrush = New-Object System.Windows.Media.LinearGradientBrush
        $gradientBrush.StartPoint = "0,0"
        $gradientBrush.EndPoint = "1,1"
        $gradientStop1 = New-Object System.Windows.Media.GradientStop
        $gradientStop1.Color = [System.Windows.Media.ColorConverter]::ConvertFromString("#0F3460")
        $gradientStop1.Offset = 0
        $gradientStop2 = New-Object System.Windows.Media.GradientStop
        $gradientStop2.Color = [System.Windows.Media.ColorConverter]::ConvertFromString("#1A1A2E")
        $gradientStop2.Offset = 1
        $gradientBrush.GradientStops.Add($gradientStop1)
        $gradientBrush.GradientStops.Add($gradientStop2)
        $entryBorder.Background = $gradientBrush
        
        # Create grid for this entry
        $entryGrid = New-Object System.Windows.Controls.Grid
        
        # Add column definitions
        $col1 = New-Object System.Windows.Controls.ColumnDefinition
        $col1.Width = "80"
        $entryGrid.ColumnDefinitions.Add($col1)
        
        $col2 = New-Object System.Windows.Controls.ColumnDefinition
        $col2.Width = "120"
        $entryGrid.ColumnDefinitions.Add($col2)
        
        $col3 = New-Object System.Windows.Controls.ColumnDefinition
        $col3.Width = "120"
        $entryGrid.ColumnDefinitions.Add($col3)
        
        $col4 = New-Object System.Windows.Controls.ColumnDefinition
        $col4.Width = "120"
        $entryGrid.ColumnDefinitions.Add($col4)
        
        $col5 = New-Object System.Windows.Controls.ColumnDefinition
        $col5.Width = "140"
        $entryGrid.ColumnDefinitions.Add($col5)
        
        $col6 = New-Object System.Windows.Controls.ColumnDefinition
        $col6.Width = "120"
        $entryGrid.ColumnDefinitions.Add($col6)
        
        # Lap Number
        $lapText = New-Object System.Windows.Controls.TextBlock
        $lapText.Text = $lap.LapNumber
        $lapText.HorizontalAlignment = "Center"
        $lapText.VerticalAlignment = "Center"
        $lapText.FontFamily = "Segoe UI"
        $lapText.FontSize = 16
        $lapText.FontWeight = "Bold"
        $lapText.Foreground = "#4CAF50"  # Green
        [System.Windows.Controls.Grid]::SetColumn($lapText, 0)
        $entryGrid.Children.Add($lapText)
        
        # Sector 1
        $s1Text = New-Object System.Windows.Controls.TextBlock
        $s1Text.Text = $lap.Sector1
        $s1Text.HorizontalAlignment = "Center"
        $s1Text.VerticalAlignment = "Center"
        $s1Text.FontFamily = "Consolas"
        $s1Text.FontSize = 16
        if ($validLaps.Count -gt 0 -and $lap.OriginalSector1 -eq $bestS1Time) {
            $s1Text.Foreground = "#BB86FC"  # Same purple as optimal times
            $s1Text.FontWeight = "Bold"
        } else {
            $s1Text.Foreground = "#BBBBBB"
        }
        [System.Windows.Controls.Grid]::SetColumn($s1Text, 1)
        $entryGrid.Children.Add($s1Text)
        
        # Sector 2
        $s2Text = New-Object System.Windows.Controls.TextBlock
        $s2Text.Text = $lap.Sector2
        $s2Text.HorizontalAlignment = "Center"
        $s2Text.VerticalAlignment = "Center"
        $s2Text.FontFamily = "Consolas"
        $s2Text.FontSize = 16
        if ($validLaps.Count -gt 0 -and $lap.OriginalSector2 -eq $bestS2Time) {
            $s2Text.Foreground = "#BB86FC"  # Same purple as optimal times
            $s2Text.FontWeight = "Bold"
        } else {
            $s2Text.Foreground = "#BBBBBB"
        }
        [System.Windows.Controls.Grid]::SetColumn($s2Text, 2)
        $entryGrid.Children.Add($s2Text)
        
        # Sector 3
        $s3Text = New-Object System.Windows.Controls.TextBlock
        $s3Text.Text = $lap.Sector3
        $s3Text.HorizontalAlignment = "Center"
        $s3Text.VerticalAlignment = "Center"
        $s3Text.FontFamily = "Consolas"
        $s3Text.FontSize = 16
        if ($validLaps.Count -gt 0 -and $lap.OriginalSector3 -eq $bestS3Time) {
            $s3Text.Foreground = "#BB86FC"  # Same purple as optimal times
            $s3Text.FontWeight = "Bold"
        } else {
            $s3Text.Foreground = "#BBBBBB"
        }
        [System.Windows.Controls.Grid]::SetColumn($s3Text, 3)
        $entryGrid.Children.Add($s3Text)
        
        # Lap Time
        $lapTimeText = New-Object System.Windows.Controls.TextBlock
        $lapTimeText.Text = $lap.LapTime
        $lapTimeText.HorizontalAlignment = "Center"
        $lapTimeText.VerticalAlignment = "Center"
        $lapTimeText.FontFamily = "Consolas"
        $lapTimeText.FontSize = 17
        $lapTimeText.FontWeight = "Bold"
        if ($validLaps.Count -gt 0 -and $lap.OriginalLapTime -eq $bestLapTime) {
            $lapTimeText.Foreground = "#BB86FC"  # Same purple as optimal times
        } else {
            $lapTimeText.Foreground = "#FFFFFF"
        }
        [System.Windows.Controls.Grid]::SetColumn($lapTimeText, 4)
        $entryGrid.Children.Add($lapTimeText)
        
        # Delta
        $deltaText = New-Object System.Windows.Controls.TextBlock
        $deltaText.Text = $lap.Delta
        $deltaText.HorizontalAlignment = "Center"
        $deltaText.VerticalAlignment = "Center"
        $deltaText.FontFamily = "Consolas"
        $deltaText.FontSize = 16
        $deltaText.FontWeight = "Bold"
        $deltaText.Foreground = "#F39C12"  # Orange
        [System.Windows.Controls.Grid]::SetColumn($deltaText, 5)
        $entryGrid.Children.Add($deltaText)
        
        # Add grid to border, then border to container
        $entryBorder.Child = $entryGrid
        $lapContainer.Children.Add($entryBorder)
    }
}

# Timer for updating data
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(2)

# Data update function
$timer.Add_Tick({
    try {
        # Check if Le Mans Ultimate is running
        $lmuProcess = Get-Process -Name "Le Mans Ultimate" -ErrorAction SilentlyContinue
        if (-not $lmuProcess) {
            $statusText.Text = "Le Mans Ultimate not running"
            $connectionStatus.Foreground = "Red"
            $script:newsession = $true
            return
        }
        
        if ($script:newsession -eq $true) {
            $StandingsLapData = $null
            try {
                $StandingsLapData = (Invoke-RestMethod -Uri 'http://localhost:6397/rest/watch/standings' -method 'GET' -TimeoutSec 5) | Where-Object player -eq $true
            }
            catch {
                $statusText.Text = "Waiting for LMU connection..."
                $connectionStatus.Foreground = "Red"
                return
            }
            
            if ($StandingsLapData) {
                $connectionStatus.Foreground = "Green"
                $statusText.Text = "Connected to LMU"
                
                # Get car details
                $carDetails = ((Invoke-RestMethod -Uri 'http://localhost:6397/rest/race/car' -method 'GET') | Where-Object id -eq $StandingsLapData.carId).fullPathTree -split(', ')
                $newClass = $carDetails[1]
                $newCar = $carDetails[2]
                
                # Get session info
                $SessionInfo = (Invoke-RestMethod -Uri 'http://localhost:6397/rest/watch/sessionInfo' -method 'GET')
                $newTrack = $SessionInfo.trackName
                $newDriver = $SessionInfo.playerName
                
                # Get session settings
                $SessionSettings = (Invoke-RestMethod -Uri 'http://localhost:6397/rest/sessions/?' -method 'GET')
                $script:sessionData.cutRules = $SessionSettings.SESSSET_cut_rules.stringValue
                
                # Only reset lap data if this is actually a new session (different track, driver, or car)
                $isActuallyNewSession = ($script:sessionData.track -ne $newTrack) -or 
                                       ($script:sessionData.driver -ne $newDriver) -or 
                                       ($script:sessionData.car -ne $newCar)
                
                if ($isActuallyNewSession) {
                    # Reset lap data only for truly new sessions
                    $script:previousCompletedLaps = 0
                    $script:laps = @()
                    Write-Host "New session detected - lap data reset" -ForegroundColor Magenta
                }
                
                # Update session data
                $script:sessionData.class = $newClass
                $script:sessionData.car = $newCar
                $script:sessionData.track = $newTrack
                $script:sessionData.driver = $newDriver
                $script:newsession = $false
                
                # Update GUI with color coding based on car class
                $trackInfoText.Text = "Track: $($script:sessionData.track)"
                $driverText.Text = $script:sessionData.driver
                $carText.Text = $script:sessionData.car
                $classText.Text = $script:sessionData.class
                
                # Set colors based on car class
                $classColor = switch ($script:sessionData.class) {
                    { $_ -like "*Hyper*" -or $_ -like "*LMH*" } { "#FF4444" }  # Lighter red for Hypercar/LMH
                    { $_ -like "*LMP2*" } { "#87CEEB" }  # Sky Blue for LMP2
                    { $_ -like "*GTE*" -or $_ -like "*GTLM*" } { "#F39C12" }  # Orange for GTE/GTLM
                    { $_ -like "*GT3*" } { "#07D300" }  # Green for GT3
                    default { "#4CAF50" }  # Default green
                }
                
                $driverText.Foreground = $classColor
                $carText.Foreground = $classColor
                $classText.Foreground = $classColor
                
                $bestLapText.Text = "--:--.---"
                $bestS1Text.Text = "---.---"
                $bestS2Text.Text = "---.---"
                $bestS3Text.Text = "---.---"
                $optimalLapText.Text = "--:--.---"
                $optimalS1Text.Text = "---.---"
                $optimalS2Text.Text = "---.---"
                $optimalS3Text.Text = "---.---"
                
                # Clear lap times container
                Populate-LapTimesEntries -lapsData @()
                
                # Console output
                Write-Host "Track: $($script:sessionData.track)" -ForegroundColor Cyan
                Write-Host "Cut Rules: $($script:sessionData.cutRules)" -ForegroundColor Cyan
                Write-Host "Driver: $($script:sessionData.driver)" -ForegroundColor Cyan
                Write-Host "Class: $($script:sessionData.class)" -ForegroundColor Cyan
                Write-Host "Car: $($script:sessionData.car)" -ForegroundColor Cyan
            }
            else {
                $statusText.Text = "Waiting for session data..."
                $connectionStatus.Foreground = "Orange"
            }
        }
        else {
            $StandingsLapData = $null
            try {
                $StandingsLapData = (Invoke-RestMethod -Uri 'http://localhost:6397/rest/watch/standings' -method 'GET' -TimeoutSec 5) | Where-Object player -eq $true
            }
            catch {
                $statusText.Text = "Connection lost"
                $connectionStatus.Foreground = "Red"
                return
            }
            
            if (!$StandingsLapData) {
                $statusText.Text = "Waiting for session data..."
                $connectionStatus.Foreground = "Orange"
                return
            }
            
            $currentCompletedLaps = $StandingsLapData.lapsCompleted
            if ($currentCompletedLaps -ne $script:previousCompletedLaps) {
                if ($StandingsLapData.lastLapTime -lt 0) {
                    $lapdata = [pscustomobject]@{
                        LapNumber = $StandingsLapData.lapsCompleted
                        LapTime = -1  # Invalid lap time
                        Sector1 = -1  # Invalid sector
                        Sector2 = -1  # Invalid sector
                        Sector3 = -1  # Invalid sector
                        Delta = -1    # Invalid delta
                    }
                }
                else {
                    # Calculate sector times with validation (keep in seconds)
                    $sector1Time = [Math]::Round($StandingsLapData.lastSectorTime1, 3)
                    $sector2Time = [Math]::Round($StandingsLapData.lastSectorTime2 - $StandingsLapData.lastSectorTime1, 3)
                    $sector3Time = [Math]::Round($StandingsLapData.lastLapTime - $StandingsLapData.lastSectorTime2, 3)
                    
                    $lapdata = [pscustomobject]@{
                        LapNumber = $StandingsLapData.lapsCompleted
                        LapTime = [Math]::Round($StandingsLapData.lastLapTime, 3)
                        Sector1 = if ($sector1Time -le 0) { -1 } else { $sector1Time }
                        Sector2 = if ($sector2Time -le 0) { -1 } else { $sector2Time }
                        Sector3 = if ($sector3Time -le 0) { -1 } else { $sector3Time }
                        Delta = 0  # Will be calculated after finding best lap
                    }
                }
                
                # Console output
                $displayLapTime = if ($lapdata.LapTime -lt 0) { "--:--.---" } else { Convert-SecondsToTimestamp $lapdata.LapTime }
                $displayS1 = if ($lapdata.Sector1 -lt 0) { "--.---" } else { Convert-SecondsToTimestamp $lapdata.Sector1 }
                $displayS2 = if ($lapdata.Sector2 -lt 0) { "--.---" } else { Convert-SecondsToTimestamp $lapdata.Sector2 }
                $displayS3 = if ($lapdata.Sector3 -lt 0) { "--.---" } else { Convert-SecondsToTimestamp $lapdata.Sector3 }
                Write-Host "$($lapdata.LapNumber) $displayLapTime | $displayS1 $displayS2 $displayS3" -ForegroundColor Yellow
                
                # Create display object for DataGrid
                $displayLap = [PSCustomObject]@{
                    LapNumber = $lapdata.LapNumber
                    Sector1 = $displayS1
                    Sector2 = $displayS2
                    Sector3 = $displayS3
                    LapTime = $displayLapTime
                    Delta = if ($lapdata.Delta -lt 0) { "--.---" } else { "{0:+0.000;-0.000;+0.000}" -f $lapdata.Delta }
                    # Keep original values for calculations
                    OriginalLapTime = $lapdata.LapTime
                    OriginalSector1 = $lapdata.Sector1
                    OriginalSector2 = $lapdata.Sector2
                    OriginalSector3 = $lapdata.Sector3
                    OriginalDelta = $lapdata.Delta
                }
                
                $script:laps += $displayLap
                $script:previousCompletedLaps = $currentCompletedLaps
                
                # Update best lap info and calculate deltas
                $validLaps = $script:laps | Where-Object OriginalLapTime -gt 0
                if ($validLaps.Count -gt 0) {
                    $bestLap = $validLaps | Sort-Object OriginalLapTime | Select-Object -First 1
                    $bestLapTime = $bestLap.OriginalLapTime
                    
                    # Calculate deltas for all laps
                    foreach ($lap in $script:laps) {
                        if ($lap.OriginalLapTime -lt 0) {
                            $lap.Delta = "--.---"
                        }
                        elseif ($lap.OriginalLapTime -eq $bestLap.OriginalLapTime) {
                            $lap.Delta = "--.---"  # Best lap gets no delta
                        }
                        else {
                            $deltaSeconds = $lap.OriginalLapTime - $bestLapTime
                            $lap.Delta = "{0:+0.000;-0.000;+0.000}" -f $deltaSeconds
                        }
                    }
                    
                    # Update best lap display
                    $bestLapText.Text = $bestLap.LapTime
                    
                    # Calculate optimal lap from best sectors
                    $validSectorLaps = $validLaps | Where-Object { $_.OriginalSector1 -gt 0 -and $_.OriginalSector2 -gt 0 -and $_.OriginalSector3 -gt 0 }
                    if ($validSectorLaps.Count -gt 0) {
                        $bestS1Lap = $validSectorLaps | Sort-Object OriginalSector1 | Select-Object -First 1
                        $bestS2Lap = $validSectorLaps | Sort-Object OriginalSector2 | Select-Object -First 1
                        $bestS3Lap = $validSectorLaps | Sort-Object OriginalSector3 | Select-Object -First 1
                        
                        $bestS1 = $bestS1Lap.Sector1
                        $bestS2 = $bestS2Lap.Sector2
                        $bestS3 = $bestS3Lap.Sector3
                        
                        # Set sector text and highlight if it's the best sector
                        $bestS1Text.Text = $bestLap.Sector1
                        if ($bestLap.Sector1 -eq $bestS1) {
                            $bestS1Text.Foreground = "#BB86FC"
                        } else {
                            $bestS1Text.Foreground = "White"
                        }
                        
                        $bestS2Text.Text = $bestLap.Sector2
                        if ($bestLap.Sector2 -eq $bestS2) {
                            $bestS2Text.Foreground = "#BB86FC"
                        } else {
                            $bestS2Text.Foreground = "White"
                        }
                        
                        $bestS3Text.Text = $bestLap.Sector3
                        if ($bestLap.Sector3 -eq $bestS3) {
                            $bestS3Text.Foreground = "#BB86FC"
                        } else {
                            $bestS3Text.Foreground = "White"
                        }
                        
                        $optimalTime = $bestS1Lap.OriginalSector1 + $bestS2Lap.OriginalSector2 + $bestS3Lap.OriginalSector3
                        $optimalLapText.Text = Convert-SecondsToTimestamp $optimalTime
                        $optimalS1Text.Text = $bestS1
                        $optimalS2Text.Text = $bestS2
                        $optimalS3Text.Text = $bestS3
                    }
                    else {
                        # No valid sector data available
                        $bestS1Text.Text = $bestLap.Sector1
                        $bestS1Text.Foreground = "White"
                        $bestS2Text.Text = $bestLap.Sector2
                        $bestS2Text.Foreground = "White"
                        $bestS3Text.Text = $bestLap.Sector3
                        $bestS3Text.Foreground = "White"
                    }
                }
                
                Write-Host "DEBUG: Displaying $($script:laps.Count) laps in grid" -ForegroundColor Cyan
                $window.Dispatcher.Invoke([Action]{
                    Populate-LapTimesEntries -lapsData $script:laps
                })
            }
        }
    }
    catch {
        $statusText.Text = "Error: $($_.Exception.Message)"
        $connectionStatus.Foreground = "Red"
        Write-Host "Error in timer: $($_.Exception.Message)" -ForegroundColor Red
    }
})

# Start the timer
$timer.Start()

# Upload button event handler (empty as requested)
  $uploadButton.Add_Click({
      # TODO: Add upload functionality here
    $apiToken = 'Enter Auth'  # Store this securely in production
      $headers = @{
          'Authorization' = "Bearer $apiToken"
          'Content-Type' = 'application/json'
      }
    $apiUrl = 'http://enterURLhere/api/data/ttdata/track.json' 
    try {
        $TTtrack = Invoke-RestMethod -Uri $apiUrl -Method 'GET' -Headers $headers
    } catch {
        Show-Error "Failed to connect to upload server"
        return
    }
    if($TTtrack.track -notlike $script:sessionData.track)
    {
        Show-Warning "Wrong track! Expected: $($TTtrack.track), Current: $($script:sessionData.track)"
        Write-Host "Track should be $($TTtrack.track), cannot upload data." -ForegroundColor Red
        return
    }
    elseif($script:sessionData.cutRules -notlike "Default" -and $script:sessionData.cutRules -notlike "Strict")
    {
        Show-Warning "Invalid track limits! Must be 'Default' or 'Strict', Current: $($script:sessionData.cutRules)"
        Write-Host "Track limit rules need to be default or strict, cannot upload data." -ForegroundColor Red
        return
    }
    elseif(!($script:laps |where-object OriginalLapTime -gt 0))
    {
        Show-Warning "No valid laps to upload."
        Write-Host "No valid laps found, cannot upload data." -ForegroundColor Red
        return
    }
    else
    {
      $sessionData = [pscustomobject]@{
        track = $script:sessionData.track
        cutRules = $script:sessionData.cutRules
        driver = $script:sessionData.driver
        class = $script:sessionData.class
        car = $script:sessionData.car
        BestLap = ($script:laps |where-object OriginalLapTime -gt 0 | Sort-Object OriginalLapTime | Select-Object -First 1).OriginalLapTime
        Sector1 = ($script:laps |where-object OriginalLapTime -gt 0 | Sort-Object OriginalLapTime | Select-Object -First 1).OriginalSector1
        Sector2 = ($script:laps |where-object OriginalLapTime -gt 0  | Sort-Object OriginalLapTime | Select-Object -First 1).OriginalSector2
        Sector3 = ($script:laps |where-object OriginalLapTime -gt 0  | Sort-Object OriginalLapTime | Select-Object -First 1).OriginalSector3
      }
      $apiUrl = 'http://enterURLhere/api/data/results'
      $jsonBody = $sessionData | ConvertTo-Json -Depth 10
      try {
          $response = Invoke-RestMethod -Uri $apiUrl -Method 'POST' -Body $jsonBody -Headers $headers
          Show-Success "Data uploaded successfully!"
          Write-Host "DEBUG: Response received" -ForegroundColor Magenta
          Write-Host "Session data posted." -ForegroundColor Green
      } catch {
          Show-Error "Upload failed: $($_.Exception.Message)"
          Write-Host "DEBUG: Exception occurred" -ForegroundColor Magenta
          Write-Host "Failed to post session data" -ForegroundColor Red
      }
      try {
          $refresh = Invoke-RestMethod -Uri "http://enterURLhere/api/execute/LMU_Results" -Method 'POST' -Headers $headers
          Show-Success "Data uploaded successfully!"
          Write-Host "DEBUG: Response received" -ForegroundColor Magenta
          Write-Host "Leaderboard updated" -ForegroundColor Green
      } catch {
          Show-Error "Upload failed: $($_.Exception.Message)"
          Write-Host "DEBUG: Exception occurred" -ForegroundColor Magenta
          Write-Host "Failed to update leaderboard" -ForegroundColor Red
      }
    }
})

# Export button event handler
$exportButton.Add_Click({
    try {
        # Create save file dialog
        Add-Type -AssemblyName System.Windows.Forms
        $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
        $saveFileDialog.Filter = "JSON files (*.json)|*.json|All files (*.*)|*.*"
        $saveFileDialog.Title = "Export Session Data"
        $saveFileDialog.FileName = "LMU_Session_Export_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
        
        if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            # Gather all session data
            $exportData = @{
                SessionData = @{
                    Track = $script:sessionData.track
                    Driver = $script:sessionData.driver
                    Car = $script:sessionData.car
                    Class = $script:sessionData.class
                }
            }
            # Add individual lap data if available
            if ($script:laps) {
                foreach ($lap in $script:laps) {
                    $lapInfo = @{
                        LapTime = $lap.OriginalLapTime
                        Sector1 = $lap.OriginalSector1
                        Sector2 = $lap.OriginalSector2
                        Sector3 = $lap.OriginalSector3
                    }
                    $exportData.Laps += $lapInfo
                }
            }
            
            # Convert to JSON and save
            $jsonData = $exportData | ConvertTo-Json -Depth 10 -Compress:$false
            [System.IO.File]::WriteAllText($saveFileDialog.FileName, $jsonData, [System.Text.Encoding]::UTF8)
            
            Show-Success "Session data exported successfully to:`n$($saveFileDialog.FileName)"
        }
    } catch {
        Show-Error "Export failed: $($_.Exception.Message)"
    }
})

# Function to create and show leaderboard window
function Show-LeaderboardWindow {
    # Create leaderboard window XAML
    $leaderboardXaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Jardier Community TT - LMU Leaderboard"
    Width="1200"
    Height="900"
    MinWidth="1200"
    MinHeight="700"
    WindowStartupLocation="CenterScreen"
    Background="#FF1A1A2E">
    
    <Window.Resources>
        <!-- Gradient Brushes -->
        <LinearGradientBrush x:Key="BackgroundGradient" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#1A1A2E" Offset="0"/>
            <GradientStop Color="#16213E" Offset="1"/>
        </LinearGradientBrush>
        
        <LinearGradientBrush x:Key="CardGradient" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#0F3460" Offset="0"/>
            <GradientStop Color="#1A1A2E" Offset="1"/>
        </LinearGradientBrush>
        
        <!-- Position Brushes -->
        <LinearGradientBrush x:Key="GoldBrush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#FFD700" Offset="0"/>
            <GradientStop Color="#FFA500" Offset="1"/>
        </LinearGradientBrush>
        
        <LinearGradientBrush x:Key="SilverBrush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#C0C0C0" Offset="0"/>
            <GradientStop Color="#A9A9A9" Offset="1"/>
        </LinearGradientBrush>
        
        <LinearGradientBrush x:Key="BronzeBrush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#CD7F32" Offset="0"/>
            <GradientStop Color="#B87333" Offset="1"/>
        </LinearGradientBrush>
        
        <!-- Car Class Brushes -->
        <LinearGradientBrush x:Key="HyperBrush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#FF4444" Offset="0"/>
            <GradientStop Color="#C23C0C" Offset="1"/>
        </LinearGradientBrush>
        
        <LinearGradientBrush x:Key="LMP2Brush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#4834D4" Offset="0"/>
            <GradientStop Color="#686DE0" Offset="1"/>
        </LinearGradientBrush>
        
        <LinearGradientBrush x:Key="GTEBrush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#F39C12" Offset="0"/>
            <GradientStop Color="#E67E22" Offset="1"/>
        </LinearGradientBrush>
        
        <LinearGradientBrush x:Key="GT3Brush" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#07D300" Offset="0"/>
            <GradientStop Color="#01A40F" Offset="1"/>
        </LinearGradientBrush>
        
        <!-- Styles -->
        <Style x:Key="HeaderStyle" TargetType="TextBlock">
            <Setter Property="FontSize" Value="28"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="0,10"/>
        </Style>
        
        <Style x:Key="ClassCardStyle" TargetType="Border">
            <Setter Property="CornerRadius" Value="10"/>
            <Setter Property="Padding" Value="15"/>
            <Setter Property="Margin" Value="10"/>
            <Setter Property="BorderBrush" Value="#0F3460"/>
            <Setter Property="BorderThickness" Value="2"/>
        </Style>
        
        <Style x:Key="PositionStyle" TargetType="TextBlock">
            <Setter Property="FontSize" Value="20"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="5"/>
        </Style>
    </Window.Resources>
    
    <Grid Background="{StaticResource BackgroundGradient}">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        
        <!-- Header -->
        <Grid Grid.Row="0" Margin="20">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            
            <StackPanel Grid.Column="0" HorizontalAlignment="Center">
                <TextBlock Text="Jardier Community TT - LMU Leaderboard" Style="{StaticResource HeaderStyle}"/>
                <TextBlock Name="LeaderboardTrackText" Text="Loading..." FontSize="16" Foreground="#BBBBBB" HorizontalAlignment="Center" Margin="0,5"/>
            </StackPanel>
            
            <Button Name="RefreshLeaderboardButton" Grid.Column="1" Width="100" Height="40" VerticalAlignment="Top"
                    FontSize="12" FontWeight="Bold" Foreground="White" Content="Refresh" Margin="0,10,0,0">
                <Button.Background>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                        <GradientStop Color="#5A4FCF" Offset="0"/>
                        <GradientStop Color="#3B2F7F" Offset="1"/>
                    </LinearGradientBrush>
                </Button.Background>
                <Button.Style>
                    <Style TargetType="Button">
                        <Setter Property="BorderThickness" Value="0"/>
                        <Setter Property="Cursor" Value="Hand"/>
                        <Setter Property="Template">
                            <Setter.Value>
                                <ControlTemplate TargetType="Button">
                                    <Border Background="{TemplateBinding Background}" 
                                            CornerRadius="10" 
                                            BorderThickness="{TemplateBinding BorderThickness}"
                                            BorderBrush="{TemplateBinding BorderBrush}">
                                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    </Border>
                                    <ControlTemplate.Triggers>
                                        <Trigger Property="IsMouseOver" Value="True">
                                            <Setter Property="Background">
                                                <Setter.Value>
                                                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                                                        <GradientStop Color="#6B5BD6" Offset="0"/>
                                                        <GradientStop Color="#4A3F8F" Offset="1"/>
                                                    </LinearGradientBrush>
                                                </Setter.Value>
                                            </Setter>
                                        </Trigger>
                                    </ControlTemplate.Triggers>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </Button.Style>
            </Button>
        </Grid>
        
        <!-- Class Winners Cards -->
        <Grid Grid.Row="1" Margin="20,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            
            <Border Name="HyperCard" Grid.Column="0" Style="{StaticResource ClassCardStyle}" Background="{StaticResource CardGradient}">
                <StackPanel HorizontalAlignment="Center">
                    <TextBlock Text="HYPERCAR" FontSize="14" FontWeight="Bold" Foreground="#FF4444" HorizontalAlignment="Center"/>
                    <TextBlock Name="HyperDriver" Text="--" FontSize="16" FontWeight="Bold" Foreground="#FF4444" HorizontalAlignment="Center" TextWrapping="Wrap"/>
                    <TextBlock Name="HyperCar" Text="--" FontSize="12" Foreground="#FF4444" HorizontalAlignment="Center" TextWrapping="Wrap"/>
                    <TextBlock Name="HyperTime" Text="--:--.---" FontSize="20" FontWeight="Bold" FontFamily="Consolas" Foreground="White" HorizontalAlignment="Center"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,2">
                        <TextBlock Name="HyperS1" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD" Margin="0,0,4,0"/>
                        <TextBlock Name="HyperS2" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD" Margin="0,0,4,0"/>
                        <TextBlock Name="HyperS3" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD"/>
                    </StackPanel>
                </StackPanel>
            </Border>
            
            <Border Name="LMP2Card" Grid.Column="1" Style="{StaticResource ClassCardStyle}" Background="{StaticResource CardGradient}">
                <StackPanel HorizontalAlignment="Center">
                    <TextBlock Text="LMP2" FontSize="14" FontWeight="Bold" Foreground="#87CEEB" HorizontalAlignment="Center"/>
                    <TextBlock Name="LMP2Driver" Text="--" FontSize="16" FontWeight="Bold" Foreground="#87CEEB" HorizontalAlignment="Center" TextWrapping="Wrap"/>
                    <TextBlock Name="LMP2Car" Text="--" FontSize="12" Foreground="#87CEEB" HorizontalAlignment="Center" TextWrapping="Wrap"/>
                    <TextBlock Name="LMP2Time" Text="--:--.---" FontSize="20" FontWeight="Bold" FontFamily="Consolas" Foreground="White" HorizontalAlignment="Center"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,2">
                        <TextBlock Name="LMP2S1" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD" Margin="0,0,4,0"/>
                        <TextBlock Name="LMP2S2" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD" Margin="0,0,4,0"/>
                        <TextBlock Name="LMP2S3" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD"/>
                    </StackPanel>
                </StackPanel>
            </Border>
            
            <Border Name="GTECard" Grid.Column="2" Style="{StaticResource ClassCardStyle}" Background="{StaticResource CardGradient}">
                <StackPanel HorizontalAlignment="Center">
                    <TextBlock Text="GTE" FontSize="14" FontWeight="Bold" Foreground="#F39C12" HorizontalAlignment="Center"/>
                    <TextBlock Name="GTEDriver" Text="--" FontSize="16" FontWeight="Bold" Foreground="#F39C12" HorizontalAlignment="Center" TextWrapping="Wrap"/>
                    <TextBlock Name="GTECar" Text="--" FontSize="12" Foreground="#F39C12" HorizontalAlignment="Center" TextWrapping="Wrap"/>
                    <TextBlock Name="GTETime" Text="--:--.---" FontSize="20" FontWeight="Bold" FontFamily="Consolas" Foreground="White" HorizontalAlignment="Center"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,2">
                        <TextBlock Name="GTES1" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD" Margin="0,0,4,0"/>
                        <TextBlock Name="GTES2" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD" Margin="0,0,4,0"/>
                        <TextBlock Name="GTES3" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD"/>
                    </StackPanel>
                </StackPanel>
            </Border>
            
            <Border Name="GT3Card" Grid.Column="3" Style="{StaticResource ClassCardStyle}" Background="{StaticResource CardGradient}">
                <StackPanel HorizontalAlignment="Center">
                    <TextBlock Text="GT3" FontSize="14" FontWeight="Bold" Foreground="#07D300" HorizontalAlignment="Center"/>
                    <TextBlock Name="GT3Driver" Text="--" FontSize="16" FontWeight="Bold" Foreground="#07D300" HorizontalAlignment="Center" TextWrapping="Wrap"/>
                    <TextBlock Name="GT3Car" Text="--" FontSize="12" Foreground="#07D300" HorizontalAlignment="Center" TextWrapping="Wrap"/>
                    <TextBlock Name="GT3Time" Text="--:--.---" FontSize="20" FontWeight="Bold" FontFamily="Consolas" Foreground="White" HorizontalAlignment="Center"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,2">
                        <TextBlock Name="GT3S1" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD" Margin="0,0,4,0"/>
                        <TextBlock Name="GT3S2" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD" Margin="0,0,4,0"/>
                        <TextBlock Name="GT3S3" Text="---.---" FontSize="16" FontFamily="Consolas" Foreground="#DDDDDD"/>
                    </StackPanel>
                </StackPanel>
            </Border>
        </Grid>
        

        
        <!-- Leaderboard Grid -->
        <Border Grid.Row="3" Margin="20,0" Background="Transparent" CornerRadius="10" BorderBrush="#0F3460" BorderThickness="1">
            <ScrollViewer VerticalScrollBarVisibility="Auto">
                <StackPanel Name="LeaderboardContainer" Orientation="Vertical">
                    <!-- Header Row -->
                    <Border Background="{StaticResource CardGradient}" BorderBrush="#1cbdb5ff" BorderThickness="0,0,0,1">
                        <Grid Height="40">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="60"/>
                                <ColumnDefinition Width="70"/>
                                <ColumnDefinition Width="200"/>
                                <ColumnDefinition Width="200"/>
                                <ColumnDefinition Width="80"/>
                                <ColumnDefinition Width="80"/>
                                <ColumnDefinition Width="80"/>
                                <ColumnDefinition Width="80"/>
                                <ColumnDefinition Width="100"/>
                                <ColumnDefinition Width="80"/>
                                <ColumnDefinition Width="80"/>
                            </Grid.ColumnDefinitions>
                            
                            <TextBlock Grid.Column="0" Text="Pos" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="1" Text="Class Pos" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="2" Text="Driver" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="3" Text="Car" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="4" Text="Class" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="5" Text="Sector 1" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="6" Text="Sector 2" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="7" Text="Sector 3" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="8" Text="Lap Time" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="9" Text="Overall Delta" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            <TextBlock Grid.Column="10" Text="Class Delta" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Grid>
                    </Border>
                    <!-- Leaderboard entries will be added here dynamically -->
                </StackPanel>
            </ScrollViewer>
        </Border>
        
        <!-- Status Bar -->
        <Border Grid.Row="4" Background="#27b4c7ff" Padding="10">
            <TextBlock Name="LeaderboardStatusText" Text="Loading leaderboard data..." Foreground="#BBBBBB" HorizontalAlignment="Center"/>
        </Border>
    </Grid>
</Window>
"@

    # Load XAML for leaderboard window
    $leaderboardReader = [System.Xml.XmlNodeReader]::new([xml]$leaderboardXaml)
    $script:leaderboardWindow = [Windows.Markup.XamlReader]::Load($leaderboardReader)
    
    # Get leaderboard controls
    $leaderboardTrackText = $script:leaderboardWindow.FindName("LeaderboardTrackText")
    $hyperDriver = $script:leaderboardWindow.FindName("HyperDriver")
    $hyperCar = $script:leaderboardWindow.FindName("HyperCar")
    $hyperTime = $script:leaderboardWindow.FindName("HyperTime")
    $hyperS1 = $script:leaderboardWindow.FindName("HyperS1")
    $hyperS2 = $script:leaderboardWindow.FindName("HyperS2")
    $hyperS3 = $script:leaderboardWindow.FindName("HyperS3")
    $hyperCard = $script:leaderboardWindow.FindName("HyperCard")
    $lmp2Driver = $script:leaderboardWindow.FindName("LMP2Driver")
    $lmp2Car = $script:leaderboardWindow.FindName("LMP2Car")
    $lmp2Time = $script:leaderboardWindow.FindName("LMP2Time")
    $lmp2S1 = $script:leaderboardWindow.FindName("LMP2S1")
    $lmp2S2 = $script:leaderboardWindow.FindName("LMP2S2")
    $lmp2S3 = $script:leaderboardWindow.FindName("LMP2S3")
    $lmp2Card = $script:leaderboardWindow.FindName("LMP2Card")
    $gteDriver = $script:leaderboardWindow.FindName("GTEDriver")
    $gteCar = $script:leaderboardWindow.FindName("GTECar")
    $gteTime = $script:leaderboardWindow.FindName("GTETime")
    $gteS1 = $script:leaderboardWindow.FindName("GTES1")
    $gteS2 = $script:leaderboardWindow.FindName("GTES2")
    $gteS3 = $script:leaderboardWindow.FindName("GTES3")
    $gteCard = $script:leaderboardWindow.FindName("GTECard")
    $gt3Driver = $script:leaderboardWindow.FindName("GT3Driver")
    $gt3Car = $script:leaderboardWindow.FindName("GT3Car")
    $gt3Time = $script:leaderboardWindow.FindName("GT3Time")
    $gt3S1 = $script:leaderboardWindow.FindName("GT3S1")
    $gt3S2 = $script:leaderboardWindow.FindName("GT3S2")
    $gt3S3 = $script:leaderboardWindow.FindName("GT3S3")
    $gt3Card = $script:leaderboardWindow.FindName("GT3Card")
    $leaderboardContainer = $script:leaderboardWindow.FindName("LeaderboardContainer")
    $leaderboardStatusText = $script:leaderboardWindow.FindName("LeaderboardStatusText")
    $refreshLeaderboardButton = $script:leaderboardWindow.FindName("RefreshLeaderboardButton")
    
    # Function to load leaderboard data
    function Load-LeaderboardData {
        try {
            $leaderboardStatusText.Text = "Loading data..."
            
            $apiToken = 'Enter Auth'
            $headers = @{
                'Authorization' = "Bearer $apiToken"
                'Content-Type' = 'application/json'
            }
            
            # Get track info
            $track = Invoke-RestMethod -Uri 'http://enterURLhere/api/data/ttdata/track.json' -Method 'GET' -Headers $headers
            
            # Get leaderboard data
            $leaderboard = Invoke-RestMethod -Uri 'http://enterURLhere/api/data/ttdata/LMU_results.json' -Method 'GET' -Headers $headers
            
            # Update track info
            $leaderboardTrackText.Text = "Track: $($track.track)"
            
            # Update Hypercar card
            $hyperWinner = $leaderboard.FastestInClass | Where-Object class -like 'Hypercar'
            if ($hyperWinner) {
                $hyperDriver.Text = $hyperWinner.Driver
                $hyperCar.Text = $hyperWinner.Car
                $hyperTime.Text = $hyperWinner.BestLap
                $hyperS1.Text = $hyperWinner.Sector1
                $hyperS2.Text = $hyperWinner.Sector2
                $hyperS3.Text = $hyperWinner.Sector3
                $hyperCard.Opacity = 1.0
            } else {
                $hyperDriver.Text = "No Entries"
                $hyperCar.Text = ""
                $hyperTime.Text = ""
                $hyperS1.Text = "---.---"
                $hyperS2.Text = "---.---"
                $hyperS3.Text = "---.---"
                $hyperCard.Opacity = 0.5
            }
            
            # Update LMP2 card
            $lmp2Winner = $leaderboard.FastestInClass | Where-Object class -like 'LMP2'
            if ($lmp2Winner) {
                $lmp2Driver.Text = $lmp2Winner.Driver
                $lmp2Car.Text = $lmp2Winner.Car
                $lmp2Time.Text = $lmp2Winner.BestLap
                $lmp2S1.Text = $lmp2Winner.Sector1
                $lmp2S2.Text = $lmp2Winner.Sector2
                $lmp2S3.Text = $lmp2Winner.Sector3
                $lmp2Card.Opacity = 1.0
            } else {
                $lmp2Driver.Text = "No Entries"
                $lmp2Car.Text = ""
                $lmp2Time.Text = ""
                $lmp2S1.Text = "---.---"
                $lmp2S2.Text = "---.---"
                $lmp2S3.Text = "---.---"
                $lmp2Card.Opacity = 0.5
            }
            
            # Update GTE card
            $gteWinner = $leaderboard.FastestInClass | Where-Object class -like 'GTE'
            if ($gteWinner) {
                $gteDriver.Text = $gteWinner.Driver
                $gteCar.Text = $gteWinner.Car
                $gteTime.Text = $gteWinner.BestLap
                $gteS1.Text = $gteWinner.Sector1
                $gteS2.Text = $gteWinner.Sector2
                $gteS3.Text = $gteWinner.Sector3
                $gteCard.Opacity = 1.0
            } else {
                $gteDriver.Text = "No Entries"
                $gteCar.Text = ""
                $gteTime.Text = ""
                $gteS1.Text = "---.---"
                $gteS2.Text = "---.---"
                $gteS3.Text = "---.---"
                $gteCard.Opacity = 0.5
            }
            
            # Update GT3 card
            $gt3Winner = $leaderboard.FastestInClass | Where-Object class -like 'GT3'
            if ($gt3Winner) {
                $gt3Driver.Text = $gt3Winner.Driver
                $gt3Car.Text = $gt3Winner.Car
                $gt3Time.Text = $gt3Winner.BestLap
                $gt3S1.Text = $gt3Winner.Sector1
                $gt3S2.Text = $gt3Winner.Sector2
                $gt3S3.Text = $gt3Winner.Sector3
                $gt3Card.Opacity = 1.0
            } else {
                $gt3Driver.Text = "No Entries"
                $gt3Car.Text = ""
                $gt3Time.Text = ""
                $gt3S1.Text = "---.---"
                $gt3S2.Text = "---.---"
                $gt3S3.Text = "---.---"
                $gt3Card.Opacity = 0.5
            }
            
            # Update leaderboard container and store data for styling calculations
            $script:leaderboardData = $leaderboard.Leaderboard
            Populate-LeaderboardEntries -leaderboardData $script:leaderboardData
            
            $leaderboardStatusText.Text = "Last updated: $(Get-Date -Format 'HH:mm:ss')"
            
        } catch {
            $leaderboardStatusText.Text = "Error loading data: $($_.Exception.Message)"
            Write-Host "Leaderboard error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    # Function to populate leaderboard entries
    function Populate-LeaderboardEntries {
        param($leaderboardData)
        
        # Clear existing entries (but keep the header)
        $childrenToRemove = @()
        foreach ($child in $leaderboardContainer.Children) {
            if ($child -ne $leaderboardContainer.Children[0]) {  # Keep first child (header)
                $childrenToRemove += $child
            }
        }
        foreach ($child in $childrenToRemove) {
            $leaderboardContainer.Children.Remove($child)
        }
        
        # Class colors
        $classColors = @{
            "HYPERCAR" = "#FF4444"
            "LMP2" = "#87CEEB"
            "GTE" = "#F39C12"
            "GT3" = "#07D300"
        }
        
        # Get fastest sectors per class for purple highlighting
        $fastestSectors = @{}
        foreach ($entry in $leaderboardData) {
            $class = $entry.Class
            if (-not $fastestSectors.ContainsKey($class)) {
                $fastestSectors[$class] = @{
                    Sector1 = $null
                    Sector2 = $null
                    Sector3 = $null
                }
            }
            
            # Parse sector times for comparison (convert "00:25.123" to seconds)
            $s1Time = if ($entry.Sector1 -and $entry.Sector1 -ne "---" -and $entry.Sector1 -ne "") {
                try {
                    $parts = $entry.Sector1 -split ':'
                    $mins = [int]$parts[0]
                    $secs = [double]$parts[1]
                    $mins * 60 + $secs
                } catch { $null }
            } else { $null }
            
            $s2Time = if ($entry.Sector2 -and $entry.Sector2 -ne "---" -and $entry.Sector2 -ne "") {
                try {
                    $parts = $entry.Sector2 -split ':'
                    $mins = [int]$parts[0]
                    $secs = [double]$parts[1]
                    $mins * 60 + $secs
                } catch { $null }
            } else { $null }
            
            $s3Time = if ($entry.Sector3 -and $entry.Sector3 -ne "---" -and $entry.Sector3 -ne "") {
                try {
                    $parts = $entry.Sector3 -split ':'
                    $mins = [int]$parts[0]
                    $secs = [double]$parts[1]
                    $mins * 60 + $secs
                } catch { $null }
            } else { $null }
            
            if ($s1Time -and ($fastestSectors[$class].Sector1 -eq $null -or $s1Time -lt $fastestSectors[$class].Sector1)) {
                $fastestSectors[$class].Sector1 = $s1Time
                $fastestSectors[$class].Sector1Text = $entry.Sector1
            }
            if ($s2Time -and ($fastestSectors[$class].Sector2 -eq $null -or $s2Time -lt $fastestSectors[$class].Sector2)) {
                $fastestSectors[$class].Sector2 = $s2Time
                $fastestSectors[$class].Sector2Text = $entry.Sector2
            }
            if ($s3Time -and ($fastestSectors[$class].Sector3 -eq $null -or $s3Time -lt $fastestSectors[$class].Sector3)) {
                $fastestSectors[$class].Sector3 = $s3Time
                $fastestSectors[$class].Sector3Text = $entry.Sector3
            }
        }
        
        # Add each leaderboard entry
        foreach ($entry in $leaderboardData) {
            # Create border with gradient background for the row
            $entryBorder = New-Object System.Windows.Controls.Border
            $entryBorder.Height = 30
            $entryBorder.Margin = "0,1,0,0"
            
            # Create gradient background matching main boxes
            $gradientBrush = New-Object System.Windows.Media.LinearGradientBrush
            $gradientBrush.StartPoint = "0,0"
            $gradientBrush.EndPoint = "1,1"
            $gradientStop1 = New-Object System.Windows.Media.GradientStop
            $gradientStop1.Color = [System.Windows.Media.ColorConverter]::ConvertFromString("#0F3460")
            $gradientStop1.Offset = 0
            $gradientStop2 = New-Object System.Windows.Media.GradientStop
            $gradientStop2.Color = [System.Windows.Media.ColorConverter]::ConvertFromString("#1A1A2E")
            $gradientStop2.Offset = 1
            $gradientBrush.GradientStops.Add($gradientStop1)
            $gradientBrush.GradientStops.Add($gradientStop2)
            $entryBorder.Background = $gradientBrush
            
            # Create grid for this entry
            $entryGrid = New-Object System.Windows.Controls.Grid
            $entryGrid.Height = 25
            
            # Add column definitions
            $col1 = New-Object System.Windows.Controls.ColumnDefinition
            $col1.Width = "60"
            $entryGrid.ColumnDefinitions.Add($col1)
            
            $col2 = New-Object System.Windows.Controls.ColumnDefinition
            $col2.Width = "70"
            $entryGrid.ColumnDefinitions.Add($col2)
            
            $col3 = New-Object System.Windows.Controls.ColumnDefinition
            $col3.Width = "200"
            $entryGrid.ColumnDefinitions.Add($col3)
            
            $col4 = New-Object System.Windows.Controls.ColumnDefinition
            $col4.Width = "200"
            $entryGrid.ColumnDefinitions.Add($col4)
            
            $col5 = New-Object System.Windows.Controls.ColumnDefinition
            $col5.Width = "80"
            $entryGrid.ColumnDefinitions.Add($col5)
            
            $col6 = New-Object System.Windows.Controls.ColumnDefinition
            $col6.Width = "80"
            $entryGrid.ColumnDefinitions.Add($col6)
            
            $col7 = New-Object System.Windows.Controls.ColumnDefinition
            $col7.Width = "80"
            $entryGrid.ColumnDefinitions.Add($col7)
            
            $col8 = New-Object System.Windows.Controls.ColumnDefinition
            $col8.Width = "80"
            $entryGrid.ColumnDefinitions.Add($col8)
            
            $col9 = New-Object System.Windows.Controls.ColumnDefinition
            $col9.Width = "100"
            $entryGrid.ColumnDefinitions.Add($col9)
            
            $col10 = New-Object System.Windows.Controls.ColumnDefinition
            $col10.Width = "80"
            $entryGrid.ColumnDefinitions.Add($col10)
            
            $col11 = New-Object System.Windows.Controls.ColumnDefinition
            $col11.Width = "80"
            $entryGrid.ColumnDefinitions.Add($col11)
            
            # Position - with gold/silver/bronze highlighting
            $posText = New-Object System.Windows.Controls.TextBlock
            $posText.Text = $entry.Position
            $posText.HorizontalAlignment = "Center"
            $posText.VerticalAlignment = "Center"
            $posText.FontFamily = "Segoe UI"
            $posText.FontSize = 16
            if ($entry.Position -eq 1) {
                $posText.Foreground = "#FFD700"  # Gold
                $posText.FontWeight = "Bold"
            } elseif ($entry.Position -eq 2) {
                $posText.Foreground = "#C0C0C0"  # Silver
                $posText.FontWeight = "Bold"
            } elseif ($entry.Position -eq 3) {
                $posText.Foreground = "#CD7F32"  # Bronze
                $posText.FontWeight = "Bold"
            } else {
                $posText.Foreground = "#FFFFFF"
            }
            [System.Windows.Controls.Grid]::SetColumn($posText, 0)
            $entryGrid.Children.Add($posText)
            
            # Class Position - with gold/silver/bronze highlighting
            $classPosText = New-Object System.Windows.Controls.TextBlock
            $classPosText.Text = $entry.ClassPosition
            $classPosText.HorizontalAlignment = "Center"
            $classPosText.VerticalAlignment = "Center"
            $classPosText.FontFamily = "Segoe UI"
            $classPosText.FontSize = 16
            if ($entry.ClassPosition -eq 1) {
                $classPosText.Foreground = "#FFD700"  # Gold
                $classPosText.FontWeight = "Bold"
            } elseif ($entry.ClassPosition -eq 2) {
                $classPosText.Foreground = "#C0C0C0"  # Silver
                $classPosText.FontWeight = "Bold"
            } elseif ($entry.ClassPosition -eq 3) {
                $classPosText.Foreground = "#CD7F32"  # Bronze
                $classPosText.FontWeight = "Bold"
            } else {
                $classPosText.Foreground = "#FFFFFF"
            }
            [System.Windows.Controls.Grid]::SetColumn($classPosText, 1)
            $entryGrid.Children.Add($classPosText)
            
            # Driver - with class color
            $driverText = New-Object System.Windows.Controls.TextBlock
            $driverText.Text = $entry.Driver
            $driverText.HorizontalAlignment = "Left"
            $driverText.VerticalAlignment = "Center"
            $driverText.FontFamily = "Segoe UI"
            $driverText.FontSize = 16
            $driverText.FontWeight = "Bold"
            if ($classColors.ContainsKey($entry.Class)) {
                $driverText.Foreground = $classColors[$entry.Class]
            } else {
                $driverText.Foreground = "#FFFFFF"
            }
            $driverText.Margin = "5,0,0,0"
            [System.Windows.Controls.Grid]::SetColumn($driverText, 2)
            $entryGrid.Children.Add($driverText)
            
            # Car
            $carText = New-Object System.Windows.Controls.TextBlock
            $carText.Text = $entry.Car
            $carText.HorizontalAlignment = "Left"
            $carText.VerticalAlignment = "Center"
            $carText.FontFamily = "Segoe UI"
            $carText.FontSize = 16
            $carText.Foreground = "#FFFFFF"
            $carText.Margin = "5,0,0,0"
            [System.Windows.Controls.Grid]::SetColumn($carText, 3)
            $entryGrid.Children.Add($carText)
            
            # Class - with class color highlighting
            $classText = New-Object System.Windows.Controls.TextBlock
            $classText.Text = $entry.Class
            $classText.HorizontalAlignment = "Center"
            $classText.VerticalAlignment = "Center"
            $classText.FontFamily = "Segoe UI"
            $classText.FontSize = 16
            $classText.FontWeight = "Bold"
            if ($classColors.ContainsKey($entry.Class)) {
                $classText.Foreground = $classColors[$entry.Class]
            } else {
                $classText.Foreground = "#FFFFFF"
            }
            [System.Windows.Controls.Grid]::SetColumn($classText, 4)
            $entryGrid.Children.Add($classText)
            
            # Sector 1 - with purple highlighting for fastest
            $s1Text = New-Object System.Windows.Controls.TextBlock
            $s1Text.Text = if ($entry.Sector1 -and $entry.Sector1 -ne "---") { $entry.Sector1 } else { "---" }
            $s1Text.HorizontalAlignment = "Center"
            $s1Text.VerticalAlignment = "Center"
            $s1Text.FontFamily = "Segoe UI"
            $s1Text.FontSize = 16
            if ($entry.Sector1 -and $fastestSectors[$entry.Class].Sector1Text -eq $entry.Sector1) {
                $s1Text.Foreground = "#BB86FC"  # Same purple as optimal times
                $s1Text.FontWeight = "Bold"
            } else {
                $s1Text.Foreground = "#FFFFFF"
            }
            [System.Windows.Controls.Grid]::SetColumn($s1Text, 5)
            $entryGrid.Children.Add($s1Text)
            
            # Sector 2 - with purple highlighting for fastest
            $s2Text = New-Object System.Windows.Controls.TextBlock
            $s2Text.Text = if ($entry.Sector2 -and $entry.Sector2 -ne "---") { $entry.Sector2 } else { "---" }
            $s2Text.HorizontalAlignment = "Center"
            $s2Text.VerticalAlignment = "Center"
            $s2Text.FontFamily = "Segoe UI"
            $s2Text.FontSize = 16
            if ($entry.Sector2 -and $fastestSectors[$entry.Class].Sector2Text -eq $entry.Sector2) {
                $s2Text.Foreground = "#BB86FC"  # Same purple as optimal times
                $s2Text.FontWeight = "Bold"
            } else {
                $s2Text.Foreground = "#FFFFFF"
            }
            [System.Windows.Controls.Grid]::SetColumn($s2Text, 6)
            $entryGrid.Children.Add($s2Text)
            
            # Sector 3 - with purple highlighting for fastest
            $s3Text = New-Object System.Windows.Controls.TextBlock
            $s3Text.Text = if ($entry.Sector3 -and $entry.Sector3 -ne "---") { $entry.Sector3 } else { "---" }
            $s3Text.HorizontalAlignment = "Center"
            $s3Text.VerticalAlignment = "Center"
            $s3Text.FontFamily = "Segoe UI"
            $s3Text.FontSize = 16
            if ($entry.Sector3 -and $fastestSectors[$entry.Class].Sector3Text -eq $entry.Sector3) {
                $s3Text.Foreground = "#BB86FC"  # Same purple as optimal times
                $s3Text.FontWeight = "Bold"
            } else {
                $s3Text.Foreground = "#FFFFFF"
            }
            [System.Windows.Controls.Grid]::SetColumn($s3Text, 7)
            $entryGrid.Children.Add($s3Text)
            
            # Lap Time
            $lapTimeText = New-Object System.Windows.Controls.TextBlock
            $lapTimeText.Text = if ($entry.BestLap) { $entry.BestLap } else { "" }
            $lapTimeText.HorizontalAlignment = "Center"
            $lapTimeText.VerticalAlignment = "Center"
            $lapTimeText.FontFamily = "Segoe UI"
            $lapTimeText.FontSize = 16
            $lapTimeText.Foreground = "#FFFFFF"
            [System.Windows.Controls.Grid]::SetColumn($lapTimeText, 8)
            $entryGrid.Children.Add($lapTimeText)
            
            # Overall Delta - in orange
            $overallDeltaText = New-Object System.Windows.Controls.TextBlock
            $overallDeltaText.Text = if ($entry.OverallDelta) { $entry.OverallDelta } else { "" }
            $overallDeltaText.HorizontalAlignment = "Center"
            $overallDeltaText.VerticalAlignment = "Center"
            $overallDeltaText.FontFamily = "Segoe UI"
            $overallDeltaText.FontSize = 16
            $overallDeltaText.Foreground = "#F39C12"  # Orange
            [System.Windows.Controls.Grid]::SetColumn($overallDeltaText, 9)
            $entryGrid.Children.Add($overallDeltaText)
            
            # Class Delta - in orange
            $classDeltaText = New-Object System.Windows.Controls.TextBlock
            $classDeltaText.Text = if ($entry.ClassDelta) { $entry.ClassDelta } else { "" }
            $classDeltaText.HorizontalAlignment = "Center"
            $classDeltaText.VerticalAlignment = "Center"
            $classDeltaText.FontFamily = "Segoe UI"
            $classDeltaText.FontSize = 16
            $classDeltaText.Foreground = "#F39C12"  # Orange
            [System.Windows.Controls.Grid]::SetColumn($classDeltaText, 10)
            $entryGrid.Children.Add($classDeltaText)
            
            # Add grid to border, then border to container
            $entryBorder.Child = $entryGrid
            $leaderboardContainer.Children.Add($entryBorder)
        }
    }
    
    # Refresh button event handler
    $refreshLeaderboardButton.Add_Click({
        try {
            $leaderboardStatusText.Text = "Loading data..."
            
            $apiToken = 'Enter Auth'
            $headers = @{
                'Authorization' = "Bearer $apiToken"
                'Content-Type' = 'application/json'
            }
            
            # Get track info
            $track = Invoke-RestMethod -Uri 'http://enterURLhere/api/data/ttdata/track.json' -Method 'GET' -Headers $headers
            
            # Get leaderboard data
            $leaderboard = Invoke-RestMethod -Uri 'http://enterURLhere/api/data/ttdata/LMU_results.json' -Method 'GET' -Headers $headers
            
            # Update track info
            $leaderboardTrackText.Text = "Track: $($track.track)"
            
            # Update class cards and leaderboard (simplified refresh)
            $script:leaderboardData = $leaderboard.Leaderboard
            
            # Update status
            $leaderboardStatusText.Text = "Last updated: $(Get-Date -Format 'HH:mm:ss')"
            
        } catch {
            $leaderboardStatusText.Text = "Error loading data: $($_.Exception.Message)"
            Write-Host "Leaderboard refresh error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }.GetNewClosure())
    
    # Remove the script block as we're using inline approach
    
    # Load initial data
    Load-LeaderboardData
    
    # Show the leaderboard window (non-modal)
    $script:leaderboardWindow.Show()
}

# Leaderboard button event handler
$leaderboardButton.Add_Click({
    Show-LeaderboardWindow
})

# Window closing event
$window.Add_Closing({
    $timer.Stop()
    $script:startloop = $false
    
    # Close leaderboard window if it exists and is open
    if ($script:leaderboardWindow -and $script:leaderboardWindow.IsVisible) {
        $script:leaderboardWindow.Close()
    }
})

# Show the window
$window.ShowDialog()