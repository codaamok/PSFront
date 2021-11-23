# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- New function: `Get-FrontInbox`
- Added more query filters to `Find-FrontConversation`

## [0.1.6] - 2021-11-22
### Added
- New functions: `Update-FrontConversation`, `Find-FrontConversation`, `New-FrontComment`

### Changed
- Renamed parameter `-Tag` to `-TagId` in `Add-FrontConversationTag`
- Use `PSCredential` object time to decode secure string instead of `ConvertFrom-SecureString` to consider older versions of PS

[Unreleased]: https://github.com/codaamok/PSFront/compare/0.1.6..HEAD
[0.1.6]: https://github.com/codaamok/PSFront/tree/0.1.6