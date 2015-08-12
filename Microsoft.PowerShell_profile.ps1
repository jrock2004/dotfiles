# BANNER
# ---------------------------------------------------
$date = Get-Date;
$day = $date.DayOfWeek;

$todayis = "========================================================================
Today is $day - $date
Things are looking up! Have a non-threatening day.
------------------------------------------------------------------------";
$todayis

# VISUAL
# ---------------------------------------------------




# ALIAS
# ---------------------------------------------------
Set-Alias omnisharp "C:\Users\costa\Development\omnisharp-roslyn\scripts\Omnisharp.cmd"
Set-Alias editor "gvim"
Set-Alias cisco "C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpnui.exe"
Set-Alias rsa "C:\Program Files (x86)\RSA SecurID Software Token\SecurID.exe"


#### Start the omni server and point it to your project
function nlog {omnisharp -s C:\Users\costa\Development\Work\ApplicationManagement\}
function vnext {omnisharp  -s C:\Users\costa\Development\Work\VendorNext\}
function vnextauto {omnisharp  -s C:\Users\costa\Development\Work\VendorNextAutomation\}

#### Take the bookmarks from edge and import to IE
function updatebookmarks {
	Copy-Item C:\Users\costa\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\MicrosoftEdge\User\Default\Favorites\Links\* -recurse -destination C:\Users\costa\Favorites\Links	
}


#### Edit stuff
function msprofile {editor $profile}
function vimrc {editor ~/.vimrc}

#### Work Stuff
function vpn {rsa cisco}

#### Folders
function gvhsmain {sl "C:\Users\costa\Development\greenvalleyhs"}
function gvhstheme {sl "C:\Users\costa\Development\greenvalleyhs\wp-content\themes\greenvalleyhs"}

