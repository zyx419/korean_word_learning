Param(
  [string]$Device = "",
  [string]$Token = "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",
  [string]$DbSentences = "https://www.notion.so/5c551969902b454e998c979283f3f98b?v=29cdc335259a8112bedc000c12187d3d",
  [string]$DbHighlights = "https://www.notion.so/d751daa1223242dfae42527cc3ae3036?v=29cdc335259a8127a187000c7e4b9d0e",
  [string]$DbPrefs = "https://www.notion.so/579dfb3d5627440c94257beb30cb8250?v=29cdc335259a812ab8a2000cfb5275c7",
  [string]$LogFile = "",
  [bool]$LaunchEmulator = $true
)

$ErrorActionPreference = 'Stop'

$baseScript = Join-Path $PSScriptRoot "run_dev.local.ps1"
if (-not (Test-Path -LiteralPath $baseScript)) {
  throw "找不到基础启动脚本：$baseScript"
}

$scriptParams = @{
  Device = $Device
  Token = $Token
  DbSentences = $DbSentences
  DbHighlights = $DbHighlights
  DbPrefs = $DbPrefs
  LogFile = $LogFile
  LaunchEmulator = $LaunchEmulator
  EmulatorId = "Pixel_Tablet_API_34"
}

& $baseScript @scriptParams

