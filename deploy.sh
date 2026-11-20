#!/bin/sh
# 복지꿀통 진단기 — GitHub Pages 배포 (저장소가 이미 있어야 함)
# 사용: sh /workspace/bokjikkultong-finder-site/deploy.sh
set -e
REPO="${REPO:-gimdevelope/bokjikkultong-finder}"
cd /workspace/bokjikkultong-finder-site

[ -d .git ] || git init -q
git add -A
git -c user.name="김개발" -c user.email="gimdevelope@users.noreply.github.com" \
    commit -m "feat: 복지 진단기 근거UI 개편 (3단 판정·공고 원문 근거·카톡 공유) + Pages 배포" -q || echo "변경 없음"
git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${REPO}.git"
git push -u origin main

echo "▶ Pages 활성화 시도"
gh api -X POST "repos/${REPO}/pages" -f "source[branch]=main" -f "source[path]=/" 2>&1 | head -5 || \
gh api -X PUT "repos/${REPO}/pages" -f "source[branch]=main" -f "source[path]=/" 2>&1 | head -5

echo "▶ 상태"
gh api "repos/${REPO}/pages" --jq '{status, html_url}' 2>&1 | head -5
