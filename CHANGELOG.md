# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.5] - 2022-02-16
### Added
- Two new functions: `Get-FrontConversation` and `Get-FrontConversationMessages`

## [0.2.4] - 2022-02-15
### Fixed
- Fixed issue with rate limiting support in private function `InvokeFrontRestMethod` where you would likely experience an infinite loop based on the do/while looping criteria.

## [0.2.3] - 2022-02-15
### Added
- Added support for handling 429 Too Many Requests HTTP response for Front's rate limiting

## [0.1.14] - 2021-12-15
### Added
- New functions: `Get-FrontInbox`, `Get-FrontTag`, `Get-FrontMessageTemplate`, `Get-FrontMessageTemplateFolder`, `Update-FrontMessageTemplate`
- Added more query filters to `Find-FrontConversation`

## [0.1.6] - 2021-11-22
### Added
- New functions: `Update-FrontConversation`, `Find-FrontConversation`, `New-FrontComment`

### Changed
- Renamed parameter `-Tag` to `-TagId` in `Add-FrontConversationTag`
- Use `PSCredential` object time to decode secure string instead of `ConvertFrom-SecureString` to consider older versions of PS

[Unreleased]: https://github.com/codaamok/PSFront/compare/0.2.5..HEAD
[0.2.5]: https://github.com/codaamok/PSFront/compare/0.2.4..0.2.5
[0.2.4]: https://github.com/codaamok/PSFront/compare/0.2.3..0.2.4
[0.2.3]: https://github.com/codaamok/PSFront/compare/0.1.14..0.2.3
[0.1.14]: https://github.com/codaamok/PSFront/compare/0.1.6..0.1.14
[0.1.6]: https://github.com/codaamok/PSFront/tree/0.1.6