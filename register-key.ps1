# register-key.ps1
# 로컬 공개키(id_ed25519.pub)를 아래 서버들의 authorized_keys에 등록한다.
# PowerShell에서 실행:  .\register-key.ps1
# 아직 키가 없는 서버는 실행 중 비밀번호를 "한 번" 묻고, 이후부터는 안 묻는다.
# 실행할 때마다 같은 폴더에 register-key.log 에 기록을 남긴다(append).

$PubKeyPath = "$env:USERPROFILE\.ssh\id_ed25519.pub"

# 로그 파일: 이 스크립트와 같은 폴더
$LogPath = Join-Path $PSScriptRoot "register-key.log"

# 로그용 함수: 화면에도 찍고 파일에도 남긴다
function Write-Log {
    param(
        [string]$Message,
        [string]$Color = "Gray"
    )
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host $Message -ForegroundColor $Color
    Add-Content -Path $LogPath -Value "[$ts] $Message" -Encoding utf8
}

# ↓↓↓ 등록할 서버들. Port는 생략하면 기본 22 사용 ↓↓↓
$Servers = @(
    @{ User = "kevin"; Host = "192.168.2.240" }                 # 기본 포트(22)
    @{ User = "kevin"; Host = "192.168.2.50";  Port = 1122 }
    @{ User = "kevin"; Host = "192.168.2.51";  Port = 1122 }
)
# ↑↑↑ 필요한 만큼 줄을 추가/삭제하면 된다 ↑↑↑

Add-Content -Path $LogPath -Value "" -Encoding utf8
Write-Log "===== register-key.ps1 실행 시작 =====" "Yellow"
Write-Log "공개키: $PubKeyPath"

if (-not (Test-Path $PubKeyPath)) {
    Write-Log "공개키가 없습니다: $PubKeyPath" "Red"
    Write-Log "먼저 'ssh-keygen -t ed25519' 로 키를 만드세요." "Yellow"
    Write-Log "===== 실행 중단 (공개키 없음) =====" "Yellow"
    exit 1
}

$PubKey = Get-Content $PubKeyPath

$RemoteCmd = "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

$okCount = 0
$failCount = 0

foreach ($s in $Servers) {
    $target = "$($s.User)@$($s.Host)"

    # 포트가 지정돼 있으면 -p 옵션을 붙인다
    if ($s.ContainsKey("Port")) {
        $sshArgs = @("-p", "$($s.Port)", $target, $RemoteCmd)
        $label = "$target (port $($s.Port))"
    } else {
        $sshArgs = @($target, $RemoteCmd)
        $label = "$target (port 22)"
    }

    Write-Log ""
    Write-Log ">>> $label 에 키 등록 중..." "Cyan"
    $PubKey | ssh @sshArgs
    if ($?) {
        Write-Log ">>> $label 등록 성공" "Green"
        $okCount++
    } else {
        Write-Log ">>> $label 등록 실패 (주소/포트/접속 확인 필요)" "Red"
        $failCount++
    }
}

Write-Log ""
Write-Log "결과: 성공 $okCount / 실패 $failCount (총 $($Servers.Count))" "Yellow"
Write-Log "===== register-key.ps1 실행 종료 =====" "Yellow"

Write-Host ""
Write-Host "로그 파일: $LogPath" -ForegroundColor DarkGray
Write-Host "접속 확인: 'ssh kevin@주소' (포트 다르면 'ssh -p 1122 kevin@주소')" -ForegroundColor Yellow
