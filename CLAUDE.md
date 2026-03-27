# lex-uais: UAIS Registration Extension for LegionIO

**Repository Level 3 Documentation**
- **Parent (Level 2)**: `/Users/miverso2/rubymine/legion/extensions/CLAUDE.md`
- **Parent (Level 1)**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that provides a client for United AI Studio (UAIS) agent registration. Registers, deregisters, and queries Digital Worker status with the UAIS platform. Defaults to mock mode when no `base_url` is configured, and uses soft-warn enforcement so registration failures never block operations.

**Version**: 0.1.0
**GitHub**: https://github.com/LegionIO/lex-uais
**License**: Apache-2.0

## Architecture

```
Legion::Extensions::Uais
├── Runners/
│   └── Registration          # register_worker, deregister_worker, check_registration, airb_status
├── Helpers/
│   └── Client                # Net::HTTP connection builder with build_request helper
└── Client                    # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/uais.rb` | Entry point, extension registration, `default_settings` |
| `lib/legion/extensions/uais/runners/registration.rb` | Registration logic (all 4 operations) + mock adapter + soft-warn |
| `lib/legion/extensions/uais/helpers/client.rb` | Net::HTTP connection builder with timeout and auth |
| `lib/legion/extensions/uais/client.rb` | Standalone `Client` class for use outside Legion framework |

## Runner Methods

All methods are in `Runners::Registration` and return hashes with status info. On failure, they log warnings via `soft_warn` and return error hashes instead of raising.

| Method | Args | Notes |
|--------|------|-------|
| `register_worker` | `worker_id:, name:, owner_msid:, extension_name:, **opts` | opts: `risk_tier:`, `team:`, `business_role:` |
| `deregister_worker` | `worker_id:, reason: nil` | |
| `check_registration` | `worker_id:` | |
| `airb_status` | `worker_id:` | AIRB approval status |

## Mock Mode

Mock mode is active when `mock: true` (default) or `base_url` is nil. All operations return success with `mock: true` in the response hash.

## Notes

- `default_settings` defines `mock: true`, `base_url: nil`, `timeout: 30`
- Uses Net::HTTP directly (no Faraday dependency)
- `soft_warn` logs via `Legion::Logging.warn` if available; never raises
- Standalone `Client` class auto-enables mock when `base_url` is nil

## Dependencies

| Gem | Purpose |
|-----|---------|
| `legion-json` | JSON serialization |
| `legion-logging` | Logging (optional, for soft-warn) |
| `legion-settings` | Configuration management |

## Testing

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
