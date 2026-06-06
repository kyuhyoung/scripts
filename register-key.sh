#!/usr/bin/env bash
# register-key.sh  (register-key.ps1 의 Ubuntu/Linux 버전)
# 로컬 공개키(id_ed25519.pub)를 아래 서버들의 authorized_keys에 등록한다.
# 실행:  bash register-key.sh   또는   ./register-key.sh  (chmod +x 후)
# 아직 키가 없는 서버는 실행 중 비밀번호를 "한 번" 묻고, 이후부터는 안 묻는다.
# 실행할 때마다 스크립트와 같은 폴더에 register-key.log 에 기록을 남긴다(append).

PUBKEY="$HOME/.ssh/id_ed25519.pub"

# 로그 파일: 이 스크립트와 같은 폴더
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGPATH="$SCRIPT_DIR/register-key.log"

# 로그용 함수: 화면에도 찍고 파일에도 남긴다
log() {
    local ts
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "$1"
    echo "[$ts] $1" >> "$LOGPATH"
}

# ↓↓↓ 등록할 서버들. "user@host" 뒤에 포트를 적는다. 포트 생략 시 22 사용 ↓↓↓
#     형식:  "user@host:port"   (포트 없으면 그냥 "user@host")
SERVERS=(
    "kevin@192.168.2.240"          # 기본 포트(22)
    "kevin@192.168.2.50:1122"
    "kevin@192.168.2.51:1122"
)
# ↑↑↑ 필요한 만큼 줄을 추가/삭제하면 된다 ↑↑↑

echo "" >> "$LOGPATH"
log "===== register-key.sh 실행 시작 ====="
log "공개키: $PUBKEY"

if [ ! -f "$PUBKEY" ]; then
    log "공개키가 없습니다: $PUBKEY"
    log "먼저 'ssh-keygen -t ed25519' 로 키를 만드세요."
    log "===== 실행 중단 (공개키 없음) ====="
    exit 1
fi

REMOTE_CMD='mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'

ok=0
fail=0

for entry in "${SERVERS[@]}"; do
    # "user@host:port" 에서 포트 분리
    if [[ "$entry" == *:* ]]; then
        target="${entry%:*}"     # user@host
        port="${entry##*:}"      # port
    else
        target="$entry"
        port="22"
    fi
    label="$target (port $port)"

    log ""
    log ">>> $label 에 키 등록 중..."
    if ssh -p "$port" "$target" "$REMOTE_CMD" < "$PUBKEY"; then
        log ">>> $label 등록 성공"
        ok=$((ok + 1))
    else
        log ">>> $label 등록 실패 (주소/포트/접속 확인 필요)"
        fail=$((fail + 1))
    fi
done

log ""
log "결과: 성공 $ok / 실패 $fail (총 ${#SERVERS[@]})"
log "===== register-key.sh 실행 종료 ====="

echo ""
echo "로그 파일: $LOGPATH"
echo "접속 확인: 'ssh kevin@주소' (포트 다르면 'ssh -p 1122 kevin@주소')"
