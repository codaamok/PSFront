# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- New functions: `Update-FrontConversation`, `Find-FrontConversation`, `New-FrontComment`

### Changed
- Renamed parameter `-Tag` to `-TagId` in `Add-FrontConversationTag`
- Use `PSCredential` object time to decode secure string instead of `ConvertFrom-SecureString` to consider older versions of PS

