# BalitaCare Pre-Push Security Checker
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " BalitaCare Security Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$hasIssues = $false

# Check 1: Database files
Write-Host "[1/5] Checking for database files..." -ForegroundColor Yellow
$dbFiles = Get-ChildItem -Recurse -Include *.db,*.sqlite -ErrorAction SilentlyContinue
if ($dbFiles.Count -gt 0) {
    Write-Host "WARNING: Database files found!" -ForegroundColor Red
    $dbFiles | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Red }
    $hasIssues = $true
} else {
    Write-Host "OK: No database files" -ForegroundColor Green
}
Write-Host ""

# Check 2: Excel files  
Write-Host "[2/5] Checking for Excel files..." -ForegroundColor Yellow
$excelFiles = Get-ChildItem -Recurse -Include *.xlsx,*.xls -ErrorAction SilentlyContinue
if ($excelFiles.Count -gt 0) {
    Write-Host "WARNING: Excel files found!" -ForegroundColor Red
    $excelFiles | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Red }
    $hasIssues = $true
} else {
    Write-Host "OK: No Excel files" -ForegroundColor Green
}
Write-Host ""

# Check 3: .env files
Write-Host "[3/5] Checking for .env files..." -ForegroundColor Yellow
$envFiles = Get-ChildItem -Recurse -Include .env -ErrorAction SilentlyContinue
if ($envFiles.Count -gt 0) {
    Write-Host "WARNING: .env files found!" -ForegroundColor Red
    $envFiles | ForEach-Object { Write-Host "  - $($_.FullName)" -ForegroundColor Red }
    $hasIssues = $true
} else {
    Write-Host "OK: No .env files" -ForegroundColor Green
}
Write-Host ""

# Check 4: .gitignore exists
Write-Host "[4/5] Checking .gitignore..." -ForegroundColor Yellow
if (Test-Path ".gitignore") {
    Write-Host "OK: .gitignore exists" -ForegroundColor Green
} else {
    Write-Host "WARNING: .gitignore not found!" -ForegroundColor Red
    $hasIssues = $true
}
Write-Host ""

# Check 5: Git status
Write-Host "[5/5] Checking git status..." -ForegroundColor Yellow
try {
    $gitStatus = git status --short 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK: Git repository initialized" -ForegroundColor Green
    }
} catch {
    Write-Host "INFO: Git not initialized" -ForegroundColor Yellow
}
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($hasIssues) {
    Write-Host "RESULT: SECURITY ISSUES DETECTED!" -ForegroundColor Red
    Write-Host ""
    Write-Host "DO NOT PUSH TO GITHUB YET!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Actions needed:" -ForegroundColor Yellow
    Write-Host "1. Remove sensitive files" -ForegroundColor Yellow
    Write-Host "2. Update .gitignore" -ForegroundColor Yellow
    Write-Host "3. Run this script again" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "See GIT_CLEANUP.md for help" -ForegroundColor Cyan
} else {
    Write-Host "RESULT: ALL CHECKS PASSED!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Safe to push to GitHub" -ForegroundColor Green
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Cyan
    Write-Host '  git add .' -ForegroundColor Gray
    Write-Host '  git commit -m "Your message"' -ForegroundColor Gray
    Write-Host '  git push origin main' -ForegroundColor Gray
}
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
