# lex-uais

LegionIO extension for United AI Studio (UAIS) agent registration. Provides a client for registering, deregistering, and checking Digital Worker registration status with the UAIS platform.

## Features

- Register/deregister Digital Workers with UAIS
- Check registration status and AIRB approval
- Mock adapter (default) for development and testing
- Soft-warn enforcement: failures log warnings but never block operations
- Standalone `Client` class for use outside the Legion framework

## Installation

Add to your Gemfile:

```ruby
gem 'lex-uais'
```

## Usage

### Standalone Client

```ruby
require 'legion/extensions/uais/client'

# Mock mode (default when no base_url)
client = Legion::Extensions::Uais::Client.new
result = client.register_worker(worker_id: 'w-123', name: 'InvoiceBot', owner_msid: 'ms123', extension_name: 'lex-invoice')

# Live mode
client = Legion::Extensions::Uais::Client.new(base_url: 'https://api.uais.uhg.com', api_key: 'key')
result = client.register_worker(worker_id: 'w-123', name: 'InvoiceBot', owner_msid: 'ms123', extension_name: 'lex-invoice')
```

### Within Legion Framework

The extension is auto-discovered via the `lex-*` naming convention. Configure via settings:

```yaml
uais:
  options:
    base_url: https://api.uais.uhg.com
    api_key: <vault-sourced>
    mock: false
    timeout: 30
```

## Runner Methods

| Method | Description |
|--------|-------------|
| `register_worker` | Register a Digital Worker with UAIS |
| `deregister_worker` | Deregister a worker |
| `check_registration` | Check if a worker is registered |
| `airb_status` | Check AIRB approval status |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

Apache-2.0
